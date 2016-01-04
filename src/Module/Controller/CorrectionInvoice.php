<?php
/**
 * Verone CRM | http://www.veronecrm.com
 *
 * @copyright  Copyright (C) 2015 - 2016 Adam Banaszkiewicz
 * @license    GNU General Public License version 3; see license.txt
 */

namespace App\Module\Invoice\Controller;

use CRM\App\Controller\BaseController;

/**
 * @section mod.Invoice.CorrectionInvoice
 */
class CorrectionInvoice extends BaseController
{
    /**
     * @access core.write
     */
    public function addAction($request)
    {
        /**
         * Step one - choose invoice to correction.
         */
        if($request->query->has('correction') == false)
        {
            return $this->render('chooseInvoice', [
                'elements' => $this->repo('Invoice')->findForCorrection()
            ]);
        }
        else
        {
            $invoice = $this->repo('Invoice')->find($request->query->get('correction'));

            /**
             * Pretend, this is new Record, not existed in DB
             */
            $invoice->isNew = true;
            $invoice->setId(null);

            // New type of Invoice
            $invoice->setType(6);

            // Change headline - must contain word of 'Correction'
            $invoice->setHeadline('Faktura Korygująca');

            // Retype number of invoice
            $invoice->setCorrectionNumber($invoice->getNumber());

            // Retype release date of invoice
            $invoice->setCorrectionDate($invoice->getReleaseDate());

            // Retype release date of invoice
            $invoice->setCorrectionReason($this->t('invoiceCorrectionReasonType5'));

            // Generate new Invoice number for Correction type
            $invoice->setNumber($this->get('mod.invoice.numberGenerator')->getNextNumber($invoice->getType()));

            // Generate new Release Date of Invoice
            $invoice->setReleaseDate(time());

            return $this->render('form', [
                'invoice'  => $invoice,
                'products' => $this->repo('Product')->findAllByInvoice($request->query->get('correction'))
            ]);
        }
    }

    /**
     * @access core.write
     */
    public function saveAction($request)
    {
        $invoice = $this->entity('Invoice')->fillFromRequest($request);
        $invoice->setOwner($this->user()->getId());
        $invoice->setCreated(time());
        $invoice->setModified(0);
        $invoice->setType(6);

        $totalSumNet   = 0;
        $totalSumGross = 0;

        $products = [];

        foreach((array) $request->get('product') as $product)
        {
            $discount = abs((float) $product['discount']);
            $tax      = abs((float) $product['tax']);
            $qty      = abs((float) $product['qty']);
            $nett     = (float) $product['unitPriceNet'];

            $nettWithDiscount = $discount ? ($nett - ($nett * ($discount / 100))) : $nett;
            $gross            = $nettWithDiscount + ($nettWithDiscount * ($tax / 100));

            $totalSumNet    += ($nettWithDiscount * $qty);
            $totalSumGross  += ($gross * $qty);

            $prod = $this->entity('Product');
            $prod->setCreateDate(time());
            $prod->setProductId($product['id']);
            $prod->setName($product['name']);
            $prod->setUnitPriceNet($nett);
            $prod->setQty($qty);
            $prod->setTax($tax);
            $prod->setUnit($product['unit']);
            $prod->setDiscount($discount);
            $prod->setComment($product['comment']);
            $prod->setCurrent(1);

            $products[] = $prod;
        }

        $invoice->setValueNett(round($totalSumNet, 2));
        $invoice->setValueGross(round($totalSumGross, 2));
        $invoice->setNumber($this->get('mod.invoice.numberGenerator')->generateNextNumber($invoice->getType()));

        $this->repo('Invoice')->save($invoice);

        $log = $this->openUserHistory($invoice);
        $log->flush('create', $this->t('invoice'));

        $changeId = $log->getChangeId();

        foreach($products as $product)
        {
            $product->setInvoiceId($invoice->getId());
            $this->repo('Product')->save($product);

            $productLog = $this->openUserHistory($product);
            $productLog->relatedWith($changeId);
            $productLog->flush('create', $this->t('invoiceProduct'));
        }

        $this->flash('success', $this->t('invoiceSaved'));

        if($request->request->has('apply'))
            return $this->redirect('Invoice', 'CorrectionInvoice', 'edit', [ 'id' => $invoice->getId() ]);
        else
            return $this->redirect('Invoice', 'Invoice', 'index');
    }

