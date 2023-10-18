    {assign var=progress value=$contacts->campaignProgress()}
    {assign var=first value=true}
    var data = [
        {foreach from=$progress item=category}
            {if (!$first)},{/if}{
                value: "{$category.total}",
                color: "{$category.base}",
                highlight: "{$category.highlight}",
                label: "{$category.label}"
            }          
            {assign var=first value=false}
        {/foreach}
    ];
    (new Chart($("#{$layer}").get(0).getContext("2d")).Pie(data,options));

