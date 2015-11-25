<?php
/**
 * Verone CRM | http://www.veronecrm.com
 *
 * @copyright  Copyright (C) 2015 Adam Banaszkiewicz
 * @license    GNU General Public License version 3; see license.txt
 */

namespace App\Module\Invoice;

use CRM\Base;

class InvoiceNumberGenerator extends Base
{
    protected $settings;

    protected $restartWithNextMonth = true;
    protected $restartWithNextYear  = true;

    protected $pattern = '';

    protected $types = [
        [1, 'sales'],
        [2, 'margin'],
        [3, 'advance'],
        [4, 'settlement'],
        [5, 'proforma'],
        [6, 'correction'],
        [7, 'exempt']
    ];

    public function getNextNumber($type)
    {
        $this->before($type);
        $type = $this->resolveTypeById($type);

        $number = (int) $this->settings->get('mod.invoice.'.$type.'.number');

        if($this->restartWithNextYear)
        {
            if((int) date('Y') != (int) $this->settings->get('mod.invoice.'.$type.'.year'))
            {
                $number = 1;
            }
        }

        if($this->restartWithNextMonth)
        {
            if((int) date('m') != (int) $this->settings->get('mod.invoice.'.$type.'.month'))
            {
                $number = 1;
            }
        }

        return str_replace(
            [
                '%N',
                '%Y',
                '%M',
                '%D',
                '%H',
                '%I'
            ],
            [
                $number,
                date('Y'),
                date('m'),
                date('d'),
                date('H'),
                date('i')
            ],
            $this->pattern
        );
    }

    public function generateNextNumber($type)
    {
        $this->before($type);
        $type = $this->resolveTypeById($type);

        if($this->restartWithNextYear)
        {
            if((int) date('Y') != (int) $this->settings->get('mod.invoice.'.$type.'.year'))
            {
                $this->settings->set('mod.invoice.'.$type.'.number', 1);
                $this->settings->set('mod.invoice.'.$type.'.year', (int) date('Y'));
            }
        }

        if($this->restartWithNextMonth)
        {
            if((int) date('m') != (int) $this->settings->get('mod.invoice.'.$type.'.month'))
            {
                $this->settings->set('mod.invoice.'.$type.'.number', 1);
                $this->settings->set('mod.invoice.'.$type.'.month', (int) date('m'));
            }
        }

        $number = (int) $this->settings->get('mod.invoice.'.$type.'.number');

        $result = str_replace(
            [
                '%N',
                '%Y',
                '%M',
                '%D',
                '%H',
                '%I'
            ],
            [
                $number,
                date('Y'),
                date('m'),
                date('d'),
                date('H'),
                date('i')
            ],
            $this->pattern
        );

        $number++;

        $this->settings->set('mod.invoice.'.$type.'.number', $number);

        return $result;
    }

    public function resetNumber($type)
    {
        $this->before($type);
        $type = $this->resolveTypeById($type);

        $this->settings->set('mod.invoice.'.$type.'.number', 1);
    }

    protected function before($type)
    {
        $type = $this->resolveTypeById($type);
        $this->settings = $this->openSettings('app');
        $this->pattern  = $this->settings->get('mod.invoice.'.$type.'.format');
        $this->restartWithNextMonth = $this->settings->get('mod.invoice.'.$type.'.restartwithnewmonth');
        $this->restartWithNextYear  = $this->settings->get('mod.invoice.'.$type.'.restartwithnewyear');
    }

    public function resolveTypeById($id)
    {
        foreach($this->types as $type)
        {
            if($type[0] == $id)
            {
                return $type[1];
            }
        }

        return 'sales';
    }
}
