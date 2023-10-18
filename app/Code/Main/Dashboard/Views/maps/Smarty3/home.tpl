{assign var=SYSTEM value=Environment::status()}
<style type='text/css'>
    .maps-search-field {
        padding: 10px 5px; float: left; background-color: rgba(202,202,202,.1); font-family: sans-serif; margin-top: 5px; border: 1px solid transparent; font-size: 1.8em; width: 80%; box-sizing: border-box
    }
    .maps-search-field:focus {
        background-color: rgba(202,202,202,.2)
    }
    .argus-map-layer {
        padding: 10px; border: 3px solid ghostwhite; border-radius: 10px; width: 49.5%; display: inline-block; overflow: hidden;
    }
    .argus-map {
        margin-left: auto; margin-right: auto; width: 105%; height: 105%; position: relative; top: -12px; left: -12px
    }
</style>
<script>
    
</script>
<hr style='opacity: .4' />
<div style="float: right; font-size: .9em;"><span style="cursor: pointer" onclick="Landing.dashboard.home()">home</span> | <span onclick="Landing.help.home()" style="cursor: pointer">help</span></div><span style='font-size: 1.2em'>Fun With Maps!</span>
<hr style='opacity: .4' />
<div class='dashboard-icon'>
    <img src='/images/dashboard/map_icon.png' style='height: 50px; margin-top: 1px; margin-bottom: 1px' onclick="Argus.dashboard.maps.home()" />
    <div style='text-align: center;'>
        Maps!
    </div>
</div>
<form name="argus-map-form" id="argus-map-form" onkeydown="Argus.dashboard.maps.scan(event)" onsubmit="return false">
<input type='text' class='maps-search-field' name=maps_member_name' id='maps_member_name' placeholder='Member Name' />
<div style='background-color: rgba(55,55,55,.3); padding: 13px; margin-top: 5px;  display: inline-block; cursor: pointer' title="Search for matching maps" onclick="Argus.maps.batching.list(1)">
   <img src='/images/argus/search.png' style='height: 32px' />
</div><br />
</form>
<hr style='opacity: .4' />
<div style="display: block">
    <div class="argus-map-layer">
        <img class="argus-map" src="https://maps.googleapis.com/maps/api/staticmap?center=FL&zoom=7&size=640x480&maptype=roadmap&key={$SYSTEM.keys.static_maps}" />
    </div>
    <div class="argus-map-layer">
        <!--img class="argus-map" src="https://maps.googleapis.com/maps/api/staticmap?center=Brooklyn+Bridge,New+York,NY&zoom=13&size=640x480&maptype=roadmap&markers=color:blue%7Clabel:S%7C40.702147,-74.015794&markers=color:green%7Clabel:G%7C40.711614,-74.012318&markers=color:red%7Clabel:C%7C40.718217,-73.998284&key={$SYSTEM.keys.static_maps}" /-->
    </div>
</div>

