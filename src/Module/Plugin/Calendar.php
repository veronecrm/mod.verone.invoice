<?php
/**
 * Verone CRM | http://www.veronecrm.com
 *
 * @copyright  Copyright (C) 2015 Adam Banaszkiewicz
 * @license    GNU General Public License version 3; see license.txt
 */

namespace App\Module\Invoice\Plugin;

use CRM\App\Module\Plugin;

class Calendar extends Plugin
{
    public function eventsGroups()
    {
        return [
            [
                'ordering'  => 0,
                'id'        => 'Invoice.Invoice',
                'name'      => $this->t('invoices')
            ]
        ];
    }

    public function eventsFromRange($from, $to)
    {
        $repo     = $this->repo('Invoice', 'Invoice');
        $invoices = $repo->findAll('`status` != 2 AND `status` != 5 AND `type` != 5 AND `paymentDate` < :to AND `paymentDate` > :from', [ ':from' => $from, ':to' => $to ]);
        $calendar = $this->repo('Event', 'Calendar');
        $result   = [];
        $datetime = $this->datetime();

        foreach($invoices as $invoice)
        {
            $event = [];
            $event['group']  = 'Invoice.Invoice';
            $event['title']  = $this->t('invoiceInvoicePaymentDate');
            $event['start']  = date('Y-m-d', $invoice->getPaymentDate());
            $event['startHuman'] = $datetime->dateShort($invoice->getPaymentDate());

            $color = $calendar->getEventColorByType(0);

            $event['color']    = $color['color'];
            $event['typeName'] = $color['name'];
            $event['id']       = $invoice->getId();
            $event['editable']    = false;
            $event['description'] = $this->t('invoiceNumber').': '.$invoice->getNumber().'<br />'.$this->t('invoiceRecipientName').': '.$invoice->getBuyerName();
            $event['onClickRedirect'] = $this->createUrl('Invoice', $repo->getControllerNameByType($invoice), 'summary', [ 'id' => $invoice->getId() ]);

            $result[] = $event;
        }

        return $result;
    }

    public function updateEvent($id, $group, array $data)
    {

    }
}
