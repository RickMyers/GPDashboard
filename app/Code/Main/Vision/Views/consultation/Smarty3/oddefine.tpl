<style type="text/css">
    .block {
        display: inline-block; color: #333
    }
    .field-block {
        white-space: nowrap; margin-right: 2px; margin-bottom: 2px; display: inline-block
    }
    .form-row {
        overflow: hidden; width: 100%; clear: both; white-space: nowrap
    }
    .form-field {
        background-color: #dfdfdf; border: 1px solid transparent; padding: 3px; border-radius: 3px; border-bottom-color: #999
    }
    .form-field:focus {
        background-color: lightcyan; border-bottom-color: #333
    }
    .diagnosis_codes_header {
        text-align: center; font-weight: bolder; text-decoration: underline
    }
    .diagnosis_codes_cell {
        overflow: hidden;
    }
    
    input[type=number]::-webkit-inner-spin-button, input[type=number]::-webkit-outer-spin-button { 
    -webkit-appearance: none;
    -moz-appearance: none;
    appearance: none;
    margin: 0; 
    }
    
    input[type=number] {
    -moz-appearance:textfield;
    }

    .cdbs {
        
    }
    
    .nodx{}
    
    
    .backgrounddx{}
    
    
    .numberremover{
    -moz-appearance:textfield;
    
    -webkit-appearance: none;
    -moz-appearance: none;
    appearance: none;
    margin: 0; 
    
    }
    
    
    


    
    
    
    
</style>
{assign var=data    value=$user->load()}
O.D. Default Values
<div style="padding:10px">
    <table style="width: 100%; margin-top: 2px">
        <tr>
            <td style="background-color: rgba(202,202,202,.2); width: 15%">
                <div class="field-block">
                    <div class="block">
                        IOP:
                    </div>
                </div>
            </td>
            <td style="background-color: rgba(202,202,202,.2); width: 20%">
                <div class="field-block">
                    <div class="block">
                        OD:
                    </div>
                    <div class="block">
                        <input type="text" class="form-field doctor_field" style="width: 60px" name="iop_od" id="iop_od-{$window_id}" /> mmHg
                    </div>
                </div>
            </td>
            <td style="background-color: rgba(202,202,202,.2)">
                <div class="field-block">
                    <div class="block">
                        OS:
                    </div>
                    <div class="block">
                        <input type="text" class="form-field doctor_field" style="width: 60px" name="iop_os" id="iop_os-{$window_id}" /> mmHg
                    </div>
                </div>
            </td>

            <td style="background-color: rgba(202,202,202,.2)">

                <div class="field-block">
                    <div class="block">
                        Ta/Tp:
                    </div>
                </div>

                <div class="field-block">
                    <div class="block" style="padding-left: 20px">

                        <select name="ta_tp" id="ta_tp-{$window_id}" class="form-field doctor_field" style="width: 150px">
                            <option value=""> </option>
                            <option value="fluress"> Ta (Fluress) </option>
                            <option value="fluorocaine"> Ta (Fluorocaine) </option>
                            <option value="tp"> Tp </option>
                            <option value="iCare"> iCare </option>
                        </select>
                    </div>
                </div>
            </td>
        </tr>
    </table>


    <table style="width: 100%; margin-top: 2px">
        <tr>
            <td style="background-color: rgba(202,202,202,.2); width: 15%">
                <div class="field-block">
                    <div class="block">
                        Dilation:
                    </div>
                </div>
            </td>
            <td style="background-color: rgba(202,202,202,.2);">
                <div class="field-block">
                    <div class="block">
                        <select name="dilation" id="dilation-{$window_id}" class='form-field doctor_field'>
                            <option value=""> </option>
                            <option value="0.0% M"> None </option>
                            <option value="0.5% M"> 0.5% M </option>
                            <option value="1.0% M"> 1.0% M </option>
                            <option value="2.5% N"> 2.5% N </option>
                        </select> 
                    </div>
                </div>
            </td>
        </tr>
    </table>
                        
    <input class="argus-settings-field" type="button" name="od_defvalues" onclick="savefeature()" id="od_defvalues" value="  Save  " />
</div>
                        
<script type='text/javascript'>

    //load info
    var abcd='{$window_id}';
console.log('testtesti23, '+abcd);
    function savefeature(){
        
        
        //pull in OD id
            var od_id="{$data.id}";

           
        
        //pull in all values
        var dil=$('#dilation-{$window_id}').val();
        var iop_od=$('#iop_od-{$window_id}').val();
        var iop_os=$('#iop_os-{$window_id}').val();
        var ta_tp=$('#ta_tp-{$window_id}').val();
       
       
       
       //save info
        if(dil!='' || iop_od!='' || iop_os!='' || ta_tp!=''){
       
            
        
            //save info
            Argus.vision.consultation.odsave(od_id, iop_od, iop_os, ta_tp, dil);
       
            //close window
       
       
       
       
        }
       else{
       console.log('no values are present');
        } 
        
        
        
     
    
    
    
    }

</script>                        