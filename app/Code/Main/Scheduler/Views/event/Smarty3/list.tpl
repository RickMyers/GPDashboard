{
    "id": "",
    "name": ""
}
{foreach from=$events item=event}
    ,{
        "id": "{$event.id}",
        "name": "[{$event.start_date}] - {$event.ipa_id_combo}"
    }
{/foreach}
