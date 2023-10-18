<style type="text/css">
    .snapshot-date {
        background-color: lightcyan; padding: 3px; border-radius: 3px; width: 135px; border: 1px solid #aaf
    }
    
    
    
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

        text-align: center;
    }
    
    
</style>
<table style="width: 100%; height: 100%" id='tiptip'>
    <tr>
        <td style="height: 50px; background-color: #333; color:ghostwhite; font-size:1.3em">Vision Batch PDF Converter</td>
    </tr>
    <tr>
        <td>
            <div style="padding: 50px 20px 0px 20px; margin-left: auto; margin-right: auto; min-width: 600px; width: 75%">
                <div style="width: 100%">
                    
                    
                    <div style="float: right; white-space: nowrap; text-align: center;  margin-left: calc(50% - 200px)">
                        <select class="form-field" style="width: 200px" name="event_location" id="event_location" onchange="testingbayone()">
                                <option value=""></option>
                                {foreach from=$finder->addresssearcher() item=client}                                    
                                    {if $client !=''}
                                        <option value="{$client}">{$client}</option>
                                    {/if}
                                {/foreach}
                            </select>
                        <br />Event Location
                    </div>
                    
                    
                    
                    
                    
                    
                    <div style="float: left; text-align: center"><input type="text" name="event_date" id="event_date" class="snapshot-date" value=""/>                    <br/>
                            Event Date
                    </div>
                    <div style="clear: both"></div>
                    
                    
                    
                    
                    <div style="float: left; text-align: center"><input type="text" name="event_number" id="event_number" class="snapshot-date" value=""/>                    <br/>
                            Event Number
                    </div>
                    
                    
                </div><br /><br />
                    
                    
                    <!-- convert this to pagination -->
                    <table id='batchtable' style="width:80%; height:100%; float: left; padding-left: 15px;" class= "tablewhiteborder" >
            <tbody>
                <!--
            <tr>
                <th class="tableborderstyle thcenterer" >Member Name</th>
                <th class="tableborderstyle thcenterer" >Member ID</th>
                <th class="tableborderstyle thcenterer" >Date</th>
                <th class="tableborderstyle thcenterer">Location</th>
                <th class="tableborderstyle thcenterer">View Form</th>
                <th class="tableborderstyle thcenterer">Save to PDF</th>
                
            </tr>

            
            {foreach from=$batchfinderer->batchpdffinder() item=batchclient}                                    
                                    
                       <tr>
                    
                    <td class="tableborderstyle" >
            {$batchclient.member_name}
                    </td>
                    
                    <td class="tableborderstyle">
            {$batchclient.member_id}
                    </td>

                    <td class="tableborderstyle">
                        {$batchclient.event_date}
                    </td>
                    
                    <td class="tableborderstyle">
                        {$batchclient.address_id}
                    </td>
<td class="tableborderstyle" >
            VIEW
                    </td>
                    <td class="tableborderstyle" >
            SAVE
                    </td>
                    
                </tr>             
                                    
            {/foreach}
            
                
                -->
                
            
            
            
            </tbody>
        </table>
                               
                               
            </div>
        </td>
    </tr>
    <tr>
        
        
        
        <td align="center">
            
            <span id='batchsearch-from-row'></span>-<span id='batchsearch-to-row'></span> of <span id='batchsearch-rows'></span>


                    <input type="button" id="batchsearch-first" class="" style="color: #333" value="  <<  " onclick="" />
                    <input type="button" id="batchsearch-previous" class="" style="color: #333" value="  <  " onclick="" />




                 <input type="button" id="batchsearch-next" class="" style="color: #333" value="  >  " onclick="" />
                 <input type="button" id="batchsearch-last" class="" style="color: #333" value="  >>  " onclick="" />



            Page <span id='batchsearch-page'></span> of <span id='batchsearch-pages'></span>

                </td>
                    
                    
        
        
        
        
        
    </tr>
    <tr>
        <td>
            <div style="padding: 50px 20px 0px 20px; margin-left: auto; margin-right: auto; min-width: 600px; width: 75%">
                <div style="width: 100%">
                    
                    
                    <div style="float: center; white-space: nowrap; text-align: center;  margin-left: calc(50% -300px)">
            <input type="button" class="" style="" value="  Convert  " onclick="tobatch()" />
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <input type="button" class="" style="" value="  Cancel  " onclick="closetest()" />
            <br><br>
             </div>
                </div>
            </div>
        </td>
    </tr>
