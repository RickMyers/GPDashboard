{assign var=data value=$screenings->workloads()}
var data = {
        labels: [
        {assign var=comma value=false}
        {foreach from=$data.labels item=label}
            {if ($comma)},{/if}"{$label}"
            {assign var=comma value=true}
        {/foreach}
        ],
        datasets: [
            {
                label: "OD",
                fillColor: "rgba(220,220,220,0.2)",
                strokeColor: "rgba(220,220,220,1)",
                highlightFill: "rgba(220,220,220,0.75)",
                highlightStroke: "rgba(220,220,220,1)",
                data: [        
                {assign var=comma value=false}
                {foreach from=$data.values item=val}
                    {if ($comma)},{/if}"{$val}"
                    {assign var=comma value=true}
                {/foreach}
                ]
            }            
        ]
    };
    (new Chart($("#{$layer}").get(0).getContext("2d")).Bar(data, options));
