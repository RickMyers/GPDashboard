    {assign var=hygenists value=$hygenists->callDurations()}
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
                label: "Call Duration",
                fillColor: "rgba(220,220,220,0.2)",
                strokeColor: "rgba(220,220,220,1)",
                highlightFill: "rgba(220,220,220,0.75)",
                highlightStroke: "rgba(220,220,220,1)",
                data: [        
                {assign var=comma value=false}
                {foreach from=$hygenists item=hygenist}
                    {if ($comma)},{/if}"{$hygenist.average_duration}"
                    {assign var=comma value=true}
                {/foreach}
                ]
            }            
        ]
    };
    (new Chart($("#{$layer}").get(0).getContext("2d")).Bar(data, options));
