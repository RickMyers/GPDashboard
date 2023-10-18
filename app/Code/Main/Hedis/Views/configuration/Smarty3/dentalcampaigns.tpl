<div style='clear:both'></div>
<div id='app-dental-campaigns-container' class='dashboard-app-container' style='width: 90%'>
    <div id='app-dental-campaigns-header' class='dashboard-app-header'><img onclick="Argus.tools.toggle(this); $('#app-dental-campaigns-body').slideToggle()" style="float: left; cursor: pointer; margin-right: 5px; height: 20px;" src="/images/dashboard/collapse.png" />
        Dental Campaigns Management
    </div>
    <div id='app-dental-campaigns-body' class='dashboard-app-body' style="position: relative; height: 400px; overflow: auto">
        
    </div>
</div>
<script type='text/javascript'>
    (new EasyAjax('/hedis/configuration/campaigns')).then(function (response) {
        $('#app-dental-campaigns-body').html(response);
    }).get();
</script>
