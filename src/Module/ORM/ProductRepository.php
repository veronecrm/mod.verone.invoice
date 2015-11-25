<?php
/**
 * Verone CRM | http://www.veronecrm.com
 *
 * @copyright  Copyright (C) 2015 Adam Banaszkiewicz
 * @license    GNU General Public License version 3; see license.txt
 */

namespace App\Module\Invoice\ORM;

use CRM\ORM\Repository;

class ProductRepository extends Repository
{
    public $dbTable = '#__invoice_product';

    public function findAllByInvoice($id)
    {
        return $this->findAll('invoiceId = :id AND `current` = 1', [ ':id' => $id ]);
    }

    public function removeAllByInvoice($id)
    {
        foreach($this->findAllByInvoice($id) as $product)
        {
                $this->delete($product);
        }
    }

    public function copyProducts($from, $to)
    {
        $products = $this->findAll('invoiceId = :invoiceId AND `current` = 1', [ ':invoiceId' => $from ]);

        foreach($products as $product)
        {
            $product->isNew = true;
            $product->setId(null);
            $product->setInvoiceId($to);

            $this->save($product);
        }
    }

    public function changeCurrentProducts($invoiceId)
    {
        $this->updateQuery('UPDATE #__invoice_product SET `current` = 0 WHERE invoiceId = :invoiceId', [ ':invoiceId' => $invoiceId ]);
    }

    public function getProductsFromHistory($invoiceId)
    {
        $products = $this->selectQuery('SELECT * FROM #__invoice_product WHERE `current` = 0 ORDER BY createDate DESC');
        $result   = [];

        foreach($products as $prod)
        {
            $result[$prod->getCreateDate()][] = $prod;
        }

        return $result;
    }
}
