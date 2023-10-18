{assign var=comma value=false}
{
    {foreach from=$templates->fetch() item=template}
        {if ($comma)},{/if}
    "{$template.name}": {
        "template":"{$json->escapeJsonString($template.template)}",
        "author":"{$template.created_by}"
    }
    {assign var=comma value=true}
    {/foreach}
}
    