</table>
<script type="text/javascript">
    
    Pagination.init('batchsearch',function (page,rows) {       
        Argus.vision.batrefresh($E('batchtable'),'batchsearch',1,13,'','');
        //Argus.vision.refresh($E('batchtable'),'batchsearch',page,rows);
    },1,13);
    
    $('#event_date').datepicker({
       onSelect: testingbayone
        
        
    
    
    });
    
    
    function closetest(){
        Desktop.window.list['{$window_id}']._close();
    
    }
    
    
    
    function tobatch(){
        //converter goes here
        var evdate= $('#event_date').val();
        var evloc= $('#event_location').val();
        
        var evnum= $('#event_number').val();
        
        console.log(evdate+'   '+evloc+'    '+evnum);
        
        Argus.vision.batchtest('',evdate,evloc, evnum );
        
    }
    
    
    function testingbayone(){
        
        //get values of both locations
        var evdate= $('#event_date').val();
        var evloc= $('#event_location').val();
        
        
        
        
        
        
        
        //recreate table here
        
        
    
        
        
        
        
        if(evdate.trim()!="" && evloc.trim()!=""){
            //clear table
            //$("#batchtable").html("");
                Argus.vision.batrefresh($E('batchtable'),'batchsearch',1,13,evdate,evloc);
            /*
            var ccc= jQuery.ajax({
                type: "GET",
                url: '/vision/queue/refreshbat',
                dataType: 'json',
                responseType: 'text',
                data: ({ theloc: evloc.trim(), thedate: evdate.trim()}),
                success: function (obj, textstatus) {
                    try{
                       // $( "#tablediv" ).append("<tbody><tr><th class='tableborderstyle thcenterer'>Member Name</th><th class='tableborderstyle thcenterer'>Member ID</th><th style='width:90px' class='tableborderstyle thcenterer'>Date</th><th class='tableborderstyle thcenterer'>Location</th><th class='tableborderstyle thcenterer'>View Form</th><th class='tableborderstyle thcenterer'>Save to PDF</th></tr>");
                        
                        for(i=0;i<obj.length;i++){
                        }
                       // $( "#tablediv" ).append("</tbody></table>");
                    }
                    catch(err){
                    }
                },
                error: function(XMLHttpRequest, textStatus, errorThrown) { 
                    alert("Status: " + textStatus); alert("Error: " + errorThrown); 
                }
            });
            */
           
           
           
           
           
           

        }
        
        
       
        
    }
    
    /*
    
 $( "#tiptip" ).click(function( event ) {
    var ele = $(event.toElement);
   if (!ele.hasClass("hasDatepicker") && !ele.hasClass("ui-datepicker") && !ele.hasClass("ui-icon") && !$(ele).parent().parents(".ui-datepicker").length){
       $(".hasDatepicker").datepicker("hide"); 
   }
});
    
    */
    
    
    var clickedondate=false;
    
    
    
    $( "#event_date" ).click(function( event ) {
            
            clickedondate=true;
    });
        
        
    
    
    $( "#tiptip" ).click(function( event ) {
        
        
        $( "#event_date" ).click(function( event ) {
            
            clickedondate=true;
        });


        
        
        
        
        
    
        
        
        var ele = $(event.toElement);
        
        
        if (!ele.hasClass("hasDatepicker") && !ele.hasClass("ui-datepicker") && !ele.hasClass("ui-icon") && !$(ele).parent().parents(".ui-datepicker").length){
            //check if datepicker is open(?)
            var id=this.id;
            
            if(   ($("#event_date").datepicker( "widget" ).is(":visible"))         ){
                
                
                
                
                if(!clickedondate){
            
                    $(".hasDatepicker").datepicker("hide");  
            
                }
                
            }
            
            
            
        }
        clickedondate=false;
    });
    
    /*
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
        /* 
        
        
        var rower=thetab.rows[h];
    
        console.log(rower);
        //rower.addClass('selected').siblings().removeClass('selected');
        rower.className = 'selected';
    
    
    
    
    }
    */
    /*
    Pagination.init('batchsearch',function (page,rows) {
       Argus.credentialing.refresh($E('tablediv'),'batchsearch',page,rows);
    },1,14);
    /**/
</script>