[
    {
        "text": "Choose a Location (optional)",
        "value": ""
    }{foreach from=$locations->ipaLocations() item=location}{if ($location.location)},
    {
        "text": "{$location.location}",
        "value": "{$location.id}",
        "title": "{$location.address}"
    }{/if}{/foreach}
]
