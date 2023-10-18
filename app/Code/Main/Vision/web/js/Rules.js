Argus.vision.rules = (function () {
    function noDiabeticRetinopathy()           { if ($(this).prop('checked')) { $('input[name="retinopathy"]')[0].checked = true; } }
    function backgroundDiabeticRetinopathy()   { if ($(this).prop('checked')) { $('input[name="retinopathy"]')[1].checked = true; } }
    function proliferativeDiabeticRetinopathy(){ if ($(this).prop('checked')) { $('input[name="retinopathy"]')[2].checked = true; } }
    function saveRetinopathyValue() {
        if ($(this).prop('checked')) {
            if (CurrentForm.data && (CurrentForm.data.status === 'I')) {
                CurrentForm.saveField('retinopathy',$("input[name='retinopathy']:checked").val());
            }
        }
    }
    function dilationNoneCheck()               { if ($('#dilation_none').prop('checked')) { $(this).prop('checked',false);  } }
    function odSettings()                      {
        $('#fcvals_od').css('visibility',($(this).val() === 'FC' ? 'visible' : 'hidden'));
        $('#odlabel').css('display',($(this).val() == +$(this).val() ? 'inline-block' : 'none'));
    }
    function addPointZeroIfNeeded() {
        var val = +this.value;
        if (parseInt(val) == parseFloat(val)) {
            $(this).val(parseInt(val)+'.0');
        }
    }
    function setDiabetesStatus() {
        var val = $('#hba1c').val();
        if (val) {
            if (+val >= 7) {
                $('#dm_alltype_controlled').attr('checked',false);
                $('#dm_alltype_uncontrolled').attr('checked',true);
            } else {
                $('#dm_alltype_uncontrolled').attr('checked',false);
                $('#dm_alltype_controlled').attr('checked',true);
            }
        }
    }
    function osSettings()                      {
        $('#fcvals_os').css('visibility',($(this).val() === 'FC' ? 'visible' : 'hidden'));
        $('#oslabel').css('display',($(this).val() == +$(this).val() ? 'inline-block' : 'none'));
    }    
    function resetDXValues()                    {
        if (!this.checked) {
            $('#'+this.name+'_period_quantity').val('').trigger('change');
            $('#'+this.name+'_period').val('').trigger('change');
        }
    }
    function resetDilationValues() {
        if (this.checked) {
            $('#dilation_fivem').prop('checked',false);
            $('#dilation_onem').prop('checked',false);
            $('#dilation_twentyfiven').prop('checked',false);
        }
    }
    function disableIfAppropriate()  {
        $('#'+this.name+'_period').prop('disabled',!$(this).prop('checked'));
        $('#'+this.name+'_period_quantity').prop('disabled',!$(this).prop('checked'));
    }
    function setTimeStamp() {
        if (!$('#exam_time').val() && ($('#iop_od').val() || $('#iop_os').val())) {
            var now = moment().format("hh:mm a");
            var parts = now.split(' ');
            $('#exam_time').val(parts[0]).trigger('change');
            $("#exam_time_ampm").val(parts[1].toUpperCase()).trigger('change');
        }
    }
    function eitherOrODAngles() {
        if ($('#angle_od').val()) {
            $('input[name="od_pupil"]').prop('checked',false);
        }
    }
    function eitherOrODPupils() {
        if ($('input[name="od_pupil"]:checked').val()) {
            $('#angle_od').val('');
        }
    }
    function eitherOrOSAngles() {
        if ($('#angle_os').val()) {
            $('input[name="os_pupil"]').prop('checked',false);
        }
    }
    function eitherOrOSPupils() {
        if ($('input[name="os_pupil"]:checked').val()) {
            $('#angle_os').val('');
        }
    }
    function setIfScreeningForm() {
        if (!$(this).prop('checked')) {
            return;
        };
        if (CurrentForm.data && CurrentForm.data.form_type && (CurrentForm.data.form_type === 'screening')) {
            $(this).prop('checked',true);
        }
    }
    function setTaFluressIfChecked() {
        if ($(this).val()) {
            $('#ta_tp').val('fluress');
        }
    }
    function setToAYearIfNotSetYet() {
        if (CurrentForm && CurrentForm.doctor) {
            if (this.checked) {
                if (!$('#eye_exam_period').val()) {
                    $('#eye_exam_period').val('MONTHS').trigger('change');
                }
                if (!$('eye_exam_period_quantity').val()) {
                    $('#eye_exam_period_quantity').val(12).trigger('change');
                }
            }
        }
    }
    return {
        init: function () {
            for (var field_name in Argus.vision.rules.fields) {
                for (var i in Argus.vision.rules.fields[field_name]) {
                    Argus.vision.rules.fields[field_name][i].apply($('input[name="'+field_name+'"]').get());
                }
            };
        },
        execute: function (field) {
            if (Argus.vision.rules.fields[field.name]) {
                for (var i in Argus.vision.rules.fields[field.name]) {
                    Argus.vision.rules.fields[field.name][i].apply(field);
                };
            }
        },
        "fields": {
            'dv_od_combo':       [odSettings],
            'dv_os_combo':       [osSettings],
            'iop_od':            [setTimeStamp,setTaFluressIfChecked],
            'iop_os':            [setTimeStamp,setTaFluressIfChecked],
            'angle_od':          [eitherOrODAngles],
            'od_pupil':          [eitherOrODPupils],
            'angle_os':          [eitherOrOSAngles],
            'os_pupil':          [eitherOrOSPupils],
            'pc_s3000':          [setIfScreeningForm],
            'pc_2023f':          [setIfScreeningForm],
            'eye_exam':          [resetDXValues,disableIfAppropriate,setToAYearIfNotSetYet],
            'opth_referral':     [resetDXValues,disableIfAppropriate],
            'hba1c':             [addPointZeroIfNeeded,setDiabetesStatus],
            'retinal_referral':  [resetDXValues,disableIfAppropriate],
            'dilation_none':     [resetDilationValues],
            'dilation_fivem':    [dilationNoneCheck],
            'dilation_onem':     [dilationNoneCheck],
            'dilation_twentyfiven': [dilationNoneCheck],
            'diag_code_e11_351': [proliferativeDiabeticRetinopathy,saveRetinopathyValue],
            'diag_code_e11_359': [proliferativeDiabeticRetinopathy,saveRetinopathyValue],
            'diag_code_e10_351': [proliferativeDiabeticRetinopathy,saveRetinopathyValue],
            'diag_code_e10_359': [proliferativeDiabeticRetinopathy,saveRetinopathyValue],
            'diag_code_e11_319': [backgroundDiabeticRetinopathy,saveRetinopathyValue],
            'diag_code_e11_311': [backgroundDiabeticRetinopathy,saveRetinopathyValue],
            'diag_code_e11_321': [backgroundDiabeticRetinopathy,saveRetinopathyValue],
            'diag_code_e11_329': [backgroundDiabeticRetinopathy,saveRetinopathyValue],
            'diag_code_e11_331': [backgroundDiabeticRetinopathy,saveRetinopathyValue],
            'diag_code_e11_339': [backgroundDiabeticRetinopathy,saveRetinopathyValue],
            'diag_code_e11_341': [backgroundDiabeticRetinopathy,saveRetinopathyValue],
            'diag_code_e11_349': [backgroundDiabeticRetinopathy,saveRetinopathyValue],
            'diag_code_e10_319': [backgroundDiabeticRetinopathy,saveRetinopathyValue],
            'diag_code_e10_311': [backgroundDiabeticRetinopathy,saveRetinopathyValue],
            'diag_code_e10_321': [backgroundDiabeticRetinopathy,saveRetinopathyValue],
            'diag_code_e10_329': [backgroundDiabeticRetinopathy,saveRetinopathyValue],
            'diag_code_e10_331': [backgroundDiabeticRetinopathy,saveRetinopathyValue],
            'diag_code_e10_339': [backgroundDiabeticRetinopathy,saveRetinopathyValue],
            'diag_code_e10_341': [backgroundDiabeticRetinopathy,saveRetinopathyValue],
            'diag_code_e10_349': [backgroundDiabeticRetinopathy,saveRetinopathyValue],
            'diag_code_e11_9':   [noDiabeticRetinopathy,saveRetinopathyValue],
            'diag_code_e11_65':  [noDiabeticRetinopathy,saveRetinopathyValue],
            'diag_code_e11_39':  [backgroundDiabeticRetinopathy,saveRetinopathyValue],
            'other_diabetes':    [noDiabeticRetinopathy,saveRetinopathyValue],
            'diag_code_e10_9':   [noDiabeticRetinopathy,saveRetinopathyValue],
            'diag_code_e10_65':  [noDiabeticRetinopathy,saveRetinopathyValue],
            'diag_code_e10_39':  [backgroundDiabeticRetinopathy,saveRetinopathyValue]
        }
    };
})();