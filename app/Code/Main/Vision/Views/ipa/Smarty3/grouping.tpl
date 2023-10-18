<style type="text/css">
    .ipa_grouping_row {
        white-space: nowrap; margin-bottom: 2px
    }
    .ipa_grouping_cell {
        display: inline-block; margin-right: 2px; background-color: rgba(202,202,202,.3)
    }
    .ipa_grouping_title {
        font-size: .85em; font-family: monospace; letter-spacing: 1px;
    }  
    .ipa_grouping_field {
        padding-left: 20px; font-size: .9em; 
    }
    .ipa_grouping_menu {
        padding: 2px; border: 1px solid #aaf; border-radius: 2px; background-color: lightcyan; font-size: .95em
    }
</style>
<table style="width: 100%; height: 100%">
    <tr>
        <td>
            <div style="box-sizing: border-box; margin: 1%; padding: 20px; border: 1px solid silver; border-radius: 20px; width: 98%; height: 98%">
                <form id="ipa_grouping_form-{$window_id}" name="ipa_grouping_form" onsubmit="return false">
                    <input type="hidden" name="current_group_id" id="current_group_id-{$window_id}" value="" />
                    <div class="ipa_grouping_row" style="height: 25px">
                        Current Group: <div id="current_ipa_group-{$window_id}" style="font-weight: bold; display: inline-block"></div>
                    </div>
                    <br />
                    <div class="ipa_grouping_row">
                        <div class="ipa_grouping_cell">
                            <div class="ipa_grouping_title">
                                IPA Group
                            </div>
                            <div class="ipa_grouping_field">
                                <select class="ipa_grouping_menu" name="ipa_group_id" id="ipa_group_id-{$window_id}" style="width: 320px">
                                    <option value=""> </option>
                                    {foreach from=$groups->fetch() item=group}
                                        <option value="{$group.id}"> {$group.group} </option>
                                    {/foreach}
                                </select>
                                <input type="text" name="ipa_group_id_combo" id="ipa_group_id-{$window_id}_combo" />
                                <input type="button" id="ipa_group_create_button-{$window_id}" name="ipa_group_create_button" value=" New Group " />
                            </div>
                        </div>
                    </div>
                    <div class="ipa_grouping_row">
                        <div class="ipa_grouping_cell">
                            <div class="ipa_grouping_title">
                                Available IPAs
                            </div>
                            <div class="ipa_grouping_field">
                                <select class="ipa_grouping_menu" name="ipa_id" id="ipa_id-{$window_id}" style="width: 320px">
                                    <option value=""> </option>
                                    {foreach from=$ipas->fetch() item=ipa}
                                        <option value="{$ipa.id}"> {$ipa.ipa} </option>
                                    {/foreach}
                                </select>
                                <input type="button" id="add_ipa_button-{$window_id}" name="add_ipa_button" value=" Add IPA " />
                            </div>
                        </div>
                    </div>                            
                    <br />
                    <div class="ipa_grouping_row">
                        <div id="ipa_group_members-{$window_id}">
                        </div>
                    </div>
                </form>
            </div>
        </td>
    </tr>
</table>
<script type="text/javascript">
    var ee = new EasyEdits(null,"ipa_grouping_form-{$window_id}");
    ee.fetch("/edits/vision/ipagrouping");
    ee.process(ee.getJSON().replace(/&&window_id&&/g,'{$window_id}'));
</script>
