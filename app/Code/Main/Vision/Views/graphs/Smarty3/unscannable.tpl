<div style="{$style}" id="tech_efficiency_unscannable">
    <div>Percentage of Unscannable Members</div>
    <canvas style="width: 100%; height: 200px" id="tech_efficiency_unscannable_graph">
    </canvas>
</div>
    {assign var=rows value=$forms->extendedInformation()}
    {assign var=unscannable value=$forms->tally($rows,'member_unscannable','Y')}    
    {assign var=total value=$rows|@count}
<script type="text/javascript">
    (function () {
        var options = {
            labels: {
                fontColor: '#ffffff'
            },            
            legend: {
                labels: {
                    fontColor: '#ffffff'
                }
            }
        };        
        var data = [
                           {
                   "value": {$unscannable},
                   "color": "#F7464A",
                   "highlight": "#FF5A5E",
                   "label": "Unscannable Members"
               },                        {
                   "value": {$total-$unscannable},
                   "color": "#46BFBD",
                   "highlight": "#5AD3D1",
                   "label": "OK"
               }
        ];
        var ctx = $("#tech_efficiency_unscannable_graph").get(0).getContext("2d");
        var myPieChart = new Chart(ctx).Pie(data,options);
    })();
</script>