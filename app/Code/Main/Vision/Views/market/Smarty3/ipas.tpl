[
    {
        "text": "Choose an IPA (optional)",
        "value": ""
    }{foreach from=$ipas->clientIpas() item=ipa}{if ($ipa.ipa)},
    {
        "text": "{$ipa.ipa}",
        "value": "{$ipa.id}"
    }{/if}{/foreach}
]