CREATE TABLE IF NOT EXISTS `#__invoice_product` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `invoiceId` int(11) NOT NULL,
  `productId` int(11) NOT NULL,
  `createDate` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `unitPriceNet` double NOT NULL,
  `qty` int(11) NOT NULL,
  `tax` double NOT NULL,
  `unit` varchar(8) COLLATE utf8_unicode_ci NOT NULL,
  `discount` double NOT NULL DEFAULT '0',
  `comment` varchar(512) COLLATE utf8_unicode_ci NOT NULL,
  `current` char(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `invoiceId` (`invoiceId`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1 ;
