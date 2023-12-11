{assign var=geocode value=$google->locationData()|json_decode:"true"}
{if (isset($geocode['status']) && ($geocode['status'] == "OK"))}
{
    "latitude": "{$geocode.results.0.geometry.location.lat}",
    "longitude": "{$geocode.results.0.geometry.location.lng}"
}
{else}
{assign var=crap value=Log::general($geocode)}
{
    "result": "Error, location not found or other error"
}
{/if}
