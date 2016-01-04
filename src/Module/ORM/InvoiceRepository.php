<?php
/**
 * Verone CRM | http://www.veronecrm.com
 *
 * @copyright  Copyright (C) 2015 - 2016 Adam Banaszkiewicz
 * @license    GNU General Public License version 3; see license.txt
 */

namespace App\Module\Invoice\ORM;

use CRM\ORM\Repository;
use CRM\ORM\Entity;
use CRM\Pagination\PaginationInterface;
use DateTime;

class InvoiceRepository extends Repository implements PaginationInterface
{
    public $dbTable = '#__invoice';

    /**
     * Store date format pattern used in dates in Invoice.
     * @var string
     */
    private $dateFormat = '/^\d\d\d\d-\d\d-\d\d$/i';

    /**
     * Store controllers list indexed by Invoice ID.
     * Is used to gets controller name for editing
     * and managing Invoice.
     * @var array
     */
    private $controllers = [
        1 => 'SalesInvoice',
        2 => 'MarginInvoice',
        3 => 'AdvanceInvoice',
        4 => 'SettlementInvoice',
        5 => 'ProformaInvoice',
        6 => 'CorrectionInvoice',
        7 => 'ExemptInvoice',
    ];

    /**
     * @see CRM\Pagination\PaginationInterface::paginationCount()
     */
    public function paginationCount()
    {
        $query = [];
        $binds = [];

        if($this->request()->get('letter'))
        {
            $query[] = 'name LIKE \''.$this->request()->get('letter').'%\'';
            $binds[':name'] = '%';
        }

        return $this->countAll(implode(' AND ', $query), $binds);
    }

    /**
     * @see CRM\Pagination\PaginationInterface::paginationGet()
     */
    public function paginationGet($start, $limit)
    {
        $query = [];
        $binds = [];

        if($this->request()->get('letter'))
        {
            $query[] = 'name LIKE \''.$this->request()->get('letter').'%\'';
            $binds[':name'] = '%';
        }

        return $this->selectQuery('SELECT * FROM #__invoice '.($query === [] ? '' : 'WHERE '.implode(' AND ', $query))." ORDER BY created DESC LIMIT $start, $limit", $binds);
    }

    public function findForCorrection()
    {
        return $this->selectQuery('SELECT * FROM #__invoice WHERE `type` != 5 AND `type` != 6 ORDER BY created DESC');
    }

    /**
     * Fill Invoice object by default data. Used for creating new Invoice.
     * @param  Invoice $invoice Invoice object to fill.
     * @return Invoice
     */
    public function fillInvoiceDefaultData($invoice)
    {
        $invoice->setHeadline('Faktura');
        $invoice->setReleaseDate(time());
        $invoice->setSellDate(time());
        $invoice->setPaymentDate(strtotime('+ 14 days'));
        $invoice->setNumber($this->get('mod.invoice.numberGenerator')->getNextNumber($invoice->getType()));
        $invoice->setDetailsSeller($this->openSettings('app')->get('company.fullname'));

        if($invoice->getType() == 5)
        {
            $invoice->setHeadline('Faktura Pro Forma');
        }

        return $invoice;
    }

    /**
     * Return controller name by given Invoice. Used to generate routes
     * for managing Invoices.
     * @param  Invoice $invoice Invoice object.
     * @return string
     */
    public function getControllerNameByType($invoice)
    {
        return $this->controllers[$invoice->getType()];
    }

    /**
     * While save or upsate Invoice, dates from form are in human
     * format (yyyy-mmn-dd), we check if it's, and if is, we transform
     * this date to timestamp stored in DB.
     * @param  Invoice $invoice Invoice object to resolve dates.
     * @return Invoice
     */
    public function resolveInvoiceDates($invoice)
    {
        if(preg_match($this->dateFormat, $invoice->getReleaseDate()))
        {
            $invoice->setReleaseDate((new DateTime($invoice->getReleaseDate()))->getTimestamp());
        }

        if(preg_match($this->dateFormat, $invoice->getSellDate()))
        {
            $invoice->setSellDate((new DateTime($invoice->getSellDate()))->getTimestamp());
        }

        if(preg_match($this->dateFormat, $invoice->getPaymentDate()))
        {
            $invoice->setPaymentDate((new DateTime($invoice->getPaymentDate()))->getTimestamp());
        }

        return $invoice;
    }

