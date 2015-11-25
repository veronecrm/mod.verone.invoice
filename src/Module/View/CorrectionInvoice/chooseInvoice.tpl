<div class="page-header">
    <div class="page-header-content">
        <div class="page-title">
            <h1>
                <i class="fa fa-credit-card"></i>
                {{ t('invoiceChooseInvoice') }}
            </h1>
        </div>
        <div class="heading-elements">
            <div class="heading-btn-group">
                <a href="#" data-form-submit="form" data-form-param="apply" class="btn btn-icon-block btn-link-success">
                    <i class="fa fa-arrow-circle-right"></i>
                    <span>{{ t('forward') }}</span>
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
            <li class="active"><a href="{{ createUrl('Invoice', 'CorrectionInvoice', 'add') }}">{{ t('invoiceNew') }}</a></li>
        </ul>
    </div>
</div>

<div class="container-fluid">
    <div class="row">
        <div class="col-md-12">
            <div class="row">
                <div class="col-md-6 col-md-offset-3">
                    <form action="{{ createUrl('Invoice', 'CorrectionInvoice', 'add') }}" method="get" id="form">
                        <input type="hidden" name="mod" value="Invoice" />
                        <input type="hidden" name="cnt" value="CorrectionInvoice" />
                        <input type="hidden" name="act" value="add" />
                        <div class="form-group">
                            <label class="control-label" for="correction">{{ t('invoiceSelectInvoiceToCorrection') }}</label>
                            <select name="correction" id="correction" class="form-control">
                                @foreach $elements
                                    <option value="{{ $item->getId() }}">{{ $item->getNumber() }}</option>
                                @endforeach
                            </select>
                        </div>
                        <div class="text-right">
                            <a href="#" class="btn btn-success" data-form-submit="form" data-form-param="apply">{{ t('forward') }}</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