    /**
     * @access core.read
     */
    public function editAction($request)
    {
        $invoice = $this->repo('Invoice')->find($request->query->get('id'));

        if(! $invoice)
        {
            $this->flash('error', $this->t('invoiceDoesntExists'));
            return $this->redirect('Invoice', 'Invoice', 'index');
        }

        return $this->render('form', [
            'invoice'  => $invoice,
            'products' => $this->repo('Product')->findAllByInvoice($invoice->getId())
        ]);
    }

    /**
     * @access core.write
     */
    public function updateAction($request)
    {
        $invoice = $this->repo('Invoice')->find($request->request->get('id'));

        if(! $invoice)
        {
            $this->flash('error', $this->t('invoiceDoesntExists'));
            return $this->redirect('Invoice', 'Invoice', 'index');
        }

        $invoiceLog = $this->openUserHistory($invoice);

        $invoice->fillFromRequest($request);
        $invoice->setModified(time());

        $productsAddDate = time();
        $productRepo = $this->repo('Product');

        // Products, in current Invoice state.
        $currentProducts = $productRepo->findAllByInvoice($invoice->getId());
        // Products from Request, new Invoice state.
        $newProducts = (array) $request->request->get('product');
        // Products Entities, for new Infoce state.
        $products = [];

        /**
         * First, find and update existing products in DB and in Request.
         */
        foreach($newProducts as $newKey => $newProduct)
        {
            foreach($currentProducts as $currentKey => $currentProduct)
            {
                if($newProduct['id'] == $currentProduct->getId())
                {
                    $discount = abs((float) $newProduct['discount']);
                    $tax      = abs((float) $newProduct['tax']);
                    $qty      = abs((float) $newProduct['qty']);
                    $nett     = (float) $newProduct['unitPriceNet'];

                    /**
                     * We shouldn't do this like this, but in that way
                     * we can write veeery less code, tha t in right way.
                     * Open product EntityLog and save that object to product
                     * property, to use during product save.
                     */
                    $currentProduct->entityLog = $this->openUserHistory($currentProduct);

                    $currentProduct->setProductId($newProduct['productId']);
                    $currentProduct->setName($newProduct['name']);
                    $currentProduct->setUnitPriceNet($nett);
                    $currentProduct->setQty($qty);
                    $currentProduct->setTax($tax);
                    $currentProduct->setUnit($newProduct['unit']);
                    $currentProduct->setDiscount($discount);
                    $currentProduct->setComment($newProduct['comment']);
                    $currentProduct->setCurrent(1);

                    $products[] = clone $currentProduct;

                    unset($newProducts[$newKey]);
                    unset($currentProducts[$currentKey]);
                }
            }
        }

        /**
         * Second, add new products, that exists in Request, but not in DB.
         */
        foreach($newProducts as $newKey => $newProduct)
        {
            $discount = abs((float) $newProduct['discount']);
            $tax      = abs((float) $newProduct['tax']);
            $qty      = abs((float) $newProduct['qty']);
            $nett     = (float) $newProduct['unitPriceNet'];

            $prod = $this->entity('Product');
            $prod->setCreateDate($productsAddDate);
            $prod->setProductId($newProduct['productId']);
            $prod->setName($newProduct['name']);
            $prod->setUnitPriceNet($nett);
            $prod->setQty($qty);
            $prod->setTax($tax);
            $prod->setUnit($newProduct['unit']);
            $prod->setDiscount($discount);
            $prod->setComment($newProduct['comment']);
            $prod->setCurrent(1);

            $products[] = $prod;
        }

        /**
         * Last, remove products from DB, that left.
         */
        foreach($currentProducts as $currentProduct)
        {
            $currentProduct->entityLog = $this->openUserHistory($currentProduct);
            $productRepo->delete($currentProduct);
        }

        $totalSumNet   = 0;
        $totalSumGross = 0;

        foreach($products as $product)
        {
            $discount = $product->getDiscount();
            $tax      = $product->getTax();
            $qty      = $product->getQty();
            $nett     = $product->getUnitPriceNet();

            $nettWithDiscount = $discount ? ($nett - ($nett * ($discount / 100))) : $nett;
            $gross            = $nettWithDiscount + ($nettWithDiscount * ($tax / 100));

            $totalSumNet   += ($nettWithDiscount * $qty);
            $totalSumGross += ($gross * $qty);
        }

        $invoice->setValueNett(round($totalSumNet, 2));
        $invoice->setValueGross(round($totalSumGross, 2));

        $this->repo('Invoice')->save($invoice);
        $invoiceLog->flush('change', $this->t('invoice'));

        $changeId = $invoiceLog->getChangeId();

        foreach($products as $product)
        {
            $product->setInvoiceId($invoice->getId());
            $isNew = $product->isNew;

            $productRepo->save($product);

            if($isNew)
            {
                $productLog = $this->openUserHistory($product);
                $productLog->relatedWith($changeId);
                $productLog->flush('create', $this->t('invoiceProduct'));
            }
            else
            {
                $product->entityLog->relatedWith($changeId);
                $product->entityLog->flush('change', $this->t('invoiceProduct'));
            }
        }

        /**
         * Log for removed products.
         */
        foreach($currentProducts as $currentProduct)
        {
            $currentProduct->entityLog->relatedWith($changeId);
            $currentProduct->entityLog->flush('delete', $this->t('invoiceProduct'));
        }

        $this->flash('success', $this->t('invoiceUpdated'));

        if($request->request->has('apply'))
            return $this->redirect('Invoice', 'CorrectionInvoice', 'edit', [ 'id' => $invoice->getId() ]);
        else
            return $this->redirect('Invoice', 'Invoice', 'index');
    }

