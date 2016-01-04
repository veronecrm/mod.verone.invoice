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
        $newProducts = [];

        foreach($products as $product)
        {
            $product->isNew = true;
            $product->setId(null);
            $product->setInvoiceId($to);

            $newProducts[] = $product;

            $this->save($product);
        }

        return $newProducts;
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

    public function getFieldsNames()
    {
        return [
            'id'            => 'ID',
            'invoiceId'     => $this->t('invoiceId'),
            'productId'     => $this->t('invoiceProductId'),
            'createDate'    => $this->t('invoiceCreateDate'),
            'name'          => $this->t('invoiceProductName'),
            'unitPriceNet'  => $this->t('invoiceUnitPriceNet'),
            'qty'           => $this->t('invoiceQuantity'),
            'tax'           => $this->t('invoiceTaxRate'),
            'unit'          => $this->t('invoiceMeasureUnit'),
            'discount'      => $this->t('invoiceDiscount'),
            'comment'       => $this->t('invoiceComment')
        ];
    }

    public function getEndValue(Entity $entity, $field)
    {
        switch($field)
        {
            case 'createDate': return date('Y-m-d', $entity->getCreateDate()); break;
            case 'discount':   return $entity->getDiscount().' %'; break;
            case 'tax':        return $entity->getTax().' %'; break;
        }

        return parent::getEndValue($entity, $field);
    }
}
