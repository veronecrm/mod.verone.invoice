<?php
/**
 * Verone CRM | http://www.veronecrm.com
 *
 * @copyright  Copyright (C) 2015 Adam Banaszkiewicz
 * @license    GNU General Public License version 3; see license.txt
 */

namespace App\Module\Invoice\ORM;

use CRM\ORM\Entity;

class Invoice extends Entity
{
    protected $id;
    protected $type;
    protected $releaseDate;
    protected $sellDate;
    protected $paymentDate;
    protected $number;
    protected $contractor;
    protected $detailsSeller;
    protected $buyerName;
    protected $buyerCountry;
    protected $buyerCity;
    protected $buyerPostCode;
    protected $buyerStreet;
    protected $buyerNIP;
    protected $shipmentName;
    protected $shipmentCountry;
    protected $shipmentCity;
    protected $shipmentPostCode;
    protected $shipmentStreet;
    protected $showShipment;
    protected $headline;
    protected $status;
    protected $correctionNumber;
    protected $correctionDate;
    protected $correctionReason;
    protected $valueNett;
    protected $valueGross;
    protected $owner;
    protected $created;
    protected $modified;

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
     * Gets the type.
     *
     * @return mixed
     */
    public function getType()
    {
        return $this->type;
    }

    /**
     * Sets the $type.
     *
     * @param mixed $type the type
     *
     * @return self
     */
    public function setType($type)
    {
        $this->type = $type;

        return $this;
    }

    /**
     * Gets the releaseDate.
     *
     * @return mixed
     */
    public function getReleaseDate()
    {
        return $this->releaseDate;
    }

    /**
     * Sets the $releaseDate.
     *
     * @param mixed $releaseDate the release date
     *
     * @return self
     */
    public function setReleaseDate($releaseDate)
    {
        $this->releaseDate = $releaseDate;

        return $this;
    }

    /**
     * Gets the sellDate.
     *
     * @return mixed
     */
    public function getSellDate()
    {
        return $this->sellDate;
    }

    /**
     * Sets the $sellDate.
     *
     * @param mixed $sellDate the sell date
     *
     * @return self
     */
    public function setSellDate($sellDate)
    {
        $this->sellDate = $sellDate;

        return $this;
    }

    /**
     * Gets the paymentDate.
     *
     * @return mixed
     */
    public function getPaymentDate()
    {
        return $this->paymentDate;
    }

    /**
     * Sets the $paymentDate.
     *
     * @param mixed $paymentDate the payment date
     *
     * @return self
     */
    public function setPaymentDate($paymentDate)
    {
        $this->paymentDate = $paymentDate;

        return $this;
    }

    /**
     * Gets the number.
     *
     * @return mixed
     */
    public function getNumber()
    {
        return $this->number;
    }

    /**
     * Sets the $number.
     *
     * @param mixed $number the number
     *
     * @return self
     */
    public function setNumber($number)
    {
        $this->number = $number;

        return $this;
    }

    /**
     * Gets the contractor.
     *
     * @return mixed
     */
    public function getContractor()
    {
        return $this->contractor;
    }

    /**
     * Sets the $contractor.
     *
     * @param mixed $contractor the contractor
     *
     * @return self
     */
    public function setContractor($contractor)
    {
        $this->contractor = $contractor;

        return $this;
    }

    /**
     * Gets the detailsSeller.
     *
     * @return mixed
     */
    public function getDetailsSeller()
    {
        return $this->detailsSeller;
    }

    /**
     * Sets the $detailsSeller.
     *
     * @param mixed $detailsSeller the details seller
     *
     * @return self
     */
    public function setDetailsSeller($detailsSeller)
    {
        $this->detailsSeller = $detailsSeller;

        return $this;
    }

    /**
     * Gets the buyerName.
     *
     * @return mixed
     */
    public function getBuyerName()
    {
        return $this->buyerName;
    }

    /**
     * Sets the $buyerName.
     *
     * @param mixed $buyerName the buyer name
     *
     * @return self
     */
    public function setBuyerName($buyerName)
    {
        $this->buyerName = $buyerName;

        return $this;
    }

