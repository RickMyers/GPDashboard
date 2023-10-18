


<div>
    <input type="hidden" name="winid" id='winid' value='' />
    
    <div style=" font-size: 15px; padding-top: 20px; text-align: center">
    Please select a location:
    
    
    </div>
    Search: <input type="text" style="width: 100px" name="searchfield" id="searchfield" />
    <br>
    <div id='locations'>
       <!-- <ul>-->
       
        <div>
            <table style="width:100%; padding-left: 50px; padding-right: 50px">
                <tr>
                    
                    <td style="width:250px">
                        <B>Member Name</B>
                    </td>
                    <td style="width:100px">
                        <B>Member ID</B>
                    </td>
                    <td style="width:75px">
                        <B>Date of Birth</B>
                    </td>
                    
                    <td style="width:75px">
                        <B>Gender</B>
                    </td>
                    
                    <td style="width:250px">
                        <B>Members Address</B>
                    </td>
                    
                    <td style="width:100px">
                        <B>Healthcare Group</B>
                    </td>
                    



                </tr>

            </table>
        </div>
       
       
       
       
       <div id="peopletable">
       
        {foreach from=$peoplefinder->peoplefind() item=npiitem}

            <div onclick='shiplocation( "{$npiitem.id}")' style='cursor: pointer; '>
                <table style="width:100%">
                    <tr>
                        
                        
                        
                        <td style="width:250px">
                            {$npiitem.member_name}
                        </td>
                        <td style="width:100px">
                            {$npiitem.member_number}  
                        </td>
                        <td style="width:75px">
                            {$npiitem.date_of_birth}  
                        </td>

                        <td style="width:75px">
                            {$npiitem.gender}  
                        </td>
                       
                        <td style="width:250px">
                           {$npiitem.address}
                            
                        </td>
                        <td style="width:100px">
                           {$npiitem.client}
                            
                        </td>
                        
                        
                        
                        
                        
                        
                        
                        
                    </tr>
                    
                    
                </table>
                
            </div>
                
            
        {/foreach}
        
        
        </div>
        
        
    </div>
    
    
    
 
    
</div>
<div id="oklahoma"></div>


<script type='text/javascript'>
    
    
    
    function julie(){
        
        console.log('dothething');
        
    }
    
    function shiplocation( theid ){
        
       
    
    
    
    
    
    
    
    
    
        var ccc= jQuery.ajax({
                type: "GET",
                url: '/vision/consultation/personfinder',
                dataType: 'json',
                responseType: 'text',
                data: ({  theid: theid}),
                success: function (obj, textstatus) {
                    //wayorder=order2
                    try{
                        var id2=obj[0].id;
                        
                        


                        var a = $('#member_name');
                        if(a){                                       
                          a.val(obj[0].member_name).change();                          
                        }
                        
                        var b = $('#member_id');
                        if(b){            
                          b.val(obj[0].member_number).change();
                        }
                        
                        var c = $('#member_address');
                        if(c){            
                          c.val(obj[0].address).change();
                        }
                    
                        var d = $('#date_of_birth');
                        if(d){                                                            
                          d.val(obj[0].date_of_birth).change();
                        }
                    var e = $('#gender');
                        if(e){            
                          e.val(obj[0].gender).change();
                        }
                     
                        
                        
                        
                        console.log('fbs: '+obj[0].fbs);
                        
                        var g = $('#fbs');
                        if(g){                               
                             if(obj[0].fbs){
                                 g.val(obj[0].fbs).change();
                             }
                        }
                        
                        
                        var h = $('#hba1c');
                        if(h){   
                             if(obj[0].hba1c){
                                 h.val(obj[0].hba1c).change();
                             }
                        }
                        //type years
                        var i = $('#type_yrs');
                        if(i){   
                             if(obj[0].number_of_years){
                                 i.val(obj[0].number_of_years).change();
                             }
                             else{
                                 i.val('').change();
                             }
                        }
                        //bmi
                        var j = $('#bmi');
                        if(j){   
                             if(obj[0].bmi){
                                 j.val(obj[0].bmi).change();
                             }
                        }


                        var k = $('#fbs_date');
                        if(k){   
                             if(obj[0].fbs_date){
                                 k.val(obj[0].fbs_date).change();
                             }
                        }
                        
                        
                        var l = $('#hba1c_date');
                        if(l){   
                             if(obj[0].hba1c_date){
                                 l.val(obj[0].hba1c_date).change();
                             }
                        }

console.log('controlled: '+obj[0].controlled);

                        //radio btn's
                        if(obj[0].diabetes_status){
                            var btnname='';
                            if( (obj[0].diabetes_status).toString().toUpperCase()=='CONTROLLED'){
                                btnname='dm_alltype_controlled';
                            }
                            else if( (obj[0].diabetes_status).toString().toUpperCase()=='UNCONTROLLED'){
                                btnname='dm_alltype_uncontrolled';                                
                            }
                            else{
                                btnname='dm_alltype_unknown';
                            }
                            radiobtn = document.getElementById(btnname);
                            radiobtn.checked = true;
                            $('#'+btnname).trigger('change');
                            
                        }
                        


                        
                        if(obj[0].diabetes_type){
                            var btnname='';
                            if( (obj[0].diabetes_type).toString().toUpperCase()=='Type1' || (obj[0].diabetes_type).toString().toUpperCase()=='Type 1' || (obj[0].diabetes_type).toString().toUpperCase()=='1' ){
                                btnname='type_1diab';
                            }                            
                            else{
                                btnname='type_2diab';
                            }
                            var radiobtn = document.getElementById(btnname);
                            if(radiobtn){
                                radiobtn.checked = true;
                                $('#'+btnname).trigger('change');
                            }
                            
                        }





                        //checkboxes

                        var m=$('#type_oral');
                        if(m){
                            if(obj[0].type_oral){
                                if(obj[0].type_oral=='Y' || obj[0].type_oral=='on'){
                                    document.getElementById("type_oral").checked = true;
                                }
                                else{
                                    document.getElementById("type_oral").checked = false;
                                }                                
                            }
                            else{
                                document.getElementById("type_oral").checked = false;
                            }
                            
                        }





                        var n=$('#type_insulin');
                        if(n){
                            if(obj[0].type_insulin){
                                if(obj[0].type_insulin=='Y' || obj[0].type_insulin=='on'){
                                    document.getElementById("type_insulin").checked = true;
                                }
                                else{
                                    document.getElementById("type_insulin").checked = false;
                                }                                
                            }
                            else{
                                document.getElementById("type_insulin").checked = false;
                            }
                            
                        }

                        
                        
                        
                        var o=$('#type_diet');
                        if(o){
                            if(obj[0].type_diet){
                                if(obj[0].type_diet=='Y' || obj[0].type_diet=='on'){
                                    document.getElementById("type_diet").checked = true;
                                }
                                else{
                                    document.getElementById("type_diet").checked = false;
                                }                                
                            }
                            else{
                                document.getElementById("type_diet").checked = false;
                            }
                            
                        }








                        
                    }
                    catch(err){
                    }



                },
                error: function(XMLHttpRequest, textStatus, errorThrown) { 
                        alert("Status: " + textStatus); alert("Error: " + errorThrown); 
                    }       

            });
    
    
    
    
    
    
        var xxx=Desktop.whoami('oklahoma');

        Desktop.window.list[xxx]._close();
    }

