<script type='text/javascript'>
(function () {
    let options = {
        labels: {
            fontColor: '#ffffff'
        },            
        legend: {
            labels: {
                fontColor: '#ffffff'
            }
        }        
    };
    let data = [
        {
            value: '{$contacts->assignments(false,$campaign_id,'C')}',
            color:"Blue",
            highlight: "#AAAAFF",
            label: "Completed"
        },            
        {
            value: '{$contacts->assignments(false,$campaign_id,'N')}',
            color:"Grey",
            highlight: "#CCCCCC",
            label: "Unassigned"
        },
        {
            value: '{$contacts->assignments(false,$campaign_id,'A')}',
            color:"Green",
            highlight: "#AAFFAA",
            label: "In Progress"
        },
        {
            value: '{$contacts->assignments(false,$campaign_id,'R')}',
            color:"#333333",
            highlight: "#777777",
            label: "Returned"
        }
    ];
    let ctd = $("#outreach_graph_1").get(0).getContext("2d");
    ctd.clearRect(0,0,ctd.width,ctd.height);
    (new Chart(ctd).Pie(data,options));     
    {assign var=comma value=false}
    data = [
    {foreach from=$contacts->campaignContacts(false,'A') item=assignee}{if ($comma)},{/if}
        {
            value: '{$assignee.total}',
            color:"{$contacts->getColor()}",
            highlight: "{$contacts->getHighlight()}",
            label: "Assigned to {$assignee.assignee_name}"
        }{assign var=comma value=true}
    {/foreach}
    ];
    ctd = $("#outreach_graph_2").get(0).getContext("2d");
    ctd.clearRect(0,0,ctd.width,ctd.height);
    (new Chart(ctd).Pie(data,options));         
    {assign var=comma value=false}    
    data = [
    {foreach from=$contacts->campaignContacts(false,'C') item=assignee}{if ($comma)},{/if}
        {
            value: '{$assignee.total}',
            color:"{$contacts->getColor()}",
            highlight: "{$contacts->getHighlight()}",
            label: "Completed by {$assignee.assignee_name}"
        }{assign var=comma value=true}
    {/foreach}
    ];
    ctd = $("#outreach_graph_3").get(0).getContext("2d");
    ctd.clearRect(0,0,ctd.width,ctd.height);
    (new Chart(ctd).Pie(data,options));      
})();
</script>
