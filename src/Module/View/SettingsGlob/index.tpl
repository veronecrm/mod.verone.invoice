@no-extends
<script>
function handleFileSelect(evt) {
    var files = evt.target.files; // FileList object

    // Loop through the FileList and render image files as thumbnails.
    for(var i = 0, f; f = files[i]; i++)
    {
        // Only process image files.
        if(! f.type.match('image.*'))
        {
            continue;
        }

        var reader = new FileReader();

        // Closure to capture the file information.
        reader.onload = (function(theFile)
        {
            return function(e)
            {
                var img = [
                    '<img class="img-thumbnail" style="max-height:100px" src="',
                    e.target.result, '" title="',
                    escape(theFile.name), '"/>'
                ].join('');

                document.getElementById('list').innerHTML = img;

                document.getElementById('invoice_logo_name').value = escape(theFile.name);
            };
        })(f);

        // Read in the image file as a data URL.
        reader.readAsDataURL(f);
    }
}
$(document).ready(function() {
    document.getElementById('invoice_logo').addEventListener('change', handleFileSelect, false);
});
</script>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-12">
            <div class="panel panel-default">
                <div class="panel-heading">{{ t('basicInformations') }}</div>
                <div class="panel-body">
                    <div class="container-fluid">
                        <div class="row">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label for="invoice-logo" class="control-label">{{ t('invoiceLogo') }}</label>
                                    <div class="input-group">
                                        <span class="input-group-btn">
                                            <label class="btn btn-primary btn-file">{{ t('selectFile') }}&hellip; <input type="file" name="invoice_logo" id="invoice_logo" accept="image/*" /></label>
                                        </span>
                                        <input type="text" class="form-control" id="invoice_logo_name" readonly>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <span class="text-center" id="list" style="display:block;padding:12px 0;">{{ t('selectFile') }}</span>
                                <label for="invoice-logo" class="control-label text-center">{{ t('invoiceNewLogo') }}</label>
                            </div>
                            <div class="col-md-4">
                                <?php
                                    $file = '/modules/Invoice/'.$settings->get('mod.invoice.pdf.logo');
                                    
                                    if(is_file(BASEPATH.'/web'.$file))
                                    {
                                        echo '<span class="text-center" style="display:block"><img class="img-thumbnail" style="max-height:100px" src="'.$file.'?v='.time().'" /></span>';
                                    }
                                    else
                                    {
                                        echo '<span class="text-center" style="display:block;padding:12px 0;">Brak</span>';
                                    }
                                ?>
                                <label for="invoice-logo" class="control-label text-center">{{ t('invoiceCurrentLogo') }}</label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="panel panel-default">
                <div class="panel-heading">{{ t('invoiceInvoicesDetails') }}</div>
                <div class="panel-body">
                    <div class="tabbable tabs-left">
                        <ul class="nav nav-tabs">
                            <li class="active"><a href="#1" data-toggle="tab">Faktura zwykła (sprzedażowa)</a></li>
                            <!-- <li><a href="#2" data-toggle="tab">Faktura VAT marża</a></li> -->
                            <!-- <li><a href="#3" data-toggle="tab">Zaliczkowa</a></li> -->
                            <!-- <li><a href="#4" data-toggle="tab">Rozliczeniowa (końcowa)</a></li> -->
                            <li><a href="#5" data-toggle="tab">Pro forma</a></li>
                            <li><a href="#6" data-toggle="tab">Korygująca</a></li>
                            <!-- <li><a href="#7" data-toggle="tab">Podatnika zwolnionego</a></li> -->
                        </ul>
                        <div class="tab-content">
                            <div class="tab-pane active" id="1">
                                <div class="panel panel-default">
                                    <div class="panel-heading panel-heading-hl">Faktura zwykła (sprzedażowa)</div>
                                    <div class="panel-body">
                                        <div class="form-group has-feedback">
                                            <label for="invoice-sales-format" class="control-label">{{ t('invoiceSettingsNumberFormat') }} <a href="#" class="btn-invoice-help-format help-inline" data-type="sales" data-toggle="tooltip" title="{{ t('help') }}"><i class="fa fa-support"></i></a></label>
                                            <div class="input-group">
                                                <input name="invoice-sales-format" id="invoice-sales-format" class="form-control" type="text" value="{{ $settings->get('mod.invoice.sales.format') }}" style="font-family:Monospace" />
                                                <a class="input-group-addon btn-invoice-help-format help-inline" data-type="sales" href="#" data-toggle="tooltip" title="{{ t('help') }}"><i class="fa fa-support"></i></a>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="invoice-sales-reset-number-year" class="control-label">{{ t('invoiceSettingsResetNumberWithNewYear') }}</label>
                                            <select name="invoice-sales-reset-number-year" id="invoice-sales-reset-number-year" class="form-control">
                                                <option value="1"{{ $settings->get('mod.invoice.sales.opt.restartwithnewyear') == 1 ? ' selected="selected"' : '' }}>{{ t('syes') }}</option>
                                                <option value="0"{{ $settings->get('mod.invoice.sales.opt.restartwithnewyear') == 0 ? ' selected="selected"' : '' }}>{{ t('sno') }}</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="invoice-sales-reset-number-month" class="control-label">{{ t('invoiceSettingsResetNumberWithNewMonth') }}</label>
                                            <select name="invoice-sales-reset-number-month" id="invoice-sales-reset-number-month" class="form-control">
                                                <option value="1"{{ $settings->get('mod.invoice.sales.opt.restartwithnewmonth') == 1 ? ' selected="selected"' : '' }}>{{ t('syes') }}</option>
                                                <option value="0"{{ $settings->get('mod.invoice.sales.opt.restartwithnewmonth') == 0 ? ' selected="selected"' : '' }}>{{ t('sno') }}</option>
                                            </select>
                                        </div>
                                        <div class="form-group has-feedback">
                                            <label for="invoice-sales-number" class="control-label">{{ t('invoiceNumber') }}</label>
                                            <input name="invoice-sales-number" id="invoice-sales-number" class="form-control" type="text" value="{{ $settings->get('mod.invoice.sales.number') }}" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="tab-pane" id="2">
                                <div class="panel panel-default">
                                    <div class="panel-heading panel-heading-hl">Faktura VAT marża</div>
                                    <div class="panel-body">
                                        <div class="form-group has-feedback">
                                            <label for="invoice-margin-format" class="control-label">{{ t('invoiceSettingsNumberFormat') }} <a href="#" class="btn-invoice-help-format help-inline" data-type="margin" data-toggle="tooltip" title="{{ t('help') }}"><i class="fa fa-support"></i></a></label>
                                            <div class="input-group">
                                                <input name="invoice-margin-format" id="invoice-margin-format" class="form-control" type="text" value="{{ $settings->get('mod.invoice.margin.format') }}" style="font-family:Monospace" />
                                                <a class="input-group-addon btn-invoice-help-format help-inline" data-type="margin" href="#" data-toggle="tooltip" title="{{ t('help') }}"><i class="fa fa-support"></i></a>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="invoice-margin-reset-number-year" class="control-label">{{ t('invoiceSettingsResetNumberWithNewYear') }}</label>
                                            <select name="invoice-margin-reset-number-year" id="invoice-margin-reset-number-year" class="form-control">
                                                <option value="1"{{ $settings->get('mod.invoice.margin.opt.restartwithnewyear') == 1 ? ' selected="selected"' : '' }}>{{ t('syes') }}</option>
                                                <option value="0"{{ $settings->get('mod.invoice.margin.opt.restartwithnewyear') == 0 ? ' selected="selected"' : '' }}>{{ t('sno') }}</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="invoice-margin-reset-number-month" class="control-label">{{ t('invoiceSettingsResetNumberWithNewMonth') }}</label>
                                            <select name="invoice-margin-reset-number-month" id="invoice-margin-reset-number-month" class="form-control">
                                                <option value="1"{{ $settings->get('mod.invoice.margin.opt.restartwithnewmonth') == 1 ? ' selected="selected"' : '' }}>{{ t('syes') }}</option>
                                                <option value="0"{{ $settings->get('mod.invoice.margin.opt.restartwithnewmonth') == 0 ? ' selected="selected"' : '' }}>{{ t('sno') }}</option>
                                            </select>
                                        </div>
                                        <div class="form-group has-feedback">
                                            <label for="invoice-margin-number" class="control-label">{{ t('invoiceNumber') }}</label>
                                            <input name="invoice-margin-number" id="invoice-margin-number" class="form-control" type="text" value="{{ $settings->get('mod.invoice.margin.number') }}" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="tab-pane" id="3">
                                <div class="panel panel-default">
                                    <div class="panel-heading panel-heading-hl">Zaliczkowa</div>
                                    <div class="panel-body">
                                        <div class="form-group has-feedback">
                                            <label for="invoice-advance-format" class="control-label">{{ t('invoiceSettingsNumberFormat') }} <a href="#" class="btn-invoice-help-format help-inline" data-type="advance" data-toggle="tooltip" title="{{ t('help') }}"><i class="fa fa-support"></i></a></label>
                                            <div class="input-group">
                                                <input name="invoice-advance-format" id="invoice-advance-format" class="form-control" type="text" value="{{ $settings->get('mod.invoice.advance.format') }}" style="font-family:Monospace" />
                                                <a class="input-group-addon btn-invoice-help-format help-inline" data-type="advance" href="#" data-toggle="tooltip" title="{{ t('help') }}"><i class="fa fa-support"></i></a>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="invoice-advance-reset-number-year" class="control-label">{{ t('invoiceSettingsResetNumberWithNewYear') }}</label>
                                            <select name="invoice-advance-reset-number-year" id="invoice-advance-reset-number-year" class="form-control">
                                                <option value="1"{{ $settings->get('mod.invoice.advance.opt.restartwithnewyear') == 1 ? ' selected="selected"' : '' }}>{{ t('syes') }}</option>
                                                <option value="0"{{ $settings->get('mod.invoice.advance.opt.restartwithnewyear') == 0 ? ' selected="selected"' : '' }}>{{ t('sno') }}</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="invoice-advance-reset-number-month" class="control-label">{{ t('invoiceSettingsResetNumberWithNewMonth') }}</label>
                                            <select name="invoice-advance-reset-number-month" id="invoice-advance-reset-number-month" class="form-control">
                                                <option value="1"{{ $settings->get('mod.invoice.advance.opt.restartwithnewmonth') == 1 ? ' selected="selected"' : '' }}>{{ t('syes') }}</option>
                                                <option value="0"{{ $settings->get('mod.invoice.advance.opt.restartwithnewmonth') == 0 ? ' selected="selected"' : '' }}>{{ t('sno') }}</option>
                                            </select>
                                        </div>
                                        <div class="form-group has-feedback">
                                            <label for="invoice-advance-number" class="control-label">{{ t('invoiceNumber') }}</label>
                                            <input name="invoice-advance-number" id="invoice-advance-number" class="form-control" type="text" value="{{ $settings->get('mod.invoice.advance.number') }}" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="tab-pane" id="4">
                                <div class="panel panel-default">
                                    <div class="panel-heading panel-heading-hl">Rozliczeniowa (końcowa)</div>
                                    <div class="panel-body">
                                        <div class="form-group has-feedback">
                                            <label for="invoice-settlement-format" class="control-label">{{ t('invoiceSettingsNumberFormat') }} <a href="#" class="btn-invoice-help-format help-inline" data-type="settlement" data-toggle="tooltip" title="{{ t('help') }}"><i class="fa fa-support"></i></a></label>
                                            <div class="input-group">
                                                <input name="invoice-settlement-format" id="invoice-settlement-format" class="form-control" type="text" value="{{ $settings->get('mod.invoice.settlement.format') }}" style="font-family:Monospace" />
                                                <a class="input-group-addon btn-invoice-help-format help-inline" data-type="settlement" href="#" data-toggle="tooltip" title="{{ t('help') }}"><i class="fa fa-support"></i></a>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="invoice-settlement-reset-number-year" class="control-label">{{ t('invoiceSettingsResetNumberWithNewYear') }}</label>
                                            <select name="invoice-settlement-reset-number-year" id="invoice-settlement-reset-number-year" class="form-control">
                                                <option value="1"{{ $settings->get('mod.invoice.settlement.opt.restartwithnewyear') == 1 ? ' selected="selected"' : '' }}>{{ t('syes') }}</option>
                                                <option value="0"{{ $settings->get('mod.invoice.settlement.opt.restartwithnewyear') == 0 ? ' selected="selected"' : '' }}>{{ t('sno') }}</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="invoice-settlement-reset-number-month" class="control-label">{{ t('invoiceSettingsResetNumberWithNewMonth') }}</label>
                                            <select name="invoice-settlement-reset-number-month" id="invoice-settlement-reset-number-month" class="form-control">
                                                <option value="1"{{ $settings->get('mod.invoice.settlement.opt.restartwithnewmonth') == 1 ? ' selected="selected"' : '' }}>{{ t('syes') }}</option>
                                                <option value="0"{{ $settings->get('mod.invoice.settlement.opt.restartwithnewmonth') == 0 ? ' selected="selected"' : '' }}>{{ t('sno') }}</option>
                                            </select>
                                        </div>
                                        <div class="form-group has-feedback">
                                            <label for="invoice-settlement-number" class="control-label">{{ t('invoiceNumber') }}</label>
                                            <input name="invoice-settlement-number" id="invoice-settlement-number" class="form-control" type="text" value="{{ $settings->get('mod.invoice.settlement.number') }}" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="tab-pane" id="5">
                                <div class="panel panel-default">
                                    <div class="panel-heading panel-heading-hl">Pro forma</div>
                                    <div class="panel-body">
                                        <div class="form-group has-feedback">
                                            <label for="invoice-proforma-format" class="control-label">{{ t('invoiceSettingsNumberFormat') }} <a href="#" class="btn-invoice-help-format help-inline" data-type="proforma" data-toggle="tooltip" title="{{ t('help') }}"><i class="fa fa-support"></i></a></label>
                                            <div class="input-group">
                                                <input name="invoice-proforma-format" id="invoice-proforma-format" class="form-control" type="text" value="{{ $settings->get('mod.invoice.proforma.format') }}" style="font-family:Monospace" />
                                                <a class="input-group-addon btn-invoice-help-format help-inline" data-type="proforma" href="#" data-toggle="tooltip" title="{{ t('help') }}"><i class="fa fa-support"></i></a>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="invoice-proforma-reset-number-year" class="control-label">{{ t('invoiceSettingsResetNumberWithNewYear') }}</label>
                                            <select name="invoice-proforma-reset-number-year" id="invoice-proforma-reset-number-year" class="form-control">
                                                <option value="1"{{ $settings->get('mod.invoice.proforma.opt.restartwithnewyear') == 1 ? ' selected="selected"' : '' }}>{{ t('syes') }}</option>
                                                <option value="0"{{ $settings->get('mod.invoice.proforma.opt.restartwithnewyear') == 0 ? ' selected="selected"' : '' }}>{{ t('sno') }}</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="invoice-proforma-reset-number-month" class="control-label">{{ t('invoiceSettingsResetNumberWithNewMonth') }}</label>
                                            <select name="invoice-proforma-reset-number-month" id="invoice-proforma-reset-number-month" class="form-control">
                                                <option value="1"{{ $settings->get('mod.invoice.proforma.opt.restartwithnewmonth') == 1 ? ' selected="selected"' : '' }}>{{ t('syes') }}</option>
                                                <option value="0"{{ $settings->get('mod.invoice.proforma.opt.restartwithnewmonth') == 0 ? ' selected="selected"' : '' }}>{{ t('sno') }}</option>
                                            </select>
                                        </div>
                                        <div class="form-group has-feedback">
                                            <label for="invoice-proforma-number" class="control-label">{{ t('invoiceNumber') }}</label>
                                            <input name="invoice-proforma-number" id="invoice-proforma-number" class="form-control" type="text" value="{{ $settings->get('mod.invoice.proforma.number') }}" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="tab-pane" id="6">
                                <div class="panel panel-default">
                                    <div class="panel-heading panel-heading-hl">Korygująca</div>
                                    <div class="panel-body">
                                        <div class="form-group has-feedback">
                                            <label for="invoice-correction-format" class="control-label">{{ t('invoiceSettingsNumberFormat') }} <a href="#" class="btn-invoice-help-format help-inline" data-type="correction" data-toggle="tooltip" title="{{ t('help') }}"><i class="fa fa-support"></i></a></label>
                                            <div class="input-group">
                                                <input name="invoice-correction-format" id="invoice-correction-format" class="form-control" type="text" value="{{ $settings->get('mod.invoice.correction.format') }}" style="font-family:Monospace" />
                                                <a class="input-group-addon btn-invoice-help-format help-inline" data-type="correction" href="#" data-toggle="tooltip" title="{{ t('help') }}"><i class="fa fa-support"></i></a>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="invoice-correction-reset-number-year" class="control-label">{{ t('invoiceSettingsResetNumberWithNewYear') }}</label>
                                            <select name="invoice-correction-reset-number-year" id="invoice-correction-reset-number-year" class="form-control">
                                                <option value="1"{{ $settings->get('mod.invoice.correction.opt.restartwithnewyear') == 1 ? ' selected="selected"' : '' }}>{{ t('syes') }}</option>
                                                <option value="0"{{ $settings->get('mod.invoice.correction.opt.restartwithnewyear') == 0 ? ' selected="selected"' : '' }}>{{ t('sno') }}</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="invoice-correction-reset-number-month" class="control-label">{{ t('invoiceSettingsResetNumberWithNewMonth') }}</label>
                                            <select name="invoice-correction-reset-number-month" id="invoice-correction-reset-number-month" class="form-control">
                                                <option value="1"{{ $settings->get('mod.invoice.correction.opt.restartwithnewmonth') == 1 ? ' selected="selected"' : '' }}>{{ t('syes') }}</option>
                                                <option value="0"{{ $settings->get('mod.invoice.correction.opt.restartwithnewmonth') == 0 ? ' selected="selected"' : '' }}>{{ t('sno') }}</option>
                                            </select>
                                        </div>
                                        <div class="form-group has-feedback">
                                            <label for="invoice-correction-number" class="control-label">{{ t('invoiceNumber') }}</label>
                                            <input name="invoice-correction-number" id="invoice-correction-number" class="form-control" type="text" value="{{ $settings->get('mod.invoice.correction.number') }}" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="tab-pane" id="7">
                                <div class="panel panel-default">
                                    <div class="panel-heading panel-heading-hl">Podatnika zwolnionego</div>
                                    <div class="panel-body">
                                        <div class="form-group has-feedback">
                                            <label for="invoice-exempt-format" class="control-label">{{ t('invoiceSettingsNumberFormat') }} <a href="#" class="btn-invoice-help-format help-inline" data-type="exempt" data-toggle="tooltip" title="{{ t('help') }}"><i class="fa fa-support"></i></a></label>
                                            <div class="input-group">
                                                <input name="invoice-exempt-format" id="invoice-exempt-format" class="form-control" type="text" value="{{ $settings->get('mod.invoice.exempt.format') }}" style="font-family:Monospace" />
                                                <a class="input-group-addon btn-invoice-help-format help-inline" data-type="exempt" href="#" data-toggle="tooltip" title="{{ t('help') }}"><i class="fa fa-support"></i></a>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="invoice-exempt-reset-number-year" class="control-label">{{ t('invoiceSettingsResetNumberWithNewYear') }}</label>
                                            <select name="invoice-exempt-reset-number-year" id="invoice-exempt-reset-number-year" class="form-control">
                                                <option value="1"{{ $settings->get('mod.invoice.exempt.opt.restartwithnewyear') == 1 ? ' selected="selected"' : '' }}>{{ t('syes') }}</option>
                                                <option value="0"{{ $settings->get('mod.invoice.exempt.opt.restartwithnewyear') == 0 ? ' selected="selected"' : '' }}>{{ t('sno') }}</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="invoice-exempt-reset-number-month" class="control-label">{{ t('invoiceSettingsResetNumberWithNewMonth') }}</label>
                                            <select name="invoice-exempt-reset-number-month" id="invoice-exempt-reset-number-month" class="form-control">
                                                <option value="1"{{ $settings->get('mod.invoice.exempt.opt.restartwithnewmonth') == 1 ? ' selected="selected"' : '' }}>{{ t('syes') }}</option>
                                                <option value="0"{{ $settings->get('mod.invoice.exempt.opt.restartwithnewmonth') == 0 ? ' selected="selected"' : '' }}>{{ t('sno') }}</option>
                                            </select>
                                        </div>
                                        <div class="form-group has-feedback">
                                            <label for="invoice-exempt-number" class="control-label">{{ t('invoiceNumber') }}</label>
                                            <input name="invoice-exempt-number" id="invoice-exempt-number" class="form-control" type="text" value="{{ $settings->get('mod.invoice.exempt.number') }}" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="invoice-help-format" tabindex="-1" role="dialog" aria-labelledby="invoice-help-format-modal-label" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="<?php echo $app->t('close'); ?>"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="invoice-help-format-modal-label">{{ t('invoiceWhatIsInvoiceNumberFormat') }}</h4>
            </div>
            <div class="modal-body">
                {{ t('invoiceInvoiceNumberFormatExplanation') }}
                <hr />
                {{ t('invoiceInvoiceNumberFormatHowCreateExplanation') }}
                <div class="container-fluid container-modal">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="quick-format-generator">{{ t('invoiceYourFormat') }}</label>
                                <input type="text" id="quick-format-generator" class="form-control" value="" style="font-family:Monospace" />
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="quick-format-generated">{{ t('invoiceExampleInvoiceNumber') }}</label>
                                <input type="text" id="quick-format-generated" class="form-control" value="" style="font-family:Monospace" />
                            </div>
                        </div>
                    </div>
                    <div class="row invoice-format-quick-form">
                        <div class="col-md-12">
                            <p>{{ t('invoiceUseBelowedButtonsToInsertValuesToFormat') }}</p>
                            <button type="button" class="btn btn-sm btn-default" data-val="%N">{{ t('invoiceNumber') }}</button>
                            <button type="button" class="btn btn-sm btn-default" data-val="%Y">{{ t('year') }}</button>
                            <button type="button" class="btn btn-sm btn-default" data-val="%M">{{ t('month') }}</button>
                            <button type="button" class="btn btn-sm btn-default" data-val="%D">{{ t('day') }}</button>
                            <button type="button" class="btn btn-sm btn-default" data-val="%H">{{ t('hour') }}</button>
                            <button type="button" class="btn btn-sm btn-default" data-val="%I">{{ t('minute') }}</button>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">{{ t('close') }}</button>
                <a href="#" class="btn btn-primary">{{ t('invoiceApplyFormat') }}</a>
            </div>
        </div>
    </div>
