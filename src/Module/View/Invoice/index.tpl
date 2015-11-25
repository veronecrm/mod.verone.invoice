<?php $app->assetter()->load('datetimepicker'); ?>

<div class="page-header">
    <div class="page-header-content">
        <div class="page-title">
            <h1>
                <i class="fa fa-credit-card"></i>
                {{ t('invoices') }}
            </h1>
        </div>
        <div class="heading-elements">
            <div class="heading-btn-group">
                <a href="#" class="btn btn-icon-block btn-link-success" data-toggle="modal" data-target="#invoice-new">
                    <i class="fa fa-plus"></i>
                    <span>{{ t('invoiceNew') }}</span>
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
            <li class="active"><a href="{{ createUrl('Invoice', 'Invoice', 'index') }}">{{ t('invoices') }}</a></li>
        </ul>
        <ul class="breadcrumb-elements">
            <li><a href="<?=$app->createUrl('Settings', 'Glob', 'index', [ 'module' => 'Invoice', 'tab' => 'invoice' ]); ?>"><i class="fa fa-cog"></i> {{ t('settings') }}</a></li>
        </ul>
        <div class="breadcrumb-elements-toggle">
            <i class="fa fa-unsorted"></i>
        </div>
    </div>
</div>

<div class="container-fluid">
    <div class="row">
        <div class="col-md-12">
            <?php
                /**
                 * Here we store QuickEdit values for rows.
                 */
                $jsQuickEdit = [];
            ?>
            <table class="table table-default table-clicked-rows table-responsive">
                <thead>
                    <tr>
                        <th class="text-center span-1"><input type="checkbox" name="select-all" data-select-all="input_contractor" /></th>
                        <th>{{ t('invoiceNumber') }}</th>
                        <th>{{ t('status') }}</th>
                        <th>{{ t('invoiceNetValue') }}</th>
                        <th class="text-right">{{ t('action') }}</th>
                    </tr>
                </thead>
                <tbody>
                    @foreach $elements
                        <?php $controller = $repo->getControllerNameByType($item); ?>
                        <tr data-row-click-target="<?php echo $app->createUrl('Invoice', $controller, 'summary', [ 'id' => $item->getId() ]); ?>" id="row-{{ $item->getId() }}">
                            <td class="text-center hidden-xs"><input type="checkbox" name="input_contractor" value="{{ $item->getId() }}" /></td>
                            <td data-th="{{ t('invoiceNumber') }}" class="th">{{ $item->getNumber() }}</td>
                            <td data-th="{{ t('status') }}" class="invoice-status">{{ t('invoiceStatus'.$item->getStatus()) }}</td>
                            <td data-th="{{ t('invoiceNetValue') }}"><?php echo number_format($item->getValueNett(), 2, '.', ''); ?></td>
                            <td data-th="{{ t('action') }}" class="app-click-prevent">
                                <div class="actions-box">
                                    <button type="button" class="btn btn-default btn-xs quick-edit-trigger hidden-xs" data-quick-edit-id="{{ $item->getId() }}" data-toggle="tooltip" title="{{ t('quickEdit') }}"><i class="fa fa-map-o"></i></button>
                                    <div class="btn-group right">
                                        <a href="<?php echo $app->createUrl('Invoice', $controller, 'edit', [ 'id' => $item->getId() ]); ?>" class="btn btn-default btn-xs btn-main-action" title="{{ t('edit') }}"><i class="fa fa-pencil"></i></a>
                                        <button type="button" class="btn btn-default btn-xs dropdown-toggle" data-toggle="dropdown">
                                            <span class="caret"></span>
                                        </button>
                                        <ul class="dropdown-menu with-headline">
                                            <li class="headline">{{ t('moreOptions') }}</li>
                                            <li><a href="<?php echo $app->createUrl('Invoice', $controller, 'edit', [ 'id' => $item->getId() ]); ?>" title="{{ t('edit') }}"><i class="fa fa-pencil"></i> {{ t('edit') }}</a></li>
                                            <li><a href="<?php echo $app->createUrl('Invoice', $controller, 'summary', [ 'id' => $item->getId() ]); ?>" title="{{ t('summary') }}"><i class="fa fa-bars"></i> {{ t('summary') }}</a></li>
                                            <li role="separator" class="divider"></li>
                                            @if $item->getType() == 5
                                                <li><a href="<?php echo $app->createUrl('Invoice', $controller, 'convert', [ 'id' => $item->getId(), 'to' => 'SalesInvoice' ]); ?>" title="{{ t('invoiceConvertToSalesInvoice') }}" class="invoice-convert-sales"><i class="fa fa-caret-square-o-right"></i> {{ t('invoiceConvertToSalesInvoice') }}</a></li>
                                            @endif
                                            @if $item->getType() == 1
                                                <li><a href="<?php echo $app->createUrl('Invoice', 'CorrectionInvoice', 'add', [ 'correction' => $item->getId() ]); ?>" title="{{ t('invoiceCreateCorrection') }}"><i class="fa fa-paste"></i> {{ t('invoiceCreateCorrection') }}</a></li>
                                            @endif
                                            <li><a href="<?php echo $app->createUrl('Invoice', $controller, 'convert', [ 'id' => $item->getId(), 'to' => 'self' ]); ?>" title="{{ t('invoiceDuplicate') }}" class="invoice-duplicate"><i class="fa fa-copy"></i> {{ t('invoiceDuplicate') }}</a></li>
                                            <li class="dropdown-submenu">
                                                <a href="#" title="{{ t('invoiceExportToPDF') }}"><i class="fa fa-file-pdf-o"></i> {{ t('invoiceExportToPDF') }}</a>
                                                <ul class="dropdown-menu with-headline">
                                                    <li class="headline">{{ t('invoiceExportToPDF') }}</li>
                                                    <li><a href="<?php echo $app->createUrl('Invoice', 'Invoice', 'export', [ 'id' => $item->getId(), 'type' => 'pdf', 'original' => 1 ]); ?>" title="{{ t('invoiceOriginal') }}">{{ t('invoiceOriginal') }}</a></li>
                                                    <li><a href="<?php echo $app->createUrl('Invoice', 'Invoice', 'export', [ 'id' => $item->getId(), 'type' => 'pdf', 'original' => 0 ]); ?>" title="{{ t('invoiceCopy') }}">{{ t('invoiceCopy') }}</a></li>
                                                </ul>
                                            </li>
                                            <li class="dropdown-submenu">
                                                <a href="#" title="{{ t('print') }}"><i class="fa fa-print"></i> {{ t('print') }}</a>
                                                <ul class="dropdown-menu with-headline">
                                                    <li class="headline">{{ t('print') }}</li>
                                                    <li><a href="<?php echo $app->createUrl('Invoice', 'Invoice', 'print', [ 'id' => $item->getId(), 'original' => 1 ]); ?>" target="_blank" title="{{ t('invoiceOriginal') }}">{{ t('invoiceOriginal') }}</a></li>
                                                    <li><a href="<?php echo $app->createUrl('Invoice', 'Invoice', 'print', [ 'id' => $item->getId(), 'original' => 0 ]); ?>" target="_blank" title="{{ t('invoiceCopy') }}">{{ t('invoiceCopy') }}</a></li>
                                                </ul>
                                            </li>
                                            <li role="separator" class="divider"></li>
                                            <li class="item-danger"><a href="#" data-toggle="modal" data-target="#invoice-delete" data-href="<?php echo $app->createUrl('Invoice', $controller, 'delete', [ 'id' => $item->getId() ]); ?>" title="{{ t('delete') }}"><i class="fa fa-remove danger"></i> {{ t('delete') }}</a></li>
                                        </ul>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <?php
                            $jsQuickEdit[] = "{id:{$item->getId()},status:{$item->getStatus()},releaseDate:'".date('Y-m-d', $item->getReleaseDate())."',sellDate:'".date('Y-m-d', $item->getSellDate())."',paymentDate:'".date('Y-m-d', $item->getPaymentDate())."'}";
                        ?>
                    @endforeach
                </tbody>
            </table>
            {{ $pagination|raw }}
        </div>
    </div>
