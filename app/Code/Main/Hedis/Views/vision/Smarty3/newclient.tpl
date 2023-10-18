<table style="width: 100%; height: 100%">
    <tr>
        <td>
            <div style="position: relative; margin-left: auto; margin-right: auto; padding: 10px; border-radius: 10px; background-color: ghostwhite; color: #333; width: 600px;">
                <form name="new_client_form" id="new_client_form" onclick="return false">
                    <br />
                    
                    New Client Name: <input type="text" name="client_name" id="new_client_name" value="" /><br /><br /><br />
                    <button style="position: absolute; right: 5px; bottom: 5px" id="new_client_name_submit" onclick="$('#desktop-lightbox').css('display','none')">&nbsp;Save&nbsp;</button>
                    <button style="position: absolute; left:  5px; bottom: 5px" onclick="$('#desktop-lightbox').css('display','none')">Cancel</button>
                </form>
            </div>
        </td>
    </tr>
</table>
<script type="text/javascript">
    new EasyEdits('/edits/vision/newclient','vision-new-client');
</script>
                        
