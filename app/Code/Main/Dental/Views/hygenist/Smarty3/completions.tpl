    {assign var=completions value=$contacts->completions()}
    {assign var=first value=true}
    {assign var=testing value=false}
    var data = [
        {foreach from=$completions item=category}
            {if (!$first)},{/if}{
                value: "{$category.total}",
                color: "{$category.base}",
                highlight: "{$category.highlight}",
                label: "{$category.label}"
                {if $category.total>0}{assign var=testing value=true}{/if}
                
            }          
            {assign var=first value=false}
        {/foreach}
    ];
    {if $testing}
    (new Chart($("#{$layer}").get(0).getContext("2d")).Pie(data,options));
    {else}
        var ctx=$("#{$layer}").get(0).getContext("2d");
        
        ctx.font = "20px Arial";
ctx.fillText("No data currently available",30,80);
    {/if}