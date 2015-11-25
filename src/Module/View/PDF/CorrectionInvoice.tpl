@no-extends
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
</head>
<body>
    <style>
        body {font-family:'dejavu sans';font-size:10px;color:#000;}
        table {width:100%;border-spacing:0;margin:0 0 20px 0;padding:0;border-collapse:collapse;}
        table td,
        table th {font-size:8px;color:#000;padding:2px 4px;text-align:left;vertical-align:top;}
        table th {font-size:8px;font-weight:bold;text-transform:uppercase;padding:5px 4px;background-color:#E1E1E1}
        table tr:nth-child(even) td {background-color:#F7F7F7}
        table td small {font-size:7px;color:#777;display:block;}
        table.t th,
        table.t td {border:1px solid #ddd;}
        table.tax-table td,
        table.tax-table th {padding:2px 4px;background-color:transparent;}
        table.tax-table .tax-sum td {font-weight:bold;}
        div.summary {font-size:13px;font-weight:bold;text-align:right;margin:10px 0 20px 0;}
        div.summary span {font-size:15px;}
    </style>
    <div>
        <table>
            <tbody>
                <tr>
                    <td style="vertical-align:top;width:25%">
                        <?php $file = '/modules/Invoice/'.$app->openSettings('app')->get('mod.invoice.pdf.logo'); ?>

                        <?php if(is_file(BASEPATH.'/web'.$file)): ?>
                            <img style="height:140px" src="{{ $app->request()->getUriForPath($file) }}" />
                        <?php endif; ?>
                    </td>
                    <td style="vertical-align:top;width:50%;">
                        <h1 style="text-align:center;text-transform:uppercase;font-size:16px;margin:0;padding:0;">{{ $invoice->getHeadline() }}</h1>
                        <h2 style="text-align:center;text-transform:uppercase;font-weight:normal;font-size:13px;margin:0;padding:0;color:#666;">{{ $invoice->getNumber() }}</h2>
                        <h2 style="text-align:center;text-transform:uppercase;font-weight:normal;font-size:11px;margin:5px 0 0 0;padding:0;color:#aaa;">({{ $type }})</h2>
                    </td>
                    <td style="vertical-align:top;text-align:right;width:25%;">
                        {{ t('invoiceReleaseDate') }}: <span>{{ date('Y-m-d', $invoice->getReleaseDate()) }}</span><br />
                        {{ t('invoiceSellDate') }}: <span>{{ date('Y-m-d', $invoice->getSellDate()) }}</span><br />
                        {{ t('invoicePaymentDate') }}: <span>{{ date('Y-m-d', $invoice->getPaymentDate()) }}</span><br />
                        ---------------------------------<br />
                        {{ t('invoiceCorrectionNumber') }}: <span>{{ $invoice->getCorrectionNumber() }}</span><br />
                        {{ t('invoiceCorrectionDate') }}: <span>{{ date('Y-m-d', $invoice->getCorrectionDate()) }}</span>
                    </td>
                </tr>
            </tbody>
        </table>
        <table>
            <tbody>
                <tr>
                    @if $invoice->getShowShipment()
                        <td style="vertical-align:top;width:33.33%"><h3 style="font-size:10px">{{ t('invoiceSeller') }}</h3><?php echo nl2br($invoice->getDetailsSeller()); ?></td>
                        <td style="vertical-align:top;width:33.33%"><h3 style="font-size:10px">{{ t('invoiceBuyer') }}</h3>{{ $invoice->getBuyerName() }}<br /><br />{{ $invoice->getBuyerStreet() }}<br />{{ $invoice->getBuyerPostCode() }} {{ $invoice->getBuyerCity() }} ({{ $invoice->getBuyerCountry() }})<br />NIP: {{ $invoice->getBuyerNIP() }}</td>
                        <td style="vertical-align:top;width:33.33%"><h3 style="font-size:10px">{{ t('invoiceRecipient') }}</h3>{{ $invoice->getShipmentName() }}<br /><br />{{ $invoice->getShipmentStreet() }}<br />{{ $invoice->getShipmentPostCode() }} {{ $invoice->getShipmentCity() }} ({{ $invoice->getShipmentCountry() }})</td>
                    @else
                        <td style="vertical-align:top;width:50%"><h3 style="font-size:10px">{{ t('invoiceSeller') }}</h3><?php echo nl2br($invoice->getDetailsSeller()); ?></td>
                        <td style="vertical-align:top;width:50%"><h3 style="font-size:10px">{{ t('invoiceBuyer') }}</h3>{{ $invoice->getBuyerName() }}<br /><br />{{ $invoice->getBuyerStreet() }}<br />{{ $invoice->getBuyerPostCode() }} {{ $invoice->getBuyerCity() }} ({{ $invoice->getBuyerCountry() }})<br />NIP: {{ $invoice->getBuyerNIP() }}</td>
                    @endif
                </tr>
            </tbody>
        </table>
        <table class="t">
            <thead>
                <tr>
                    <th style="text-align:center;">{{ t('invoiceNO') }}</th>
                    <th>{{ t('name') }}</th>
                    <th style="text-align:center;">{{ t('invoiceMeasureUnit') }}</th>
                    <th style="text-align:center;">{{ t('invoiceQuantity') }}</th>
                    <th style="text-align:center;">{{ t('invoiceUnitPrice') }}</th>
                    <th style="text-align:center;">{{ t('invoiceDiscount') }} (%)</th>
                    <th style="text-align:center;">{{ t('invoiceTaxRate') }}</th>
                    <th style="text-align:center;">{{ t('invoiceTaxValue') }}</th>
                    <th style="text-align:center;">{{ t('invoiceValue') }}</th>
                </tr>
            </thead>
            <?php
                $totalSum    = 0;
                $taxesValues = [];
            ?>
            <tbody>
                @foreach $products
                    <?php
                        $tax   = ((float) $item->getTax()) / 100;
                        $price = ((float) $item->getUnitPriceNet());
                        $qty   = ((float) $item->getQty());
                        $discount = ((float) $item->getDiscount()) / 100;

                        if($discount)
                        {
                            $price = $price - ($price * $discount);
                        }

                        // (qty * unitPriceNet) * tax%
                        $taxValue = ($qty * $price) * $tax;

                        // ((qty * unitPriceNet) * tax%) + (qty * unitPriceNet)
                        $grossValue = (($qty * $price) * $tax) + ($qty * $price);

                        if(isset($taxesValues[$item->getTax()]) === false)
                        {
                            $taxesValues[$item->getTax()] = 0;
                        }

                        $taxesValues[$item->getTax()] += ($qty * $price);
                        $totalSum += $grossValue;
                    ?>
                    <tr>
                        <td style="text-align:right;"><?php echo $key + 1; ?>.</td>
                        <td>{{ $item->getName() }}</td>
                        <td style="text-align:center;">{{ $item->getUnit() }}</td>
                        <td style="text-align:center;">{{ $item->getQty() }}</td>
                        <td style="text-align:right;"><?php echo number_format($item->getUnitPriceNet(), 2, '.', ''); ?></td>
                        <td style="text-align:right;">{{ $item->getDiscount() }}</td>
                        <td style="text-align:right;">{{ $item->getTax() }}</td>
                        <td style="text-align:right;"><?php echo number_format($taxValue, 2, '.', ''); ?></td>
                        <td style="text-align:right;"><?php echo number_format($grossValue, 2, '.', ''); ?></td>
                    </tr>
                @endforeach
            </tbody>
        </table>
        <table>
            <tbody>
                <tr>
                    <td style="width:65%"> </td>
                    <td style="width:35%;padding:0;">
                        <table class="tax-table t">
                            <thead>
                                <tr>
                                    <th style="text-align:center;">{{ t('invoiceVAT') }}</th>
                                    <th style="text-align:center;">{{ t('invoiceValueNet') }}</th>
                                    <th style="text-align:center;">{{ t('invoiceValueVAT') }}</th>
                                    <th style="text-align:center;">{{ t('invoiceValueGross') }}</th>
                                </tr>
                            </thead>
                            <?php
                                $taxSumA = 0;
                                $taxSumB = 0;
                                $taxSumC = 0;
                            ?>
                            <tbody>
                                @foreach $taxesValues
                                    <?php
                                        $w = floatval($item * ($key / 100));

                                        $taxSumA += $item;
                                        $taxSumB += $w;
                                        $taxSumC += $item + $w;
                                    ?>
                                    <tr>
                                        <td style="text-align:center;">{{ $key }}</td>
                                        <td style="text-align:right;"><?php echo number_format($item, 2, '.', ''); ?></td>
                                        <td style="text-align:right;"><?php echo number_format($w, 2, '.', ''); ?></td>
                                        <td style="text-align:right;"><?php echo number_format($item + $w, 2, '.', ''); ?></td>
                                    </tr>
                                @endforeach
                            </tbody>
                            <tfoot>
                                <tr class="tax-sum">
                                    <td style="text-align:center;">{{ t('invoiceTotal') }}</td>
                                    <td style="text-align:right;"><?php echo number_format($taxSumA, 2, '.', ''); ?></td>
                                    <td style="text-align:right;"><?php echo number_format($taxSumB, 2, '.', ''); ?></td>
                                    <td style="text-align:right;"><?php echo number_format($taxSumC, 2, '.', ''); ?></td>
                                </tr>
                            </tfoot>
                        </table>
                    </td>
                </tr>
            </tbody>
        </table>
        <div></div>
        <div class="summary">{{ t('invoiceToPay') }}: <span><?php echo number_format($totalSum, 2, '.', ''); ?></span> zł</div>
        <div class="correction-reason">
            <span style="text-align:left;font-weight:normal;font-size:10px;margin:0 0 2px 0;padding:0;color:#000;font-weight:bold;">Powód korekty:</span> &nbsp; <i style="font-size:9px;">{{ $invoice->getCorrectionReason() }}</i>
        </div>
        <table>
            <tbody>
                <tr>
                    <td style="padding:30px;width:50%;"><div style="text-align:center;border:1px solid #ddd;padding:5px;"><div style="height:80px;"></div>{{ t('invoicePersonAuthorizedToCollect') }}</div></td>
                    <td style="padding:30px;width:50%;"><div style="text-align:center;border:1px solid #ddd;padding:5px;"><div style="height:80px;"></div>{{ t('invoicePersonAuthorizedToProduction') }}</div></td>
                </tr>
            </tbody>
        </table>
    </div>
</body>
</html>
