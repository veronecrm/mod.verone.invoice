<?php
/**
 * Verone CRM | http://www.veronecrm.com
 *
 * @copyright  Copyright (C) 2015 - 2016 Adam Banaszkiewicz
 * @license    GNU General Public License version 3; see license.txt
 */

namespace App\Module\Invoice\Controller;

use CRM\App\Controller\BaseController;
use CRM\Pagination\Paginator;
use System\Http\Response;

/**
 * @section mod.Invoice.Invoice
 */
class Invoice extends BaseController
{
    /**
     * @access core.module
     */
    public function indexAction($request)
    {
        $repo      = $this->repo();
        $paginator = new Paginator($repo, $request->get('page'), $this->createUrl('Invoice', 'Invoice', 'index'));

        return $this->render('', [
            'elements'    => $paginator->getElements(),
            'pagination'  => $paginator,
            'repo'        => $repo
        ]);
    }

    /**
     * @access core.write
     */
    public function quickUpdateAction($request)
    {
        $invoice = $this->repo('Invoice')->find($request->request->get('id'));

        if(! $invoice)
        {
            return $this->responseAJAX([
                'status'  => 'error',
                'message' => $this->t('invoiceDoesntExists')
            ]);
        }

        $invoice->fillFromRequest($request);
        $invoice->setModified(time());

        $this->repo('Invoice')->save($invoice);

        /**
         * @todo User History
         * $this->openUserHistory($invoice)->flush('create', $this->t('invoice'));
         */

        return $this->responseAJAX([
            'status'  => 'success',
            'message' => $this->t('invoiceUpdated')
        ]);
    }

    /**
     * @access core.read
     */
    public function allContractorsAction()
    {
        $result = [];

        foreach($this->repo('Contractor', 'Contractor')->findAll() as $item)
        {
            $result[] = $item->exportToArray();
        }

        return $this->responseAJAX([
            'status' => 'success',
            'data'   => $result
        ]);
    }

    /**
     * @access core.read
     */
    public function allProductsAction()
    {
        $result = [];

        foreach($this->repo('Product', 'Product')->findAll() as $key => $item)
        {
            $result[$key] = $item->exportToArray();
            $tax = $this->repo('Tax', 'Tax')->find($item->getTax());

            if(! $tax)
            {
                $result[$key]['tax'] = null;
            }
            else
            {
                $result[$key]['tax'] = $tax->exportToArray();
            }

            $unit = $this->repo('MeasureUnit', 'MeasureUnit')->find($item->getUnit());

            if(! $unit)
            {
                $result[$key]['unit'] = null;
            }
            else
            {
                $result[$key]['unit'] = $unit->exportToArray();
            }
        }

        return $this->responseAJAX([
            'status' => 'success',
            'data'   => $result
        ]);
    }

    /**
     * @access core.read
     */
    public function exportAction($request)
    {
        $invoice = $this->repo('Invoice')->find($request->query->get('id'));

        if(! $invoice)
        {
            $this->flash('error', $this->t('invoiceDoesntExists'));
            return $this->redirect('Invoice', 'Invoice', 'index');
        }

        $view = $this->repo('Invoice')->getControllerNameByType($invoice);

        $html = $this->get('templating.engine')->render($view.'.PDF', [
            'products' => $this->repo('Product')->findAllByInvoice($invoice->getId()),
            'invoice'  => $invoice,
            'type'     => $request->get('original') == 1 ? $this->t('invoiceOriginal') : $this->t('invoiceCopy')
        ]);

        if($request->get('type') == 'pdf')
        {
            $response = new Response();
            $response->headers->setDisposition('attachment', $invoice->getHeadline().' - '.str_replace('/', '-', $invoice->getNumber()).' ('.($request->get('original') == 1 ? $this->t('invoiceOriginal') : $this->t('invoiceCopy')).').pdf');
            $response->headers->set('Content-Type', 'application/pdf');

            try
            {
                // Remote Images
                define('DOMPDF_ENABLE_REMOTE', true);
                define('DOMPDF_ENABLE_AUTOLOAD', false);
                require_once BASEPATH.'/vendor/dompdf/dompdf/dompdf_config.inc.php';

                $dompdf = new \DOMPDF();
                $dompdf->load_html($html);
                $dompdf->render();

                $response->setContent($dompdf->output());
            }
            catch(\Exception $e)
            {
                $this->flash('error', 'Wystąpił błąd podczas generowania pliku PDF: "'.$e->getMessage().'"');
                return $this->redirect('Invoice', 'Invoice', 'index');
            }

            return $response;
        }
        else
        {
            return $this->response($html);
        }
    }

    /**
     * @access core.read
     */
    public function printAction($request)
    {
        $invoice = $this->repo('Invoice')->find($request->query->get('id'));

        if(! $invoice)
        {
            $this->flash('error', $this->t('invoiceDoesntExists'));
            return $this->redirect('Invoice', 'Invoice', 'index');
        }

        $view = $this->repo('Invoice')->getControllerNameByType($invoice);

        $html = $this->get('templating.engine')->render($view.'.Print', [
            'products' => $this->repo('Product')->findAllByInvoice($invoice->getId()),
            'invoice'  => $invoice,
            'type'     => $request->get('original') == 1 ? $this->t('invoiceOriginal') : $this->t('invoiceCopy')
        ]);

        return $this->response($html);
    }
}
