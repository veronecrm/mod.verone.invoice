<?php
/**
 * Verone CRM | http://www.veronecrm.com
 *
 * @copyright  Copyright (C) 2015 - 2016 Adam Banaszkiewicz
 * @license    GNU General Public License version 3; see license.txt
 */

namespace App\Module\Invoice\Plugin;

use CRM\App\Module\Plugin;

class SettingsGlob extends Plugin
{
    public function tabs()
    {
        return [
            [
                'ordering'  => 10,
                'icon'      => 'fa fa-credit-card',
                'icon-type' => 'class',
                'name'      => $this->t('modNameInvoice'),
                'tab'       => 'invoice',
                'module'    => 'Invoice'
            ]
        ];
    }

    public function contents($tab)
    {
        return $this->get('templating.engine')->render('index.SettingsGlob.Invoice', [
            'settings' => $this->openSettings('app')
        ]);
    }

    public function update($tab, $request)
    {
        $app = $this->openSettings('app');

        $settings = [
            'mod.invoice.sales.format' => 'invoice-sales-format',
            'mod.invoice.sales.number' => 'invoice-sales-number',
            'mod.invoice.sales.opt.restartwithnewyear' => 'invoice-sales-reset-number-year',
            'mod.invoice.sales.opt.restartwithnewmonth' => 'invoice-sales-reset-number-month',
            'mod.invoice.margin.format' => 'invoice-margin-format',
            'mod.invoice.margin.number' => 'invoice-margin-number',
            'mod.invoice.margin.opt.restartwithnewyear' => 'invoice-margin-reset-number-year',
            'mod.invoice.margin.opt.restartwithnewmonth' => 'invoice-margin-reset-number-month',
            'mod.invoice.advance.format' => 'invoice-advance-format',
            'mod.invoice.advance.number' => 'invoice-advance-number',
            'mod.invoice.advance.opt.restartwithnewyear' => 'invoice-advance-reset-number-year',
            'mod.invoice.advance.opt.restartwithnewmonth' => 'invoice-advance-reset-number-month',
            'mod.invoice.settlement.format' => 'invoice-settlement-format',
            'mod.invoice.settlement.number' => 'invoice-settlement-number',
            'mod.invoice.settlement.opt.restartwithnewyear' => 'invoice-settlement-reset-number-year',
            'mod.invoice.settlement.opt.restartwithnewmonth' => 'invoice-settlement-reset-number-month',
            'mod.invoice.proforma.format' => 'invoice-proforma-format',
            'mod.invoice.proforma.number' => 'invoice-proforma-number',
            'mod.invoice.proforma.opt.restartwithnewyear' => 'invoice-proforma-reset-number-year',
            'mod.invoice.proforma.opt.restartwithnewmonth' => 'invoice-proforma-reset-number-month',
            'mod.invoice.correction.format' => 'invoice-correction-format',
            'mod.invoice.correction.number' => 'invoice-correction-number',
            'mod.invoice.correction.opt.restartwithnewyear' => 'invoice-correction-reset-number-year',
            'mod.invoice.correction.opt.restartwithnewmonth' => 'invoice-correction-reset-number-month',
            'mod.invoice.exempt.format' => 'invoice-exempt-format',
            'mod.invoice.exempt.number' => 'invoice-exempt-number',
            'mod.invoice.exempt.opt.restartwithnewyear' => 'invoice-exempt-reset-number-year',
            'mod.invoice.exempt.opt.restartwithnewmonth' => 'invoice-exempt-reset-number-month',
        ];

        $logger = $this->get('history.user.log');
        $logger->setModule('Settings');
        $logger->setEntityId(0);
        $logger->setEntityName('Invoice');

        foreach($settings as $key => $name)
        {
            $logger->appendPreValue($key, $app->get($key));
        }

        foreach($settings as $key => $name)
        {
            $app->set($key, $request->get($name));
        }

        foreach($settings as $key => $name)
        {
            $logger->appendPostValue($key, $app->get($key));
        }

        if(isset($_FILES['invoice_logo']) && is_array($_FILES['invoice_logo']) && $_FILES['invoice_logo']['error'] != 4)
        {
            if(is_uploaded_file($_FILES['invoice_logo']['tmp_name']))
            {
                list($width, $height) = getimagesize($_FILES['invoice_logo']['tmp_name']);

                if($width == 0 || $height == 0)
                {
                    $this->flash('warning', $this->t('invoiceUploadedFileIsntImage'));
                }
                elseif($width > 300 || $height > 300)
                {
                    $this->flash('warning', $this->t('invoiceMaxImageSizesRestriction'));
                }
                else
                {
                    $ext  = pathinfo($_FILES['invoice_logo']['name'], PATHINFO_EXTENSION);
                    $name = 'logo.'.$ext;

                    if(is_file(BASEPATH.'/web/modules/Invoice/'.$name))
                    {
                        $logger->appendPreValue('mod.invoice.pdf.logo', md5_file(BASEPATH.'/web/modules/Invoice/'.$name));

                        unlink(BASEPATH.'/web/modules/Invoice/'.$name);
                    }
                    else
                    {
                        $logger->appendPreValue('mod.invoice.pdf.logo', '');
                    }

                    move_uploaded_file($_FILES['invoice_logo']['tmp_name'], BASEPATH.'/web/modules/Invoice/'.$name);

                    $app->set('mod.invoice.pdf.logo', $name);

                    $logger->appendPostValue('mod.invoice.pdf.logo', md5_file(BASEPATH.'/web/modules/Invoice/'.$name));
                }
            }
        }

        $logger->flush(2, $this->t('invoiceSettings'));
    }
}
