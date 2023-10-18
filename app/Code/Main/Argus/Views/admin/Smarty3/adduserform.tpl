<style type='text/css'>

    .new-user-field {
        margin-left: 30px;
    }
    .new-user-field-desc {
        margin-left: 30px; font-size: 1.1em; font-family: monospace; letter-spacing: 1px; margin-bottom: 15px;
    }
    .new-user-field-entry {
        padding: 2px; border: 1px solid #aaf; border-radius: 2px; font-size: 1.2em
    }
</style>
<div id='add-user-form-layer-{$window_id}'>
    <form name="argus-new-user-form" id="argus-new-user-form-{$window_id}" onsubmit="return false">
        <br /><br />
        <fieldset style="padding: 20px"><legend style="font-family: sans-serif; font-weight: bold; color: #333">
                New User Form Instructions</legend>
            Below are the minimum fields required to add a person.  An e-mail will be generated and sent to the person
            identified below informing them of their account and their default password, which they will have to change.
            <br /><br />
            <div class="new-user-field">
                <input type="text" name="first_name" id="first_name-{$window_id}" class="new-user-field-entry" />
            </div>
            <div class="new-user-field-desc">
                First Name
            </div>
            <div class="new-user-field">
                <input type="text" name="last_name" id="last_name-{$window_id}" class="new-user-field-entry" />
            </div>
            <div class="new-user-field-desc">
                Last Name
            </div>
            <div class="new-user-field">
                <input type="text" name="email" id="email-{$window_id}" class="new-user-field-entry" />
            </div>
            <div class="new-user-field-desc">
                E-mail Address
            </div>
            <div class="new-user-field">
                <select name="gender" id="gender-{$window_id}"  class="new-user-field-entry">
                    <option value=""></option>
                    <option value="M"> Male </option>
                    <option value="F"> Female </option>
                </select>
            </div>
            <div class="new-user-field-desc">
                Gender
            </div>
            <br />
            <div class="new-user-field">
                <input value="Add User" type="button" name="new-user-submit" id="new-user-submit-{$window_id}" class="blueButton" style="padding: 5px 10px; font-size: 1em" />
            </div>
        </fieldset>
    </form>
</div>
<script type="text/javascript">
    var ee = new EasyEdits(null,"argus-new-user-{$window_id}");
    ee.fetch("/edits/argus/newuser");
    ee.process(ee.getJSON().replace(/&&win_id&&/g,'{$window_id}'));
</script>