    /**
     * @access core.write
     */
    public function convertAction($request)
    {
        $invoice = $this->repo('Invoice')->find($request->query->get('id'));

        if(! $invoice)
        {
            $this->flash('error', $this->t('invoiceDoesntExists'));
            return $this->redirect('Invoice', 'Invoice', 'index');
        }

        $currentNumber = $invoice->getNumber();

        $invoice->isNew = true;
        $invoice->setId(null);
        $invoice->setCreated(time());
        $invoice->setModified(null);

        $invoice->setNumber($this->get('mod.invoice.numberGenerator')->generateNextNumber($invoice->getType()));

        $this->repo('Invoice')->save($invoice);

        $products = $this->repo('Product')->copyProducts($request->query->get('id'), $invoice->getId());

        $invoiceLog = $this->openUserHistory($invoice);
        $invoiceLog->flush('create', $this->t('invoice'));
        $changeId = $invoiceLog->getChangeId();

        foreach($products as $product)
        {
            $entityLog = $this->openUserHistory($product);
            $entityLog->relatedWith($changeId);
            $entityLog->flush('create', $this->t('invoiceProduct'));
        }

        $this->flash('success', sprintf($this->t('invoiceDuplicatedWithNewNumber'), $invoice->getNumber()));

        return $this->redirect('Invoice', 'Invoice', 'index');
    }

    /**
     * @access core.delete
     */
    public function deleteAction($request)
    {
        $invoice = $this->repo('Invoice')->find($request->query->get('id'));

        if(! $invoice)
        {
            $this->flash('error', $this->t('invoiceDoesntExists'));
            return $this->redirect('Invoice', 'Invoice', 'index');
        }

        $log = $this->openUserHistory($invoice);
        $log->flush('delete', $this->t('invoice'));
        $changeId = $log->getChangeId();

        $productRepo = $this->repo('Product');
        $currentProducts = $productRepo->findAllByInvoice($invoice->getId());

        foreach($currentProducts as $product)
        {
            $entityLog = $this->openUserHistory($product);
            $entityLog->relatedWith($changeId);
            $entityLog->flush('delete', $this->t('invoiceProduct'));

            $productRepo->delete($product);
        }

        $this->repo('Invoice')->delete($invoice);

        $this->flash('success', $this->t('invoiceRemoved'));
        return $this->redirect('Invoice', 'Invoice', 'index');
    }

    /**
     * @access core.read
     */
    public function summaryAction($request)
    {
        $repo    = $this->repo();
        $invoice = $repo->find($request->get('id'));

        if(! $invoice)
        {
            $this->flash('danger', $this->t('invoiceDoesntExists'));
            return $this->redirect('Invoice', 'Invoice', 'index');
        }

        return $this->render('summary', [
            'invoice'  => $invoice,
            'products' => $this->repo('Product')->findAllByInvoice($invoice->getId()),
            'history'  => $this->repo('Product')->getProductsFromHistory($invoice->getId()),
            'owner'    => $this->repo('User', 'User')->findWithComplement($invoice->getOwner())
        ]);
    }
}
