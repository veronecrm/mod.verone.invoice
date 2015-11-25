<?php
/**
 * Verone CRM | http://www.veronecrm.com
 *
 * @copyright  Copyright (C) 2015 Adam Banaszkiewicz
 * @license    GNU General Public License version 3; see license.txt
 */

namespace App\Module\Invoice\ORM;

use CRM\ORM\Entity;

class Product extends Entity
{
    protected $id;
    protected $invoiceId;
    protected $productId;
    protected $createDate;
    protected $name;
    protected $unitPriceNet;
    protected $qty;
    protected $tax;
    protected $unit;
    protected $discount;
    protected $comment;
    protected $current;

    /**
     * Gets the id.
     *
     * @return mixed
     */
    public function getId()
    {
        return $this->id;
    }

    /**
     * Sets the $id.
     *
     * @param mixed $id the id
     *
     * @return self
     */
    public function setId($id)
    {
        $this->id = $id;

        return $this;
    }

    /**
     * Gets the invoiceId.
     *
     * @return mixed
     */
    public function getInvoiceId()
    {
        return $this->invoiceId;
    }

    /**
     * Sets the $invoiceId.
     *
     * @param mixed $invoiceId the invoice id
     *
     * @return self
     */
    public function setInvoiceId($invoiceId)
    {
        $this->invoiceId = $invoiceId;

        return $this;
    }

    /**
     * Gets the productId.
     *
     * @return mixed
     */
    public function getProductId()
    {
        return $this->productId;
    }

    /**
     * Sets the $productId.
     *
     * @param mixed $productId the product id
     *
     * @return self
     */
    public function setProductId($productId)
    {
        $this->productId = $productId;

        return $this;
    }

    /**
     * Gets the createDate.
     *
     * @return mixed
     */
    public function getCreateDate()
    {
        return $this->createDate;
    }

    /**
     * Sets the $createDate.
     *
     * @param mixed $createDate the create date
     *
     * @return self
     */
    public function setCreateDate($createDate)
    {
        $this->createDate = $createDate;

        return $this;
    }

    /**
     * Gets the name.
     *
     * @return mixed
     */
    public function getName()
    {
        return $this->name;
    }

    /**
     * Sets the $name.
     *
     * @param mixed $name the name
     *
     * @return self
     */
    public function setName($name)
    {
        $this->name = $name;

        return $this;
    }

    /**
     * Gets the unitPriceNet.
     *
     * @return mixed
     */
    public function getUnitPriceNet()
    {
        return $this->unitPriceNet;
    }

    /**
     * Sets the $unitPriceNet.
     *
     * @param mixed $unitPriceNet the unit price net
     *
     * @return self
     */
    public function setUnitPriceNet($unitPriceNet)
    {
        $this->unitPriceNet = $unitPriceNet;

        return $this;
    }

    /**
     * Gets the qty.
     *
     * @return mixed
     */
    public function getQty()
    {
        return $this->qty;
    }

    /**
     * Sets the $qty.
     *
     * @param mixed $qty the qty
     *
     * @return self
     */
    public function setQty($qty)
    {
        $this->qty = $qty;

        return $this;
    }

    /**
     * Gets the tax.
     *
     * @return mixed
     */
    public function getTax()
    {
        return $this->tax;
    }

    /**
     * Sets the $tax.
     *
     * @param mixed $tax the tax
     *
     * @return self
     */
    public function setTax($tax)
    {
        $this->tax = $tax;

        return $this;
    }

    /**
     * Gets the unit.
     *
     * @return mixed
     */
    public function getUnit()
    {
        return $this->unit;
    }

    /**
     * Sets the $unit.
     *
     * @param mixed $unit the unit
     *
     * @return self
     */
    public function setUnit($unit)
    {
        $this->unit = $unit;

        return $this;
    }

    /**
     * Gets the discount.
     *
     * @return mixed
     */
    public function getDiscount()
    {
        return $this->discount;
    }

    /**
     * Sets the $discount.
     *
     * @param mixed $discount the discount
     *
     * @return self
     */
    public function setDiscount($discount)
    {
        $this->discount = $discount;

        return $this;
    }

    /**
     * Gets the comment.
     *
     * @return mixed
     */
    public function getComment()
    {
        return $this->comment;
    }

    /**
     * Sets the $comment.
     *
     * @param mixed $comment the comment
     *
     * @return self
     */
    public function setComment($comment)
    {
        $this->comment = $comment;

        return $this;
    }

    /**
     * Gets the current.
     *
     * @return mixed
     */
    public function getCurrent()
    {
        return $this->current;
    }

    /**
     * Sets the $current.
     *
     * @param mixed $current the current
     *
     * @return self
     */
    public function setCurrent($current)
    {
        $this->current = $current;

        return $this;
    }
}
