<input type='hidden' id='num_of_subs' value='0' />
<div>
    Please Select the IPA you want to add subgroups to:
    <div> 
        
        
            <select class="form-field" style="width: 500px" name="ipa_box" id="ipa_box-{$window_id}" onchange="showsubs()">
                <option value=''>Please Select a Value</option>
                {foreach from=$finder->createmainipatable() item=client}
                    {if $client.ipa_name!='Other'}
                    <option value="{$client.ipa_id}">{$client.ipa_name}</option>
                    {/if}
                {/foreach}

            </select>
    </div> 
    
    
    <br>
    <div id='subvalsec'>
        <!-- show other sub values here -->
        
        
    </div>
    <hr>
    <br>
    Please input the sub-groups you would like to add to the selected IPA
    <br>
    Sub1: <input type="text" id="ipasub1"  name="ipasub1" value="">
    <br>
    Sub2: <input type="text" id="ipasub2"  name="ipasub2" value="">
    <br>
    Sub3: <input type="text" id="ipasub3"  name="ipasub3" value="">
    <br>
    Sub4: <input type="text" id="ipasub4"  name="ipasub4" value="">
    <br>
    Sub5: <input type="text" id="ipasub5"  name="ipasub5" value="">
    <br>
    
    
    <input type="button" id="SubBtn" Value="   Add Values   "  onclick="subber()">
    <input type="button" id="closebtn" Value="   Close   "  onclick="closetest()">
    <!-- <input type="button" id="closebtn" Value="   testtest   "  onclick="testtest()"> -->
    
</div>
<div id="oklahoma"></div>



<script type='text/javascript'>

function testtest(){
//console.log('peanut');
//    console.log($("input#num_of_subs").val());
}



function showsubs(){
    
    jQuery('#subvalsec').html('');
    $("input#num_of_subs").val(0);
    
    
    var testval= $("#ipa_box-{$window_id}").val();
    
    if(testval && testval!=''){
        
        /////////////////////////////////////////
        
        
        
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
  

        
        
        
        
        
        
        
    }
}


function subber(){
     //get ipa val from drop down
    var testval= $("#ipa_box-{$window_id}").val();
    
    //if not testval
    if(testval && testval!=''){
        
        
       
        
        //pull max subs in ipa val from hidden value
        var ipasubcount=$("input#num_of_subs").val();
        
        //get total count of subs 
        
        
        
        
        
        var bbb= jQuery.ajax({
            type: "GET",
            url: '/vision/consultation/getipasubcount',
            dataType: 'json',
            data: { },
            success: function (obj, textstatus) {
                var submax=0;
                //number of total sub
                submax=obj[0].theamount-1;  
        
        
        
        
                

                
                var subval=document.getElementById("ipasub1").value;

                if(subval.trim()!=''){
                    ipasubcount=parseInt(ipasubcount)+1;
                    submax=parseInt(submax)+1;
                    makesubbers(subval.trim(), testval, ipasubcount, submax);

                }

                subval=document.getElementById("ipasub2").value;
                if(subval.trim()!=''){
                    ipasubcount=parseInt(ipasubcount)+1;
                    submax=parseInt(submax)+1;
                    makesubbers(subval.trim(), testval, ipasubcount, submax);

                }


                subval=document.getElementById("ipasub3").value;
                if(subval.trim()!=''){
                    ipasubcount=parseInt(ipasubcount)+1;
                    submax=parseInt(submax)+1;
                    makesubbers(subval.trim(), testval, ipasubcount, submax);

                }


                subval=document.getElementById("ipasub4").value;
                if(subval.trim()!=''){
                    ipasubcount=parseInt(ipasubcount)+1;
                    submax=parseInt(submax)+1;
                    makesubbers(subval.trim(), testval, ipasubcount, submax);

                }


                subval=document.getElementById("ipasub5").value;
                if(subval.trim()!=''){
                    ipasubcount=parseInt(ipasubcount)+1;
                    submax=parseInt(submax)+1;
                    makesubbers(subval.trim(), testval, ipasubcount, submax);

                }
showsubs();

                //
                document.getElementById("ipasub1").value='';
                document.getElementById("ipasub2").value='';
                document.getElementById("ipasub3").value='';
                document.getElementById("ipasub4").value='';
                document.getElementById("ipasub5").value='';
                
                
                var xyz=Pagination.get('subipa');
                
                var zzz=parseInt(xyz.pages.current);
                
                Argus.vision.refresh($E('ipasubtable'),'subipa',zzz,13);
                /**/
            }

        });
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    

}

function closetest(){
    Desktop.window.list['{$window_id}']._close();
    
    
}

//makesubbers(subval.trim(), themax, numup, submax);
function makesubbers(subname, parentid, suborder, subid){

    
    
    var bo;
    bo=  new EasyAjax('/hedis/configuration/savesub');

  

    bo.add('sub_name', subname); 

    bo.add('ipa_parent_id', parentid); 
    bo.add('sub_order_id',suborder);
    bo.add('is_enabled',1);        
    bo.add('sub_id', subid);
    bo.then(function (response) { 
    
        //close window
       // Desktop.window.list['{$window_id}']._close();
   
   
        //refresh table
        
        
        
    
    }).post();



}




</script>