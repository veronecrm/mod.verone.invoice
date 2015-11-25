<?php
/**
 * Verone CRM | http://www.veronecrm.com
 *
 * @copyright  Copyright (C) 2015 Adam Banaszkiewicz
 * @license    GNU General Public License version 3; see license.txt
 */

namespace App\Module\Invoice\Controller;

use CRM\App\Controller\BaseController;

/**
 * @section mod.Invoice.Invoice
 */
class ProformaInvoice extends BaseController
{
    /**
     * @access core.write
     */
    public function addAction()
    {
        $invoice = $this->entity('Invoice');
        $invoice->setType(5);

        $this->repo('Invoice')->fillInvoiceDefaultData($invoice);

        return $this->render('form', [
            'invoice'  => $invoice,
            'products' => []
        ]);
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
        $invoice->setType(5);

        $totalSumNet   = 0;
        $totalSumGross = 0;

        $products = [];
        $productsAddDate = time();

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
            $prod->setCreateDate($productsAddDate);
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

        foreach($products as $product)
        {
            $product->setInvoiceId($invoice->getId());
            $this->repo('Product')->save($product);
        }

        /**
         * @todo User History
         * $this->openUserHistory($invoice)->flush('create', $this->t('invoice'));
         */

        $this->flash('success', $this->t('invoiceSaved'));

        if($request->request->has('apply'))
            return $this->redirect('Invoice', 'ProformaInvoice', 'edit', [ 'id' => $invoice->getId() ]);
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

        $invoice->fillFromRequest($request);
        $invoice->setModified(time());

        $totalSumNet   = 0;
        $totalSumGross = 0;

        // First, remove old products
        $this->repo('Product')->removeAllByInvoice($invoice->getId());

        $products = [];
        $productsAddDate = time();

        foreach((array) $request->request->get('product') as $product)
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
            $prod->setCreateDate($productsAddDate);
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

        $this->repo('Invoice')->save($invoice);

        foreach($products as $product)
        {
            $product->setInvoiceId($invoice->getId());
            $this->repo('Product')->save($product);
        }

        /**
         * @todo User History
         * $this->openUserHistory($invoice)->flush('create', $this->t('invoice'));
         */

        $this->flash('success', $this->t('invoiceUpdated'));

        if($request->request->has('apply'))
            return $this->redirect('Invoice', 'ProformaInvoice', 'edit', [ 'id' => $invoice->getId() ]);
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

        if($request->query->get('to') == 'SalesInvoice')
        {
            $invoice->setType(1);
        }

        $invoice->setNumber($this->get('mod.invoice.numberGenerator')->generateNextNumber($invoice->getType()));

        $this->repo('Invoice')->save($invoice);

        $this->repo('Product')->copyProducts($request->query->get('id'), $invoice->getId());

        $this->openUserHistory($invoice)->flush('create', $this->t('invoice'));

        if($request->query->get('to') == 'SalesInvoice')
        {
            $this->flash('success', sprintf($this->t('invoiceProformaConvertedToSalesInvoice'), $invoice->getNumber(), $currentNumber));
        }
        else
        {
            $this->flash('success', sprintf($this->t('invoiceDuplicatedWithNewNumber'), $invoice->getNumber()));
        }

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

        $this->repo('Product')->removeAllByInvoice($invoice->getId());
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
            'owner'    => $this->repo('User', 'User')->findWithComplement($invoice->getOwner())
        ]);
    }
}