</div>

<div class="modal fade" id="invoice-delete" tabindex="-1" role="dialog" aria-labelledby="invoice-delete-modal-label" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content modal-danger">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="<?php echo $app->t('close'); ?>"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="invoice-delete-modal-label">{{ t('invoiceDeleteConfirmationHeader') }}</h4>
            </div>
            <div class="modal-body">
                {{ t('invoiceDeleteConfirmationContent') }}
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">{{ t('close') }}</button>
                <a href="#" class="btn btn-danger">{{ t('syes') }}</a>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="invoice-new" tabindex="-1" role="dialog" aria-labelledby="invoice-new-modal-label" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="<?php echo $app->t('close'); ?>"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="invoice-new-modal-label">Wybierz rodzaj faktury</h4>
            </div>
            <div class="modal-body">
                <div class="container-fluid container-modal">
                    <div class="row">
                        <div class="col-md-12">
                            <a class="info-tile tile-primary" href="<?php echo $app->createUrl('Invoice', 'SalesInvoice', 'add'); ?>">
                                <div class="icon"><i class="fa fa-money"></i></div>
                                <div class="heading">{{ t('invoiceTypeSales') }}</div>
                                <div class="body"><i class="fa fa-arrow-right"></i></div>
                                <div class="footer">&nbsp; <i class="fa fa-arrow-right"></i></div>
                            </a>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <a class="info-tile tile-info" href="<?php echo $app->createUrl('Invoice', 'ProformaInvoice', 'add'); ?>">
                                <div class="icon"><i class="fa fa-money"></i></div>
                                <div class="heading">{{ t('invoiceTypeProforma') }}</div>
                                <div class="body"><i class="fa fa-arrow-right"></i></div>
                                <div class="footer">&nbsp; <i class="fa fa-arrow-right"></i></div>
                            </a>
                        </div>
                        <div class="col-md-6">
                            <a class="info-tile tile-info" href="<?php echo $app->createUrl('Invoice', 'CorrectionInvoice', 'add'); ?>">
                                <div class="icon"><i class="fa fa-money"></i></div>
                                <div class="heading">{{ t('invoiceTypeCorrection') }}</div>
                                <div class="body"><i class="fa fa-arrow-right"></i></div>
                                <div class="footer">&nbsp; <i class="fa fa-arrow-right"></i></div>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">{{ t('close') }}</button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="invoice-duplicate" tabindex="-1" role="dialog" aria-labelledby="invoice-duplicate-modal-label" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="<?php echo $app->t('close'); ?>"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="invoice-duplicate-modal-label">{{ t('invoiceDuplicate') }}</h4>
            </div>
            <div class="modal-body">
                <p>{{ t('invoiceDuplicateMoreInfo') }}</p>
            </div>
            <div class="modal-footer">
                <a href="" class="btn btn-primary">{{ t('invoiceDuplicate') }}</a>
                <button type="button" class="btn btn-default" data-dismiss="modal">{{ t('close') }}</button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="invoice-convert-sales" tabindex="-1" role="dialog" aria-labelledby="invoice-convert-sales-modal-label" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="<?php echo $app->t('close'); ?>"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="invoice-convert-sales-modal-label">{{ t('invoiceConvertToSalesInvoice') }}</h4>
            </div>
            <div class="modal-body">
                <p>{{ t('invoiceConvertToSalesInvoiceMoreInfo') }}</p>
            </div>
            <div class="modal-footer">
                <a href="" class="btn btn-primary">{{ t('invoiceConvert') }}</a>
                <button type="button" class="btn btn-default" data-dismiss="modal">{{ t('close') }}</button>
            </div>
        </div>
    </div>
