<div style="background-color: rgba(202,202,202,.5); margin-bottom: 2px; clear: both; padding: 2px;">
    <div style="width: 20%; font-weight: bold; display: inline-block">
        Room Name
    </div>
    <div style="width: 20%; font-weight: bold; display: inline-block">
        Activated
    </div>
    <div style="width: 20%; font-weight: bold; display: inline-block">
        Technician
    </div>
    <div style="width: 10%; font-weight: bold; display: inline-block">
        Form
    </div>    
    <div style="width: 10%; font-weight: bold; display: inline-block">
        Member
    </div>       
</div>
{* ############################################################################
    WE ARE USING THE ROOM ID AS THE FORM ID... NOT SURE IF THATS A BAD IDEA YET
   ############################################################################# *}
{foreach from=$rooms->details() item=room}
    <div style="cursor: pointer; background-color: rgba(202,202,202,{cycle values=".15,.3"}); margin-bottom: 2px">
        <div style="width: 20%; padding-left: 20px; display: inline-block">
            <a href="#" onclick="Argus.teledentistry.open.facetime(); return false">{$room.waiting_room_name}</a>
        </div>
        <div style="width: 20%; display: inline-block">
            {$room.visit_date}{* use session_start when available *}
        </div>
        <div style="width: 20%; display: inline-block">
            {$room.hygienist_name} &nbsp;
        </div>
        <div style="width: 10%; display: inline-block">
            <a href="#" onclick="Argus.dental.consultation.open('{$room.form_id}'); return false">Form</a>
        </div>        
        <div style="width: 10%; display: inline-block">
            {$room.member_name}
        </div>
    </div>
{/foreach}
