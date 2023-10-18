<div>
    Please Input the main IPA here
    <br>
    <input type="text" id="ipamain"  name="ipamain" placeholder="Input Main value here" value="" style="width:200px">
    <br>
    
    <hr>
    <br>
    Please input the sub types of the IPA (if applicable) and in the order you would prefer them to appear
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
    
    
    <input type="button" id="SubBtn" Value="   Submit   "  onclick="subber()">
    <input type="button" id="closebtn" Value="   Close   "  onclick="closetest()">
    
</div>
<div id="oklahoma"></div>



<script type='text/javascript'>

function subber(){
    var techmo=0;
    
techmo+=1
    
    var ao;    
    //ao=  new EasyAjax('/hedis/configuration/saveipa');

    ////ao.add('id', id); //not needed
    //ao.add('order_by_num',COUNT(*));  //need way to state in xml
    //ao.add('ipa_id',COUNT(*));  //need way to state in xml
    //ao.add('ipa_name', 
    //
    //ao.then(function (response) { }).post();
    
    //document.getElementById("oklahoma").innerHTML="memememe";

    var themain=document.getElementById("ipamain").value;
    


    var themax=0;

    if(themain.trim()!=''){
        var aaa= jQuery.ajax({
            type: "GET",
            url: '/vision/consultation/getipacount',
            dataType: 'json',
            data: { },
                   success: function (obj, textstatus) {
                       themax=obj[0].theamount;  

                      //write values to ipa here

                      ao=  new EasyAjax('/hedis/configuration/saveipa');


                      
                      ao.add('order_by_num', themax); 
                      ao.add('ipa_id', themax);  //need way to state in xml
                      ao.add('ipa_name', themain);
                      ao.add('is_enabled',1);
                      //
                      ao.then(function (response) { 
                      
                      
                                var bbb= jQuery.ajax({
                                type: "GET",
                                url: '/vision/consultation/getipasubcount',
                                dataType: 'json',
                                data: { },
                                       success: function (obj, textstatus) {
                                           var submax=0;
                                           submax=obj[0].theamount;  
                                           var numup=1;
                                            
                                           makesubbers(' ', themax, numup, submax);
                                           
                                           
                                           var subval=document.getElementById("ipasub1").value;
                                           
                                           if(subval.trim()!=''){
                                               numup=parseInt(numup)+1;
                                               submax=parseInt(submax)+1;
                                               makesubbers(subval.trim(), themax, numup, submax);
                                               
                                           }
                                           
                                           subval=document.getElementById("ipasub2").value;
                                           if(subval.trim()!=''){
                                               numup=parseInt(numup)+1;
                                               submax=parseInt(submax)+1;
                                               makesubbers(subval.trim(), themax, numup, submax);
                                               
                                           }
                                           
                                           
                                           subval=document.getElementById("ipasub3").value;
                                           if(subval.trim()!=''){
                                               numup=parseInt(numup)+1;
                                               submax=parseInt(submax)+1;
                                               makesubbers(subval.trim(), themax, numup, submax);
                                               
                                           }
                                           
                                           
                                           subval=document.getElementById("ipasub4").value;
                                           if(subval.trim()!=''){
                                               numup=parseInt(numup)+1;
                                               submax=parseInt(submax)+1;
                                               makesubbers(subval.trim(), themax, numup, submax);
                                               
                                           }
                                           
                                           
                                           subval=document.getElementById("ipasub5").value;
                                           if(subval.trim()!=''){
                                               numup=parseInt(numup)+1;
                                               submax=parseInt(submax)+1;
                                               makesubbers(subval.trim(), themax, numup, submax);
                                               
                                           }
                                           
                                           //main group
                                            var xyz=Pagination.get('mainipa');
                
                                            var zzz=parseInt(xyz.pages.current);
                                            
                                            Argus.vision.refresh($E('ipatable'),'mainipa',zzz,13);

                                            //sub group

                                            xyz=Pagination.get('subipa');

                                            zzz=parseInt(xyz.pages.current);
                                            
                                            Argus.vision.refresh($E('ipasubtable'),'subipa',zzz,13);
                                          
                                           
                                           
                                       }

                                });
    
                    }).post();
                    }

            });
    }




}

function closetest(){
    Desktop.window.list['{$window_id}']._close();
    
    
}


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
     //   Desktop.window.list['{$window_id}']._close();
   
   
        //refresh table
        
        
        
    
    }).post();



}




</script>