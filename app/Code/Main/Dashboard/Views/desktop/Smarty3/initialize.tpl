{
    "application":
    {
        "windowStyle": "solid",
        "desktop": {
        },
        "owner": {
        },
        "appearance": {
        }
    },
    "controls": [
    ],
    "apps": [
        {assign var=comma value=false}
        {foreach from=$apps->myApps() item=app}
            {if ($comma)},{else}{assign var=comma value=true}{/if}{
                "id":             "{$app.id}",
                "app":            "{$app.app}",
                "description":    "{$app.description}",
                "image":          "{$app.icon}",
                "minimized_icon": "{$app.minimized_icon}",
                "url":            "{$app.url}",
                "component":      "{$app.component}",
                "style":          ""
            }
        {/foreach}
    ],
    "windows": []
    
}