    /**
     * Gets the buyerCountry.
     *
     * @return mixed
     */
    public function getBuyerCountry()
    {
        return $this->buyerCountry;
    }

    /**
     * Sets the $buyerCountry.
     *
     * @param mixed $buyerCountry the buyer country
     *
     * @return self
     */
    public function setBuyerCountry($buyerCountry)
    {
        $this->buyerCountry = $buyerCountry;

        return $this;
    }

    /**
     * Gets the buyerCity.
     *
     * @return mixed
     */
    public function getBuyerCity()
    {
        return $this->buyerCity;
    }

    /**
     * Sets the $buyerCity.
     *
     * @param mixed $buyerCity the buyer city
     *
     * @return self
     */
    public function setBuyerCity($buyerCity)
    {
        $this->buyerCity = $buyerCity;

        return $this;
    }

    /**
     * Gets the buyerPostCode.
     *
     * @return mixed
     */
    public function getBuyerPostCode()
    {
        return $this->buyerPostCode;
    }

    /**
     * Sets the $buyerPostCode.
     *
     * @param mixed $buyerPostCode the buyer post code
     *
     * @return self
     */
    public function setBuyerPostCode($buyerPostCode)
    {
        $this->buyerPostCode = $buyerPostCode;

        return $this;
    }

    /**
     * Gets the buyerStreet.
     *
     * @return mixed
     */
    public function getBuyerStreet()
    {
        return $this->buyerStreet;
    }

    /**
     * Sets the $buyerStreet.
     *
     * @param mixed $buyerStreet the buyer street
     *
     * @return self
     */
    public function setBuyerStreet($buyerStreet)
    {
        $this->buyerStreet = $buyerStreet;

        return $this;
    }

    /**
     * Gets the buyerNIP.
     *
     * @return mixed
     */
    public function getBuyerNIP()
    {
        return $this->buyerNIP;
    }

    /**
     * Sets the $buyerNIP.
     *
     * @param mixed $buyerNIP the buyer n i p
     *
     * @return self
     */
    public function setBuyerNIP($buyerNIP)
    {
        $this->buyerNIP = $buyerNIP;

        return $this;
    }

    /**
     * Gets the shipmentName.
     *
     * @return mixed
     */
    public function getShipmentName()
    {
        return $this->shipmentName;
    }

    /**
     * Sets the $shipmentName.
     *
     * @param mixed $shipmentName the shipment name
     *
     * @return self
     */
    public function setShipmentName($shipmentName)
    {
        $this->shipmentName = $shipmentName;

        return $this;
    }

    /**
     * Gets the shipmentCountry.
     *
     * @return mixed
     */
    public function getShipmentCountry()
    {
        return $this->shipmentCountry;
    }

    /**
     * Sets the $shipmentCountry.
     *
     * @param mixed $shipmentCountry the shipment country
     *
     * @return self
     */
    public function setShipmentCountry($shipmentCountry)
    {
        $this->shipmentCountry = $shipmentCountry;

        return $this;
    }

    /**
     * Gets the shipmentCity.
     *
     * @return mixed
     */
    public function getShipmentCity()
    {
        return $this->shipmentCity;
    }

    /**
     * Sets the $shipmentCity.
     *
     * @param mixed $shipmentCity the shipment city
     *
     * @return self
     */
    public function setShipmentCity($shipmentCity)
    {
        $this->shipmentCity = $shipmentCity;

        return $this;
    }

    /**
     * Gets the shipmentPostCode.
     *
     * @return mixed
     */
    public function getShipmentPostCode()
    {
        return $this->shipmentPostCode;
    }

    /**
     * Sets the $shipmentPostCode.
     *
     * @param mixed $shipmentPostCode the shipment post code
     *
     * @return self
     */
    public function setShipmentPostCode($shipmentPostCode)
    {
        $this->shipmentPostCode = $shipmentPostCode;

        return $this;
    }

    /**
     * Gets the shipmentStreet.
     *
     * @return mixed
     */
    public function getShipmentStreet()
    {
        return $this->shipmentStreet;
    }

