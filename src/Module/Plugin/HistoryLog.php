<?php
/**
 * Verone CRM | http://www.veronecrm.com
 *
 * @copyright  Copyright (C) 2015 Adam Banaszkiewicz
 * @license    GNU General Public License version 3; see license.txt
 */

namespace App\Module\Invoice\Plugin;

use CRM\App\Module\Plugin;

class HistoryLog extends Plugin
{
    public function retrieve($changes, $module, $entity, $id)
    {
        if($module == 'Settings' && $entity == 'Invoice' && $id == 0)
        {
            $fields = [
                'mod.invoice.sales.format' => $this->t('invoiceTypeSales').' - '.$this->t('invoiceSettingsNumberFormat'),
                'mod.invoice.sales.number' => $this->t('invoiceTypeSales').' - '.$this->t('invoiceNumber'),
                'mod.invoice.sales.opt.restartwithnewyear' => $this->t('invoiceTypeSales').' - '.$this->t('invoiceSettingsResetNumberWithNewYear'),
                'mod.invoice.sales.opt.restartwithnewmonth' => $this->t('invoiceTypeSales').' - '.$this->t('invoiceSettingsResetNumberWithNewMonth'),
                'mod.invoice.margin.format' => $this->t('invoiceTypeMargin').' - '.$this->t('invoiceSettingsNumberFormat'),
                'mod.invoice.margin.number' => $this->t('invoiceTypeMargin').' - '.$this->t('invoiceNumber'),
                'mod.invoice.margin.opt.restartwithnewyear' => $this->t('invoiceTypeMargin').' - '.$this->t('invoiceSettingsResetNumberWithNewYear'),
                'mod.invoice.margin.opt.restartwithnewmonth' => $this->t('invoiceTypeMargin').' - '.$this->t('invoiceSettingsResetNumberWithNewMonth'),
                'mod.invoice.advance.format' => $this->t('invoiceTypeAdvance').' - '.$this->t('invoiceSettingsNumberFormat'),
                'mod.invoice.advance.number' => $this->t('invoiceTypeAdvance').' - '.$this->t('invoiceNumber'),
                'mod.invoice.advance.opt.restartwithnewyear' => $this->t('invoiceTypeAdvance').' - '.$this->t('invoiceSettingsResetNumberWithNewYear'),
                'mod.invoice.advance.opt.restartwithnewmonth' => $this->t('invoiceTypeAdvance').' - '.$this->t('invoiceSettingsResetNumberWithNewMonth'),
                'mod.invoice.settlement.format' => $this->t('invoiceTypeSettlement').' - '.$this->t('invoiceSettingsNumberFormat'),
                'mod.invoice.settlement.number' => $this->t('invoiceTypeSettlement').' - '.$this->t('invoiceNumber'),
                'mod.invoice.settlement.opt.restartwithnewyear' => $this->t('invoiceTypeSettlement').' - '.$this->t('invoiceSettingsResetNumberWithNewYear'),
                'mod.invoice.settlement.opt.restartwithnewmonth' => $this->t('invoiceTypeSettlement').' - '.$this->t('invoiceSettingsResetNumberWithNewMonth'),
                'mod.invoice.proforma.format' => $this->t('invoiceTypeProforma').' - '.$this->t('invoiceSettingsNumberFormat'),
                'mod.invoice.proforma.number' => $this->t('invoiceTypeProforma').' - '.$this->t('invoiceNumber'),
                'mod.invoice.proforma.opt.restartwithnewyear' => $this->t('invoiceTypeProforma').' - '.$this->t('invoiceSettingsResetNumberWithNewYear'),
                'mod.invoice.proforma.opt.restartwithnewmonth' => $this->t('invoiceTypeProforma').' - '.$this->t('invoiceSettingsResetNumberWithNewMonth'),
                'mod.invoice.correction.format' => $this->t('invoiceTypeCorrection').' - '.$this->t('invoiceSettingsNumberFormat'),
                'mod.invoice.correction.number' => $this->t('invoiceTypeCorrection').' - '.$this->t('invoiceNumber'),
                'mod.invoice.correction.opt.restartwithnewyear' => $this->t('invoiceTypeCorrection').' - '.$this->t('invoiceSettingsResetNumberWithNewYear'),
                'mod.invoice.correction.opt.restartwithnewmonth' => $this->t('invoiceTypeCorrection').' - '.$this->t('invoiceSettingsResetNumberWithNewMonth'),
                'mod.invoice.exempt.format' => $this->t('invoiceTypeExempt').' - '.$this->t('invoiceSettingsNumberFormat'),
                'mod.invoice.exempt.number' => $this->t('invoiceTypeExempt').' - '.$this->t('invoiceNumber'),
                'mod.invoice.exempt.opt.restartwithnewyear' => $this->t('invoiceTypeExempt').' - '.$this->t('invoiceSettingsResetNumberWithNewYear'),
                'mod.invoice.exempt.opt.restartwithnewmonth' => $this->t('invoiceTypeExempt').' - '.$this->t('invoiceSettingsResetNumberWithNewMonth'),
                'mod.invoice.pdf.logo' => $this->t('invoiceLogoFileMD5')
            ];

            foreach($changes as $change)
            {
                if(substr($change->getField(), -10) == 'thnewmonth' || substr($change->getField(), -10) == 'ithnewyear')
                {
                    $change->setPre($change->getPre() == 1 ? $this->t('syes') : $this->t('sno'));
                    $change->setPost($change->getPost() == 1 ? $this->t('syes') : $this->t('sno'));
                }

                foreach($fields as $field => $name)
                {
                    if($change->getField() == $field)
                    {
                        $change->setField($name);
                    }
                }
            }
        }
    }
}
