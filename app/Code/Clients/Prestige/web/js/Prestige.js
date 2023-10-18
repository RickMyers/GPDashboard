Argus.prestige = (function ($) {
    return {
        provider: {
            reconciliation: function () {
                var win = Desktop.semaphore.checkout(true);
                win._title('Provider Reconciliation')._open();
                (new EasyAjax('/prestige/reconciliation/form')).add('window_id',win.id).then(function (response) {
                    win.set(response);
                }).get();
            }
        }
    }
})($);