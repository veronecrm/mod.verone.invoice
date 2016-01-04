<?php
/**
 * Verone CRM | http://www.veronecrm.com
 *
 * @copyright  Copyright (C) 2015 - 2016 Adam Banaszkiewicz
 * @license    GNU General Public License version 3; see license.txt
 */

namespace App\Module\Invoice\Controller;

use CRM\App\Controller\BaseController;

class ProductInvoice extends BaseController
{
    public function allProductsAction()
    {
        $result = [];

        foreach($this->repo('Product', 'Product')->findAll() as $item)
        {
            $result[] = $item->exportToArray();
        }

        return $this->responseAJAX([
            'status' => 'success',
            'data' => $result
        ]);
    }
}
