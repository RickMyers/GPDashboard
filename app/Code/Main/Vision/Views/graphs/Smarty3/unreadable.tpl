<div style="{$style}" id="tech_efficiency_unreadable">
    <div>Percentage of Unreadable Members</div>
    <canvas style="width: 100%; height: 200px" id="tech_efficiency_unreadable_graph">
    </canvas>
</div>
    {assign var=rows value=$forms->extendedInformation()}
    {assign var=unreadable value=$forms->tally($rows,'images_unreadable','Y')}
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
                   "value": {$unreadable},
                   "color": "#F7464A",
                   "highlight": "#FF5A5E",
                   "label": "Unreadable Images"
               },                        {
                   "value": {$total-$unreadable},
                   "color": "#46BFBD",
                   "highlight": "#5AD3D1",
                   "label": "OK"
               }
        ];
        var ctx = $("#tech_efficiency_unreadable_graph").get(0).getContext("2d");
        var myPieChart = new Chart(ctx).Pie(data,options);
    })();
</script>