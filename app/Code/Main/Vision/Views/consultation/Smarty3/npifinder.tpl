


<div>
    <input type="hidden" name="winid" id='winid' value='' />
    
    <div style=" font-size: 15px; padding-top: 20px; text-align: center">
    Please select a location:
    </div>
    <br>
    <div id='locations'>
       <!-- <ul>-->
       
        <div>
            <table style="width:100%; padding-left: 50px; padding-right: 50px">
                <tr>
                    <td style="width:75px">
                        Event #
                    </td>
                    <td style="width:75px">
                        Group Event
                    </td>
                    <td style="width:250px">
                        Buisness Name
                    </td>
                    
                    <td style="width:250px">
                        Event Location
                    </td>
                    <td style="width:75px">
                        Event Date
                    </td>
<!--

                    <td style="width:75px">
                        Group Event
                    </td>

                    <td style="width:75px">
                        Screening/Scanning
                    </td>

                    <td style="width:75px">
                        Location NPI#
                    </td>
-->


                </tr>

            </table>
        </div>
       
       
       
       
       
       
        {foreach from=$schnpifinder->npifind() item=npiitem}
            
            
<!--            
            <li style="background-color: rgba(202,202,202,{cycle values=".15,.3"}); padding-bottom: 3px; font-size: 1.2em">
                <a href="#" id='adr-{$npiitem.id}' onclick='shiplocationtwo({$npiitem.id})'>{$npiitem.address}</a>
            <div style="float: right; margin-right: 5px; padding-right: 20px" id='date-{$npiitem.id}' value='{$npiitem.date}'> {$npiitem.date}</div>
            </li>
    -->        
     <div onclick='getvalues( "{$npiitem.id}"   )' style='cursor: pointer; '> 
          
                <table style="width:100%">
                    <tr>
                        
                        
                        <td style="width:75px">
                            {$npiitem.event_id}
                        </td>
                        
                        <td style="width:75px">
                        {$npiitem.health_plan}
                    </td>
                        
                        
                        
                        <td style="width:250px">
                            {$npiitem.location_id}                            
                        </td>
                        
                        <td style="width:250px">
                            {$npiitem.address}                            
                        </td>
                        
                        <td style="width:75px">
                            {$npiitem.date}                            
                        </td>
                        
                        <!--npiitem.grouper-->
                        <!--npiitem.eventtype-->
                        <!--
                        <td style="width:75px">
                            TheGroup
                        </td>
                        
                        
                        
                        
                        <td style="width:75px">
                            ScreenorScan
                        </td>
                        
                        
                        
                        <td style="width:75px">
                            $npiitem.npi_id
                        </td>
                        -->
                        
                        
                        
                    </tr>
                    
                    
                </table>
                
            </div>
                
            
        {/foreach}
        <!--</ul>-->
        
        
        
        
    </div>
    
    
    
 
    
</div>
<div id="oklahoma"></div>


