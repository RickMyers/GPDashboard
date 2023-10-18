<div style='clear:both'></div>
<div id='app-vision-events-container' class='dashboard-app-container' style='width: 90%'>
    
    <div id='app-vision-events-header' class='dashboard-app-header'><img onclick="Argus.tools.toggle(this); $('#app-vision-events-body').slideToggle()" style="float: left; cursor: pointer; margin-right: 5px; height: 20px;" src="/images/dashboard/collapse.png" />
        Vision Events Management
    </div>
    <div id="app-vision-events-tabs" style="color:#333"></div>
    <div id='app-vision-events-body' class='dashboard-app-body' style="position: relative; height: 400px; overflow: auto">
        
        <input type="hidden" id="intable"  name="intable" value="">
        <input type="hidden" id="tab1select" name="tab1select" value="">
        <input type="hidden" id="tab2select" name="tab2select" value="">
        <input type="hidden" id="tab3select" name="tab3select" value="">
        
        <div id="ipatab">
            <table id='ipamaintable' style="width:100%" class="tablecenterer">
                <tr>    
                    <td>
                        <div id="ipadiv">
        <table id='ipatable' style="width:80%; height:100%;  float: left; padding-right: 15px; padding-left: 15px;" class="tableborderstyle tablewhiteborder" >
            <tbody>
            <tr>
            <th class="tableborderstyle thcenterer" style="display:none;">ID</th>
            <th class="tableborderstyle thcenterer" >Name</th>
            <th class="tableborderstyle thcenterer" >IPA ID</th>
            <th class="tableborderstyle thcenterer" >Order Number</th>
            <th class="tableborderstyle thcenterer" >Enabled?</th>
            
            {foreach from=$ipa->fetch() item=ipaitem}
                <tr>
                    <td class="tableborderstyle" style="display:none;">
                        {$ipaitem.id}
                    </td>
                    
                    <td class="tableborderstyle">
                        {$ipaitem.ipa_name}
                    </td>
                    <td class="tableborderstyle">
                        {$ipaitem.ipa_id}
                    </td>
                    
                    <td class="tableborderstyle">
                        {$ipaitem.order_by_num}
                    </td>
                    <td class="tableborderstyle" >
                        {if ({$ipaitem.ipa_name}!='Other') }
                        <input type='checkbox' {if ({$ipaitem.is_enabled} == 1)}checked='checked'{/if} id="ipa-{$ipaitem@iteration}" onclick="disabler('ipa-{$ipaitem@iteration}', 'ipatable', {$ipaitem.id})"/>
                        {/if}
                    </td>
                </tr>
            {/foreach}
            </tbody>
        </table>
            </div>
                    </td>
                    <td></td>
                    <td>
                        <div id="subdiv">
        <table id='ipasubtable' style="width:80%; height:100%; float: left; padding-left: 15px;" class= "tablewhiteborder">
            <tbody>
            <tr>
                <th class="tableborderstyle thcenterer" style="display:none;">ID</th>
                <th class="tableborderstyle thcenterer" style="width:500px">Sub Name</th>
                <th class="tableborderstyle thcenterer">Sub ID</th>
                <th class="tableborderstyle thcenterer">Sub Order Number</th>
                <th class="tableborderstyle thcenterer">Enabled?</th>
            </tr>

            
            
            
            {foreach from=$ipa_sub->ipafinder() item=ipaitem}
                <tr>
                    
                    <td class="tableborderstyle" style="display:none;">
                        {$ipaitem.id}

                    </td>
                    
                    <td class="tableborderstyle">
                        {$ipaitem.The_Name}

                    </td>

                    <td class="tableborderstyle">
                        {$ipaitem.the_sub_id}
                    </td>
                    
                    <td class="tableborderstyle">
                        {$ipaitem.sub_order_id}
                    </td>

                    <td class="tableborderstyle" >
                        {if ({$ipaitem.The_Name}!='Other') }
                        <input type='checkbox' {if ({$ipaitem.is_enabled} == 1)}checked='checked'{/if} id="sub-{$ipaitem@iteration}" onclick="disabler('sub-{$ipaitem@iteration}','ipasubtable', {$ipaitem.id} )"/>
                        {/if}
                    </td>
                    
                </tr>
                
                
            {/foreach}
            
            
            
            </tbody>
        </table>
            </div>
                    </td>
                </tr>
                
                <!-- button row-->
                
                <tr>
                    <td>
            
                <span id='mainipa-from-row'></span>-<span id='mainipa-to-row'></span> of <span id='mainipa-rows'></span>
            
                
                        <input type="button" id="mainipa-first" class="" style="color: #333" value="  <<  " onclick="" />
                        <input type="button" id="mainipa-previous" class="" style="color: #333" value="  <  " onclick="" />
                        
                        <!--<input type="button" class="" style="color: #333" value="  testtest  " onclick="testupper(1)" />-->
                     <!--   <input type="button" class="" style="color: #333" value="  ^  " onclick="upper(1)" /> -->
                        <input type="button" class="" style="color: #333" value="  Add IPA  " onclick="addipa()" />                        
                    <!--    <input type="button" class="" style="color: #333" value="  v  " onclick="downer(1)" /> -->
                     <!--   <input type="button" class="" style="color: #333" value="  testtest  " onclick="testtest()" /> -->
                        
                     <!--   <input type="button" class="" style="color: #333" value="  Edit  " onclick="" /> -->
                     <input type="button" id="mainipa-next" class="" style="color: #333" value="  >  " onclick="" />
                     <input type="button" id="mainipa-last" class="" style="color: #333" value="  >>  " onclick="" />
                        
                        
                      
                Page <span id='mainipa-page'></span> of <span id='mainipa-pages'></span>
            
                    </td>
                    
                    
                    <td></td>
                    
                    
                    
                    <td>
                        <span id='subipa-from-row'></span>-<span id='subipa-to-row'></span> of <span id='subipa-rows'></span>
                        <input type="button" id="subipa-first" class="" style="color: #333" value="  <<  " onclick="" />
                        <input type="button" id="subipa-previous" class="" style="color: #333" value="  <  " onclick="" />
                        
                        
                      <!--  <input type="button" class="" style="color: #333" value="  ^  " onclick="upper(2)" /> -->
                        <input type="button" class="" style="color: #333" value="  Add Subgroups  " onclick="addsubipa()" />     
                        <!-- <input type="button" class="" style="color: #333" value="  v  " onclick="downer(2)" /> -->
                        
                       <!-- <input type="button" class="" style="color: #333" value="  Test  " onclick="doipasub()" />
                        <input type="button" class="" style="color: #333" value="  Test info  " onclick="getrowinfo()" /> -->
                        
                        <input type="button" id="subipa-next" class="" style="color: #333" value="  >  " onclick="" />
                        <input type="button" id="subipa-last" class="" style="color: #333" value="  >>  " onclick="" />
                         <span id='subipa-page'></span> of <span id='subipa-pages'></span>
                    </td>
                </tr>
                
                
            
            </table>
        </div>
        
            
            
            
            
            
            
        <!--second tab table -->
    <div id="npitab">
        <table class="tablecenterer" style="margin:0">
            <tbody>
        <tr>
                    
                    <td align="center">
                        <br>
                        <div id="npidiv">
                        <table id='npitable' style="width:45%; float: left; padding-left: 15px;" class="tablewhiteborder">
                            <tr>
                                <th class="tableborderstyle thcenterer" style="width:200px; height: 50px">NPI #</th>
                                <th class="tableborderstyle thcenterer" style="width:750px;height: 50px">Event Location</th>
                                <th class="tableborderstyle thcenterer" style="width:500px;height: 50px">Created On</th>
                            </tr>
                            
                            
                            {foreach from=$event_npi->fetch() item=eventnpi}
                                <tr>
                                    <td class="tableborderstyle" style="height:50px">
                                        {$eventnpi.npi_id}
                                        
                                    </td>

                                    <td class="tableborderstyle" style="height:50px">
                                        {$eventnpi.location}
                                    </td>
                                    <td class="tableborderstyle" style="height:50px">
                                        {$eventnpi.created_on}
                                    </td>
                                    
                                </tr>
                            {/foreach}
                            
                            
                        </table>
                        </div>
                        
                    </td>
                    
                </tr>
                <tr>
                    <td align="center">
                        <span id='npival-from-row'></span>-<span id='npival-to-row'></span> of <span id='npival-rows'></span>
                        <input type="button" id="npival-first" class="" style="color: #333" value="  <<  " onclick="" />
                        <input type="button" id="npival-previous" class="" style="color: #333" value="  <  " onclick="" />
                        
                        
                        
                        <input type="button" id="npival-next" class="" style="color: #333" value="  >  " onclick="" />
                        <input type="button" id="npival-last" class="" style="color: #333" value="  >>  " onclick="" />
                         Page <span id='npival-page'></span> of <span id='npival-pages'></span>
                    </td>
                </tr>
                <tr>
                    <td align="center">
                        NPI#:&nbsp;&nbsp;
                        <input type="text" style="width: 175px;color: #333" name="npinum" id="npinum" />
                        &nbsp;&nbsp;Event Location:&nbsp;&nbsp;
                        <input type="text" style="width: 550px;color: #333" name="npiloc" id="npiloc" />
                        
                        
                        <input type="button" class="" style="color: #333" value="  Add  " onclick="addnpi()" />
                        <!--
                        <input type="button" class="" style="color: #333" value="  Edit  " onclick="" />
                        <input type="button" class="" style="color: #333" value="  Delete  " onclick="" />
                        -->
                        
                        
                        
                    </td>
                    
                </tr>
            </tbody>
        </table>
    </div>
