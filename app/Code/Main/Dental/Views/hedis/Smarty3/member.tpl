<style type='text/css'>
    .consultation_form {
        padding: 5px
    }
    .narrow_width {
        width: 15%;
    }
    .medium_width {
        width: 25%
    }
    .wide_width {
        width: 50%
    }
    .full_width{
        width: 100%;
    }
    .nc_row {
        min-width: 600px; overflow: hidden; white-space: nowrap
    }
    .nc_cell {
        padding: 2px; display: inline-block; background-color: rgba(202,202,202,.2); margin-right: 2px; margin-bottom: 1px; overflow: hidden; min-width: 120px
    }
    .nc_desc {
        font-family: monospace; font-size: 1em; letter-spacing: 2px; color: #333
    }
    .nc_field {
        font-family: sans-serif; color: black; font-size: 1.2em; padding-left: 15px
    }
</style>

    
{assign var=participant value=$member->fullResults()}
    <div class='consultation_form'>

        <fieldset><legend title="Contact ID: {$participant.contact_id}">Member Information</legend>
            <div class='nc_row'>

                <div class='nc_cell' style='width: 20%'>
                    <div class='nc_desc'>
                        Member ID
                    </div>
                    <div class='nc_field'>
                        {$participant.member_id}
                    </div>
                </div>
                <div class='nc_cell'  style='width: 20%'>
                    <div class='nc_desc'>
                        First Name
                    </div>
                    <div class='nc_field'>
                        {$participant.first_name}
                    </div>
                </div>
                <div class='nc_cell'  style='width: 20%'>
                    <div class='nc_desc'>
                        Last Name
                    </div>
                    <div class='nc_field'>
                        {$participant.last_name}
                    </div>
                </div>  
                <div class='nc_cell'  style='width: 20%'>
                    <div class='nc_desc'>
                        Date of Birth
                    </div>
                    <div class='nc_field'>
                       &nbsp; {$participant.date_of_birth}
                    </div>
                </div> 
                <div class='nc_cell'  style='width: 20%'>
                    <div class='nc_desc'>
                        Age
                    </div>
                    <div class='nc_field'>
                      &nbsp;{$helper->age($participant.date_of_birth)}
                    </div>
                </div> 

            </div>
            <div class='nc_row'>

                <div class='nc_cell' style='width: 40%'>
                    <div class='nc_desc'>
                        Phone Number
                    </div>
                    <div class='nc_field'>
                        {$participant.phone_number}
                    </div>
                </div>
                <div class='nc_cell'  style='width: 20%'>
                    <div class='nc_desc'>
                        Address
                    </div>
                    <div class='nc_field'>
                        {$participant.address}
                    </div>
                </div>
                <div class='nc_cell'  style='width: 20%'>
                    <div class='nc_desc'>
                        City
                    </div>
                    <div class='nc_field'>
                        {$participant.city}
                    </div>
                </div>  
                <div class='nc_cell'  style='width: 20%'>
                    <div class='nc_desc'>
                        State
                    </div>
                    <div class='nc_field'>
                       &nbsp; {$participant.state}
                    </div>
                </div> 
                <div class='nc_cell'  style='width: 20%'>
                    <div class='nc_desc'>
                        Zip Code
                    </div>
                    <div class='nc_field'>
                      &nbsp; {$participant.state}
                    </div>
                </div> 

            </div>                    
               
            <div class='nc_row'>
                <div class='nc_cell' style='width: 33%; margin-right: .1%'>
                    <div class='nc_desc'>
                        Counseling Completed
                    </div>
                    <div class='nc_field'>
                        {if ($participant.counseling_completed == 'Y')}
                            Yes
                        {elseif ($participant.counseling_completed == 'N')}
                            No
                        {else}
                            N/A
                        {/if}
                        
                    </div>
                </div>
                <div class='nc_cell' style='width: 33%; margin-right: .1%'>
                    <div class='nc_desc'>
                        Requested Appointment
                    </div>
                    <div class='nc_field'>
                        {if ($participant.requested_appointment == 'Y')}
                            Yes
                        {elseif ($participant.requested_appointment == 'N')}
                            No
                        {else}
                            N/A
                        {/if}
                        
                    </div>
                </div> 
                <div class='nc_cell' style='width: 33%; margin-right: .1%'>
                    <div class='nc_desc'>
                        Yearly Dental Visit
                    </div>
                    <div class='nc_field'>
                        {if ($participant.yearly_dental_visit == 'Y')}
                            Yes
                        {elseif ($participant.yearly_dental_visit == 'N')}
                            No
                        {else}
                            N/A
                        {/if}
                        
                    </div>
                </div>                         
        </fieldset>
        <br /><br />
    
        
        
        <br /><br /><br/>
        <script type="text/javascript">
            Desktop.window.list['{$window_id}']._scroll(true);
        </script>
