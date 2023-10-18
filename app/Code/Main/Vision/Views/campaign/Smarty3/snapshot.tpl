<style type="text/css">
    .snapshot-date {
        background-color: lightcyan; padding: 3px; border-radius: 3px; width: 135px; border: 1px solid #aaf
    }
</style>
<table style="width: 100%; height: 100%" id='tiptip'>
    <tr>
        <td style="height: 50px; background-color: #333; color:ghostwhite; font-size:1.3em">Vision Snapshot</td>
    </tr>
    <tr>
        <td>
            <div style="padding: 50px 20px 0px 20px; margin-left: auto; margin-right: auto; min-width: 600px; width: 75%">
                <div style="width: 100%">
                    <div style="float: right; white-space: nowrap; text-align: center;  margin-left: calc(50% - 265px)">
                        <input type="text" name="snapshot_end_date"   id="snapshot_end_date"   class="snapshot-date" value=""/>
                        <br />Event End Date</div>
                    <div style="float: right; white-space: nowrap; text-align: center; margin:0">
                        <!-- margin:0 right-floated-width 0 left-floated-width -->
                        
                        Healthplan: 
                        <select name="Healthplan" id="healthplan" style="width: 200px; height: 20px">
                            <option value="---"> Please Choose a Provider </option>
                            <option value=""> All </option>
                            <option value="WellMed"> WellMED </option>
                            <option value="WellMed/WellCare"> WellMED/WellCare </option>
                            <option value="WellCare"> WellCare </option>
                            <option value="Optimum"> Optimum </option>
                            <option value="Freedom"> Freedom </option>
                            

                        </select>
                        
                    </div>
                        <div style="float: left; text-align: center"><input type="text" name="snapshot_start_date" id="snapshot_start_date" class="snapshot-date" value=""/>                    <br/>
                            Event Start Date</div>
                        <div style="clear: both"></div>
                    </div><br /><br />
                    <div id='tablediv'>
                        <ul>
                           <li style="background-color: rgba(202,202,202,{cycle values=".15,.3"}); padding-bottom: 3px; font-size: 1.2em">
                               <a href="#" onclick=" if($('#healthplan').val()!=='---'){  Argus.vision.reports(); } return false;">Create Snapshot</a>
                               
                           </li>
                        </ul>
                    </div>
            </div>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
</table>
<script type="text/javascript">
    $('#snapshot_start_date').datepicker({
        //onSelect: testingbayone
        
    
    
    
    });
    $('#snapshot_end_date').datepicker({
        //onSelect: testingbayone
       
    });
    
    
    function testingbayone(){
        //clear table
        $("#tablediv").html("");
        
        //recreate table here
        var startd= $('#snapshot_start_date').val();
        //startd=startd.replace(/\//g,'-');
        var endd= $('#snapshot_end_date').val();
        
        
        var abc = $('#dental_campaign_id').val();
        
        
        var switcher= [];
        switcher[0]=.15;
        switcher[1]=.3;
            var ccc= jQuery.ajax({
                type: "GET",
                url: '/dental/consultation/refreshsnap',
                dataType: 'json',
                responseType: 'text',
                data: ({ startdate: startd.trim(), enddate: endd.trim(), campid: abc}),
                success: function (obj, textstatus) {
                    //wayorder=order2
                    try{
                        $( "#tablediv" ).append('<ul>');
                        
                        for(i=0;i<obj.length;i++){
                            var aaa='<li style="background-color: rgba(202,202,202,'+switcher[i%2]+'); padding-bottom: 3px; font-size: 1.2em">';
                            if(obj[i].detail_available=='Y'){
                                aaa+= '<a href="#" onclick="Argus.dental.reports(\''+obj[i].title+'\'); return false;">'+obj[i].title+'</a>';
                            }
                            else{
                                aaa+=obj[i].title;
                            }
                            
                            
                            aaa+='<div style="float: right; margin-right: 5px">';
                            if(obj[i].total!=null){
                                aaa+=obj[i].total; 
                            }
                            else{
                                aaa+='0';
                            }
                            
                            aaa+='</div>';
                            
                            $( "#tablediv" ).append(aaa);
                            
                        
                            
                        
                            $( "#tablediv" ).append('</li>');
                        
                        
                        
                        
                          
                        
                        }
                    
                    
                    $( "#tablediv" ).append('</ul>');
                    
                    
                    
                    
                    /*
                     

                        
                            
                               
                                 <div style="float: right; margin-right: 5px"> {$stat.total}</div>
                            
                       
                        
                     */
                    
                    
                    }
                    catch(err){
                    }



                },
                error: function(XMLHttpRequest, textStatus, errorThrown) { 
                        alert("Status: " + textStatus); alert("Error: " + errorThrown); 
                    }       

            });
            
        
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
    
    
    
    $( "#snapshot_start_date" ).click(function( event ) {
            
            clickedondate=true;
    });
        
        
    $( "#snapshot_end_date" ).click(function( event ) {
            
            clickedondate=true;
    });
    
    $( "#tiptip" ).click(function( event ) {
        
        
        $( "#snapshot_start_date" ).click(function( event ) {
            
            clickedondate=true;
        });


        $( "#snapshot_end_date" ).click(function( event ) {
            
                clickedondate=true;
        });
        
        
        
        
    
        
        
        var ele = $(event.toElement);
        
        
        if (!ele.hasClass("hasDatepicker") && !ele.hasClass("ui-datepicker") && !ele.hasClass("ui-icon") && !$(ele).parent().parents(".ui-datepicker").length){
            //check if datepicker is open(?)
            var id=this.id;
            if(  ($("#snapshot_end_date").datepicker( "widget" ).is(":visible")) || ($("#snapshot_start_date").datepicker( "widget" ).is(":visible"))         ){
                
                
                
                if(!clickedondate){
                    
                    $(".hasDatepicker").datepicker("hide");  
                    
                }
                
            }
            
            
            
        }
        clickedondate=false;
    });
    
    
    
    
</script>