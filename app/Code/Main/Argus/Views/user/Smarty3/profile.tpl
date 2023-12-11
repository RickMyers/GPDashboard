{assign var=appl value=$appellation->load(true)}
<style type="text/css">
    .argus-settings-form-field-description {
        letter-spacing: 2px; font-size: .9; color: white; font-family: sans-serif;
    }
    .argus-settings-field {
         margin-right: 15px; margin-bottom: 20px
    }
    .argus-settings-form-field {
        color: #333; background-color: lightcyan; border: 1px solid #aaf
    }
    .change-password-field-area {
    }
    .change-password-field-desc {
        padding-bottom: 15px; font-size: .9em; letter-spacing: 1px
    }
</style>
<hr style='opacity: .4' />
<div>
    <div style="float: right; font-size: .9em;"><span style="cursor: pointer" onclick="Argus.dashboard.home()">home</span> | <span onclick="Argus.help.home()" style="cursor: pointer">help</span></div><div style='font-size: 1.2em; float: left;'><i class="glyphicons glyphicons-cogwheel" style="color: ghostwhite"></i> SETTINGS</div>
    <div style="margin-left: auto; margin-right: auto; width: 200px; ">
        User ID: {$login->getUserName()|strtoupper}
    </div>
</div>
<hr style='opacity: .4' />
<table><tr><td>
<div style="width: 600px;  padding: 10px; display: inline-block; ">
<form name="argus-settings-form" id="argus-settings-form">
    <input type="hidden" name='id' id='id' value='{$user->getId()}' />
    <input type="hidden" name='background_id' id='background_id' value='{$settings->getBackgroundId()}' />
    <input type="hidden" name='background_image' id='background_image' value='{$settings->getBackgroundImage()}' />
    <table><tr>
            <td><img src='/images/argus/avatars/{$user->getId()}.jpg' onerror='this.src="/images/argus/placeholder-{$user->getGender()}.png"' height='120' /></td>
            <td>
                <div class='argus-settings-field' style="float: left; margin-left: 30px; margin-bottom: 5px">
                    <input class='argus-settings-form-field' type="file" name="photo" id='photo' placeholder="New Photo" />
                    <div class="argus-settings-form-field-description">
                        User Photo
                    </div>
                </div>
            </td>
        </tr></table>
    <br/>
    <div class='argus-settings-field' style="float: left">
        <input class="argus-settings-form-field" type="text" name="email" id='email' value="{$login->getEmail()}" placeholder="E-Mail Address" />
        <div class="argus-settings-form-field-description">
            E-Mail Address
        </div>
    </div>
    <div style="clear: both"></div>
    <div class='argus-settings-field' style="float: left; margin-right: 10px">
        <select class='argus-settings-form-field' name="appellation_id" id='appellation_id' >
            <option value=''></option>
            {foreach from=$appellations->fetch() item=appellation}
                <option value='{$appellation.id}'>{$appellation.appellation}</option>
            {/foreach}
        </select>
        <div class="argus-settings-form-field-description">
            Title
        </div>
    </div>
    <div class='argus-settings-field' style="float: left">
        <input class='argus-settings-form-field' type="text" name="first_name" id='first_name' value="{$user->getFirstName()}" placeholder="First Name" />
        <div class="argus-settings-form-field-description">
            First Name
        </div>
    </div>
    <div class='argus-settings-field' style="float: left">
        <input class="argus-settings-form-field" type="text" name="last_name" id="last_name" value="{$user->getLastName()}" placeholder="Last Name" />
        <div class="argus-settings-form-field-description">
            Last Name
        </div>
    </div>
    <div class='argus-settings-field' style="float: left">
        <select class="argus-settings-form-field" name="gender" id="gender" value="{$user->getGender()}" >
            <option value=''></option>
            <option value='M'> Male </option>
            <option value='F'> Female </option>
        </select>
        <div class="argus-settings-form-field-description">
            Gender
        </div>
    </div>
    <div style="clear: both"></div>
    
    {if (($roles->userHasRole('O.D.')) || ($roles->userHasRole('Primary Care Physician')))}
    <div class='argus-settings-field' style="">
        <select class="argus-settings-form-field" name="credential" id="credential" value="{$user->getCredential()}" >
            <option value=''></option>
            <option value='OD'> OD </option>
            <option value='MD'> MD </option>
        </select>
        <div class="argus-settings-form-field-description">
            Provider Credential
        </div>
    </div>    
    {/if}
    
    <div class='argus-settings-field' style="float: left">
        <input class="argus-settings-form-field" type="text" name="preferred_name" id="preferred_name" value="{$user->getPreferredName()}" placeholder="Preferred Name" />
        <div class="argus-settings-form-field-description">
            Preferred Name
        </div>
    </div>
    <div class='argus-settings-field' style="float: left">
        <input class="argus-settings-form-field" type="checkbox" name="use_preferred_name" id="use_preferred_name"{if ($user->getUsePreferredName() == 'Y')}checked{/if} value="Y" />
        <span class="argus-settings-form-field-description">
            Use Preferred Name
        </span>
    </div>
    <div style="clear: both"></div>
    <div class='argus-settings-field' style="float: left">
        <input class="argus-settings-form-field" type="text" name="maiden_name" id="maiden_name" value="{$user->getMaidenName()}" placeholder="Maiden Name" />
        <div class="argus-settings-form-field-description">
            Maiden Name
        </div>
    </div>
    <div class='argus-settings-field' style="float: left">
        <input class="argus-settings-form-field" type="text" name="date_of_birth" id="date_of_birth" value="{$user->getDateOfBirth()}" placeholder="YYYY-MM-DD" />
        <div class="argus-settings-form-field-description">
            Date Of Birth
        </div>
    </div>
    <div style="clear: both"></div>
    <div class='argus-settings-field' style="float: left">
        <input type="checkbox" name="transparent_windows" id="transparent_windows" value="Y" {if ($settings->getTransparentWindows() == "Y")}checked{/if} />
        Use Transparent Windows
    </div>        
    <div style="clear: both"></div>
    {if ($roles->userHasRole('Tele Hygienist'))}
        <div style="padding: 10px 0px; border-top: 1px solid ghostwhite">
           <p>As a Tele-Hygienist you can provide a name for your virtual waiting room.  If you do not specify one, your name will be used</p><br />
            Waiting Room Name: <input class="argus-settings-form-field" type="text" style="color: #333" name="waiting_room_name" id="waiting_room_name" value="{$settings->getWaitingRoomName()}" />
        </div>
    {else}
       <input type="hidden" name="waiting_room_name" id="waiting_room_name" value="{$settings->getWaitingRoomName()}" />
    {/if}
    {if ($roles->userHasRole('Market Level'))}
    <div style="clear: both"></div>        
        <div style="padding: 10px 0px; border-top: 1px solid ghostwhite">
           <p>As a Market Level administrator, please choose the applicable market from the choice below:</p><br />
           <select name="market_level" id="market_level" style="width: 200px; background-color: lightcyan; border: 1px solid #333; padding: 2px">
               <option value=""></option>
               <option value="111"> CarePlus </option>
           </select>
        </div>
        {if ($settings->getMarketLevel())}
            <script type="text/javascript">
                $('#market_level').val('{$settings->getMarketLevel()}');
            </script>
        {/if}
    {/if}
    {if ($roles->userHasRole('O.D.'))}
        <div style="padding-bottom: 5px; padding-top: 5px; border-top: 1px solid ghostwhite"><b>Claiming Information</b><br /><br />
            If you are providing services that can be claimed, please fill out the following information so that we can generate the claim files for you:<br /><br />
            <table>
                <tr>
                    <td align="right" style="padding-right: 2px">
                        NPI: 
                    </td>
                    <td>
                        <input type="text" name="npi" id="npi" value="{$user->getNpi()}" class="argus-settings-form-field"/>
                    </td>
                </tr>
                <tr>
                    <td align="right" style="padding-right: 2px">
                        License #: 
                    </td>
                    <td>
                        <input type="text" name="license_number" id="license_number" value="{$user->getLicenseNumber()}"  class="argus-settings-form-field" />
                    </td>                    
                </tr>
            </table>
            <br />
            Office Address
            <table>
                <tr>
                    <td style="padding-right: 2px"><input type="text" value="{$user->getOfficeAddress()}" name="office_address" id="office_address" class="argus-settings-form-field" style="width: 250px" /></td>
                    <td style="padding-right: 2px"><input type="text" value="{$user->getOfficeCity()}"    name="office_city"    id="office_city" value="" class="argus-settings-form-field" style="width: 100px"  /></td>
                    <td style="padding-right: 2px"><input type="text" value="{$user->getOfficeState()}"   name="office_state"   id="office_state" value="" class="argus-settings-form-field" style="width: 50px; text-transform: uppercase"  /></td>
                    <td style="padding-right: 2px"><input type="text" value="{$user->getOfficeZipcode()}" name="office_zipcode" id="office_zipcode" value="" class="argus-settings-form-field" style="width: 100px"  /></td>
                </tr>
                <tr>
                    <td>Street</td>
                    <td>City</td>
                    <td>State</td>
                    <td>Zip Code</td>
                </tr>
                
            </table>
            <br /><br />
        </div>
    {/if}
    {if ($roles->userHasRole('Pin (4-Digit)'))}
        {assign var=junk value=$pins->load(true)}
        <div style="padding-bottom: 5px; padding-top: 5px; border-top: 1px solid ghostwhite">
            To be able to sign electronic documents, a valid PIN has to be established. <br /><br />
            Status:&nbsp;
            {if ($pins->getPin())}
                <u style="color: green">You have a valid pin established, no action required</u><br /><br />
            {else}
                <u style="color: red">You need to establish a PIN below</u><br /><br />
            {/if}
            To establish or change your PIN, please enter a PIN # below:<br /><br />
            Pin (4-Digit): <input style="" placeholder="####" maxlength="4" type="text" name="user_pin" id="user_pin" value="" /><br /><br />
        </div>
    {else if ($roles->userHasRole('Pin (6-Digit)'))}
        {assign var=junk value=$pins->load(true)}
        <div style="padding-bottom: 5px; padding-top: 10px;  border-top: 1px solid ghostwhite">
            To be able to sign electronic documents, a valid PIN has to be established. <br /><br />
            Status:&nbsp;
            {if ($pins->getPin())}
                <u style="color: green">You have a valid pin established, no action required</u><br /><br />
            {else}
                <u style="color: red">You need to establish a PIN below</u><br /><br />
            {/if}
            To establish or change your PIN, please enter a PIN # below:<br /><br />
            Pin (6-Digit): <input style="" placeholder="######" maxlength="6" type="text" name="user_pin" id="user_pin" value="" /><br /><br />
        </div>
    {else}
        <input style="" type="hidden" name="user_pin" id="user_pin" value="" />
    {/if}
    {if ($roles->userHasRole('Webservice Access'))}
        <div style="clear: both; margin-bottom: 50px">
            <hr /><b>API Alternative Authentication</b><br /><br />
                As an alternative to accessing the Webservices API with your username and password to retrieve a session token, you may also use the API User ID below, and a
                generated API key in place of your password.<br /><br />
                Click the 'Generate' button to create an API key to use in place of your password when logging in.<br /><br />
                {assign var=api_user value=10980-$user->getId()}
                API User ID: <u><b>{$api_user}</b></u><br />
                <input type="text" name="api_key" id="api_key" class="argus-settings-form-field" value='{$user->getApiKey()}' style="width: 300px; font-family: monospace; font-size: .95em; letter-spacing: 1px" /> <input type='button' value=' Generate Key ' style='color: #333' id='api_generate_key'/>
            <hr />
        </div>
    {/if}
    <div class='argus-settings-field' style="float: left">
        <input class="argus-settings-form-field" type="button" name="settings-submit" id="settings-submit" value="  SAVE  " />
    </div>
    <div style="clear: both"></div>
