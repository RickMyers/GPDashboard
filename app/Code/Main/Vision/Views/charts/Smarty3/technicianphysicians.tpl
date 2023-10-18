    var data = [
        {assign var=comma value=false}
        {foreach from=$data item=health_plan}
            {if ($comma)},{/if}{
                value: {$health_plan.total},
                color:"{$health_plan.color}",
                highlight: "{$health_plan.highlight}",
                label: "{$health_plan.name}"
            }
            {assign var=comma value=true}
        {/foreach}
    ];
    (new Chart($("#{$layer}").get(0).getContext("2d")).Pie(data,options));



