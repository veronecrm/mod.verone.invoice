<?php
/**
 * Verone CRM | http://www.veronecrm.com
 *
 * @copyright  Copyright (C) 2015 Adam Banaszkiewicz
 * @license    GNU General Public License version 3; see license.txt
 */

namespace App\Module\Invoice\Plugin;

use CRM\App\Module\Plugin;

class HomeTiles extends Plugin
{
    public function tilesGet()
    {
        if($this->acl('mod.Invoice.Tile', 'mod.Invoice')->isAllowed('mod.invoice.tile.cashflow') === false)
        {
            return;
        }

        $repo = $this->repo('Invoice', 'Invoice');

        $thisMonth = new \DateTime('now');
        $firstDay  = (new \DateTime(date('01-m-Y', $thisMonth->getTimestamp())))->getTimestamp(); // hard-coded '01' for first day
        $lastDay   = (new \DateTime(date('t-m-Y', $thisMonth->getTimestamp())))->getTimestamp();

        $thisMonth = $repo->countNetValueInPeriod($firstDay, $lastDay);

        $prevMonth = new \DateTime('- 1 month');

        $firstDay  = (new \DateTime(date('01-m-Y', $prevMonth->getTimestamp())))->getTimestamp(); // hard-coded '01' for first day
        $lastDay   = (new \DateTime(date('t-m-Y', $prevMonth->getTimestamp())))->getTimestamp();

        $prevMonth = $repo->countNetValueInPeriod($firstDay, $lastDay);

        return [
            [
                'color'   => 'tile-primary',
                'icon'    => '<i class="fa fa-money"></i>',
                'heading' => $this->t('invoiceCashFlow'),
                'value'   => ((int) $thisMonth).' ',
                'footer'  => ($prevMonth == 0 ? '+'.intval($thisMonth).'00%' : round(($thisMonth / $prevMonth) * 100, 2).'%'),
            ]
        ];
    }
}
