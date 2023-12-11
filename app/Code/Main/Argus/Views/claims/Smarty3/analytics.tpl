<div id="claim_charts" style="padding-top: 40px">
    <form name="hedis_claims_analytics_form" id="hedis_claims_analytics_form" onsubmit="return false">
    Choose Year: <select name="yyyy" id='claims_analytics_yyyy'>
                    <option value=''> </option>
                    <option value='2020'> 2020 </option>
                    <option value='2021'> 2021 </option>
                    <option value='2022'> 2022 </option>
                    <option value='2023'> 2023 </option>
                    <option value='2024'> 2024 </option>
                    <option value='2025'> 2025 </option>
                 </select>
    </form>
    <div class='dashboard-graph' style="float: right; width: 45%; margin-right: 3%">
        <div id="claim_chart_1_label" style="background-color: rgba(202,202,202,.3)">&nbsp;</div>
        <div style="height: 140px; position: relative">
            <canvas id='claim_chart_1' style='width: 100%; height: 100%;'></canvas>
        </div>
    </div>
    <div class='dashboard-graph' style="float: right; width: 45%; margin-right: 3%">
        <div id="claim_chart_2_label" style="background-color: rgba(202,202,202,.3)">&nbsp;</div>
        <div style="height: 140px; position: relative">
            <canvas id='claim_chart_2' style='width: 100%; height: 100%;'></canvas>
        </div>
    </div>
    <div style="clear: both; height: 40px"></div>
    <div class='dashboard-graph' style="float: right; width: 45%; margin-right: 3%">
        <div id="claim_chart_3_label" style="background-color: rgba(202,202,202,.3)">&nbsp;</div>
        <div style="height: 140px; position: relative">
            <canvas id='claim_chart_3' style='width: 100%; height: 100%;'></canvas>
        </div>
    </div>
    <div class='dashboard-graph' style="float: right; width: 45%; margin-right: 3%">
        <div id="claim_chart_4_label" style="background-color: rgba(202,202,202,.3)">&nbsp;</div>
        <div style="height: 140px; position: relative">
            <canvas id='claim_chart_4' style='width: 100%; height: 100%;'></canvas>
        </div>
    </div>
</div>
<script type='text/javascript'>
    (function () {
        new EasyEdits('/edits/argus/analytics');
        let options = {
            pointLabelFontColor : "#F7F7F7",
            scaleFontColor: "#F7F7F7",
            labels: {
                // This more specific font property overrides the global property
                fontColor: '#ffffff'
            },            
            legend: {
                labels: {
                    // This more specific font property overrides the global property
                    fontColor: '#ffffff'
                }
            }
        };
        {if ($role->userHasRole('O.D.'))}
        $('#claim_chart_1_label').html('Form Volumes By Month');
        let data = {
            labels: [{$charts->monthNames()}],
            datasets: [
                7,4,7,9,2,3
            ]
        };
        let ctx = $("#claim_chart_1").get(0).getContext("2d");
        let myBarChart = new Chart(ctx).Bar(data, options);    
         data = {
            labels: [{$charts->monthNames()}],
            datasets: [
                7,4,7,9,2,3
            ]
        };
        ctx = $("#claim_chart_2").get(0).getContext("2d");
        var myLineChart = new Chart(ctx).Line(data, options);        

        {elseif ($role->userHasRole('HEDIS Vision Manager'))}

        {elseif ($role->userHasRole('System Administrator'))}    

        {/if}
        
                
    })();
</script>