</div>

<div class="quick-edit-form">
    <div class="qef-cnt">
        <h4>{{ t('quickEdit') }}</h4>
        <form action="" method="post" class="form-validation" id="invoice-quick-edit">
            <div class="form-group">
                <label for="status" class="control-label">Status</label>
                <select name="status" class="form-control required" id="status">
                    <option value="1">{{ t('invoiceStatus1') }}</option>
                    <option value="2">{{ t('invoiceStatus2') }}</option>
                    <option value="3">{{ t('invoiceStatus3') }}</option>
                    <option value="4">{{ t('invoiceStatus4') }}</option>
                    <option value="5">{{ t('invoiceStatus5') }}</option>
                </select>
            </div>
            <div class="form-group">
                <label for="releaseDate" class="control-label">Data wystawienia</label>
                <div class="input-group date">
                    <input class="form-control required" type="text" id="releaseDate" name="releaseDate" value="" />
                    <span class="input-group-addon calendar-open">
                        <span class="fa fa-calendar"></span>
                    </span>
                </div>
            </div>
            <div class="form-group">
                <label for="sellDate" class="control-label">Data sprzedaży</label>
                <div class="input-group date">
                    <input class="form-control required" type="text" id="sellDate" name="sellDate" value="" />
                    <span class="input-group-addon calendar-open">
                        <span class="fa fa-calendar"></span>
                    </span>
                </div>
            </div>
            <div class="form-group payment-date-calendar">
                <label for="paymentDate" class="control-label">Termin płatności</label>
                <div class="input-group date">
                    <input class="form-control" type="text" id="paymentDate" name="paymentDate" value="" />
                    <span class="input-group-addon calendar-open">
                        <span class="fa fa-calendar"></span>
                    </span>
                </div>
            </div>
        </form>
    </div>
    <div class="bottom-actions">
        <button type="button" class="btn btn-circle btn-secondary btn-quick-edit-close left" data-toggle="tooltip" title="{{ t('close') }}"><i class="fa fa-angle-double-left"></i></button>
        <a href="#" class="btn btn-circle btn-default" data-toggle="tooltip" title="{{ t('fullEdition') }}"><i class="fa fa-pencil"></i></a>
        <button type="button" class="btn btn-circle btn-success btn-quick-edit-save" data-toggle="tooltip" title="{{ t('save') }}"><i class="fa fa-save"></i></button>
    </div>
