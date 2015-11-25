<div class="page-header">
    <div class="page-header-content">
        <div class="page-title">
            <h1>
                <i class="fa fa-credit-card"></i>
                {{ t('invoiceInvoiceSummary') }}
            </h1>
        </div>
        <div class="heading-elements">
            <div class="heading-btn-group">
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
            <li class="active"><a href="{{ createUrl('Invoice', 'SalesInvoice', 'summary', [ 'id' => $invoice->getId() ]) }}">{{ t('invoice') }} - {{ $invoice->getNumber() }}</a></li>
        </ul>
    </div>
</div>

<div class="container-fluid">
    <div class="row">
        <div class="col-md-12">
            <div class="row">
                <div class="col-md-6">
                    <div class="panel panel-default">
                        <div class="panel-body">
                            <div class="summary-panel">
                                <h3>{{ $invoice->getHeadline() }}</h3>
                                <span class="actions">
                                    <a href="{{ createUrl('Invoice', 'SalesInvoice', 'edit', [ 'id' => $invoice->getId() ]) }}" class="btn btn-sm btn-default"><i class="fa fa-pencil"></i> {{ t('edit') }}</a>
                                </span>
                                <div class="summary-details">
                                    <div class="item">
                                        <label>{{ t('invoiceReleaseDate') }}</label>
                                        <div>{{ date('Y-m-d', $invoice->getReleaseDate()) }}</div>
                                    </div>
                                    <div class="item">
                                        <label>{{ t('invoiceSellDate') }}</label>
                                        <div>{{ date('Y-m-d', $invoice->getSellDate()) }}</div>
                                    </div>
                                    <div class="item">
                                        <label>{{ t('invoicePaymentDate') }}</label>
                                        <div>{{ date('Y-m-d', $invoice->getPaymentDate()) }}</div>
                                    </div>
                                    <div class="item">
                                        <label>{{ t('invoiceStatus') }}</label>
                                        <div>{{ t('invoiceStatus'.$invoice->getStatus()) }}</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            {{ t('invoiceBuyerDetails') }}
                        </div>
                        <div class="panel-body summary-panel">
                            <div class="summary-details">
                                <div class="item">
                                    <label>{{ t('invoiceBuyerName') }}</label>
                                    <div>{{ $invoice->getBuyerName() }}</div>
                                </div>
                                <div class="item">
                                    <label>{{ t('invoiceCity') }}</label>
                                    <div>{{ $invoice->getBuyerCity() }}</div>
                                </div>
                                <div class="item">
                                    <label>{{ t('invoiceStreet') }}</label>
                                    <div>{{ $invoice->getBuyerStreet() }}</div>
                                </div>
                                <div class="item">
                                    <label>{{ t('invoiceCountry') }}</label>
                                    <div>{{ $invoice->getBuyerCountry() }}</div>
                                </div>
                                <div class="item">
                                    <label>{{ t('invoicePostCode') }}</label>
                                    <div>{{ $invoice->getBuyerPostCode() }}</div>
                                </div>
                                <div class="item">
                                    <label>{{ t('invoiceNIP') }}</label>
                                    <div>{{ $invoice->getBuyerNIP() }}</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            {{ t('invoiceRecipientsDetails') }}
                        </div>
                        <div class="panel-body summary-panel">
                            @if $invoice->getShowShipment()
                                <div class="summary-details">
                                    <div class="item">
                                        <label>{{ t('invoiceRecipientName') }}</label>
                                        <div>{{ $invoice->getShipmentName() }}</div>
                                    </div>
                                    <div class="item">
                                        <label>{{ t('invoiceCity') }}</label>
                                        <div>{{ $invoice->getShipmentCity() }}</div>
                                    </div>
                                    <div class="item">
                                        <label>{{ t('invoiceStreet') }}</label>
                                        <div>{{ $invoice->getShipmentStreet() }}</div>
                                    </div>
                                    <div class="item">
                                        <label>{{ t('invoiceCountry') }}</label>
                                        <div>{{ $invoice->getShipmentCountry() }}</div>
                                    </div>
                                    <div class="item">
                                        <label>{{ t('invoicePostCode') }}</label>
                                        <div>{{ $invoice->getShipmentPostCode() }}</div>
                                    </div>
                                </div>
                            @else
                                <p style="text-align:center;padding:40px;">{{ t('invoiceShippmentNotShowedOnInvoice') }}</p>
                            @endif
                        </div>
                    </div>
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            {{ t('historyOfChanges') }} (<span class="summary-history-total">0</span>)
                        </div>
                        <div class="panel-body">
                            <div class="summary-panel history-summary"></div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            {{ t('invoiceContent') }}
                        </div>
                        <div class="panel-body">
                            <table class="table table-default">
                                <thead>
                                    <tr>
                                        <th>{{ t('name') }}</th>
                                        <th class="text-right">{{ t('invoiceUnitPriceNet') }}</th>
                                        <th class="text-right">{{ t('invoiceQuantity') }}</th>
                                        <th class="text-right">{{ t('invoiceDiscount') }}</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    @foreach $products
                                        <tr>
                                            <td>{{ $item->getName() }}</td>
                                            <td class="text-right">{{ $item->getUnitPriceNet() }}</td>
                                            <td class="text-right">{{ $item->getQty() }}</td>
                                            <td class="text-right">{{ $item->getDiscount() }} %</td>
                                        </tr>
                                    @endforeach
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            {{ t('comments') }}
                        </div>
                        <div class="panel-body">
                            <div class="comments-panel"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    $(function() {
        APP.RecordHistoryLog.create({
            target: '.summary-panel.history-summary',
            targetTotalCount: '.summary-history-total',
            module: 'Invoice',
            entity: 'Invoice',
            id: '{{ $invoice->getId() }}'
        });

        APP.Comments.create({
            target: '.comments-panel',
            module: 'Invoice',
            entity: 'Invoice',
            id: '{{ $invoice->getId() }}'
        });
    });
</script>
