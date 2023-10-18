var ConsultationForms = { };
Argus.vision = (function () {
    //local scope variables here
    var importWindow;
    var importTimer;
    var ValidDateFormats = ["MM/DD/YYYY","MM/DD","MM/DD/YY"];
    
    /* -----------------------------------------------------------------------------------------
     * Private functions are not instanciated, meaning they don't have anything to do with state
     * 
     * Private function for setting up the actual form display window
     */
    function initWindow() {
        if (typeof(Desktop)!=="undefined") {
            var win = Desktop.window.list[this.window_id];
            win.resize = (function (win) {
                return function () {
                    if ($E('vision-form-tabs')) {
                        $('#vision-package').height(win.content.height() -  $E('vision-form-tabs').offsetHeight);
                    }
                }
            })(win);
            $('#comment').on('click',function () {
                $('#form-comment-layer').css('display','block');
                $('#comment_attach_button').css('visibility','visible');
                $E('vision_form_comments').focus();
            }); 
        }
    }
    /* -------------------------------------------------------------------------
     * Private function for priming the date picking fields
     */
    function primeForm() {
        if (!this.print) {
            $('#date_of_birth').datepicker();
            $('#hba1c_date').datepicker();
            $('#last_exam_date_btn').on('click',(function (status) {
                var datePicker = status;
                return function () {
                    datePicker = !datePicker;
                    if (datePicker) {
                        $('#last_exam_date').val('').datepicker();
                        $('#last_exam_date').trigger('focus');
                    } else {
                        $('#last_exam_date').datepicker('hide');
                        $('#last_exam_date').datepicker('destroy');
                    }
                }
            })(false));
            $('#fbs_date').datepicker();
            $('#event_date').datepicker(); 
            $('.deselecter').on('click',function (evt) {
                if (evt.target.checked && evt.target.getAttribute('prior_state')=='true') {
                    evt.target.checked = false;
                    $(evt.target).trigger('change');
                } 
                evt.target.setAttribute('prior_state',evt.target.checked);
            });
        }
        $('#date_of_birth').on('change',function () {
            if (this.value) {
                var mydate;
                if (this.value.indexOf('/')!==-1) {
                    mydate = moment(this.value,'MM/DD/YYYY');
                } else {
                    mydate = moment(this.value,'YYYY-MM-DD');
                }
                $('#age').html(moment().diff(mydate,'years')+" Years Old");
            }
        });
        //if you press tab at any time, this will close all datepickers
        $('#new-retina-consultation-form').on('keyup',function (evt) {
            if (evt && evt.keyCode && (evt.keyCode === 9) && (evt.target.id.indexOf('date') == -1)) {
                $('#last_exam_date').datepicker('hide');
                $('#event_date').datepicker('hide');
                $('#hba1c_date').datepicker('hide');
                $('#fbs_date').datepicker('hide');
            }
        });
    }
    
    /* -------------------------------------------------------------------------
     * Private function for setting up the multi-tab display
     */   
    function pageSetup() {
        if (!this.print) {
            var tabs = new EasyTab('vision-form-tabs');
            tabs.add('Form',null,'vision-form-tab',120);
            tabs.add('Scans',function () {
                var name = $('#member_name').val();
                var member_id = $('#member_id').val();
                $('#form-scan-patient-id').html(((name) ? name : '') + ((member_id) ? ' ['+member_id+']' : ''));
            },'vision-form-images-tab',120);
            tabs.add('Feedback',null,'vision-form-feedback-tab',120);
            tabs.tabClick(0);   
            (new EasyAjax('/vision/retina/scans')).add('form_id',this.form_id).then(function (response) {
                $('#form-scan-list').html(response);
            }).post();            
        }
    }

    //########################################################################################
    //This is the prototype template for managing our forms, one will be instantiated per form
    var ConsultationForm = {
        data: { },
        addressSearch: false,
        retain: [
            'address_id',
            'address_id_combo',
            'npi_id',
            'npi_id_combo',
            'location_id',
            'location_id_combo',
            'physician_npi',
            'physician_npi_combo',
            'ipa_id',
            'ipa_id_combo'
        ],
        checkRetain: function (evt) {
            var retain = false;
            var i = 0;
            while (i<CurrentForm.retain.length && !retain) {
                CurrentForm.retain[i];
                retain = (evt.target.name == CurrentForm.retain[i]);
                i++;
            }
            if (retain) {
                EasyAjax.setCookie(evt.target.name,$('#'+evt.target.name).val());
            }            
        },
        floatCheck: function (field) {
            var val = $(field).val();
            if (parseInt(val) == parseFloat(val)) {
                $(field).val(parseFloat(val)+'.0');
            }
            return this;
        },
        load: function (after) {
            var me = this;
            if (this.tag) {
                var oldStatus = (this.data && this.data.status) ? this.data.status : false;
                (new EasyAjax('/vision/consultation/load')).add('tag',this.tag).then(function (response) {
                    CurrentForm.data = JSON.parse(response);
                    CurrentForm.form_id = CurrentForm.data.id;
                    //Say CHEESE!
                    if (CurrentForm.data['reason'] && ((CurrentForm.data['reason']=='Images Unreadable') || (CurrentForm.data['reason']=='No Diagnosis') || (CurrentForm.data['reason']=='Member Data Missing or Incorrect')) && (CurrentForm.data['claim_status'] && (CurrentForm.data['claim_status']=='E'))) {
                        $('#mark_form_as_claimed_button').css('display','block');
                    }
                    if (CurrentForm.data['pcp_portal_withhold'] && (CurrentForm.data['pcp_portal_withhold']=='Y')) {
                        $('#release_to_pcp_portal').css('display','block');
                    }
                    for (var i in CurrentForm.data) {
                        if (i.substr(0,3)=='lbl_') {
                            if ($E(i)) {
                                $E(i).innerText = CurrentForm.data[i];
                            }
                        } else {
                            if ((i.indexOf('date') !== -1) && CurrentForm.data[i]) {
                                var format = false;
                                var mydate;
                                if (!typeof(i) === 'string') {
                                    Argus.tools.value.set('new-retina-consultation-form',i,i,CurrentForm.data[i]);
                                } else if ((CurrentForm.data[i].indexOf('-') !== -1) || (CurrentForm.data[i].indexOf('/') !== -1)) {
                                    format = (CurrentForm.data[i].indexOf('-') !== -1) ? 'YYYY-MM-DD' : 'MM/DD/YYYY';
                                }
                                if (format) {
                                    mydate = moment(CurrentForm.data[i],format);
                                    Argus.tools.value.set('new-retina-consultation-form',i,i,mydate.format("MM/DD/YYYY"));
                                } else {
                                    Argus.tools.value.set('new-retina-consultation-form',i,i,CurrentForm.data[i]);
                                }
                                $('#'+i).trigger('change');
                            } else {
                                Argus.tools.value.set('new-retina-consultation-form',i,i,CurrentForm.data[i]);
                            }
                        }
                    }
                    oldStatus = (oldStatus) ? oldStatus : CurrentForm.data.status;
                    //the following statement handles for when the form_type has not been set
                    CurrentForm.data.form_type = (CurrentForm.data.form_type) ? CurrentForm.data.form_type : ((CurrentForm.data.technician && CurrentForm.data.technician) ? "scanning" : "screening"); 
                    StateMachine.transition.call(CurrentForm,oldStatus,CurrentForm.data.status);
                    if (after) {
                        after();
                    }
                    me.floatCheck($E('hba1c'));
                    Argus.vision.rules.init();
                }).post();
            }                    
        },
        reload: function () {
            var win = Argus.vision.consultation.active = Argus.vision.consultation.active ? Argus.vision.consultation.active : Desktop.semaphore.checkout(true);
            win._static(true)._scroll(false);
            (new EasyAjax('/vision/consultation/open')).add('window_id',win.id).add('tag',this.data.tag).then(function (response) {
                win.set(response);
                win.resize = (function (win) {
                    return function () {
                        $('#vision-package').height(win.content.height() - $E('vision-form-tabs').offsetHeight-5);
                    }
                })(win);
                win.resize();
                Argus.vision.rules.init();
            }).post();               
        },
        recall: function () {
            if (confirm("Return consultation to staging?")) {
                this.setStatus('N');
            }
        },        
        signingFunction: null,
        submitForReview: function () {
            var me = this;
            if (Edits['consultation_form'].validate()) {
                if ($('#npi_id').val()) {
                    $('#npi_id').trigger('change');
                }
                (new EasyAjax('/vision/consultation/submit')).add('id',this.data.id).then(function (response) {
                    me.reload();
                }).post();
            }
        },
        sign: function () {
            var pin = $('#user-pin-number').val();
            if (pin) {
                (new EasyAjax('/vision/consultation/sign')).add('id',this.data.id).add('pin',pin).then(function (response) {
                    pin = JSON.parse(response);
                    if (pin && pin.valid) {
                        CurrentForm.signingFunction.call(CurrentForm,pin);
                    } else {
                        alert("Invalid Pin");
                    }
                }).post();
            }
            Argus.dashboard.lightbox.close();
        },        
        preparer: function () {
            if (this.data.pcp_staff_has_signed && (this.data.pcp_staff_has_signed == 'Y')) {
                var signature = Handlebars.compile((Humble.template('vision/PreparerSignature')));
                var data = { 
                    "preparer": this.data.pcp_staff_member,
                    "signature": (this.data.pcp_staff_signature) ? this.data.pcp_staff_signature : this.data.pcp_staff_member
                };
                $('#technician_signature').css('display','block').html(signature(data));
            } else {
                
            } 
        },
        memberCheck: function () {
            function checkToSeeIfMemberIsInEvent(event_id,member_id) {
                (new EasyAjax('/vision/event/check')).add('event_id',event_id).add('member_id',member_id).then(function (response) {
                    var result = JSON.parse(response);
                    if (!result.id) {
                        if (confirm("The member is not on the event schedule, would you like to add them?")){
                            var n = $('#member_name').val().split(',');
                            (new EasyAjax('/vision/schedule/add')).add('first_name',n[1]).add('last_name',n[0]).add('event_id',event_id).add('member_number',member_id).add('member_name',$('#member_name').val()).add('addon','Y').then(function (response) {

                            }).post();
                        }
                    } 
                }).post();
            }
            $('#event_id').on('change',function (evt) {
                if (this.value && $('#member_id').val()) {
                    checkToSeeIfMemberIsInEvent(this.value,$('#member_id').val());
                }
            });
            $('#member_id').on('change',function (evt) {
                if (this.value && $('#event_id').val()) {
                    checkToSeeIfMemberIsInEvent($('#event_id').val(),this.value);
                }
            });
        },
        pin: function () {
            Argus.dashboard.lightbox.open(Handlebars.compile((Humble.template('vision/VisionPinPrompt'))));
            $('#user-pin-number').focus();            
        },
        preparerSign: function (pin) {
            $('#technician_signature').html(pin.signature);
            CurrentForm.load();
            
        },
        signAndComplete: function (pin) {
            $('#od_signed_date').val(moment().format("MM/DD/YYYY")).trigger('change');
            $('#od_signed_time').val(moment().format("hh:mm A")).trigger('change');
            this.setStatus('C');
            (new EasyAjax('/vision/consultation/claimready')).add('form_id',CurrentForm.form_id).then(function (response) {
            }).post();
        },
        signature: function () {
            if (this.data.doctor_has_signed && (this.data.doctor_has_signed == 'Y')) {
                var signature = Handlebars.compile((Humble.template('vision/DoctorSignature')));
                var data = { 
                    "doctor": this.data.doctor,
                    "license_number": (this.data.license_number) ? this.data.license_number : false,
                    "signed_date": (this.data.od_signed_date) ? this.data.od_signed_date : false,
                    "signed_time": (this.data.od_signed_time) ? this.data.od_signed_time : false,
                };
                $('#od_signature').css('display','block').html(signature(data));
            }               
        },
        active: function () {
            var me = this;
            $('#new-retina-consultation-form').on('change',function (evt) {
                CurrentForm.checkRetain(evt);
                var ao = new EasyAjax('/vision/consultation/save');
                ao.add('id',me.data.id).add(evt.target.name,ao.getValue(evt.target,'new-retina-consultation-form')).then(function (response) {
                    Argus.vision.rules.execute(evt.target);
                }).post();
            });                
        },
        codes: function () {
            $('.cdbs').on('click',function(evt) {
                var diagnostic_code = evt.target.id.split("_");
                var label           = "lbl_code_"+diagnostic_code[2]+"_"+diagnostic_code[3];
                if (this.checked) {  
                    $('#active_diagnosis_code').val(evt.target.id);                
                    $('#eyeselect').val("");
                    $('#thecbname').html(diagnostic_code[2].replace("e","E ")+"."+diagnostic_code[3]);
                    $('#myModal').css('display',"block");
                } else {
                    var label_text = $E(label).innerText.trim();
                    $E(label).innerText = label_text.substr(0,label_text.length-1)+'_';
                    CurrentForm.saveLabel(label,$E(label).innerText);
                }   
            });
            $('#closebtn').on('click',function (){
                $('#myModal').css('display','none');
                var diagnostic_code = $('#active_diagnosis_code').val();
                $E(diagnostic_code).click();

            });
            $('#eyeselect').on('change',function (evt) {
                var diagnostic_code = $('#active_diagnosis_code').val();
                if (diagnostic_code) {
                    diagnostic_code = diagnostic_code.split("_");
                    var label = "lbl_code_"+diagnostic_code[2]+"_"+diagnostic_code[3];
                    var label_text = $E(label).innerText.trim();
                    $E(label).innerText = label_text.substr(0,label_text.length-1)+this.value;
                    $('#myModal').css('display','none');
                    CurrentForm.saveLabel(label,$E(label).innerText);
                }
                return true;
            });
        },
        init: function (doAfter) {
            initWindow.apply(this);
            pageSetup.apply(this);
            primeForm.apply(this);
            this.load(function () {
                //if no value for address_id, get one from the cookie
                var i, val;
                if (CurrentForm.data.version) {
                    $('#form-version-number').html('-'+CurrentForm.data.version);
                }
                //must specifically fire lookup for PCP NPI
                if (CurrentForm.data.version==1 && CurrentForm.data.status === 'N') {
                 /*   if (confirm('Would you like to populate this form with the location information from the previous form?')) {
                        for (i=0; i<CurrentForm.retain.length; i++) {
                            val = $('#'+CurrentForm.retain[i]).val();
                            if (!val) {
                                $('#'+CurrentForm.retain[i]).val(EasyAjax.getCookie(CurrentForm.retain[i])).trigger("change");
                            }
                        }
                    }*/
                }
                if (CurrentForm.data.status == 'N') {
                    CurrentForm.saveField('version',++CurrentForm.data.version);
                }
                if (doAfter) {
                    doAfter();
                }
            });
        },
        setup: function () {
        },
        set:  function (field,value) {
            this.data[field] = value;
        },
        saveLabel: function (label,text) {
            (new EasyAjax('/vision/consultation/save')).add('id',this.data.id).add(label,text).then(function (response) {
                console.log(response);
            }).post();            
        },
        save: function (evt) {
            CurrentForm.checkRetain(evt);
            var ao = new EasyAjax('/vision/consultation/save');
            ao.add('id',this.data.id).add(evt.target.name,ao.getValue(evt.target,'new-retina-consultation-form')).then(function (response) {
            }).post();
        },
        saveField: function (name,val) {
            var ao = new EasyAjax('/vision/consultation/save');
            val = val ? val : ao.getValue(name,'new-retina-consultation-form');
            ao.add('id',CurrentForm.data.id).add(name,val).then(function (response) {
            }).post();
        },        
        isValidDate: function (date_string) {
            return moment(date_string, ValidDateFormats, true).isValid();
        },
        setStatus: function (status,after,message) {
            var me = this;
            if (status) {
                var ao = new EasyAjax('/vision/consultation/save');
                if (message) {
                    ao.add('last_activity',message);
                }
                ao.add('id',this.data.id).add('status',status).then(function (response) {
                    if (status=='C') {
                        Desktop.window.list[CurrentForm.window_id]._close();
                    } else {
                        me.reload(after);
                    }
                }).post();
            }
        },
        close: function () {
            Desktop.window.list[this.window_id]._close();
        },
        clearSignature: function () {
            (new EasyAjax('/vision/consultation/clearsignature')).add('form_id',CurrentForm.form_id).then(function (response) {
                CurrentForm.close();
            }).post()
        }
    };
    var pcp_report = false;
    return {
        control:     false,
        window_id:   false,
        form_id:     false,
        form_window: false,
        scan_window: false,
        srch_window: false,
        current_scans: 0,
        RTC: function () {
            (new EasyAjax('/argus/user/hasrole')).add('role','HEDIS Vision Manager').then(function (response) {
                var user = JSON.parse(response);
                if (user.role) {
                    Argus.dashboard.socket.on('VisionClaimReady',Argus.vision.claims.available); 
                    Argus.dashboard.socket.on('NoncontractedClaimReady',Argus.vision.claims.noncontracted);
                    Argus.vision.claims.available();
                    Argus.vision.claims.noncontracted();
                }
            }).get();        },
        init: function () {
            Handlebars.registerHelper('ifOther', function(arg1, options){return(arg1=='Other') ?  options.inverse(this) : options.fn(this) });
            Handlebars.registerHelper('ifisone', function(arg1, options){return(arg1=='1') ?  options.fn(this)  : options.inverse(this) });
            Argus.vision.queue.bound        = Handlebars.compile((Humble.template('vision/VisionInboundOutboundQueue')));
            Argus.vision.queue.staging      = Handlebars.compile((Humble.template('vision/VisionStagingQueue')));
            Argus.vision.queue.archive      = Handlebars.compile((Humble.template('vision/VisionArchiveQueue')));
            Argus.vision.queue.complete     = Handlebars.compile((Humble.template('vision/VisionCompletedQueue')));
            Argus.vision.queue.search       = Handlebars.compile((Humble.template('vision/VisionArchiveSearch')));
            Argus.vision.queue.unassigned   = Handlebars.compile((Humble.template('vision/VisionUnassignedQueue')));
            Argus.vision.queue.adminrequired= Handlebars.compile((Humble.template('vision/VisionAdminRequiredQueue')));
            Argus.vision.queue.genfailed    = Handlebars.compile((Humble.template('vision/VisionGenerationFailedQueue')));
            Argus.vision.queue.subipa       = Handlebars.compile((Humble.template('vision/SubIPA'))); 
            Argus.vision.queue.mainipa      = Handlebars.compile((Humble.template('vision/MainIPA')));
            Argus.vision.queue.npival       = Handlebars.compile((Humble.template('vision/NPIValue')));
            Argus.vision.pcp.queue          = Handlebars.compile((Humble.template('vision/PCPQueue')));
            Argus.vision.od.queue           = Handlebars.compile((Humble.template('vision/VisionODQueue')));
            Argus.vision.od.stagingqueue    = Handlebars.compile((Humble.template('vision/VisionODStagingQueue')));
            Argus.vision.event.searchtpl    = Handlebars.compile((Humble.template('vision/EventSearch')));
            //Argus.vision.ipa.clientqueue    = Handlebars.compile((Humble.template('vision/IPAHealthPlanQueue')));
            Argus.vision.ipa.physicianqueue = Handlebars.compile((Humble.template('vision/IPAPhysicianQueue')));
            Argus.vision.secondaryqueues.failedclaims  = Handlebars.compile((Humble.template('vision/VisionFailedClaims')));            
            Argus.vision.secondaryqueues.referralqueue = Handlebars.compile((Humble.template('vision/VisionReferrals'))); 
            Argus.vision.secondaryqueues.nonconqueue   = Handlebars.compile((Humble.template('vision/NonContracted')));
            //need to fix -- What? (Rick)
            Argus.vision.queue.batchsearch  = Handlebars.compile((Humble.template('vision/BatchSearch')));
            Argus.vision.tech.queue         = Handlebars.compile((Humble.template('vision/TechCompleted')));
        },
        claims: {
            current: 0,
            available: function (data) {
                (new EasyAjax('/vision/consultation/claims')).then(function (response) {
                    Argus.vision.claims.current = parseInt(response);
                    $('#vision_claims_indicator').css('opacity',(Argus.vision.claims.current ? '1.0':'.3')).attr('title',Argus.vision.claims.current+' Claims Available To Be Run');
                }).post();        
            },
            noncontracted: function (data) {
                (new EasyAjax('/vision/consultation/noncontracted')).then(function (response) {
                    let num = parseInt(response);
                    $('#noncontracted_claims_indicator').css('opacity',(num ? '1.0':'.3')).attr('title',num+' Non-Contracted Claims Available To Invoice');
                }).post();        
            },
            run: function (icon) {
                if (confirm(icon.title+"\n\nWould you like to batch and claim those now?")) {
                    var number = prompt('How many claims would you like to run?',Argus.vision.claims.current);
                    if (+number) {
                        $('#desktop-lightbox').css('display','block').html('<table style="width: 100%; height: 100%"><tr><td id="claim_status_message" style="font-size: 3em; color: ghostwhite" align="center">Hang on a minute,<br /><img src="/images/argus/spinner.gif" style="height: 75px"/><br />Doing Grownup Things...</td></tr></table>');
                        (new EasyAjax('/vision/consultation/claim')).add('number',number).then(function (response) {
                            $('#claim_status_message').html(response);
//                            window.setTimeout(function () { $('#desktop-lightbox').css('display','none').html(''); },6000);
                        }).post();
                    }
                }
            }
        },
        rules: false,
        event: {
            searchtpl: null,
            window: null,
            search: function () {
                var win = Argus.vision.event.window = (Argus.vision.event.window) ? Argus.vision.event.window : Desktop.semaphore.checkout(true);
                win._static(true)._title('Event Search List');
                (new EasyAjax('/vision/events/search')).add('window_id',win.id).then(function (response) {
                    win._open(response);
                }).post();
            },
            list: function (body,page,row) {
                (new EasyAjax('/vision/events/list')).add('page',page).add('row',row).then(function (response) {
                    response = {
                        "data": JSON.parse(response)
                    }
                    if (data) {
                        $(body).html(Argus.vision.event.searchtpl(response).trim());
                        Pagination.set('event-list',this.getPagination());
                    }                    
                }).post();
            },
            assign: function (event_id) {
                (new EasyAjax('/vision/events/list')).add('id',event_id).then(function (response) {
                    response = JSON.parse(response);
                    if (response && response.length) {
                        $('#event_id').val(event_id);
                        CurrentForm.saveField('event_id');
                        CurrentForm.saveField('address_id',response[0].address_id);
                        CurrentForm.saveField('location_id',response[0].location_id);
                        CurrentForm.saveField('ipa_id',response[0].ipa_id);
                        CurrentForm.saveField('npi_id',response[0].npi_id);
                        $('#event_date').val(moment(response[0].start_date.replace(/-/g,'')).format("L")).trigger('change');
                        $('#location_id_combo').val(response[0].location_id_combo).trigger('change');
                        $('#address_id_combo').val(response[0].address_id_combo).trigger('change');
                        $('#npi_id_combo').val(response[0].npi_id_combo).trigger('change');
                        $('#ipa_id_combo').val(response[0].ipa_id_combo).trigger('change');
                        $('#client_id').val(response[0].client_id).trigger('change');
                        if (Argus.vision.event.window) {
                            Argus.vision.event.window._close();
                        }
                    }
                }).post();             
            },
            cancel: function (event_id) {
                if (confirm('Cancel this event?')) {
                    (new EasyAjax('/vision/schedule/cancel')).add('event_id',event_id).then(function (response) {
                    }).post();
                }
            },
            close: function (event_id) {
                if (confirm('Do you wish to conclude this event, sending out automatic notifications?')) {
                    (new EasyAjax('/vision/event/close')).add('event_id',event_id).then(function () {
                        //$('#close_event_button').css('display','none');
                    }).post();
                }
            },
            attachment: function (attachment_id) {
                window.open('/vision/attachment/open?attachment_id='+attachment_id);
            }
        },
        pcp: {
            inprogress: false,
            info: function (evt,who) {
                if (!Argus.vision.pcp.inprogress) {
                    Argus.vision.pcp.inprogress = true;
                    (new EasyAjax('/argus/provider/info')).add('version','2.1').add('number',$(evt.target).val()).then(function (response) {
                        Argus.vision.pcp.inprogress = false;
                        var pcp = JSON.parse(response);
                        if (pcp) {
                            if (pcp.Errors) {
                                alert(who+' NPI Error: '+pcp.Errors[0].description);
                            } else if (pcp.result_count) {
                                switch (who) {
                                    case 'PCP' : 
                                        if (pcp.results[0].basic && pcp.results[0].basic.last_name && pcp.results[0].basic.first_name) {
                                            $('#primary_doctor_combo').val(pcp.results[0].basic.last_name+", "+pcp.results[0].basic.first_name).trigger('change');
                                        } else if (pcp.results[0].basic && pcp.results[0].basic.authorized_official_last_name && pcp.results[0].basic.authorized_official_first_name) {
                                            $('#primary_doctor_combo').val(pcp.results[0].basic.authorized_official_last_name+", "+pcp.results[0].basic.authorized_official_first_name).trigger('change');
                                        } else {
                                            console.log(response);
                                            alert('No valid results came back for that NPI');
                                        }                                   
                                        break;
                                    case 'Location':
                                        //hmmm, what to do here
                                        break;
                                }
                            }
                        }
                    }).get();
                }
            },
            queue: false,
            refresh: function (queue,queue_id,page,rows) {
                (new EasyAjax('/vision/queue/pcp')).add('page',page).add('rows',rows).then(function (response) {
                    Argus.vision.pcp.app(response);
                }).post();
            },
            app: function (data) {
                data = JSON.parse(data);
                if (data) {
                    $('#pcp_consultations_queue').html(Argus.vision.pcp.queue(data['pcpqueue']).trim());
                    Pagination.set('pcpqueue',data['pcpqueue'].pagination);
                }
            },
            release: function (id) {
                if (confirm("Release this form to the PCP's Portal?")) {
                    (new EasyAjax('/vision/consultation/release')).add('id',id).then(function (response) {
                        $('#release_to_pcp_portal').css('visibility','hidden');
                        Desktop.window.list[CurrentForm.window_id]._close();
                    }).post();
                }
            }
        },
        claim: {
            clear: function () {
                if (confirm("Do you wish to mark this screening/scanning claimed?")) {
                    (new EasyAjax('/vision/consultation/markclaimed')).add('form_id',CurrentForm.form_id).then(function (response) {
                        $('#mark_form_as_claimed_button').css('visibility','hidden');
                        $('#form_reset_claim').css('visibility','visible');
                        //Desktop.window.list[CurrentForm.window_id]._close();
                    }).post();
                }
            },
            reset: function () {
                if (confirm("Do you wish to reset the claim status so that it can be run through the claims process again?")) {
                    (new EasyAjax('/vision/consultation/claimreset')).add('form_id',CurrentForm.form_id).then(function (response) {
                        $('#form_reset_claim').css('visibility','hidden');
                        $('#mark_form_as_claimed_button').css('visibility','visible');                        
                    }).post();
                }
            }
        },
                
        od: {
            reassign: function () {
                (new EasyAjax('/vision/od/form')).then(function (response) {
                    Argus.dashboard.lightbox.open(response);
                }).get();
            },
            queue: false,
            stagingqueue: false,
            refresh: function (queue,queue_id,page,rows) {
                (new EasyAjax('/vision/od/queue')).add('queue_id',queue_id).add('page',page).add('rows',rows).then(function (response) {
                    Argus.singleton.set(queue_id,page);
                    response = {
                        "data": JSON.parse(response)
                    };
                    if (queue_id == 'od_staging') {
                        $(queue).html(Argus.vision.od.stagingqueue(response).trim());
                    } else {
                        $(queue).html(Argus.vision.od.queue(response).trim());
                    }
                    Pagination.set(queue_id,this.getPagination());
                }).post();
            },
            app: function (data) {
                data = JSON.parse(data);
                if (data) {
                    $('#vision_od_staging_queue').html(Argus.vision.od.stagingqueue(data['od_staging']).trim());
                    $('#vision_screening_queue').html(Argus.vision.od.queue(data['screening']).trim());
                    $('#vision_scanning_queue').html(Argus.vision.od.queue(data['scanning']).trim());
                    Pagination.set('screening',data['screening'].pagination);
                    Pagination.set('scanning',data['scanning'].pagination);
                    Pagination.set('od_staging',data['od_staging'].pagination);
                }
            }
        }, 
        invoice: {
            win: false,
            review: function () {
                var win = Argus.vision.invoice.win = ((Argus.vision.invoice.win) ? Argus.vision.invoice.win : Desktop.semaphore.checkout(true));
                (new EasyAjax('/vision/invoice/review')).add('window_id',win.id).then(function (response) {
                    win.dock('R')._scroll(true)._title('Candidates To Invoice')._open(response);
                }).post();
            },
            remove: function (form_id,window_id) {
                if (confirm('Remove form '+form_id+' from list forms that can be invoiced?\n\nThis will release the form to the PCP portal')) {
                    (new EasyAjax('/vision/invoice/removeform')).add('form_id',form_id).add('window_id',window_id).then(function (response) {
                        Desktop.window.list[window_id].set(response);
                    }).post();
                }
            }
        },
        admin: {
            queue: {
                search: false
            },
            app: function (data) {
                data = (data) ? JSON.parse(data) : false;
                if (data) {
                    $('#vision_admin_required_queue').html(Argus.vision.queue.adminrequired(data['admin_required']).trim());
                    Pagination.set('admin_required',data['admin_required'].pagination);
                }                
            },
            refresh: function (queue,queue_id,page,rows) {
                (new EasyAjax('/vision/admin/queue')).add('referral_reason',$('#referral_reason').val()).add('queue_id',queue_id).add('page',page).add('rows',rows).then(function (response) {
                    Argus.singleton.set(queue_id,page);
                    response = {
                        "data": JSON.parse(response)
                    };
                    if (queue_id == 'admin_required') {
                        $(queue).html(Argus.vision.queue.adminrequired(response).trim());
                    } 
                    Pagination.set(queue_id,this.getPagination());                    
                }).post();                
            },
            search: {
                page: function (text) {
                    var win = Desktop.semaphore.checkout(true);
                    (new EasyAjax('/vision/admin/searchpage')).add('window_id',win.id).add('search',text).then(function (response) {
                        win._title('Failed Generation Search')._open(response);
                    }).post();
                },
                execute: function (search,win_id,page,rows) {
                    (new EasyAjax('/vision/admin/searchqueue')).add('window_id',win_id).add('page',(page)?page:1).add('rows',(rows)?rows:20).add('search',search).then(function (response) {
                        var raw = {
                            "data": JSON.parse(response)
                        };
                        Pagination.set('vision-admin-search-'+win_id,this.getPagination());
                        $('#admin-search-page-body-'+win_id).html(Argus.vision.admin.queue.search(raw));
                    }).post();                      
                }
            }
        },    
        tech: {
            nonconqueue: false,
            failedclaims: false,
            referralqueue: false,
            refresh: function (queue,queue_id,page,rows) {
                (new EasyAjax('/vision/queue/refresh')).add('queue_id',queue_id).add('page',page).add('rows',rows).then(function (response) {
                    Argus.singleton.set(queue_id,page);
                    response = {
                        "data": JSON.parse(response)
                    };
                    $(queue).html(Argus.vision.tech.queue(response).trim());
                    Pagination.set(queue_id,this.getPagination());
                }).post();
            },
            app: function (data) {
                data = JSON.parse(data);
                if (data) {
                    $('#vision_tech_completed_queue').html(Argus.vision.tech.queue(data['tech_completed']).trim());
                    Pagination.set('tech_completed',data['tech_completed'].pagination);
                }
            }            
        },
        secondaryqueues: {
            /* USE THIS AS A TEMPLATE FOR HOW TO HANDLE QUEUES UNTIL WE GET THE NODE.JS STUFF WORKING WELL */            
            nonconqueue: false,
            failedclaims: false,
            referralqueue: false,
            refresh: function (queue,queue_id,page,rows) {
                (new EasyAjax('/vision/secondaryqueues/queue')).add('queue_id',queue_id).add('page',page).add('rows',rows).then(function (response) {
                    Argus.singleton.set(queue_id,page);
                    response = {
                        "data": JSON.parse(response)
                    };
                    if (queue_id == 'non_contracted') {
                        $(queue).html(Argus.vision.secondaryqueues.nonconqueue(response).trim());
                    } else if (queue_id == 'failed_claims') {
                        $(queue).html(Argus.vision.secondaryqueues.failedclaims(response).trim());     
                    } else  {
                        $(queue).html(Argus.vision.secondaryqueues.referralqueue(response).trim());
                    }
                    Pagination.set(queue_id,this.getPagination());
                }).post();
            },
            app: function (data) {
                data = JSON.parse(data);
                if (data) {
                    $('#vision_non_contracted_queue').html(Argus.vision.secondaryqueues.nonconqueue(data['non_contracted']).trim());
                    $('#vision_failed_claims_queue').html(Argus.vision.secondaryqueues.failedclaims(data['failed_claims']).trim());
                    $('#vision_referral_required_queue').html(Argus.vision.secondaryqueues.referralqueue(data['referral_required']).trim());
                    Pagination.set('referral_required',data['referral_required'].pagination);
                    Pagination.set('failed_claims',data['failed_claims'].pagination);
                    Pagination.set('non_contracted',data['non_contracted'].pagination);
                }
            }
        },         
        training: {
            webinar: function (whichone) {
                var win = Desktop.semaphore.checkout(true);
                (new EasyAjax(whichone)).then(function (response) {
                    win._static(true)._title('Training Webinar')._open(response);
                }).get();
            }
        },
        pcpreports: {
            open: function (report,resource) {
                pcp_report = (pcp_report) ? pcp_report : Desktop.semaphore.checkout(true);
                pcp_report._title(report)._scroll(true)._open();
                (new EasyAjax(resource)).add('year',$('#report_year').val()).then(function (response) {
                    $(pcp_report.content).html(response);
                }).post();
            }
        },
        signature: {
            clear: function () {
                if (confirm('Do you wish to clear the signature and return the form to the reviewer (OD)?')) {
                    CurrentForm.clearSignature();
                }
            }
        },
        member: {
            missing: {
                remove: function (evt,id) {
                    evt.stopPropagation();
                    (new EasyAjax('/vision/member/remove')).add('id',id).then(function (response) {
                        Argus.vision.admin.refresh($E('vision-generation-failed-queue'),'generation-failed',1,15);
                    }).post();
                }
            },
            info: function (id) {
                var win = Desktop.semaphore.checkout(true);
                (new EasyAjax('/vision/member/info')).add('window_id',win.id).add('id',id).then(function (response) {
                    win._open(response);
                }).post();
            },
            remove: function (member,id,event_id) {
                if (confirm('Remove member '+member+' from the event?')) {
                    (new EasyAjax('/vision/schedule/remove')).add('id',id).add('event_id',event_id).then(function (response) {
                        $('#new-event-member-list').html(response);
                    }).post();
                }
            }, 
            importList: function () {
                importWindow = (importWindow) ? importWindow : Desktop.semaphore.checkout(true);
                importWindow._title('Member Import Window')._static(true);
                (new EasyAjax('/vision/members/importform')).then(function (response) {
                    importWindow._open(response);
                }).get();
            },
            importUpdate: function () {
                (new EasyAjax('/dashboard/home/progress').add('app','member_import')).then(function (response) {
                    if (response) {
                        var result = JSON.parse(response);
                        if (result && result.percent < 100) {
                            $('#member_import_progress_indicator').html(result.percent);
                            importTimer = window.setTimeout(Argus.vision.member.importUpdate,1000);
                        } else {
                            window.clearTimeout(importTimer);
                            importWindow._close();
                        }
                    }
                }).get();
            },
            demographics: function (member_id) {
                let ao = (new EasyAjax('/vision/members/demographics')).add('member_id',member_id);
                if ($('#client_id').val()) {
                    ao.add('client_id',$('#client_id').val());
                }
                ao.then(function (response) {
                    if (response) {
                        var data = JSON.parse(response);
                        if (data && data[0]) {
                            $("#client_id option:contains(" + data[0].group_id + ")").attr('selected', 'selected').trigger('change');
                            $('#member_address').val(data[0].address_full+', '+data[0].city+', '+data[0].state+', '+data[0].zip_code).trigger('change');
                            $('#member_name').val(data[0].last_name+', '+data[0].first_name).trigger('change');
                            $('#date_of_birth').val(moment(data[0].date_of_birth.date).format('MM/DD/YYYY')).trigger('change');
                            if (data[0].gender) {
                                $('#gender').val(data[0].gender).trigger('change');
                            }
                        } else {
                            if (data.length == 0) {
                                if (member_id.substr(member_id.length-2)==='01') {
                                    if (member_id.length >= 6) {
                                        Argus.vision.member.demographics(member_id.substr(0,memer_id.length-2));
                                    }
                                } else {
                                    $('#member_address').val('').trigger('change');
                                    $('#member_name').val('').trigger('change');
                                    $('#date_of_birth').val('').trigger('change');
                                    $('#gender').val('').trigger('change');
                                }
                            }
                        }
                    }
                }).post();
            }
        },
        search: {
            page: function (text,ipa) {
                var win = Desktop.semaphore.checkout(true);
                ipa = (ipa) ? ipa : false;
                win._title('Search...')._open();
                (new EasyAjax('/vision/consultation/searchpage')).add('ipa',ipa).add('search',text).add('window_id',win.id).then(function (response) {
                    win.set(response);
                }).post();
            },
            member: function (page,rows) {
                var search = $('#member-search-field').val();
                search = search.split(',');
                (new EasyAjax('/vision/consultation/membersearch')).add('health_plan',$('#screening_client').val()).add('page',(page)?page:1).add('rows',(rows)?rows:40).add('search',search[0]).then(function (response) {
                    var raw = {
                        "data": JSON.parse(response)
                    };
                    Pagination.set('vision-member-search',this.getPagination());
                    $('#member-search-body').html(Argus.vision.queue.member(raw));
                }).post();                
                
            },
            execute: function (search,win,page,rows,ipa) {
                var win = Desktop.window.list[win];
                ipa = (ipa) ? ipa : false;
                var mine_only = $("#search_mine_only").is(':checked') ? "Y" : "N";
                (new EasyAjax('/vision/consultation/search')).add('ipa',ipa).add('search_mine_only',mine_only).add('window_id',win.id).add('page',(page)?page:1).add('rows',(rows)?rows:20).add('search',search).then(function (response) {
                    var raw = {
                        "data": JSON.parse(response)
                    };
                    Pagination.set('vision-search-'+win.id,this.getPagination());
                    $('#search-page-body-'+win.id).html(Argus.vision.queue.search(raw));
                }).post();                
            }
        },
        archive: {
            app: function (data) {
                data = JSON.parse(data);
                if (data) {
                    
                    $('#vision-signed-queue').html(Argus.vision.queue.complete(data['signed']).trim());
                    $('#vision-archive-queue').html(Argus.vision.queue.archive(data['archive']).trim());
                    Pagination.set('signed',data['signed'].pagination);
                    Pagination.set('archive',data['archive'].pagination);
                }
            },
            refresh:  function (queue,queue_id,page,rows) {
                (new EasyAjax('/vision/queue/refresh')).add('queue_id',queue_id).add('page',page).add('rows',rows).then(function (data) {
                    Argus.singleton.set(queue_id,page);
                    var raw = {
                        "data": JSON.parse(data)
                    }
                    Pagination.set(queue_id,this.getPagination());
                    if (queue_id === 'archived') {
                        $(queue).html(Argus.vision.queue.archive(raw).trim());
                    } else {
                        $(queue).html(Argus.vision.queue.complete(raw).trim());
                    } 
                }).post();
            }
        },
        app:    function (data) {
            data = JSON.parse(data);
            if (data) {
                $('#vision_inbound_queue').html(Argus.vision.queue.bound(data['inbound']).trim());
                $('#vision_outbound_queue').html(Argus.vision.queue.bound(data['outbound']).trim());
                $('#vision_staging_queue').html(Argus.vision.queue.staging(data['staging']).trim());
                Pagination.set('staging',data['staging'].pagination);
                Pagination.set('inbound',data['inbound'].pagination);
                Pagination.set('outbound',data['outbound'].pagination);
            }
        },
        refresh:  function (queue,queue_id,page,rows) {
            (new EasyAjax('/vision/queue/refresh')).add('queue_id',queue_id).add('page',page).add('rows',rows).then(function (data) {
                Argus.singleton.set(queue_id,page);
                var raw = {
                    "data": JSON.parse(data)
                }
                Pagination.set(queue_id,this.getPagination());
                if (queue_id == 'staging') {
                    $(queue).html(Argus.vision.queue.staging(raw).trim());
                } else if (queue_id === 'unassigned') {
                    $(queue).html(Argus.vision.queue.unassigned(raw).trim());
                } else if ((queue_id == 'signed' )|| (queue_id == 'archived' )) {
                    $(queue).html(Argus.vision.queue.archive(raw).trim());
                } else if ( queue_id=='subipa'){
                    $(queue).html(Argus.vision.queue.subipa(raw).trim());
                } else if ( queue_id=='mainipa'){
                    $(queue).html(Argus.vision.queue.mainipa(raw).trim());
                } else if ( queue_id=='npival'){
                    $(queue).html(Argus.vision.queue.npival(raw).trim());
                } else if ( queue_id=='batchsearch'){
                    $(queue).html(Argus.vision.queue.batchsearch(raw).trim());
                } else {
                    $(queue).html(Argus.vision.queue.bound(raw).trim());
                }
            }).post();
        },
        batrefresh:  function (queue,queue_id,page,rows,evdate,evloc) {
            (new EasyAjax('/vision/queue/refreshbat')).add('queue_id',queue_id).add('page',page).add('rows',rows).add('evdate',evdate).add('evloc',evloc).then(function (data) {
                Argus.singleton.set(queue_id,page);
                var raw = {
                    "data": JSON.parse(data)
                }
                Pagination.set(queue_id,this.getPagination());
                $(queue).html(Argus.vision.queue.batchsearch(raw).trim());
            }).post();
        },
        //batch save based upon event date and address (and possible member id if for single)
        batchtest: function (memid,evdate,evloc,evnum) {
            if (evloc.includes('#')) {
                evloc= evloc.replace('#','{HASH}');
            }
            if (evloc.includes('&')) {
                evloc= evloc.replace('&','{AND}');
            }
            window.open('/vision/campaign/battest?memid='+memid+'&evdate='+evdate+'&evloc='+evloc+'&evid='+evnum);
        },
        //batch save based upon event id
        batcheventid: function (eventid) {
            window.open('/vision/campaign/batevid?event_id='+eventid);
        },
        consultation: {
            uploadWindow:   false,
            active:         false,
            get:            function (print,tag,form_id,window_id,user_id,doctor,pcp_staff,pcp,IPA) {
                return ConsultationForms[tag] ? ConsultationForms[tag] : (ConsultationForms[tag] = Object.create(ConsultationForm, { "print": { "value": (print) ? true : false }, "tag": { "value": tag }, "form_id": { "value": form_id },"window_id": { "value": window_id },   "user_id": { "value": user_id }, "IPA" : { "value": IPA }, "doctor": { "value": doctor }, "pcp_staff": { "value": pcp_staff  }, "pcp": { "value": pcp  }   } ));
            },
            note: {
                leave: function () {
                    var val = '';
                    if (val = prompt('Private Note',$('#private_note').val())) {
                        (new EasyAjax('/vision/consultation/save')).add('id',CurrentForm.form_id).add('private_note',val).then(function (response) {
                            $('#private_note').val(val);
                        }).post();
                    }
                }
            },            
            member: {
                load:           function (id) {
                    (new EasyAjax('/vision/members/data')).add('id',id).then(function (response) {
                        var data = JSON.parse(response);
                    }).post();
                }                
            },
            lock: {
                toggle: function (toggle) {
                    var unlocked = (toggle.src.indexOf('unlock') != -1);
                    if (unlocked) {
                        toggle.src = '/images/vision/lock.png';
                    } else {
                        toggle.src = '/images/vision/unlock.png';
                    }
                    $('#form_locked').val(unlocked ? 'Y' : 'N').trigger('change');
                    $('#address_id_combo').attr('readonly',unlocked);
                    $('#ipa_id_combo').attr('readonly',unlocked);
                    $('#location_id_combo').attr('readonly',unlocked);
                    $('#npi_id_combo').attr('readonly',unlocked);
                }
            },
            event:          function () {
                Argus.vision.consultation.uploadWindow = (Argus.vision.consultation.uploadWindow) ? Argus.vision.consultation.uploadWindow : Desktop.semaphore.checkout(true);
                Argus.vision.consultation.uploadWindow._title('Event Member Upload')._static(true)._scroll(false);
                (new EasyAjax('/vision/members/uploadform')).add('window_id',Argus.vision.consultation.uploadWindow.id).then(function (response) {
                    Argus.vision.consultation.uploadWindow._open(response);
                }).post();
            },
            print: function (form_id) {
                window.event.stopPropagation();
                var form_window = window.open();
                if (form_window) {
                    (new EasyAjax('/vision/consultation/print')).add('id',form_id).then(function (response) {
                        form_window.document.write(response);
                    }).post();
                } else {
                    alert('failed to open window');
                }
            },
            refer: function () {
                var reason = prompt('Reason for administration referral?');
                if (reason) {
                    (new EasyAjax('/vision/consultation/refer')).add('form_id',CurrentForm.form_id).add('reason',reason).add('current_status',CurrentForm.data.status).then(function () {
                        Desktop.window.list[CurrentForm.window_id]._close();
                    }).post();
                }
            },
            returnReferral: function () {
                if (confirm("Would you like to return this form to the referrer?")) {
                    (new EasyAjax('/vision/consultation/resolve')).add('form_id',CurrentForm.form_id).then(function () {
                        Desktop.window.list[CurrentForm.window_id]._close();
                        Argus.dashboard.socket.emit('messageRelay',{ 'message': 'VisionClaimReady'} );
                    }).post();
                }
            },
            referred: function (id) {
                window.event.stopPropagation();
                if (confirm("This form has been referred to the HealthPlan/PCP?")) {
                    //set referred to 'Y' and then call the refresh
                    (new EasyAjax('/vision/consultation/referred')).add('form_id',id).then(function (response) {
                        Argus.vision.admin.refresh($E('vision_referral_required_queue'),'referral_required',1,15);
                    }).post();
                }
            },
            generate: {
                reports:    function (event_id) {
                    if (confirm('Run batch reports?')) {
                        
                        //run check here to see if any reports were completed at the moment (length of array>0
                        
                        //if yes (length>0)
                        //continue with batch run
                        //else
                        //give alert stating no files have been completed at this moment.  Please complete then try again.
                        
                        
                        var ddd= jQuery.ajax({
                        type: "GET",
                        url: '/scheduler/events/didthebatch',
                        dataType: 'json',
                        responseType: 'text',
                        data: ({  eventid: event_id}),
                        success: function (obj, textstatus) {
                            try {
                                if(obj[0].didmakebatch=='N'){
                                    
                                    //do batch
                                    Argus.vision.consultation.generate.reportsparttwo(event_id);
                                } else {
                                    //do confirm then do batch
                                    if (confirm('A report has already been created.  Are you sure you want to create a new report?')) {
                                        Argus.vision.consultation.generate.reportsparttwo(event_id);
                                    }
                                }
                            } catch(err) {
                                console.log(err);
                            }
                        },
                        error: function(XMLHttpRequest, textStatus, errorThrown) { 
                            console.log(errorThrown);
                            }       
                        });
                    }
                },
                reportsparttwo: function (event_id) {
                    (new EasyAjax('/scheduler/events/getnpiinfotwo')).add('id', event_id).then(function (response) {

                        var data = JSON.parse(response);
                         
                        var businessname=data[0].location_id;
                        var eventtime=data[0].start_time;
                        var eventdate=data[0].start_date;
                    
                        var loc=data[0].screening_location;
                        
                        var city='';
                        if (loc){
                            var sploc=loc.split(',');

                            if (sploc.length>0){
                                city=sploc[1];
                            }
                        }
                        var healthplan=data[0].health_plan;
                        var ccc= jQuery.ajax({
                            type: "GET",
                            url: '/vision/event/reports',
                            responseType: 'text',
                            dataType: 'json',
                            data: ({  eventid: event_id, businessname: businessname, eventtime:eventtime, eventdate:eventdate, city:city, healthplan:healthplan }),
                            success: function (obj, textstatus) {
                                try {
                                   if (obj.length>0) {
                                        var ddd= jQuery.ajax({
                                        type: "GET",
                                        url: '/scheduler/events/setthebatch',
                                        data: ({  eventid: event_id}),
                                        success: function (obj, textstatus) {
                                            try {

                                            } catch (err){
                                                console.log(err);
                                            }
                                        },
                                        error: function(XMLHttpRequest, textStatus, errorThrown) { 
                                            console.log(errorThrown);
                                                //alert("Status: " + textStatus); alert("Error: " + errorThrown); 
                                            }       
                                        });
                                        alert("The file is currently being emailed to the user associated with this account.  It shall arrive in a few minutes.");
                                    } else {
                                        alert("No files have been completed for this event.  Please check that at least one form has been completed and then try again.");
                                    }
                                } catch (err) {  }
                            },
                            error: function (XMLHttpRequest, textStatus, errorThrown) {  }       
                            });
                        }).get();
                },
                singlereport: function (member_id, event_date, event_location, event_id) {
                    if (confirm('Create single report?')) {
                        var ddd= jQuery.ajax({
                            type: "GET",
                            url: '/vision/consultation/didthebatch',
                            dataType: 'json',
                            responseType: 'text',
                            data: ({  eventid: event_id, eventdate:event_date, eventlocation:event_location, memberid:member_id}),
                            success: function (obj, textstatus) {
                                try {
                                    if (obj[0].didmakebatch=='N') {

                                        //do batch
                                        Argus.vision.consultation.generate.singlereportparttwo(member_id, event_date, event_location, event_id);
                                    } else {
                                        //do confirm then do batch
                                        if (confirm('A report has already been created for this member.  Create a new report?')) {
                                            Argus.vision.consultation.generate.singlereportparttwo(member_id, event_date, event_location, event_id);
                                        }
                                    }
                                } catch (err) {
                                    console.log(err);
                                }
                            },
                            error: function (XMLHttpRequest, textStatus, errorThrown) { 
                                console.log(errorThrown);
                            }       
                        });
                    }
                },
                singlereportparttwo: function (member_id, event_date, event_location, event_id) {
                    (new EasyAjax('/scheduler/events/getnpiinfotwo')).add('id', event_id).then(function (response) {

                        var data = JSON.parse(response);
                         
                        var businessname=data[0].location_id;
                        var loc=data[0].screening_location;
                        
                        var city='';
                        if (loc){
                            var sploc=loc.split(',');
                            if (sploc.length>0){
                                city=sploc[1];
                            }
                        }
                        var healthplan=data[0].health_plan;
                    
                        var ccc= jQuery.ajax({
                                type: "GET",
                                url: '/vision/event/singlereport',
                                data: ({  eventid: event_id, eventdate:event_date, eventlocation:event_location, memberid:member_id, city:city, healthplan:healthplan, businessname:businessname}),
                                success: function (obj, textstatus) {                            
                                    try {
                                        var ddd= jQuery.ajax({
                                        type: "GET",
                                        url: '/vision/consultation/setthebatch',
                                        data: ({  eventid: event_id, eventdate:event_date, eventlocation:event_location, memberid:member_id}),
                                        success: function (obj, textstatus) {
                                            try {

                                            } catch(err) {
                                                console.log(err);
                                            }
                                        },
                                        error: function(XMLHttpRequest, textStatus, errorThrown) { 
                                            console.log(errorThrown);
                                                //alert("Status: " + textStatus); alert("Error: " + errorThrown); 
                                            }       

                                        });
                                    } catch(err) {  }
                                },
                                error: function(XMLHttpRequest, textStatus, errorThrown) { 
                                    console.log(errorThrown);
                                }       
                        });  
                    }).get();
                        alert("The file is currently being emailed to the user associated with this account.  It shall arrive in a few minutes.");
                },
                forms:  function (event_id) {
                    if (($('#screening_od_'+event_id).val() || $('#screening_technician_'+event_id).val()) && confirm('Generate the forms for the event?')) {
                        (new EasyAjax('/vision/event/generate')).add('event_id',event_id).then(function (response) {
                            alert('finished!');
                        }).post();
                    } else {
                        alert("Prior to generating the forms, please assign either the technician or the O.D.");
                    }
                }
            },
            upload: function () {
            },
            create: function () {
                //if (confirm('Do you wish to create a new consultation?')) {
                    var win = Argus.vision.consultation.active = Argus.vision.consultation.active ? Argus.vision.consultation.active : Desktop.semaphore.checkout(true);
                    //win._title('New Retina Scan Consultation')._scroll(true);
                    win._title('New Retina Consultation')._scroll(false).dock('L');
                    (new EasyAjax('/vision/consultation/new')).add('window_id',win.id).add('browse',0).then(function (response) {
                        win._open(response);
                        win.resize = (function (win) {
                            return function () {
                                $('#vision-package').height(win.content.height() - $E('vision-form-tabs').offsetHeight-5);
                            }
                        })(win);
                        win.resize();
                    }).post();
                //}
            },
            open: function (form_tag) {
                if (!form_tag) {
                    alert('There is a problem with that form, no id was passed');
                    return false;
                }
                window.event.stopPropagation();
                
                Argus.vision.consultation.active = Argus.vision.consultation.active ? Argus.vision.consultation.active : Desktop.semaphore.checkout(true);
                Argus.vision.consultation.active.resize = null;
                Argus.vision.consultation.active._static(true)._scroll(false)._title('Screening/Scanning Form');
                Argus.vision.consultation.active._open('<table style="width: 100%; height: 100%"><tr><td align="center">Loading...</td></tr></table>').dock('L');
                (new EasyAjax('/vision/consultation/open')).add('window_id',Argus.vision.consultation.active.id).add('browse',1).add('tag',form_tag).then(function (response) {
                    Argus.vision.consultation.active.set(response);
                    Argus.vision.consultation.active.resize = (function (win) {
                        return function () {
                            $('#vision-package').height(win.content.height() - $E('vision-form-tabs').offsetHeight-5);
                        }
                    })(Argus.vision.consultation.active);
                    Argus.vision.consultation.active.close = (function (win) {
                        return function () {
                            $('#event_date').datepicker('hide');
                            $('#date_of_birth').datepicker('hide');
                            return true;
                        }
                    })(Argus.vision.consultation.active);
                    Argus.vision.consultation.active.resize();
                }).post();   
            },
            remove: function (form_tag) {
                Desktop.stopPropagation(window.event);
                if (confirm("Do you wish to discard the screening form?")) {
                    (new EasyAjax('/vision/consultation/discard')).add('tag',form_tag).then(function (response) {
                        Argus.vision.refresh($E('vision_staging_queue'),'staging',1,14);
                    }).post();
                }
            },
            lookup: function (window_id) {
                (new EasyAjax('/vision/consultation/lookup')).add('member_id',$('#member_id').val()).then(function (response) {
                    var data = JSON.parse(response);
                    if (data && data.length) {
                        if (data.length > 1) {
                            alert('More than one result returned');
                        } else {
                            for (var i=0; i<data.length; i++) {
                                if (data[i].date_of_birth) {
                                    var dob = data[i].date_of_birth.split('-');
                                    $('#date_of_birth').val(dob[1]+'/'+dob[2]+'/'+dob[0]).change();
                                }
                                $('#member_id').val(data[i].member_id).change();
                                $('#member_name').val(data[i].member_name).change();
                                $('#member_address').val(data[i].member_address).change();
                                $('#primary_doctor').val(data[i].pcp).change();
                                $('#fbs').val(data[i].fbs).change();
                                $('#hba1c').val(data[i].a1c).change();
                                if (data[i].type_one) {
                                    $('#type_1dm').prop("checked", true).change();
                                    $('#type_2dm').prop("checked", false).change();
                                    if (data[i].controlled) {
                                        $('#dm_type_controlled').prop("checked", true).change();
                                    } else if (data[i].uncontrolled) {
                                        $('#dm_type_uncontrolled').prop("checked", true).change();
                                    }
                                    $('#type_1yrs').val(data[i].yrs_diabetic).change();
                                    $('#type_2yrs').val("").change();
                                    $('#dm_type_2_unknown').prop("checked", true).change();
                                } else if (data[i].type_two) {
                                    $('#type_2dm').prop("checked", true).change();
                                    $('#type_1dm').prop("checked", false).change();
                                    if (data[i].controlled) {
                                        $('#dm_type_2_controlled').prop("checked", true).change();
                                    } else if (data[i].uncontrolled) {
                                        $('#dm_type_2_uncontrolled').prop("checked", true).change();
                                    }
                                    $('#type_2yrs').val(data[i].yrs_diabetic).change();
                                    //set values in 1 to null
                                    $('#type_1yrs').val("").change();
                                    $('#dm_type_unknown').prop("checked", true).change();
                                }
                            }
                        }
                    } else {
                        alert('No match on member id');
                    }
                }).post();
            },
            memberLookup: function () {
                if ($('#screening_client').val()) {
                    (new EasyAjax('/vision/consultation/members')).add('search',$('#member_name').val()).then(function (response) {
                        var win = Desktop.semaphore.checkout(true);
                        win._title('Member Lookup')._scroll(true)._open(response);
                    }).post();
                } else {
                    alert("Please select a Health Plan first");
                }
            },
            namelookup: function (window_id) {
                (new EasyAjax('/vision/consultation/namelookup')).add('member_name',$('#member_name').val()).then(function (response) {
                    var data = JSON.parse(response);
                    if (data && data.length) {
                        if (data.length > 1) {
                            alert('More than one result returned');
                        } else {
                            for (var i=0; i<data.length; i++) {
                                if (data[i].date_of_birth) {
                                    var dob = data[i].date_of_birth.split('-');
                                    $('#date_of_birth').val(dob[1]+'/'+dob[2]+'/'+dob[0]).change();
                                }
                                $('#member_id').val(data[i].member_id).change();
                                $('#member_name').val(data[i].member_name).change();
                                $('#member_address').val(data[i].member_address).change();
                                $('#primary_doctor').val(data[i].pcp).change();
                                $('#fbs').val(data[i].fbs).change();
                                $('#hba1c').val(data[i].a1c).change();
                                if (data[i].type_one) {
                                    $('#type_1dm').prop("checked", true).change();
                                    $('#type_2dm').prop("checked", false).change();
                                    if (data[i].controlled) {
                                        $('#dm_type_controlled').prop("checked", true).change();

                                    } else if (data[i].uncontrolled) {
                                        $('#dm_type_uncontrolled').prop("checked", true).change();
                                    }
                                    $('#type_1yrs').val(data[i].yrs_diabetic).change();
                                    $('#type_2yrs').val("").change();
                                    $('#dm_type_2_unknown').prop("checked", true).change();
                                } else if(data[i].type_two) {
                                    $('#type_2dm').prop("checked", true).change();
                                    $('#type_1dm').prop("checked", false).change();
                                    if (data[i].controlled) {
                                         $('#dm_type_2_controlled').prop("checked", true).change();
                                    } else if (data[i].uncontrolled) {
                                        $('#dm_type_2_uncontrolled').prop("checked", true).change();
                                    }
                                    $('#type_2yrs').val(data[i].yrs_diabetic).change();
                                    $('#type_1yrs').val("").change();
                                    $('#dm_type_unknown').prop("checked", true).change();
                                }
                            }
                        }
                    } else {
                        alert('No match on member name');
                    }
                }).post();
            },
            npilookup: function (window_id) {
               (new EasyAjax('/vision/consultation/npilookup')).add('npi_id',$('#npi_id').val()).then(function (response) {
                    var data = JSON.parse(response);
                    if (data && data.length) {
                        if (data.length > 1) {
                            alert('More than one result returned');
                            for (var i=0; i<data.length; i++) {
                            }
                        } else {
                            for (var i=0; i<data.length; i++) {
                                $('#npi_id').val(data[i].npi_id).change();                
                                $('#address_id').val(data[i].location).change(); //event
                            }
                        }
                    } else {
                        alert('No match on NPI number');
                    }
                }).post();   
            },
            newnpilookup: function (window_id,theid) {
                (new EasyAjax('/vision/consultation/npifinder')).add('window_id',window_id).add('theid',theid).then(function (response) {
                    var win = Desktop.semaphore.checkout(true);
                    win._title('The Events')._scroll(true)._open(response);
                }).post();
            },
            eventlookup: function (window_id) {
               (new EasyAjax('/vision/consultation/eventlookup')).add('location',$('#address_id').val()).then(function (response) {
                    var data = JSON.parse(response);
                    if (data && data.length) {
                        if (data.length > 1) {
                            alert('More than one result returned');
                        } else {
                            for (var i=0; i<data.length; i++) {
                                $('#npi_id').val(data[i].npi_id).change();                
                                $('#address_id').val(data[i].location).change(); //event
                            }
                        }
                    } else {
                        alert('No match on Event Location');
                    }
                }).post();   
            },
            //aaron possible takeout
            test: function () {
                var win = Desktop.semaphore.checkout(true);
                Argus.vision.scan_window = win;
                (new EasyAjax('/vision/consultation/oddefine')).add('window_id',Argus.vision.scan_window.id).then(function (response) {
                    win._title('O.D. default values')._scroll(true)._open(response);
                }).post();
            },
            odsave: function(od_id, iop_od, iop_os, ta_tp, dilation){
                var bbb= jQuery.ajax({
                    type: "GET",
                    url: '/vision/consultation/odget',
                    dataType: 'json',
                    data: { 
                        selectedorder: od_id 
                    },
                    success: function (obj, textstatus) {
                        var submax = 0;
                        //number of total sub
                        var theid = 0;
                        try {
                            theid = obj[0].id;  
                        } catch (err) {
                            
                        }
                        var ts = (new EasyAjax('/vision/consultation/odsave')).add('od_id',od_id).add('iop_od',iop_od).add('iop_os',iop_os).add('ta_tp',ta_tp).add('dilation',dilation);
                        
                        if (theid != 0) {
                            ts.add('id',theid);    
                        }
                        ts.then(function () {
                            
                        }).post(); 
                    },
                    error: function(XMLHttpRequest, textStatus, errorThrown) { 
                            alert("Status: " + textStatus); alert("Error: " + errorThrown); 
                    } 
                });
            }, 
            complete: function (form_id, window_id) {
                (new EasyAjax('/vision/consultation/status')).add('id',form_id).add('status','C').then(function (response) {
                    Desktop.window.list[window_id]._close();
                }).post();
            },
            return: function (form_id) {
                window.event.stopPropagation();
                if (confirm("Return encounter "+form_id+" to O.D?")) {
                    (new EasyAjax('/vision/consultation/return')).add('form_id',form_id).then(function (response) {
                        Argus.vision.refresh($E('vision-signed-queue'),'signed',1,20);
                    }).post();
                }
            }
        },
        queue: {
            bound:      false,
            staging:    false,
            archive:    false,
            npival:     false,
            batchsearch:false,
            search:     false,
            member:     false,
            prime: function (queue,queue_id,page,rows) {
                Argus.singleton.set(queue_id,page);
            },
            refresh: function () {
                (new EasyAjax('/vision/queue/refresh')).add('staging',1).add('inbound',1).add('outbound',1).add('page',1).add('rows',14).then(function (data) {
                    Argus.vision.app(data);
                }).post();
            }
        },
        comment: {
            post: function (form_id,window_id) {
                var comment = $('#vision_form_comments').val();
                if (comment) {
                    var ao = new EasyAjax('/vision/consultation/comment');
                    if ($('#form_comment_id').val()) {
                        ao.add('id',$('#form_comment_id').val());
                    }
                    ao.add('form_id',form_id).add('comment',comment).then(function (response) {
                        $('#comment_area').html(response);
                        $('#form-comment-layer').css('display','none');
                        $E('vision_form_comments').value = '';
                        $E('form_comment_id').value = '';
                    }).post();
                }
            },
            oldpost: function (form_id,window_id) {
                var comment = $('#vision_form_comments').val();
                if (comment) {
                    (new EasyAjax('/vision/consultation/oldcomment')).add('form_id',form_id).add('comment',comment).then(function (response) {
                        $('#comment').val(response);
                        $('#form-comment-layer').css('display','none');
                        $E('vision_form_comments').value = '';
                    }).post();
                }
            },            
            edit: function (comment_id) {
                window.event.stopPropagation();
                (new EasyAjax('/vision/consultation/editComment')).add('id',comment_id).then(function (response) {
                    var comment = JSON.parse(response);
                    $('#form_comment_id').val(comment_id);
                    $('#vision_form_comments').val(comment.comment);
                    $('#form-comment-layer').css('display','block');                    
                }).post();
            },
            remove: function (form_id,comment_id) {
                window.event.stopPropagation();
                if (confirm("Remove that comment?")) {
                    (new EasyAjax('/vision/consultation/removeComment')).add('form_id',form_id).add('id',comment_id).then(function (response) {
                        $('#comment_area').html(response);
                    }).post();
                }
            }
        },
        scan: {
            attach: function (form_id,window_id) {
                $('#upload-controls-spinner').css('display','block');
                $('#upload-controls').css('display','none');
                Argus.tools.encryptFiles($E("form-scan-image"),function (files) {
                
                    (new EasyAjax('/vision/retina/encryptedscans')).add('scans',JSON.stringify(files)).add('form_id',form_id).then(function (response) {
                        $('#form-scan-list').html(response);
                        $('#upload-controls').css('display','block');
                        $('#upload-controls-spinner').css('display','none');
                        $('#scan_upload_layer').css('display','none');
                        Desktop.window.list[window_id]._scroll(true);
                    }).post();  
                });
            },
            analyze: function (form_id,scan_id) {
                Argus.vision.scan_window = (Argus.vision.scan_window) ? Argus.vision.scan_window : Desktop.semaphore.checkout(true);
                Argus.vision.scan_window._scroll(false)._static(true)._title('Retina Scan').dock('R');
                (new EasyAjax('/vision/retina/analyze')).add('window_id',Argus.vision.scan_window.id).add('form_id',form_id).add('scan_id',scan_id).then(function (response) {
                    Argus.vision.scan_window._open(response);
                }).post();                      
            },
            remove: function (window_id,form_id,scan_id) {
                Desktop.stopPropagation(window.event);
                if (confirm("Do you wish to remove the scan from the form?")) {
                    (new EasyAjax('/vision/retina/remove')).add('form_id',form_id).add('window_id',window_id).add('scan_id',scan_id).then(function (response) {
                        $('#form-scan-list').html(response);
                    }).post();
                }
            }
        },
        ipa: {
            physicianqueue: false,
            refresh: function (queue,queue_id,page,rows) {
                (new EasyAjax('/vision/ipa/queue')).add('queue_id',queue_id).add('page',page).add('rows',rows).add('health_plan',$('#health_plan').val()).add('physician_npi',$('#physician_npi').val()).then(function (response) {
                    Argus.singleton.set(queue_id,page);
                    response = {
                        "data": JSON.parse(response)
                    };
                    $(queue).html(Argus.vision.ipa.physicianqueue(response).trim());
                    Pagination.set(queue_id,this.getPagination());
                }).post();
            },
            app: function (data) {
                data = JSON.parse(data);
                if (data) {
                    $('#ipa_physicians_queue').html(Argus.vision.ipa.physicianqueue(data['ipa_physicians']).trim());
                    Pagination.set('ipa_physicians',data['ipa_physicians'].pagination);
                }
            },
            search: function () {
                
            },
            exportData: function () {
                window.event.stopPropagation();
                window.open('/vision/ipa/export','_blank');
            }
        },
        hedis: {
            campaign: {
                snapshot: function () {
                    var win = Desktop.semaphore.checkout(true);
                    win._title('Campaign Snapshot')._scroll(true)._open();
                    (new EasyAjax('/vision/campaign/snapshot')).then(function (response) {
                        win.set(response);
                    }).post();
                },
                pdfconverter: function () {
                    var win = Desktop.semaphore.checkout(true);
                    win._title('PDF Converter')._scroll(true)._open();
                    (new EasyAjax('/vision/campaign/batchprint')).add('window_id',win.id).then(function (response) {
                        win.set(response);
                    }).post();
                }
            }
        },
        reports: function () {
            window.open('/vision/campaign/report?health_plan='+$('#healthplan').val()+'&start_date='+$('#snapshot_start_date').val()+'&end_date='+$('#snapshot_end_date').val(),'csvReport','');
        //window.open('/vision/campaign/report?start_date='+$('#snapshot_start_date').val()+'&end_date='+$('#snapshot_end_date').val(),'csvReport','');
        },
        hediscontrol: {
            redoipasub: function (){
                (new EasyAjax('/hedis/configuration/reloadipasub')).then(function (response) {
                    var data = JSON.parse(response);
                    if (data && data.length) {
                        if (data.length > 1) {
                            alert('More than one result returned');
                        } else {
                            for (var i=0; i<data.length; i++) {
                                alert(i);
                            }
                        }
                    } else {
                        //alert('No match on member id');
                    }
                }).post();
            }
        }
    }
})();
