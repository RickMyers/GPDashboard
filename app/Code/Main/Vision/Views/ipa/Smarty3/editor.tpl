<style type="text/css">
    .npi_location_row {
        white-space: nowrap; margin-bottom: 2px
    }
    .npi_location_cell {
        display: inline-block; margin-right: 2px; background-color: rgba(202,202,202,.3)
    }
    .npi_location_title {
        font-size: .85em; font-family: monospace; letter-spacing: 1px;
    }  
    .npi_location_field {
        padding-left: 20px; font-size: .9em; 
    }
    .npi_location_menu {
        padding: 2px; border: 1px solid #aaf; border-radius: 2px; background-color: lightcyan; font-size: .95em
    }
</style>
<table style="width: 100%; height: 100%">
    <tr>
        <td>
            <div style="box-sizing: border-box; margin: 1%; padding: 20px; border: 1px solid silver; border-radius: 20px; width: 98%; height: 98%">
                <form id="npi_location_form-{$window_id}" name="npi_location_form" onsubmit="return false">
                    <div class="npi_location_row">
                        <div class="npi_location_cell">
                            <div class="npi_location_title">
                                Client
                            </div>
                            <div class="npi_location_field">
                                <select class="npi_location_menu" name="client_id" id="client_id-{$window_id}" style="width: 120px">
                                    <option value=""> </option>
                                    {foreach from=$clients->fetch() item=client}
                                        <option value="{$client.id}"> {$client.client} </option>
                                    {/foreach}
                                </select>
                            </div>
                        </div>
                        <div class="npi_location_cell">
                            <div class="npi_location_title">
                                IPA
                            </div>
                            <div class="npi_location_field">
                                <select class="npi_location_menu" name="ipa_id" id="ipa_id-{$window_id}" style="width: 240px;">
                                    <option value=""> </option>
                                </select>                                
                            </div>
                        </div>
                        <div class="npi_location_cell">
                            <div class="npi_location_title">
                                Business Location
                            </div>
                            <div class="npi_location_field">
                                <select class="npi_location_menu" name="location_id" id="location_id-{$window_id}" style="width: 250px">
                                    <option value=""> </option>
                                </select>                                
                            </div>
                        </div>
                        <div class="npi_location_cell">
                            <div class="npi_location_title">
                                Address
                            </div>
                            <div class="npi_location_field">
                                <select class="npi_location_menu" name="address_id" id="address_id-{$window_id}" style="width: 250px">
                                    <option value=""> </option>
                                </select>                                
                            </div>
                        </div>                                    
                    </div>
                    <br />
                    <div class="npi_location_row">
                        <div id="location_npi_list-{$window_id}">
                        </div>
                    </div>
                </form>
            </div>
        </td>
    </tr>
</table>
<script type="text/javascript">
    var ee = new EasyEdits(null,"npi_location_form-{$window_id}");
    ee.fetch("/edits/vision/locationnpi");
    ee.process(ee.getJSON().replace(/&&window_id&&/g,'{$window_id}'));
</script>
