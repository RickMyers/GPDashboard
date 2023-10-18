    {assign var=hygenists value=$hygenists->counselingPerHygenists()}
    
    var data = {
        labels: [
        {assign var=comma value=false}
        {foreach from=$hygenists item=hygenist}
            {if ($comma)},{/if}"{$hygenist.first_name}"
            {assign var=comma value=true}
        {/foreach}
        ],
        datasets: [
            {
                label: "Counselings Completed",
                fillColor: "rgba(220,220,220,0.2)",
                strokeColor: "rgba(220,220,220,1)",
                highlightFill: "rgba(220,220,220,0.75)",
                highlightStroke: "rgba(220,220,220,1)",
                data: [        
                {assign var=comma value=false}
                {foreach from=$hygenists item=hygenist}
                    {if ($comma)},{/if}"{$hygenist.completed_counseling}"
                    {assign var=comma value=true}
                {/foreach}
                ]
            }            
        ]
    };
    {if data}
    (new Chart($("#{$layer}").get(0).getContext("2d")).Bar(data, options));
    
    {else}
        
        var ctx=$("#{$layer}").get(0).getContext("2d");
       ctx.font = "30px Arial";
ctx.fillText("No Files as of yet",10,50);
        
        
        
    {/if}

