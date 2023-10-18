{assign var=locations value=$locations->setHealthPlanId($location->getHealthPlanId())->fetch()}
{
    "location": {
        "health_plan_id": "{$location->getHealthPlanId()}",
        "full_address": "{$location->getFullAddress()}",
        "address1": "{$location->getAddress1()}",
        "city": "{$location->getCity()}",
        "state": "{$location->getState()}",
        "zip_code": "{$location->getZipCode()}"
    },
    "locations": [
        {
               "full_address": ""
        }
        {foreach from=$locations item=loc}
            ,{
                "full_address": "{$loc.address1}, {$loc.city}, {$loc.state}, {$loc.zip_code}",
                "location_id": "{$loc.name}",
                "address1": "{$loc.address1}",
                "city": "{$loc.city}",
                "state": "{$loc.state}",
                "zip_code": "{$loc.zip_code}"
            }
        {/foreach}
    ]
}