</div>
<script>
var invoiceTypeFormat = 'sales';

$(function() {
    $('#invoice-help-format').on('shown.bs.modal', function(event) {
        $('#invoice-help-format').focus();
    });

    $('.btn-invoice-help-format').click(function() {
        invoiceTypeFormat = $(this).attr('data-type');
        $('#quick-format-generator').val($('#invoice-' + invoiceTypeFormat + '-format').val());

        $('#invoice-help-format').modal();

        generateValueFromFormat();
        return false;
    });

    $('#invoice-help-format .modal-footer .btn-primary').click(function() {
        $('#invoice-' + invoiceTypeFormat + '-format').val($('#quick-format-generator').val());
        $('#invoice-help-format').modal('hide');
        return false;
    });

    $('#invoice-help-format').keyup(function() {
        generateValueFromFormat();
    });

    $('#invoice-help-format .invoice-format-quick-form .btn').on('click', function() {
        var element = document.getElementById('quick-format-generator');
        insertAtCursor(element, $(this).data('val'));
        element.focus();
        generateValueFromFormat();
    });
});

function generateValueFromFormat() {
    var d   = new Date();
    var elm = $('#quick-format-generated');
    var val = $('#quick-format-generator').val()
        .replace(/%N/g, 123)
        .replace(/%Y/g, d.getFullYear())
        .replace(/%M/g, d.getMonth())
        .replace(/%D/g, d.getDate())
        .replace(/%H/g, d.getHours())
        .replace(/%I/g, d.getMinutes());

    elm.val(val);
};

function insertAtCursor(myField, myValue) {
    // IE support
    if(document.selection)
    {
        myField.focus();
        sel = document.selection.createRange();
        sel.text = myValue;
    }
    // MOZILLA and others
    else if(myField.selectionStart || myField.selectionStart == '0')
    {
        var startPos = myField.selectionStart;
        var endPos   = myField.selectionEnd;
        myField.value = myField.value.substring(0, startPos)
            + myValue
            + myField.value.substring(endPos, myField.value.length);
    }
    else
    {
        myField.value += myValue;
    }
};
</script>
