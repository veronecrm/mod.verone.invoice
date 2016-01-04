<?php
/**
 * Verone CRM | http://www.veronecrm.com
 *
 * @copyright  Copyright (C) 2015 - 2016 Adam Banaszkiewicz
 * @license    GNU General Public License version 3; see license.txt
 */

namespace App\Module\Invoice\Plugin;

use CRM\App\Module\Plugin;

class Links extends Plugin
{
    public function mainMenu()
    {
        if($this->acl('mod.Invoice.Invoice', 'mod.Invoice')->isAllowed('core.module'))
        {
            return [
                [
                    'ordering' => 1,
                    'name'  => $this->t('modNameInvoice'),
                    'href'   => $this->createUrl('Invoice', 'Invoice', 'index'),
                    'icon-type' => 'class',
                    'icon' => 'fa fa-credit-card',
                    'module' => 'Invoice'
                ]
            ];
        }
    }
}
