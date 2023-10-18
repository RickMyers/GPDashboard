{assign var=locations value=$locations->fetch()}
[
    {
        "text": "",
        "value": ""
    }
    {foreach from=$locations item=loc}
    ,{
        "text": "{$loc.address1}, {$loc.city}, {$loc.state}, {$loc.zip_code}",
        "value": "{$loc.address1}, {$loc.city}, {$loc.state}, {$loc.zip_code}"
    }
    {/foreach}
]
