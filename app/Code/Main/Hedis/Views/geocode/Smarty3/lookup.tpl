{assign var=results value=$location->geocodeLocation()}

{assign var=lc value=$results|json_decode:"true"}
<p>latitude: {$lc.results.0.geometry.location.lat}</p>
<p>longitude: {$lc.results.0.geometry.location.lng}</p>
<p>{$lc}</p>