    public function countNetValueInPeriod($from, $to)
    {
        $result =  $this->selectQuery('SELECT SUM(`valueNett`) as sum FROM #__invoice WHERE created >= :from AND created <= :to AND type = 1', [
            ':from' => $from,
            ':to'   => $to,
        ]);

        if(isset($result[0]) && property_exists($result[0], 'sum'))
            return $result[0]->sum;
        else
            return 0;
    }

    public function getFieldsNames()
    {
        return [
            'id'            => 'ID',
            'owner'         => $this->t('recordOwner'),
            'type'          => $this->t('contractorName'),
            'releaseDate'   => $this->t('invoiceReleaseDate'),
            'sellDate'      => $this->t('invoiceSellDate'),
            'paymentDate'   => $this->t('invoicePaymentDate'),
            'number'        => $this->t('invoiceNumber'),
            'contractor'    => $this->t('invoiceContractor'),
            'detailsSeller' => $this->t('invoiceSellerDetails'),
            'buyerName'     => $this->t('invoiceBuyerName'),
            'buyerCountry'  => $this->t('invoiceCity'),
            'buyerCity'     => $this->t('invoiceStreet'),
            'buyerPostCode' => $this->t('invoiceCountry'),
            'buyerStreet'   => $this->t('invoicePostCode'),
            'buyerNIP'      => $this->t('invoiceNIP'),
            'shipmentName'  => $this->t('invoiceRecipientName'),
            'shipmentCountry'   => $this->t('invoiceCity'),
            'shipmentCity'      => $this->t('invoiceStreet'),
            'shipmentPostCode'  => $this->t('invoiceCountry'),
            'shipmentStreet'    => $this->t('invoicePostCode'),
            'showShipment'  => $this->t('invoiceShippmentOnInvoice'),
            'headline'      => $this->t('invoiceHeadline'),
            'status'        => $this->t('invoiceStatus'),
            'correctionNumber'  => $this->t('invoiceCorrectionNumber'),
            'correctionDate'    => $this->t('invoiceCorrectionDate'),
            'correctionReason'  => $this->t('invoiceCorrectionReason'),
            'valueNett'     => $this->t('invoiceValueNet'),
            'valueGross'    => $this->t('invoiceValueGross'),
            'owner'         => $this->t('recordOwner'),
            'created'       => $this->t('addDate'),
            'modified'      => $this->t('modificationDate')
        ];
    }

    public function getEndValue(Entity $entity, $field)
    {
        switch($field)
        {
            case 'releaseDate' : return date('Y-m-d', $entity->getReleaseDate()); break;
            case 'sellDate'    : return date('Y-m-d', $entity->getSellDate()); break;
            case 'paymentDate' : return date('Y-m-d', $entity->getPaymentDate()); break;
            case 'showShipment': return $entity->getShowShipment() == 1 ? $this->t('syes') : $this->t('sno'); break;
            case 'status'      : return $this->t('invoiceStatus'.$entity->getStatus()); break;
            case 'contractor'  :
                $contractor = $this->repo('Contractor', 'Contractor')->find($entity->getContractor());
                if($contractor)
                    return $contractor->getName();
                else
                    $entity->getContractor();
            break;
            case 'owner'  :
                $user = $this->repo('User', 'User')->find($entity->getOwner());
                if($user)
                    return $user->getName().' (ID:'.$entity->getOwner().')';
                else
                    return $entity->getOwner();
            break;
        }

        return parent::getEndValue($entity, $field);
    }

    /**
     * {@inheritdoc}
     */
    public function onSave(Entity $entity)
    {
        $this->resolveInvoiceDates($entity);
    }

    /**
     * {@inheritdoc}
     */
    public function onUpdate(Entity $entity)
    {
        $this->resolveInvoiceDates($entity);
    }
}