</div>

<script>
    $(function() {
        $('#invoice-delete').on('show.bs.modal', function (event) {
            $(this).find('.modal-footer a').attr('href', $(event.relatedTarget).attr('data-href'));
        });

        $('.quick-edit-form .date input[type=text]')
            .datetimepicker({format:'YYYY-MM-DD', defaultDate:'<?php echo date('Y-m-d'); ?>'})
            .parent()
            .find('.input-group-addon.calendar-open')
            .click(function() {
                $(this).parent().find('input').trigger('focus');
            });

        $('.invoice-convert-sales').click(function() {
            $('#invoice-convert-sales').modal();
            $('#invoice-convert-sales .modal-footer a').attr('href', $(this).attr('href'));
            return false;
        });

        $('.invoice-duplicate').click(function() {
            $('#invoice-duplicate').modal();
            $('#invoice-duplicate .modal-footer a').attr('href', $(this).attr('href'));
            return false;
        });

        APP.QuickEdit.create({
            url: APP.createUrl('Invoice', 'Invoice', 'quickUpdate'),
            src: [ <?php echo implode(', ', $jsQuickEdit); ?> ],
            onChange: function(id) {
                var elm = $('#row-' + id + ' .btn-main-action');
                $('.quick-edit-form .bottom-actions a.btn-default').attr('href', elm.attr('href'));

                $('.quick-edit-form .date input[type=text]').trigger('change');
            },
            onSave: function(values) {
                if(! APP.FormValidation.validateForm($('#invoice-quick-edit')))
                {
                    return false;
                }

                var statuses = [ '', '{{ t('invoiceStatus1') }}', '{{ t('invoiceStatus2') }}', '{{ t('invoiceStatus3') }}', '{{ t('invoiceStatus4') }}', '{{ t('invoiceStatus5') }}'];

                var row = $('#row-' + values.id);
                row.find('.invoice-status').text(statuses[values.status]);

                return values;
            }
        });
    });
</script>
