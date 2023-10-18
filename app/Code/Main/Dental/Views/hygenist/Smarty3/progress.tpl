    {assign var=progress value=$contacts->progress()}
    {assign var=first value=true}
    {assign var=testing value=false}
    var data = [
        {foreach from=$progress item=category}
            {if (!$first)},{/if}{
                value: "{$category.total}",
                color: "{$category.base}",
                highlight: "{$category.highlight}",
                label: "{$category.label}"
                
                {if $category.total>0}
                    {assign var=testing value=true}
                {/if}
            }          
            {assign var=first value=false}
        {/foreach}
    ];
    
    var ctx=$("#{$layer}").get(0).getContext("2d");
       
    {if $testing}
    
        
    
    (new Chart($("#{$layer}").get(0).getContext("2d")).Pie(data,options));
     
    
     {else}
        
       ctx.font = "20px Arial";
ctx.fillText("No data currently available",30,80);
        
        
        
    {/if}   
    