</form>
</div>
        </td>
        <td valign="top">
<div style="width: 250px; border: 1px solid rgba(202,202,202,.5); border-radius: 10xp; display: inline-block; margin-left: 10px; padding: 5px; ">
    <form name="argus-password-reset-form" id="argus-password-reset-form">
        <h5>Change Password Form</h5>
            <div class="change-password-field-area">
                <input type="password" name="argus_current_password" id="argus_current_password" autocomplete="off"/>
            </div>
            <div class="change-password-field-desc">
                Current Password
            </div>
            <div class="change-password-field-area">
                <input type="password" name="argus_new_password" id="argus_new_password" autocomplete="off"/>
            </div>
            <div class="change-password-field-desc">
                New Password
            </div>
            <div class="change-password-field-area">
                <input type="password" name="argus_confirm_password" id="argus_confirm_password" autocomplete="off"/>
            </div>
            <div class="change-password-field-desc">
                Confirm New Password
            </div>
            <div class="change-password-field-area">
                <input type="button" value="change" onclick="return false" id="password-change-button" />
            </div>
    </form>

</div>  
    </td>
    <td valign="top">
        <div style="width: 200px; border: 1px solid rgba(202,202,202,.5); border-radius: 10xp; display: inline-block; margin-left: 10px; padding: 10px; text-align: center">
        Available Backgrounds
        <hr />
        {foreach from=$backgrounds->fetch() item=background}
            <div style="border: 1px solid #bbb; margin-bottom: 5px; cursor: pointer" id="background_{$background.id}" onclick="Argus.dashboard.background.select({$background.id},'{$background.background}')">
                <img src="/images/dashboard/backgrounds/{$background.background}" style="height: 60px; width: 100%" />
            </div>
        {/foreach}
        </div>            
        </td></tr></table>
<script type="text/javascript">
    {if ($appl && (isset($appl.appellation_id)))}
        $('#appellation_id').val('{$appl.appellation_id}');
    {/if}
    $('#gender').val('{$user->getGender()}');
    $('#credential').val('{$user->getCredential()}');
    (new EasyEdits('/edits/argus/profile','argus-user-settings')).setValue('state','{$user->getState()}');
    (new EasyEdits('/edits/argus/password','argus-user-password'));
    Argus.dashboard.background.init();
    $('#api_generate_key').on('click',function (evt) {
        var tokens = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-';
        var key = '';
        for (var i=0; i<32; i++) {
            key += ''+tokens.substr(Math.round(tokens.length*Math.random()),1);
        }
        $('#api_key').val(key);
    });
</script>