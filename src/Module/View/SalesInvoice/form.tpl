<?php $app->assetter()->load('typeahead')->load('datetimepicker')->load('bootbox')->load('checkbox-toggle'); ?>
<style>
    .invoice-wizard .step-out {display:block;}
    .invoice-wizard .nav-tabs li.done a {color:#29B12B;}
    .input-blink-change input {-webkit-transition : border 500ms ease-out;-moz-transition : border 500ms ease-out;-o-transition : border 500ms ease-out;transition : border 500ms ease-out;}
    .flash {border-color:#0088CC;}

    .products-list .item {margin-bottom:5px;}
    .products-list .item:after {display:table;clear:both;content:" ";}
    .products-list .item .hl {display:block;background-color:#0088CC;width:100%;padding:5px 5px;}
    .products-list .item .hl:after {display:table;clear:both;content:" ";}
    .products-list .item .hl:hover {cursor:pointer;}
    .products-list .item .hl h1 {font-size:14px;text-transform:uppercase;font-weight:normal;color:#fff;float:left;margin:0;padding:4px 0;}
    .products-list .item .hl button {float:right;}
    .products-list .item .cnt {display:none;padding:5px 15px 0;}
    .products-list .item.opened .cnt {display:block;}

    .invoice-preview {max-width:800px;padding:20px;border:1px solid #ddd;box-shadow:0 0 5px rgba(0,0,0,.3);}
    .invoice-preview table {width:100%;border-spacing:0;margin:0 0 20px 0;padding:0;border-collapse:collapse;}
    .invoice-preview table td,
    .invoice-preview table th {font-size:10px;color:#000;padding:2px 4px;text-align:left;vertical-align:top;}
    .invoice-preview table th {font-size:10px;font-weight:bold;text-transform:uppercase;padding:5px 4px;background-color:#E1E1E1}
    .invoice-preview table tr:nth-child(even) td {background-color:#F7F7F7}
    .invoice-preview table td small {font-size:9px;color:#777;display:block;}
    .invoice-preview table.t th,
    .invoice-preview table.t td {border:1px solid #ddd;}
    .invoice-preview table.tax-table td,
    .invoice-preview table.tax-table th {padding:2px 4px;background-color:transparent;}
    .invoice-preview table.tax-table .tax-sum td {font-weight:bold;}
    .invoice-preview div.summary {font-size:13px;font-weight:bold;text-align:right;margin:5px 0;}
    .invoice-preview div.summary span {font-size:15px;}
    .invoice-preview div.discount {font-size:13px;font-weight:bold;text-align:right;margin:5px 0;}
    .invoice-preview div.discount span {font-size:15px;}
</style>

<div class="page-header">
    <div class="page-header-content">
        <div class="page-title">
            <h1>
                <i class="fa fa-credit-card"></i>
                <?php echo $invoice->getId() ? $app->t('invoiceEdit') : $app->t('invoiceNew'); ?><small> / {{ t('invoiceTypeSales') }}</small>
            </h1>
        </div>
        <div class="heading-elements">
            <div class="heading-btn-group">
                <a href="#" data-form-submit="form" data-form-param="apply" class="btn btn-icon-block btn-link-success">
                    <i class="fa fa-save"></i>
                    <span>{{ t('apply') }}</span>
                </a>
                <a href="#" data-form-submit="form" data-form-param="save" class="btn btn-icon-block btn-link-success">
                    <i class="fa fa-save"></i>
                    <span>{{ t('save') }}</span>
                </a>
                <a href="#" class="btn btn-icon-block btn-link-danger app-history-back">
                    <i class="fa fa-remove"></i>
                    <span>{{ t('cancel') }}</span>
                </a>
            </div>
        </div>
        <div class="heading-elements-toggle">
            <i class="fa fa-ellipsis-h"></i>
        </div>
    </div>
    <div class="breadcrumb-line">
        <ul class="breadcrumb">
            <li><a href="{{ createUrl() }}"><i class="fa fa-home"> </i>Verone</a></li>
            <li><a href="{{ createUrl('Invoice', 'Invoice', 'index') }}">{{ t('invoices') }}</a></li>
            @if $invoice->getId()
                <li class="active"><a href="{{ createUrl('Invoice', 'SalesInvoice', 'edit', [ 'id' => $invoice->getId() ]) }}">{{ t('invoiceEdit') }}</a></li>
            @else
                <li class="active"><a href="{{ createUrl('Invoice', 'SalesInvoice', 'add') }}">{{ t('invoiceNew') }}</a></li>
            @endif
        </ul>
    </div>
</div>

<div class="container-fluid">
    <div class="row">
        <div class="col-md-12">
            <form action="{{ createUrl('Invoice', 'SalesInvoice', $invoice->getId() ? 'update' : 'save') }}" method="post" id="form" class="form-validation">
                <input type="hidden" name="id" value="{{ $invoice->getId() }}" />
                <div class="panel panel-default">
                    <div class="panel-heading">{{ t('invoiceCreator') }}</div>
                    <div class="panel-body invoice-wizard">
                        <div class="tabbable tabs-left">
                            <ul class="nav nav-tabs">
                                <li><a href="#">{{ t('invoiceIntroduction') }}</a></li>
                                <li><a href="#">{{ t('invoiceSellerDetails') }}</a></li>
                                <li><a href="#">{{ t('invoiceBuyerDetails') }}</a></li>
                                <li><a href="#">{{ t('invoiceContent') }}</a></li>
                                <li><a href="#">{{ t('invoiceSummary') }}</a></li>
                            </ul>
                            <div class="tab-content">
                                <div class="step-out">
                                    <div class="step-inn">
                                        <div class="container-fluid">
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label for="releaseDate" class="control-label">{{ t('invoiceReleaseDate') }}</label>
                                                        <div class="input-group date">
                                                            <input class="form-control required" type="text" id="releaseDate" name="releaseDate" value="{{ date('Y-m-d', $invoice->getReleaseDate()) }}" />
                                                            <span class="input-group-addon calendar-open">
                                                                <span class="fa fa-calendar"></span>
                                                            </span>
                                                        </div>
                                                    </div>
                                                    <div class="form-group">
                                                        <label for="sellDate" class="control-label">{{ t('invoiceSellDate') }}</label>
                                                        <div class="input-group date">
                                                            <input class="form-control required" type="text" id="sellDate" name="sellDate" value="{{ date('Y-m-d', $invoice->getSellDate()) }}" />
                                                            <span class="input-group-addon calendar-open">
                                                                <span class="fa fa-calendar"></span>
                                                            </span>
                                                        </div>
                                                    </div>
                                                    <input class="form-control" type="hidden" id="paymentDateType" name="paymentDateType" value="1" />
                                                    <div class="form-group payment-date-calendar">
                                                        <label for="paymentDate" class="control-label">{{ t('invoicePaymentDate') }} (<a href="#">{{ t('invoiceChangeToDaysNumber') }}</a>)</label>
                                                        <div class="input-group date">
                                                            <input class="form-control" type="text" id="paymentDate" name="paymentDate" value="{{ date('Y-m-d', $invoice->getPaymentDate()) }}" />
                                                            <span class="input-group-addon calendar-open">
                                                                <span class="fa fa-calendar"></span>
                                                            </span>
                                                        </div>
                                                    </div>
                                                    <div class="form-group payment-date-days" style="display:none;">
                                                        <label for="paymentDays" class="control-label">{{ t('invoicePaymentDate') }} (<a href="#">{{ t('invoiceChangeToDate') }}</a>)</label>
                                                        <div class="input-group">
                                                            <span class="input-group-addon calendar-open">{{ t('invoiceFor') }}</span>
                                                            <input class="form-control" type="text" id="paymentDays" name="paymentDays" value="14" />
                                                            <span class="input-group-addon calendar-open">{{ t('invoiceDays') }}</span>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label for="headline" class="control-label">{{ t('invoiceHeadline') }}</label>
                                                        <input class="form-control required" type="text" id="headline" name="headline" value="{{ $invoice->getHeadline() }}" />
                                                    </div>
                                                    <div class="form-group hidden">
                                                        <label for="number" class="control-label">{{ t('invoiceNumber') }}</label>
                                                        <input class="form-control" type="text" disabled="disabled" id="number" name="number" value="{{ $invoice->getNumber() }}" />
                                                    </div>
                                                    <div class="form-group">
                                                        <label for="status" class="control-label">{{ t('invoiceStatus') }}</label>
                                                        <select name="status" class="form-control" id="status">
                                                            <option value="1"{{ $invoice->getStatus() == 1 ? ' selected="selected"' : '' }}>{{ t('invoiceStatus1') }}</option>
                                                            <option value="2"{{ $invoice->getStatus() == 2 ? ' selected="selected"' : '' }}>{{ t('invoiceStatus2') }}</option>
                                                            <option value="3"{{ $invoice->getStatus() == 3 ? ' selected="selected"' : '' }}>{{ t('invoiceStatus3') }}</option>
                                                            <option value="4"{{ $invoice->getStatus() == 4 ? ' selected="selected"' : '' }}>{{ t('invoiceStatus4') }}</option>
                                                            <option value="5"{{ $invoice->getStatus() == 5 ? ' selected="selected"' : '' }}>{{ t('invoiceStatus5') }}</option>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="clearfix"></div>
                                        <hr />
                                        <button type="button" class="btn btn-default btn-wizard-prev"><i class="fa fa-angle-left"></i> {{ t('back') }}</button>
                                        <button type="button" class="btn btn-primary btn-wizard-next">{{ t('forward') }} <i class="fa fa-angle-right"></i></button>
                                    </div>
                                </div>
                                <div class="step-out">
                                    <div class="step-inn">
                                        <div class="container-fluid">
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label for="detailsSeller" class="control-label">{{ t('invoiceFullSellerDetails') }}</label>
                                                        <textarea class="form-control required" rows="10" id="detailsSeller" name="detailsSeller">{{ $invoice->getDetailsSeller() }}</textarea>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="clearfix"></div>
                                        <hr />
                                        <button type="button" class="btn btn-default btn-wizard-prev"><i class="fa fa-angle-left"></i> {{ t('back') }}</button>
                                        <button type="button" class="btn btn-primary btn-wizard-next">{{ t('forward') }} <i class="fa fa-angle-right"></i></button>
                                    </div>
                                </div>
                                <div class="step-out step-contractor">
                                    <div class="step-inn">
                                        <input type="hidden" id="contractorId" name="contractor" value="{{ $invoice->getContractor() }}" />
                                        <div class="container-fluid">
                                            <div class="row">
                                                <div class="col-md-12">
                                                    <div class="form-group has-feedback">
                                                        <div class="input-group">
                                                            <span class="input-group-addon"><i class="fa fa-search"></i> {{ t('search') }}</span>
                                                            <input type="text" autocomplete="off" id="invoice-search-contractor" class="form-control" />
                                                            <span class="fa fa-circle-o-notch fa-spin form-control-feedback hidden" aria-hidden="true"></span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row input-blink-change">
                                                <div class="col-md-6">
                                                    <h3>{{ t('invoiceBuyerDetails') }}</h3>
                                                    <div class="container-fluid">
                                                        <div class="row">
                                                            <div class="col-md-6">
                                                                <div class="form-group">
                                                                    <label for="buyerName" class="control-label">{{ t('invoiceBuyerName') }}</label>
                                                                    <input class="form-control required" type="text" id="buyerName" name="buyerName" value="{{ $invoice->getBuyerName() }}" />
                                                                </div>
                                                                <div class="form-group">
                                                                    <label for="buyerCity" class="control-label">{{ t('invoiceCity') }}</label>
                                                                    <input class="form-control required" type="text" id="buyerCity" name="buyerCity" value="{{ $invoice->getBuyerCity() }}" />
                                                                </div>
                                                                <div class="form-group">
                                                                    <label for="buyerStreet" class="control-label">{{ t('invoiceStreet') }}</label>
                                                                    <input class="form-control required" type="text" id="buyerStreet" name="buyerStreet" value="{{ $invoice->getBuyerStreet() }}" />
                                                                </div>
                                                            </div>
                                                            <div class="col-md-6">
                                                                <div class="form-group">
                                                                    <label for="buyerCountry" class="control-label">{{ t('invoiceCountry') }}</label>
                                                                    <input class="form-control required" type="text" id="buyerCountry" name="buyerCountry" value="{{ $invoice->getBuyerCountry() }}" />
                                                                </div>
                                                                <div class="form-group">
                                                                    <label for="buyerPostCode" class="control-label">{{ t('invoicePostCode') }}</label>
                                                                    <input class="form-control required" type="text" id="buyerPostCode" name="buyerPostCode" value="{{ $invoice->getBuyerPostCode() }}" />
                                                                </div>
                                                                <div class="form-group">
                                                                    <label for="buyerNIP" class="control-label">{{ t('invoiceNIP') }}</label>
                                                                    <input class="form-control required" type="text" id="buyerNIP" name="buyerNIP" value="{{ $invoice->getBuyerNIP() }}" />
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <h3>{{ t('invoiceRecipientsDetails') }}</h3>
                                                    <div class="container-fluid" id="shipment-details">
                                                        <div class="row">
                                                            <div class="col-md-6">
                                                                <div class="form-group">
                                                                    <label for="shipmentName" class="control-label">{{ t('invoiceRecipientName') }}</label>
                                                                    <input class="form-control" type="text" id="shipmentName" name="shipmentName" value="{{ $invoice->getShipmentName() }}" />
                                                                </div>
                                                                <div class="form-group">
                                                                    <label for="shipmentCity" class="control-label">{{ t('invoiceCity') }}</label>
                                                                    <input class="form-control" type="text" id="shipmentCity" name="shipmentCity" value="{{ $invoice->getShipmentCity() }}" />
                                                                </div>
                                                                <div class="form-group">
                                                                    <label for="shipmentStreet" class="control-label">{{ t('invoiceStreet') }}</label>
                                                                    <input class="form-control" type="text" id="shipmentStreet" name="shipmentStreet" value="{{ $invoice->getShipmentStreet() }}" />
                                                                </div>
                                                            </div>
                                                            <div class="col-md-6">
                                                                <div class="form-group">
                                                                    <label for="shipmentCountry" class="control-label">{{ t('invoiceCountry') }}</label>
                                                                    <input class="form-control" type="text" id="shipmentCountry" name="shipmentCountry" value="{{ $invoice->getShipmentCountry() }}" />
                                                                </div>
                                                                <div class="form-group">
                                                                    <label for="shipmentPostCode" class="control-label">{{ t('invoicePostCode') }}</label>
                                                                    <input class="form-control" type="text" id="shipmentPostCode" name="shipmentPostCode" value="{{ $invoice->getShipmentPostCode() }}" />
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <hr />
                                                    <div>
                                                        <span>Pokaż na fakturze: &nbsp; </span> <input type="checkbox" class="checkbox-toggle" name="showShipment" id="showShipment" data-size="mini" value="1"<?php echo ($invoice->getShowShipment() ? ' checked="checked"' : ''); ?> />
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="clearfix"></div>
                                        <hr />
                                        <button type="button" class="btn btn-default btn-wizard-prev"><i class="fa fa-angle-left"></i> {{ t('back') }}</button>
                                        <button type="button" class="btn btn-primary btn-wizard-next">{{ t('forward') }} <i class="fa fa-angle-right"></i></button>
                                    </div>
                                </div>
                                <div class="step-out step-products">
                                    <div class="step-inn">
                                        <div class="container-fluid">
                                            <div class="row">
                                                <div class="col-md-12">
                                                    <div class="form-group has-feedback">
                                                        <div class="input-group">
                                                            <span class="input-group-addon"><i class="fa fa-search"></i> {{ t('search') }}</span>
                                                            <input type="text" autocomplete="off" id="invoice-search-product" class="form-control" />
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-12">
                                                    <div class="products-list">
                                                        @foreach $products
                                                            <div class="item">
                                                                <input type="hidden" id="patt_product_id" class="patt-product-id" name="product[{{ $item->getId() }}][id]" value="{{ $item->getId() }}" />
                                                                <input type="hidden" id="patt_product_unit" class="patt-product-unit" name="product[{{ $item->getId() }}][unit]" value="{{ $item->getUnit() }}" />
                                                                <input type="hidden" id="patt_product_name" class="patt-product-name" name="product[{{ $item->getId() }}][name]" value="{{ $item->getName() }}" />
                                                                <div class="hl">
                                                                    <h1>{{ $item->getName() }}</h1>
                                                                    <button type="button" class="btn btn-xs btn-danger"><i class="fa fa-remove"></i></button>
                                                                </div>
                                                                <div class="cnt">
                                                                    <div class="container-fluid">
                                                                        <div class="row">
                                                                            <div class="col-md-6">
                                                                                <div class="form-group">
                                                                                    <label for="patt_product_unitPriceNet" class="control-label">{{ t('invoiceUnitPriceNet') }}</label>
                                                                                    <div class="input-group">
                                                                                        <input class="form-control patt-product-unitPriceNet" type="text" id="patt_product_unitPriceNet" name="product[{{ $item->getId() }}][unitPriceNet]" value="{{ $item->getUnitPriceNet() }}" />
                                                                                        <span class="input-group-addon calendar-open">{{ $app->get('helper.currency')->getDefault()->symbol }}</span>
                                                                                    </div>
                                                                                </div>
                                                                                <div class="form-group">
                                                                                    <label for="patt_product_tax" class="control-label">{{ t('invoiceTaxValue') }}</label>
                                                                                    <div class="input-group">
                                                                                        <input class="form-control patt-product-tax" type="text" id="patt_product_tax" name="product[{{ $item->getId() }}][tax]" value="{{ $item->getTax() }}" />
                                                                                        <span class="input-group-addon calendar-open">%</span>
                                                                                    </div>
                                                                                </div>
                                                                                <div class="form-group">
                                                                                    <label for="patt_product_discount" class="control-label">{{ t('invoiceDiscount') }}</label>
                                                                                    <div class="input-group">
                                                                                        <input class="form-control patt-product-discount" type="text" id="patt_product_discount" name="product[{{ $item->getId() }}][discount]" value="{{ $item->getDiscount() }}" />
                                                                                        <span class="input-group-addon calendar-open">%</span>
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                            <div class="col-md-6">
                                                                                <div class="form-group">
                                                                                    <label for="patt_product_qty" class="control-label">{{ t('invoiceQuantity') }}</label>
                                                                                    <input class="form-control patt-product-qty" type="text" id="patt_product_qty" name="product[{{ $item->getId() }}][qty]" value="{{ $item->getQty() }}" />
                                                                                </div>
                                                                                <div class="form-group">
                                                                                    <label for="patt_product_comment" class="control-label">{{ t('invoiceComment') }}</label>
                                                                                    <textarea class="form-control patt-product-comment auto-grow" id="patt_product_comment" name="product[{{ $item->getId() }}][comment]">{{ $item->getComment() }}</textarea>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        @endforeach
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="clearfix"></div>
                                        <hr />
                                        <button type="button" class="btn btn-default btn-wizard-prev"><i class="fa fa-angle-left"></i> {{ t('back') }}</button>
                                        <button type="button" class="btn btn-primary btn-wizard-next">{{ t('forward') }} <i class="fa fa-angle-right"></i></button>
                                    </div>
                                </div>
                                <div class="step-out">
                                    <div class="step-inn">
                                        <div class="invoice-preview">
                                            <table class="info">
                                                <tbody>
                                                    <tr>
                                                        <td style="vertical-align:top;width:25%">
                                                            <?php $file = '/modules/Invoice/'.$app->openSettings('app')->get('mod.invoice.pdf.logo'); ?>

                                                            <?php if(is_file(BASEPATH.'/web'.$file)): ?>
                                                                <img style="height:140px" src="{{ $app->request()->getUriForPath($file) }}" />
                                                            <?php endif; ?>
                                                        </td>
                                                        <td style="vertical-align:top;width:50%;" class="hl">
                                                            <h1 style="text-align:center;text-transform:uppercase;font-size:20px;margin:0 0 7px 0;padding:0;font-weight:bold;" class="title"></h1>
                                                            <h2 style="text-align:center;text-transform:uppercase;font-weight:normal;font-size:14px;margin:0;padding:0;color:#666;" class="number"></h2>
                                                            <h2 style="text-align:center;text-transform:uppercase;font-weight:normal;font-size:11px;margin:5px 0 0 0;padding:0;color:#aaa;">({{ t('invoiceOriginal') }})</h2>
                                                        </td>
                                                        <td style="vertical-align:top;text-align:right;width:25%;">
                                                            <span class="date-release">{{ t('invoiceReleaseDate') }}: <span></span></span><br />
                                                            <span class="date-sell">{{ t('invoiceSellDate') }}: <span></span></span><br />
                                                            <span class="date-payment">{{ t('invoicePaymentDate') }}: <span></span></span>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <table class="details">
                                                <tbody>
                                                    <tr>
                                                        <td style="vertical-align:top;width:33.33%" class="seller-shippment"><h3 style="font-size:13px;font-weight:bold;">{{ t('invoiceSeller') }}</h3><div id="details-seller"></div></td>
                                                        <td style="vertical-align:top;width:33.33%" class="buyer-shippment"><h3 style="font-size:13px;font-weight:bold;">{{ t('invoiceBuyer') }}</h3><div id="details-buyer"></div></td>
                                                        <td style="vertical-align:top;width:33.33%" class="details-shippment"><h3 style="font-size:13px;font-weight:bold;">{{ t('invoiceRecipient') }}</h3><div id="details-shippment"></div></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <table class="products-table t">
                                                <thead>
                                                    <tr>
                                                        <th style="text-align:right;">{{ t('invoiceNO') }}</th>
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
                                                <tbody>
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
                                                                <tfoot>
                                                                    <tr class="tax-sum">
                                                                        <td style="text-align:center;">{{ t('invoiceTotal') }}</td>
                                                                        <td style="text-align:right;" id="a"></td>
                                                                        <td style="text-align:right;" id="b"></td>
                                                                        <td style="text-align:right;" id="c"></td>
                                                                    </tr>
                                                                </tfoot>
                                                                <tbody>
                                                                </tbody>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <div></div>
                                            <div class="summary">{{ t('invoiceToPay') }}: <span>0</span> zł</div>
                                            <table>
                                                <tbody>
                                                    <tr>
                                                        <td style="padding:30px;width:50%;"><div style="text-align:center;border:1px solid #ddd;padding:5px;"><div style="height:80px;"></div>{{ t('invoicePersonAuthorizedToCollect') }}</div></td>
                                                        <td style="padding:30px;width:50%;"><div style="text-align:center;border:1px solid #ddd;padding:5px;"><div style="height:80px;"></div>{{ t('invoicePersonAuthorizedToProduction') }}</div></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <div style="text-align:center;"></div>
                                        </div>
                                        <div class="clearfix"></div>
                                        <hr />
                                        <button type="button" class="btn btn-default btn-wizard-prev"><i class="fa fa-angle-left"></i> {{ t('back') }}</button>
                                        <button type="submit" class="btn btn-success btn-wizard-save">{{ t('save') }}</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<div id="product-list-item-pattern" style="display:none">
    <div class="item">
        <input type="hidden" id="patt_product_id" class="patt-product-id" name="patt_product_id" />
        <input type="hidden" id="patt_product_unit" class="patt-product-unit" name="patt_product_unit" />
        <input type="hidden" id="patt_product_name" class="patt-product-name" name="patt_product_name" />
        <div class="hl">
            <h1>Nazwa jakiegoś produktu</h1>
            <button type="button" class="btn btn-xs btn-danger"><i class="fa fa-remove"></i></button>
        </div>
        <div class="cnt">
            <div class="container-fluid">
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="patt_product_unitPriceNet" class="control-label">Cena jednostkowa NETTO</label>
                            <div class="input-group">
                                <input class="form-control patt-product-unitPriceNet" type="text" id="patt_product_unitPriceNet" name="patt_product_unitPriceNet" />
                                <span class="input-group-addon calendar-open">{{ $app->get('helper.currency')->getDefault()->symbol }}</span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="patt_product_tax" class="control-label">Wartość podatku</label>
                            <div class="input-group">
                                <input class="form-control patt-product-tax" type="text" id="patt_product_tax" name="patt_product_tax" />
                                <span class="input-group-addon calendar-open">%</span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="patt_product_discount" class="control-label">{{ t('invoiceDiscount') }}</label>
                            <div class="input-group">
                                <input class="form-control patt-product-discount" type="text" id="patt_product_discount" name="patt_product_discount" />
                                <span class="input-group-addon calendar-open">%</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="patt_product_qty" class="control-label">Ilość</label>
                            <input class="form-control patt-product-qty" type="text" id="patt_product_qty" name="patt_product_qty" />
                        </div>
                        <div class="form-group">
                            <label for="patt_product_comment" class="control-label">Uwagi</label>
                            <textarea class="form-control patt-product-comment auto-grow" id="patt_product_comment" name="patt_product_comment"></textarea>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    var currentStep  = 0;
    var totalSteps   = 0;
    var lastDoneStep = -1;

    var nextStep = function() {
        if(currentStep + 1 >= totalSteps || beforeNextStep(currentStep + 1) === false)
        {
            return;
        }

        $('.invoice-wizard .nav-tabs li').eq(currentStep).addClass('done');

        currentStep++;
        lastDoneStep = currentStep;
        resetSteps();
        $('.step-out').eq(currentStep).show();
        $('.invoice-wizard .nav-tabs li').eq(currentStep).addClass('active');

        return false;
    };

    var prevStep = function() {
        if(currentStep - 1 < 0)
        {
            return;
        }

        currentStep--;
        resetSteps();
        $('.step-out').eq(currentStep).show();
        $('.invoice-wizard .nav-tabs li').eq(currentStep).addClass('active');

        return false;
    };

    var showStep = function(step) {
        if(step == currentStep + 1)
        {
            nextStep();
        }

        if(step > lastDoneStep)
        {
            return;
        }

        currentStep = step;
        resetSteps();
        $('.step-out').eq(currentStep).show();
        $('.invoice-wizard .nav-tabs li').eq(currentStep).addClass('active');
    };

    var resetSteps = function() {
        $('.invoice-wizard .nav-tabs li').removeClass('active');
        $('.invoice-wizard .step-out').hide();
        lastDoneStep = currentStep;

        $('.invoice-wizard .nav-tabs li').each(function(index) {
            if(index >= currentStep)
            {
                $(this).removeClass('done');
            }
        });
    };

    var beforeNextStep = function(step) {
        if(step == 1)
        {
            var canGo = true;

            $('#releaseDate, #sellDate, #paymentDate, #paymentDays, #headline').each(function() {
                if(! APP.FormValidation.validateControl($(this)))
                {
                    canGo = false;
                }
            });

            return canGo;
        }

        if(step == 2)
        {
            return APP.FormValidation.validateControl($('#detailsSeller'));
        }

        if(step == 3)
        {
            var canGo = true;

            $('#buyerName, #buyerCity, #buyerStreet, #buyerCountry, #buyerPostCode, #buyerNIP, #shipmentName, #shipmentCity, #shipmentStreet, #shipmentCountry, #shipmentPostCode').each(function() {
                if(! APP.FormValidation.validateControl($(this)))
                {
                    canGo = false;
                }
            });

            $('#invoice-search-contractor').trigger('focus');

            return canGo;
        }

        if(step == 4)
        {
            if($('.products-list .item').length == 0)
            {
                bootbox.alert('Wybierz jakiś produkt by móc przejść dalej.', function() {
                    setTimeout(function() {
                        $('#invoice-search-product').trigger('focus');
                    }, 500);
                });

                return false;
            }

            if($('#paymentDateType').val() == 1)
            {
                paymentDate = $('#paymentDate').val();
            }
            else
            {
                var d = new Date((new Date).getTime() + (parseInt($('#paymentDays').val()) * 60 * 60 * 24 * 1000));
                paymentDate = d.getFullYear() + '-' + padInteger(d.getMonth() + 1, 2) + '-' + padInteger(d.getDate(), 2);
            }

            $('.invoice-preview .info .date-release span').text($('#releaseDate').val());
            $('.invoice-preview .info .date-sell span').text($('#sellDate').val());
            $('.invoice-preview .info .date-payment span').text(paymentDate);
            $('.invoice-preview .hl .title').text($('#headline').val());
            $('.invoice-preview .hl .number').text($('#number').val());

            $('.invoice-preview #details-seller').html($('#detailsSeller').val().replace(/\n/gi, '<br />'));
            $('.invoice-preview #details-buyer').html(
                $('#buyerName').val()
                + '<br /><br />'
                + $('#buyerStreet').val()
                + '<br />'
                + $('#buyerPostCode').val()
                + ' '
                + $('#buyerCity').val()
                + '<br />'
                + 'NIP: '
                + $('#buyerNIP').val()
            );


            $('.invoice-preview #details-shippment').html(
                $('#shipmentName').val()
                + '<br /><br />'
                + $('#buyerStreet').val()
                + '<br />'
                + $('#shipmentPostCode').val()
                + ' '
                + $('#shipmentCity').val()
            );

            if($('#showShipment').prop('checked'))
            {
                $('.details-shippment').show();
                $('.seller-shippment').css('width', '33%');
                $('.buyer-shippment').css('width', '33%');
            }
            else
            {
                $('.details-shippment').hide();
                $('.seller-shippment').css('width', '50%');
                $('.buyer-shippment').css('width', '50%');
            }

            generateProductsTable();
        }
    };

    var discount = {
        type : 1,
        value: 0
    }

    var generateProductsTable = function() {
        var p = $('.invoice-preview .products-table tbody');
                p.html(''); // Clearing table body
        var t = $('.invoice-preview .tax-table tbody');
                t.html(''); // Clearing table body

        // Stores selected products details
        var products = [];

        // Gets products details from created list
        $('.products-list .item').each(function() {
            var product = {
                'id'      : $(this).find('.patt-product-id').val(),
                'name'    : $(this).find('.hl h1').text(),
                'unit'    : $(this).find('.patt-product-unit').val(),
                'unitPriceNetOriginal' : parseFloat($(this).find('.patt-product-unitPriceNet').val()),
                'unitPriceNetFinal'    : 0,
                'tax'     : parseFloat($(this).find('.patt-product-tax').val()),
                'qty'     : parseInt($(this).find('.patt-product-qty').val()),
                'discount': (parseFloat($(this).find('.patt-product-discount').val()) * 1),
                'comment' : $(this).find('.patt-product-comment').val()
            };

            if(isNaN(product.discount))
            {
                product.discount = 0;
            }

            /**
             * If discount is provided, we calculate unit price reduced by discount value.
             */
            if(product.discount)
            {
                /**
                 * Discount is a integer (or float) value of percentage.
                 * For mathematic we need really peprentage value, so
                 * we divide user given discount by 100.
                 * I.e. we get 0.05 from given 5%
                 */
                product.discountPercent = product.discount / 100;

                product.unitPriceNetFinal = product.unitPriceNetOriginal - (product.unitPriceNetOriginal * product.discountPercent);
            }
            else
            {
                product.unitPriceNetFinal = product.unitPriceNetOriginal;
            }

            products.push(product);
        });

        /**
         * Stores total ammount, categorized by tax. I.e.
         *   {
         *     23: 154.34,
         *     8:  765.00
         *   }
         */
        var totalByTaxes = {};
        var grossTotal   = 0;

        // Generating products table
        for(var i in products)
        {
            i      = parseInt(i);
            var tt = parseFloat(((products[i].unitPriceNetFinal * products[i].qty) * (products[i].tax / 100)).toFixed(2));
            var gt = parseFloat((tt + (products[i].unitPriceNetFinal * products[i].qty)).toFixed(2));

            if(! totalByTaxes[products[i].tax])
            {
                totalByTaxes[products[i].tax] = 0;
            }

            totalByTaxes[products[i].tax] += (products[i].unitPriceNetFinal * products[i].qty);
            grossTotal += gt;

            p.append('<tr>'
                // No
                + '<td style="text-align:right;">' + (i + 1) + '.</td>'
                // Product / service name
                + '<td>' + products[i].name + (products[i].comment != '' ? '<small>' + products[i].comment + '</small>' : '') + '</td>'
                // Unit of product.serwice. I.e. piece
                + '<td style="text-align:center;">' + products[i].unit + '</td>'
                // Count of products
                + '<td style="text-align:center;">' + products[i].qty + '</td>'
                // Unit NET price
                + '<td style="text-align:right;">' + products[i].unitPriceNetOriginal.toFixed(2) + '</td>'
                // Discount
                + '<td style="text-align:right;">' + products[i].discount + '</td>'
                // Tax walue (in %)
                + '<td style="text-align:right;">' + products[i].tax + '</td>'
                // (qty * unitPriceNetFinal) * tax%
                + '<td style="text-align:right;">' + tt.toFixed(2) + '</td>'
                // ((qty * unitPriceNetFinal) * tax%) + (qty * unitPriceNetFinal)
                + '<td style="text-align:right;">' + gt.toFixed(2) + '</td>'
            + '</tr>');
        }

        var taxSumA = 0;
        var taxSumB = 0;
        var taxSumC = 0;

        // Generating taxes summary
        for(var i in totalByTaxes)
        {
            i = parseInt(i);
            var w = parseFloat((totalByTaxes[i] * (i / 100)).toFixed(2));

            taxSumA += totalByTaxes[i];
            taxSumB += w;
            taxSumC += totalByTaxes[i] + w;

            t.append('<tr>'
                // Tax rate
                + '<td style="text-align:center;">' + i + '</td>'
                // Products net value in this tax
                + '<td style="text-align:right;">' + totalByTaxes[i].toFixed(2) + '</td>'
                // Tax value calculated from products net value
                + '<td style="text-align:right;">' + w + '</td>'
                // Total gross value for this tax
                + '<td style="text-align:right;">' + (totalByTaxes[i] + w).toFixed(2) + '</td>'
            + '</tr>');
        }

        // Summary tax values
        $('.invoice-preview .tax-table tfoot')
            .find('#a')
            .text(taxSumA.toFixed(2))
            .parent()
            .find('#b')
            .text(taxSumB.toFixed(2))
            .parent()
            .find('#c')
            .text(taxSumC.toFixed(2));

        $('.invoice-preview .summary span').text(grossTotal.toFixed(2));
    };

    $(function() {
        totalSteps = $('.step-out').length;

        $('.btn-wizard-prev').click(prevStep);
        $('.btn-wizard-next').click(nextStep);

        $('.invoice-wizard .step-out').hide().eq(0).show();
        $('.invoice-wizard .nav-tabs li').each(function() {
            var index = $(this).index();
            $(this).find('a').click(function() {
                showStep(index);
                return false;
            });
        }).eq(0).addClass('active');

        $('.form-group .date input[type=text]')
            .datetimepicker({format:'YYYY-MM-DD', defaultDate:'<?php echo date('Y-m-d'); ?>'})
            .parent()
            .find('.input-group-addon.calendar-open')
            .click(function() {
                $(this).parent().find('input').trigger('focus');
            });

        var inputSearchContractor = $('#invoice-search-contractor');
        inputSearchContractor
            .focus(function() {
                $(this).val('');
            })
            .parent()
            .find('.form-control-feedback')
            .removeClass('hidden');

        APP.AJAX.call({
            url: APP.createUrl('Invoice', 'Invoice', 'allContractors'),
            success: function(data) {
                inputSearchContractor.typeahead({
                    autoSelect: true,
                    showHintOnFocus: true,
                    source: data,
                    afterSelect: function(item) {
                        $('#contractorId').val(item.id);

                        $('#buyerName').val(item.isCompany ? item.companyName : item.name);
                        $('#buyerStreet').val(item.billAddressStreet);
                        $('#buyerCountry').val(item.billAddressCountry);
                        $('#buyerCity').val(item.billAddressCity);
                        $('#buyerPostCode').val(item.billAddressPostalCode);
                        $('#buyerNIP').val(item.nip);

                        $('#shipmentName').val(item.companyName);
                        $('#shipmentStreet').val(item.shippAddressStreet);
                        $('#shipmentCountry').val(item.shippAddressCountry);
                        $('#shipmentCity').val(item.shippAddressCity);
                        $('#shipmentPostCode').val(item.shippAddressPostalCode);

                        $('.step-contractor .input-blink-change input[type=text]').addClass('flash');

                        setTimeout( function(){
                            $('.step-contractor .input-blink-change input[type=text]').removeClass('flash');
                        }, 1000);

                        APP.FormValidation.reset($('#form'));
                    }
                })
                .parent()
                .find('.form-control-feedback')
                .hide();
            }
        });

        var inputSearchProduct = $('#invoice-search-product');
        inputSearchProduct
            .focus(function() {
                $(this).val('');
            })
            .parent()
            .find('.form-control-feedback')
            .removeClass('hidden');

        APP.AJAX.call({
            url: APP.createUrl('Invoice', 'Invoice', 'allProducts'),
            success: function(data) {
                inputSearchProduct.typeahead({
                    autoSelect: true,
                    showHintOnFocus: true,
                    source: data,
                    afterSelect: function(item) {
                        inputSearchProduct.val('');

                        var patt = $('#product-list-item-pattern .item').clone();

                        patt.find('h1').text(item.name);

                        patt
                            .find('#patt_product_id')
                            .val(item.id)
                            .attr('name', 'product[' + item.id + '][id]');

                        patt
                            .find('#patt_product_unit')
                            .val(item.unit.unit ? item.unit.unit : '')
                            .attr('name', 'product[' + item.id + '][unit]');

                        patt
                            .find('#patt_product_name')
                            .val(item.name ? item.name : '')
                            .attr('name', 'product[' + item.id + '][name]');

                        patt
                            .find('#patt_product_unitPriceNet')
                            .val(item.price)
                            .attr('name', 'product[' + item.id + '][unitPriceNet]')
                            .attr('id', 'product_' + item.id + '_unitPriceNet')
                            .parent()
                            .find('label')
                            .attr('for', 'product_' + item.id + '_unitPriceNet');

                        patt
                            .find('#patt_product_tax')
                            .val(item.tax.rate ? item.tax.rate : 0)
                            .attr('name', 'product[' + item.id + '][tax]')
                            .attr('id', 'product_' + item.id + '_tax')
                            .parent()
                            .find('label')
                            .attr('for', 'product_' + item.id + '_tax');

                        patt
                            .find('#patt_product_qty')
                            .val(1)
                            .attr('name', 'product[' + item.id + '][qty]')
                            .attr('id', 'product_' + item.id + '_qty')
                            .parent()
                            .find('label')
                            .attr('for', 'product_' + item.id + '_qty');

                        patt
                            .find('#patt_product_comment')
                            .attr('name', 'product[' + item.id + '][comment]')
                            .attr('id', 'product_' + item.id + '_comment')
                            .parent()
                            .find('label')
                            .attr('for', 'product_' + item.id + '_comment');

                        patt
                            .find('#patt_product_discount')
                            .attr('name', 'product[' + item.id + '][discount]')
                            .attr('id', 'product_' + item.id + '_discount')
                            .parent()
                            .find('label')
                            .attr('for', 'product_' + item.id + '_discount');

                        patt.appendTo('.step-products .products-list');

                        $('.step-products .products-list .item').removeClass('opened').eq(-1).addClass('opened');
                    }
                })
                .parent()
                .find('.form-control-feedback')
                .hide();
            }
        });

        $('.products-list').delegate('.item .hl button', 'click', function(e) {
            $(this).closest('.item').remove();
            e.stopPropagation();
        });

        $('.products-list').delegate('.item .hl', 'click', function() {
            $('.products-list .item').removeClass('opened');
            $(this).parent().addClass('opened');
        });

        $('.payment-date-calendar a').click(function() {
            $('.payment-date-days').show().find('input').trigger('focus');
            $('.payment-date-calendar').hide();
            $('#paymentDateType').val(2);
            return false;
        });

        $('.payment-date-days a').click(function() {
            $('.payment-date-calendar').show().find('input').trigger('focus');
            $('.payment-date-days').hide();
            $('#paymentDateType').val(1);
            return false;
        });

        $('.discount-type-percent a').click(function() {
            $('.discount-type-value').show().find('input').trigger('focus');
            $('.discount-type-percent').hide();
            $('#discountType').val(2);
            return false;
        });

        $('.discount-type-value a').click(function() {
            $('.discount-type-percent').show().find('input').trigger('focus');
            $('.discount-type-value').hide();
            $('#discountType').val(1);
            return false;
        });

        $('#showShipment').change(function() {
            if($(this).prop('checked'))
                $('#shipment-details').fadeTo(250, 1);
            else
                $('#shipment-details').fadeTo(250, 0);
        }).trigger('change');



        /*****************************
        *        Validation
        *****************************/
        APP.FormValidation.bind('form', '#paymentDate', {
            validate: function(elm, val) {
                if(jQuery.trim(val) == '' && $('#paymentDateType').val() == 1)
                    return false;
                else
                    return true;
            },
            errorText: 'To pole jest wymagane.'
        });
        APP.FormValidation.bind('form', '#paymentDays', {
            validate: function(elm, val) {
                if(jQuery.trim(val) == '' && $('#paymentDateType').val() == 2)
                    return false;
                else
                    return true;
            },
            errorText: 'To pole jest wymagane.'
        });
        APP.FormValidation.bind('form', '#shipmentName', {
            validate: function(elm, val) {
                if(jQuery.trim(val) == '' && $('#showShipment').prop('checked'))
                    return false;
                else
                    return true;
            },
            errorText: 'To pole jest wymagane.'
        });
        APP.FormValidation.bind('form', '#shipmentCity', {
            validate: function(elm, val) {
                if(jQuery.trim(val) == '' && $('#showShipment').prop('checked'))
                    return false;
                else
                    return true;
            },
            errorText: 'To pole jest wymagane.'
        });
        APP.FormValidation.bind('form', '#shipmentStreet', {
            validate: function(elm, val) {
                if(jQuery.trim(val) == '' && $('#showShipment').prop('checked'))
                    return false;
                else
                    return true;
            },
            errorText: 'To pole jest wymagane.'
        });
        APP.FormValidation.bind('form', '#shipmentCountry', {
            validate: function(elm, val) {
                if(jQuery.trim(val) == '' && $('#showShipment').prop('checked'))
                    return false;
                else
                    return true;
            },
            errorText: 'To pole jest wymagane.'
        });
        APP.FormValidation.bind('form', '#shipmentPostCode', {
            validate: function(elm, val) {
                if(jQuery.trim(val) == '' && $('#showShipment').prop('checked'))
                    return false;
                else
                    return true;
            },
            errorText: 'To pole jest wymagane.'
        });
    });

    var padInteger = function(val, pad) {
        val = '000000' + val.toString();
        return val.substr(val.length - pad);
    };
</script>