<script type='text/javascript'>
    
    
    
    
    function getvalues(theid){
    console.log(theid);
    
    
    
    
    
            
    
    
    
    
        var ccc= jQuery.ajax({
            type: "GET",
            url: '/vision/consultation/spnpifind',
            dataType: 'json',
            responseType: 'text',
            data: ({  theid: theid}),
            success: function (obj, textstatus) {
                console.log('ardvark');
                //wayorder=order2
                try{
                    
                    var id2=obj[0].id;
                    //send info to other page
                    var b = $('#address_id');
                    if(b){

                       b.val(obj[0].address).change();
                    }

                    var c = $('#event_date');
                    if(c){

                       c.val(obj[0].date).change();
                    }
                    //label->need to change way is done
                    var d = $('#event_id');
                    if(d){
                       d.val(obj[0].event_id).change();                        
                    }

                    var f = $('#screening_client_combo');
                    if(f){  
                        console.log('aruba '+obj[0].health_plan);
                      if(obj[0].health_plan){                              
                        var clientval=(obj[0].health_plan).toString();//.includes('other');
                        //var uppclient=clientval.toUpperCase();   
                        f.val(clientval).change(); 
                        //do for text as well?
                        //$('#screening_client_text').val(clientval).change();
                        
                        //not sure to put in -> check with rick on how it works with legacy files
                        /*
                        if( uppclient.includes('OTHER') ){
                            f.val('Other').change();
                            $('#screening_client_other').val(obj[0].health_plan).change();
                        }
                        else{
                          f.val(obj[0].health_plan).change();
                        }
                        */
                      }   
                      else{
                        f.val('').change();
                      }
                    }
                    
                    
                    //radio btn's
                        if(obj[0].scanorscreen){
                            var btnname='';
                            if( (obj[0].scanorscreen).toString().toUpperCase()=='SCREEN'){
                                btnname='form_type_screening';
                            }
                            else{
                                btnname='form_type_scranning';
                            }
                            radiobtn = document.getElementById(btnname);
                            radiobtn.checked = true;
                            $('#'+btnname).trigger('change');
                            
                        }
                        else{
                            $('#form_type_scranning').trigger('change');
                        }
                    
                    
                    
                    
                    
                    
                    
                }
                catch(err){
                }



            },
            error: function(XMLHttpRequest, textStatus, errorThrown) { 
                console.log(errorThrown);
                    //alert("Status: " + textStatus); alert("Error: " + errorThrown); 
                }       

        });
        /**/
    
       console.log('umbrella');
        var xxx=Desktop.whoami('oklahoma');

        Desktop.window.list[xxx]._close();
    }
    
    
    //old need to remove
    //change to id
    function shiplocation( thenpi, theaddress, thedate, theevid, scrorscan){
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        var a = $('#npi_id-{$window_id}');
        if(a){
            
          a.val(thenpi).change();
        }
        
        
        //send info to other page
        var b = $('#address_id-{$window_id}');
        if(b){
            
           b.val(theaddress).change();
        }
        
        var c = $('#event_date-{$window_id}');
        if(c){
            
           c.val(thedate).change();
        }
        
        var d = $('#event_id-{$window_id}');
        if(d){
            
           d.text(theevid).change();
           d.val(theevid).trigger('change');
           //$('#event_id-$window_id}')
           //add method saver here to save event id to form (see modular on new)
           
           
           /*
            
        var ccc= jQuery.ajax({
                    type: "GET",
                    url: '/vision/consultation/getorderipasub',
                    dataType: 'json',
                    responseType: 'text',
                    data: { selectedorder: '', theparent: testval},
                    success: function (obj, textstatus) {
                        
                        $("input#num_of_subs").val(obj.length);
                        if(obj.length>1){    
                        // get all values of current sub
                            $( "#subvalsec" ).append('<div><label id="Test1">Current Subgroups for selected IPA are:</label>');
                            $( "#subvalsec" ).append('<div id="winwin" style="overflow-y:scroll; height:100px">');
                            for(i=0;i<obj.length;i++){
                                if(obj[i].sub_name!=''){
                                    var idval='LI'+i;
                                    $( "#winwin" ).append('<div><label id="'+idval+'">'+i+':  '+obj[i].sub_name+'</label></div>');
                                }

                            }
                            $( "#subvalsec" ).append('</div>');
                        }
                        else{
                            $( "#subvalsec" ).append('<div><label id="Test1">There are no current subgroups for this IPA</label>');
        
                        }


                        $( "#subvalsec" ).append('</div>');
                        
                        
                        
                    },    
                    error: function(XMLHttpRequest, textStatus, errorThrown) { 
                            alert("Status: " + textStatus); alert("Error: " + errorThrown); 
                        }       

                });
            
            */
           
           
           
           
        }
    
    //scrorscan
        if(scrorscan=="Screening"){
            //form_type_screening
            radiobtn = document.getElementById("form_type_screening-{$window_id}");
            radiobtn.checked = true;
            //radiobtn.trigger('change');
            $('#form_type_screening-{$window_id}').trigger('change');
        }
        else if(scrorscan=="Scanning"){
        //form_type_scranning
            radiobtn = document.getElementById("form_type_scranning-{$window_id}");
            radiobtn.checked = true;
            //radiobtn.trigger('change');
            $('#form_type_scranning-{$window_id}').trigger('change');
        }
    
    
    
    //Desktop.window.list['']._close();
    
    
    
        var xxx=Desktop.whoami('oklahoma');

        Desktop.window.list[xxx]._close();
    }



</script>