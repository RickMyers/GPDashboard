<div style="background-color: rgba(202,202,202,.5); margin-bottom: 2px; clear: both; padding: 2px;">
    <div style="width: 18%; font-weight: bold; display: inline-block">
        Room Name <!-- Will open the current form -->
    </div>
    <div style="width: 10%; font-weight: bold; display: inline-block">
        Session Started
    </div>
    <div style="width: 20%; font-weight: bold; display: inline-block">
        Technician
    </div>
    <div style="width: 20%; font-weight: bold; display: inline-block">
        Member Name
    </div>
    <div style="width: 18%; font-weight: bold; display: inline-block">
        Member ID
    </div>
    <div style="width: 10%; font-weight: bold; display: inline-block">
        Form <!-- Will Create A New Form -->
    </div>

</div>
<form onsubmit="return false" id="newTeledentistrySessionForm" name="newTeledentistryForm">
<input name="window_id" id="teledentistry_window_id" type="hidden" value="{$window_id}" />
{foreach item=room from=$rooms->myWaitingRoom()}
    <input type="hidden" name="form_id" id="teledentistry_form_id" value="{$room.form_id}" />
    <div style="cursor: pointer; background-color: rgba(202,202,202,{cycle values=".15,.3"}); margin-bottom: 2px">
        <div style="width: 18%; display: inline-block; padding-right: 15px">
            <a href="#" onclick="Argus.dental.consultation.open('{$room.form_id}'); return false">{$room.waiting_room_name}</a>
        </div>
        <div style="width: 10%; display: inline-block; padding-right: 15px">
            {$room.session_start}
        </div>
        <div style="width: 20%; display: inline-block; padding-right: 15px">
            {$room.hygienist}
        </div>
        <div style="width: 20%; display: inline-block; padding-right: 15px">
            <input type="text" name="member_name" id="teledentistry_member_name" value="" />
        </div>
        <div style="width: 18%; display: inline-block; padding-right: 15px">
            <input type="text" name="member_id" id="teledentistry_member_id" value="" />
        </div>
        <div style="width: 10%; display: inline-block">
            <input type="button" value="Start" id="teledentistry_start_button" />
        </div>
    </div>
{/foreach}
</form>
<script type="text/javascript">
    new EasyEdits('/edits/dental/televisit','televisit');
</script>