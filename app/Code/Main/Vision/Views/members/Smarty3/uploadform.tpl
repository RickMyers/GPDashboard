<style type="text/css">
    .vision-upload-desc {
        padding-bottom: 10px; font-family: monospace; color: #333; font-size: 1em
    }
</style>
<table style="width: 100%; height: 100%;">
    <tr>
        <td>
            <div style="width: 740px; margin-left: auto; margin-right: auto; padding: 20px;">
                <form name="vision-member-upload-form" id="vision-member-upload-form" onsubmit="return false;">
                <fieldset style="padding: 10px"><legend>Vision Event Member Upload</legend>
                    <input type="text" name="event_date" id="event_date" value="" /><br />
                    <div class="vision-upload-desc">
                        Event Date
                    </div>                   
                    <input type="text" name="office_name" id="office_name" value="" /><br />
                    <div class="vision-upload-desc">
                        Office Name
                    </div>
                    <input type="text" name="office_address" id="office_address" value="" /><br />
                    <div class="vision-upload-desc">
                        Office Address
                    </div>
                    <input type="file" name="vision_member_data" id="vision_member_data" />
                    <div class="vision-upload-desc">
                        Member List (CSV format)
                    </div><br />
                    <input type="button" value=" Upload " id="vision_upload_submit" />
                </fieldset>
            </div>
        </td>
    </tr>
</table>
<script type="text/javascript">
    
    
    new EasyEdits('/edits/vision/memberupload','vision-member-upload');
    $('#event_date').datepicker();
    
    
    
    
    var clickedondate=false;
    
    
    
    $( "#event_date" ).click(function( event ) {
            
            clickedondate=true;
        });
    
    $( "#vision-member-upload-form" ).click(function( event ) {
        
        
        $( "#event_date" ).click(function( event ) {
            
            clickedondate=true;
        });
        
        
        
        
    
        
        
        var ele = $(event.toElement);
        
        
        if (!ele.hasClass("hasDatepicker") && !ele.hasClass("ui-datepicker") && !ele.hasClass("ui-icon") && !$(ele).parent().parents(".ui-datepicker").length){
            //check if datepicker is open(?)
            var id=this.id;
            if($("#event_date").datepicker( "widget" ).is(":visible")){
                if( $(this).is('#event_date')){
            //        console.log('lammalammadingdong');
            
                }
                
                
                if(!clickedondate){
                    $(".hasDatepicker").datepicker("hide");  
                }
                
            }
            
            
            
        }
        clickedondate=false;
    });
    
    
</script>