    /**
     * Sets the $shipmentStreet.
     *
     * @param mixed $shipmentStreet the shipment street
     *
     * @return self
     */
    public function setShipmentStreet($shipmentStreet)
    {
        $this->shipmentStreet = $shipmentStreet;

        return $this;
    }

    /**
     * Gets the value of showShipment.
     *
     * @return mixed
     */
    public function getShowShipment()
    {
        return $this->showShipment;
    }

    /**
     * Sets the value of showShipment.
     *
     * @param mixed $showShipment the show shipment
     *
     * @return self
     */
    public function setShowShipment($showShipment)
    {
        $this->showShipment = $showShipment;

        return $this;
    }

    /**
     * Gets the headline.
     *
     * @return mixed
     */
    public function getHeadline()
    {
        return $this->headline;
    }

    /**
     * Sets the $headline.
     *
     * @param mixed $headline the headline
     *
     * @return self
     */
    public function setHeadline($headline)
    {
        $this->headline = $headline;

        return $this;
    }

    /**
     * Gets the status.
     *
     * @return mixed
     */
    public function getStatus()
    {
        return $this->status;
    }

    /**
     * Sets the $status.
     *
     * @param mixed $status the status
     *
     * @return self
     */
    public function setStatus($status)
    {
        $this->status = $status;

        return $this;
    }

    /**
     * Gets the correctionNumber.
     *
     * @return mixed
     */
    public function getCorrectionNumber()
    {
        return $this->correctionNumber;
    }

    /**
     * Sets the $correctionNumber.
     *
     * @param mixed $correctionNumber the correction number
     *
     * @return self
     */
    public function setCorrectionNumber($correctionNumber)
    {
        $this->correctionNumber = $correctionNumber;

        return $this;
    }

    /**
     * Gets the correctionDate.
     *
     * @return mixed
     */
    public function getCorrectionDate()
    {
        return $this->correctionDate;
    }

    /**
     * Sets the $correctionDate.
     *
     * @param mixed $correctionDate the correction date
     *
     * @return self
     */
    public function setCorrectionDate($correctionDate)
    {
        $this->correctionDate = $correctionDate;

        return $this;
    }

    /**
     * Gets the correctionReason.
     *
     * @return mixed
     */
    public function getCorrectionReason()
    {
        return $this->correctionReason;
    }

    /**
     * Sets the $correctionReason.
     *
     * @param mixed $correctionReason the correction reason
     *
     * @return self
     */
    public function setCorrectionReason($correctionReason)
    {
        $this->correctionReason = $correctionReason;

        return $this;
    }

    /**
     * Gets the nett value.
     *
     * @return mixed
     */
    public function getValueNett()
    {
        return $this->valueNett;
    }

    /**
     * Sets the $value.
     *
     * @param mixed $valueNett the nett value
     *
     * @return self
     */
    public function setValueNett($valueNett)
    {
        $this->valueNett = $valueNett;

        return $this;
    }

    /**
     * Gets the gross value.
     *
     * @return mixed
     */
    public function getValueGross()
    {
        return $this->valueGross;
    }

    /**
     * Sets the $valueGross.
     *
     * @param mixed $valueGross the gross value
     *
     * @return self
     */
    public function setValueGross($valueGross)
    {
        $this->valueGross = $valueGross;

        return $this;
    }

    /**
     * Gets the owner.
     *
     * @return mixed
     */
    public function getOwner()
    {
        return $this->owner;
    }

    /**
     * Sets the $owner.
     *
     * @param mixed $owner the owner
     *
     * @return self
     */
    public function setOwner($owner)
    {
        $this->owner = $owner;

        return $this;
    }

    /**
     * Gets the created.
     *
     * @return mixed
     */
    public function getCreated()
    {
        return $this->created;
    }

    /**
     * Sets the $created.
     *
     * @param mixed $created the created
     *
     * @return self
     */
    public function setCreated($created)
    {
        $this->created = $created;

        return $this;
    }

    /**
     * Gets the modified.
     *
     * @return mixed
     */
    public function getModified()
    {
        return $this->modified;
    }

    /**
     * Sets the $modified.
     *
     * @param mixed $modified the modified
     *
     * @return self
     */
    public function setModified($modified)
    {
        $this->modified = $modified;

        return $this;
    }
}