$('#searchfield').on('change',function(){
     var theval= $('#searchfield').val();
     console.log(theval);
     
     
     var ccc= jQuery.ajax({
                type: "GET",
                url: '/vision/consultation/personsearch',
                dataType: 'json',
                responseType: 'text',
                data: ({  searchvalue: theval}),
                success: function (obj, textstatus) {
                    //wayorder=order2
                    try{
                        jQuery('#peopletable').html('');
                        var thelen=obj.length;
                        
                        
                        
                        for(var i=0; i<thelen; i++){
                            var id2=obj[i].id;
                            console.log('the id is : '+obj[i].id);
                            console.log(obj[i].member_name);
                            
                            var thestring="<div onclick='shiplocation("+ obj[i].id + ")' style='cursor: pointer; '><table style='width:100%'><tr> <td style='width:250px'>"+obj[i].member_name+"</td> <td style='width:100px'>"+obj[i].member_number+"</td> <td style='width:75px'>"+obj[i].date_of_birth+"</td> <td style='width:75px'>"+obj[i].gender+"</td> <td style='width:250px'>"+obj[i].address+"</td> <td style='width:100px'>"+obj[i].client+"</td></tr></table> </div>";
                            //shiplocation(obj[i].id)
                        
                        $( "#peopletable" ).append(thestring);
                        
                        
                            //$( "#peopletable" ).append("<div onclick='shiplocation("+ obj[i].id + ")' style='cursor: pointer; '>");
                            //$( "#peopletable" ).append(" <table style='width:100%'><tr>");
                            
                           
                        //    $( "#peopletable" ).append("<td style='width:250px'>"+obj[i].member_name+"</td>");                            
                          //  $( "#peopletable" ).append("<td style='width:100px'>"+obj[i].member_number+"</td>");
                           // $( "#peopletable" ).append("<td style='width:75px'>"+obj[i].date_of_birth+"</td>");
                           // $( "#peopletable" ).append("<td style='width:75px'>"+obj[i].gender+"</td>");
                           // $( "#peopletable" ).append("<td style='width:250px'>"+obj[i].address+"</td>");
                           // $( "#peopletable" ).append("<td style='width:100px'>"+obj[i].client+"</td>");
                            
                            //$( "#peopletable" ).append('</tr></table> </div>');
                            
                            
                            
            
            
            
            
            
            
                        }
                        
                        

                        
                        
                    }
                    catch(err){
                    }



                },
                error: function(XMLHttpRequest, textStatus, errorThrown) { 
                        alert("Status: " + textStatus); alert("Error: " + errorThrown); 
                    }       

            });
            
     
 });

</script>