</div>
<script type='text/javascript'>
    
    //ipatable
   Pagination.init('mainipa',function (page,rows) {
        Argus.vision.refresh($E('ipatable'),'mainipa',page,rows);
    },1,13);
   
   
   Pagination.init('subipa',function (page,rows) {
        Argus.vision.refresh($E('ipasubtable'),'subipa',page,rows);
    },1,13);
    
    
    Pagination.init('npival',function (page,rows) {
        Argus.vision.refresh($E('npidiv'),'npival',page,rows);
    },1,10);
    
  //  (new EasyAjax('/hedis/configuration/events')).then(function (response) {
   //     $('#app-dental-campaigns-body').html(response);
   // }).get();
   
   
   var tabs=new EasyTab("app-vision-events-tabs");
   tabs.add('IPA', null, "ipatab", 120);
   tabs.add('NPI', null, "npitab", 120);
   tabs.tabClick(0);
   
   
   
   //the id is used to pull values
   function disabler(checkid, tableid, id){
       console.log('watermelon surprise');
        console.log('the checkboxes id is: ' +checkid);
        console.log('the table is: '+tableid);
        console.log('the id: '+id);
        
        var abc=$E(checkid).checked;
        console.log(abc);
        var ischeckval=0;
        if(abc){
            ischeckval=1;
        }
        
        
        //aaron
        //save value to database that value is disabled
        var ao;
        if(tableid=="ipatable"){
            ao=  new EasyAjax('/hedis/configuration/saveipa');
        }
        else{
            ao=  new EasyAjax('/hedis/configuration/savesub');
        }
        
        
        
        ao.add('id', id);
        ao.add('is_enabled',ischeckval);
        ao.then(function (response) { }).post();
        
        
   }
   
   
    function testtest(){
        changevals('ipatable','up');
    }
    
    
    
    function changevals(thetable,upordown){
        var thetabselect='';
        var zipzip='';
        if(thetable=='ipatable'){
            thetabselect='tab1select';
            zipzip='mainipa';
        }
        else{
            thetabselect='tab2select';
            zipzip='subipa';
        
        }
        
        var h=document.getElementById(thetabselect).value;
        console.log(h);
        var thetab=document.getElementById(thetable);
        console.log(thetab);  
        
        
        
        if(upordown=='down'){
            h=parseInt(h)+1;
            var xyz=Pagination.get(zipzip);
                
            var zzz=parseInt(xyz.pages.current);
            //if h>13 -> increase pagination page by 1 -> h=1
            if(h>13){
                h=1;
                zzz=parseInt(xyz.pages.current)+1;
                
                console.log('boots');
            }
            document.getElementById(thetabselect).value=h;
            Argus.vision.refresh($E(thetable),zipzip,zzz,13);
         
         //reselect
         
        } 
        else{
             
            //up time
            //subtract 1 from h
            h=parseInt(h)-1;
            //if h==0 -> subtract 1 from Pagination page and set h=13
            var xyz=Pagination.get(zipzip);
            console.log('current page='+xyz.pages.current);
            var zzz=parseInt(xyz.pages.current);
            
            if(h==0){
                h=13;
                zzz=parseInt(xyz.pages.current)-1;
                console.log('new page='+zzz);
                
                console.log('cats');
            }
            document.getElementById(thetabselect).value=h;
            //else set h=h
            Argus.vision.refresh($E(thetable),zipzip,zzz,13);
            
            //reselect
        
        

        }
        /* */
        
        
        var rower=thetab.rows[h];
    
        console.log(rower);
        //rower.addClass('selected').siblings().removeClass('selected');
        rower.className = 'selected';
    
    
    
    
    }
    
    
   
   function upper(thetable){
       
       console.log('banana');
       
        if(thetable==1){
            var h=document.getElementById("tab1select").value;
            
            
            var baseid=document.getElementById('ipatable').rows[h].cells.item(0).innerHTML;
         
            var thename=document.getElementById('ipatable').rows[h].cells.item(1).innerHTML;
            var ordernum=document.getElementById('ipatable').rows[h].cells.item(3).innerHTML;
            
            
            if(ordernum!=1 && thename!='Other'){
               tablemover('up',"ipatable",h);
            }
            else{
                if(baseid==1){
                    console.log('id=1');
                }
                else if(thename=='Other'){
                    console.log('other=name');
                }
                else{
                    console.log('other reason');
                }
                
            
            }
            
        }
        else {
            console.log('oklahoma');
            var h=document.getElementById("tab2select").value;
            var baseid=document.getElementById('ipasubtable').rows[h].cells.item(0).innerHTML;
         
            var thename=document.getElementById('ipasubtable').rows[h].cells.item(1).innerHTML;
            
            var ordernum=document.getElementById('ipasubtable').rows[h].cells.item(3).innerHTML;
            
            
            console.log(h);
            if((parseInt(ordernum)>2) && (thename!='Other')){
                
               tablemover('up',"ipasubtable",h);
            }
            
        }
        
    
    }
   
    function downer(thetable){
   
        var len=0;
        //if npi table
        var currentrow=0;
        if(thetable==1){
            
            
            currentrow=document.getElementById("tab1select").value;
            
            var baseid=document.getElementById('ipatable').rows[currentrow].cells.item(0).innerHTML;
         
            var thename=document.getElementById('ipatable').rows[currentrow].cells.item(1).innerHTML;
            var ordernum=document.getElementById('ipatable').rows[currentrow].cells.item(3).innerHTML;
            
            
            
            var aaa= jQuery.ajax({
            type: "GET",
            url: '/vision/consultation/getipacount',
            dataType: 'json',
            data: { },
                   success: function (obj, textstatus) {
                       var themax=obj[0].theamount;  
                       console.log('max value is: '+themax);
                       
                       
                       if((thename!='Other')  && ((parseInt(ordernum)-1)!=parseInt(themax))){
                           
                            tablemover('down',"ipatable",currentrow);
        
                        }
                       
                       
                       
                       
                       
                       
                       
                       
                   }
                   
                   
            });
            
            
            
            /*
            if(currentrow!=0 && currentrow!="" && currentrow!=null){
                len=document.getElementById("ipatable").rows.length;
                
                if(currentrow<len-2){
                
                    tablemover('down',"ipatable",currentrow,0);
                    
                
                
                }
                
            }
            */
        }
        else{
            currentrow=document.getElementById("tab2select").value;
            
            
            var baseid=document.getElementById('ipasubtable').rows[currentrow].cells.item(0).innerHTML;
         
            var thename=document.getElementById('ipasubtable').rows[currentrow].cells.item(1).innerHTML;
            var ordernum=document.getElementById('ipasubtable').rows[currentrow].cells.item(3).innerHTML;
            
                    
            if( (thename!='Other') && (ordernum!=1) ){
console.log('values are moving here');
               tablemover('down',"ipasubtable",currentrow);

            }
                    
            
            
            
            /*
            if(currentrow!=0 && currentrow!="" && currentrow!=null){
                len=document.getElementById("ipasubtable").rows.length;
                console.log(len);


                if(currentrow<len-1){
                    tablemover('down',"ipasubtable",currentrow,0);
                }
            }
            */
            
            
        }
        
        
    
    
    }
   
   
    function tablemover(whichway, thetable, therow){
   console.log('idaho');
        var baseid=document.getElementById(thetable).rows[therow].cells.item(0).innerHTML;
        console.log(baseid);
   //save the 
        var thename=document.getElementById(thetable).rows[therow].cells.item(1).innerHTML;
        console.log(thename);
        
        var theid=document.getElementById(thetable).rows[therow].cells.item(2).innerHTML;
        console.log(theid);
        
        var theorder=document.getElementById(thetable).rows[therow].cells.item(3).innerHTML;
        console.log(theorder);
        
        
        
        //not needed?
        var short="";
        if(thetable=="ipatable"){
            short="ipa";
        }
        else{
            short="sub";
        }
        console.log('albino '+short);
        var tr=parseInt(therow)-1;
        var ischecked= $E(short+'-'+tr).checked;        
        console.log(ischecked);
        
        
        
        
        
        
        
        
        
        
        //need to change
        var wayval=0;
        if(whichway=='up'){
            wayval=-1;        
        }
        else{
            wayval=1;
        }
        
        var wayorder=parseInt(theorder)+parseInt(wayval);
        
        
        
        
        
        
        
        
        
        
        
        
        
        /*
        
        var newrow=parseInt(therow)+parseInt(wayval);
        
        
        var baseid2=document.getElementById(thetable).rows[newrow].cells.item(0).innerHTML;
        console.log(baseid);
        
        var thename2=document.getElementById(thetable).rows[newrow].cells.item(1).innerHTML;
        console.log(thename2);
        
        var theid2=document.getElementById(thetable).rows[newrow].cells.item(2).innerHTML;
        console.log(theid2);
        
        var theorder2=document.getElementById(thetable).rows[newrow].cells.item(3).innerHTML;
        console.log(theorder2);
        
        var ischecked2= $E(short+'-'+newrow).checked; 
        console.log(ischecked2);
        */
        
        
        //aaron
        
        
       
      
       
       console.log('here we go');
        if(thetable=="ipatable"){
            
            
            
            var ccc= jQuery.ajax({
                type: "GET",
                url: '/vision/consultation/getorderipa',
                dataType: 'json',
                responseType: 'text',
                data: ({ selectedorder: wayorder}),
                success: function (obj, textstatus) {
                    //wayorder=order2
                    try{
                    var id2=obj[0].id;
                    console.log('the id is : '+obj[0].id);
        
                    
                    
                        
                        if(id2){
                    /////////////////////////////
                    
                    var ao=  new EasyAjax('/hedis/configuration/saveipa');
                    ao.add('id', baseid.trim());
                    ao.add('order_by_num',wayorder);

                    ao.then(function (response) {
                        var bo=  new EasyAjax('/hedis/configuration/saveipa');
                        bo.add('id', id2);
                        bo.add('order_by_num',theorder.trim());
                        bo.then(function (response) {

/*
var xyz=Pagination.get('mainipa');
//console.log(xyz);
console.log(xyz.pages.current);
Argus.vision.refresh($E('ipatable'),'mainipa',xyz.pages.current,13);
xyz=Pagination.get('subipa');

Argus.vision.refresh($E('ipasubtable'),'subipa',xyz.pages.current,13);
  */
 
 changevals('ipatable',whichway);
 var tab2=document.getElementById('tab2select');
 console.log('tab2: '+ tab2.value);
 if(tab2.value!=''){
     console.log('should not if blank');
  changevals('ipasubtable',whichway);
 }
                            
                            //aaron: add selector restarter here
                            
                            //main here
                            
                            //sub here
                            
                        }).post();

                    }).post();
                    
                    
                    
                    
                    
                    
                    
                    
                    
        
        
        
        
///////////////////////////////////////////////////
                        }
                    }
                    catch(err){
                    }



                },
                error: function(XMLHttpRequest, textStatus, errorThrown) { 
                        alert("Status: " + textStatus); alert("Error: " + errorThrown); 
                    }       

            });
            
            
            
            
            
            

        }
        else{
            
            
            
            
            if(theorder.trim()!=1){
                
                
                
                
                
                
                
                
                   var theparent=document.getElementById(thetable).rows[therow].cells.item(4).innerHTML;
                
                console.log('the parent id is: '+theparent );
                
                
                
                
                var ccc= jQuery.ajax({
                    type: "GET",
                    url: '/vision/consultation/getorderipasub',
                    dataType: 'json',
                    responseType: 'text',
                    data: { selectedorder: wayorder, theparent: theparent},
                    success: function (obj, textstatus) {
                        console.log('umpalumpa');
                        try{
                            console.log('letry');
                        //wayorder=order2
                        var id2=obj[0].id;
                        console.log('the id is : '+obj[0].id);
                        
                        var candodown=true;
                        
                        if(whichway=='down'){
                            if( (obj[0].sub_name=='Other') || (obj[0].sub_order_id==1 ) ){
                                candodown=false;
                            }
            
                        }
                        
                        
                        if(id2 && candodown){
//////////////////////////////////////////////////////////

                        var ao=  new EasyAjax('/hedis/configuration/savesub');
                        ao.add('id', baseid.trim());
                        ao.add('sub_order_id',wayorder);

                        ao.then(function (response) {
                            var bo=  new EasyAjax('/hedis/configuration/savesub');
                            bo.add('id', id2);
                            bo.add('sub_order_id',theorder.trim());
                            bo.then(function (response) {




                            //aaron: restart selector here
                            
                            //sub only here



/*
var xyz=Pagination.get('subipa');
Argus.vision.refresh($E('ipasubtable'),'subipa',xyz.pages.current,13);
*/
changevals('ipasubtable',whichway);

                            }).post();

                        }).post();













//////////////////////////////////////////////////////
                            }
                        }
                        catch(err){
                            console.log(err);
                        }

                    },
                    error: function(XMLHttpRequest, textStatus, errorThrown) { 
                            alert("Status: " + textStatus); alert("Error: " + errorThrown); 
                        }       

                });
  








                
            }
            else{
                console.log('is equal to 1 will not move');
            }
          //  $( "#ipasubtable" ).load( "visionevents.tpl  #ipasubtable" );
        }
        
        console.log('afterwards');
        
        
        
        
        
        
    }
  
   
   
   
   $(document).ready(function() {
       
       
       
       //aaron: need here (might cause issues)? or should i continue trying to put in main table
        
        
        
        
       
       
        $('table').children('tbody').children('tr').children('td').children('div').children('table').on( 'click', 'tr', function () {
            
            
            console.log('omega');
            
            
            if (event.target.type !== 'checkbox') {
                
                var valuers=$(this).find('td:first').html();
                
                
                if( (valuers!==undefined)){
                    
                    if(valuers.trim()!="Other"){
                        $(this).addClass('selected').siblings().removeClass('selected');
                        
                        //save row to hiddenvalue1
                        var therow=$(this).closest('tr').index();
                        var whichtable=$(this).closest('table').attr('id');
                        console.log(whichtable);
                        //var whichtable=document.getElementById("intable").value;
                        console.log('the table is: '+whichtable);
                        if(whichtable=="ipatable"){
                            document.getElementById("intable").value="ipa";
                           document.getElementById("tab1select").value=therow;
                        }
                        else if(whichtable=="ipasubtable"){
                            console.log('banana');
                            document.getElementById("intable").value="sub";
                           document.getElementById("tab2select").value=therow;
                        }
                        else{
                            document.getElementById("intable").value="npi";
                           document.getElementById("tab3select").value=therow;
                        }
                        
                        console.log(therow);
                        
                        
                        
                        
                        console.log('umpalumpa');
                        
                        if(document.getElementById("intable").value=="ipa"){
                        
                            console.log('hope for not');
                            /*
                            var baseid=document.getElementById('ipatable').rows[therow].cells.item(0).innerHTML;
                            console.log(baseid);
                            /*
                            var ipaidvallist= $.ajax({
                                type: "GET",
                                url: "Sub.php",
                                data: { theipaid: baseid.trim() }
                              }).done(function( msg ) {
                                console.log('ajax call worked');
                                
                                console.log(ipaidvallist);
                                
                                
                                
                              });    
                            /*  */
                             
                             console.log('regal');
                             /*
                            xmlhttp = new XMLHttpRequest();
                            xmlhttp.onreadystatechange = function() {
                             if (this.readyState == 4 && this.status == 200) {
                                   document.getElementById("ipasubtable").innerHTML = this.responseText;
                                    //put info here
                                }
                            };
                            xmlhttp.open("GET","Sub.php?theipaid="+baseid.trim(),true);
                            xmlhttp.send();
                             /* */
                              
                        }
                            
                        
                        
                        
                        
                        
                        
                    }
                    
                    
                    
                    
                }
                
                
                
                
                
            
                
                
                
            }
            else{ }
            

        } );
        
        
        
        
   });
   
   
   
   function addnpi(){
   
        
        
        var bb = new EasyAjax('/vision/consultation/savetonpi');
        bb.add('npi_id',$('#npinum').val());
        bb.add('location',$('#npiloc').val());


        bb.then(function (response) {
            
            var xyz=Pagination.get('npival');
            //console.log(xyz);
            console.log(xyz.pages.current);
            Argus.vision.refresh($E('npidiv'),'npival',xyz.pages.current,10);   
            
        }).post();
        
    
        document.getElementById("npinum").value="";
        document.getElementById("npiloc").value="";
    
    
    
    }
    
    
    
    
    
    
    function addipa(){
        var win = Desktop.semaphore.checkout(true);
        win._title('Create IPA');
        win._scroll(true);
        
        (new EasyAjax('/vision/consultation/newipa')).add('window_id',win.id).then(function (response) {
            win._open(response);
        }).post();
    
    }
   
   
   function addsubipa(){
        var win = Desktop.semaphore.checkout(true);
        win._title('Create IPA Sub-groups');
        win._scroll(true);
        
        (new EasyAjax('/vision/consultation/newsubipa')).add('window_id',win.id).then(function (response) {
            win._open(response);
        }).post();
    
    }
   
   
   
   function getrowinfo(){
       var currentrow=document.getElementById("tab2select").value;
    console.log(currentrow);
        var baseid=document.getElementById('ipasubtable').rows[currentrow].cells.item(0).innerHTML;
        console.log(baseid);
   //save the 
        var thename=document.getElementById('ipasubtable').rows[currentrow].cells.item(1).innerHTML;
        console.log(thename);
        
        var theid=document.getElementById('ipasubtable').rows[currentrow].cells.item(2).innerHTML;
        console.log(theid);
        
        var theorder=document.getElementById('ipasubtable').rows[currentrow].cells.item(3).innerHTML;
        console.log(theorder);
    
    
    
    }
   
   function doipasub(){
       console.log('ardvark');
        //Argus.vision.hediscontrol.redoipasub();
        console.log('shrimp');
        
        var currentrow=document.getElementById("tab1select").value;
        console.log('selected main row is: '+currentrow);
        var theid='';
        
        /*
        if(currentrow!=''){
            theid=document.getElementById('ipatable').rows[currentrow].cells.item(2).innerHTML;
        }
        */
        
        console.log(theid);
        
        
        //jjjjjj
        var ccc= jQuery.ajax({
            type: "GET",
            url: '/vision/consultation/createsubtable',
            dataType: 'json',
            responseType: 'text',
            data: ({ selectedrow: theid}),
            success: function (obj, textstatus) {
                
                for(k=0;k<obj.length;k++){
                    console.log(obj[k].The_Name);
        
                }
                
                
                

            },
            error: function(XMLHttpRequest, textStatus, errorThrown) { 
                    alert("Status: " + textStatus); alert("Error: " + errorThrown); 
                }       
            
        });
        
        
        
        
        
        
        
    
    }
   
   
   
   
   
   /**/
   
</script>
<style type="text/css">
    tr { cursor: default; }
    .highlight { background: green;
      color: white;
    }


    .selected{
        background: green;
      color: white;
    
    }
    
    .tablecenterer{
        margin: 0 auto;
        
    }
    
    .tablewhiteborder{
    border: 1px solid white;
    }
    
    .thcenterer{
        text-align: center;
    }
    
    .tableborderstyle {
        //border: 1px solid black;
        text-align: center;
    }
</style>