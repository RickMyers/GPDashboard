Argus.dental = (function () {
    var signingRole = '';
    var window_id   = '';
    var form_id     = '';
    var queues = ['dental_new','dental_inprogress','dental_completed'];
    return {
        init: function () {
            Argus.teledentistry.init();                                         //Daisy chaining inits
            Argus.dental.queue.inprogress           = Handlebars.compile((Humble.template('dental/DentalInprogressQueue')));
            Argus.dental.queue.completed            = Handlebars.compile((Humble.template('dental/DentalCompletedQueue')));
            Argus.dental.hedis.hygenist.template    = Handlebars.compile((Humble.template('dental/HEDISHygenistContactCallQueue')));
            Argus.dental.hedis.hygenist.completed   = Handlebars.compile((Humble.template('dental/HEDISHygenistCompletedCallQueue')));
            Argus.dental.hedis.hygenist.counseled   = Handlebars.compile((Humble.template('dental/HEDISHygenistCounseledCallQueue')));
            Argus.dental.hedis.manager.template     = Handlebars.compile((Humble.template('dental/HEDISManagerContactCallQueue')));
            Argus.dental.hedis.manager.requested    = Handlebars.compile((Humble.template('dental/HEDISManagerCompletedCallQueue')));
            Argus.dental.hedis.manager.counseled    = Handlebars.compile((Humble.template('dental/HEDISManagerCounseledCallQueue')));
            Argus.dental.hedis.manager.template     = Handlebars.compile((Humble.template('dental/HEDISManagerContactCallQueue')));
            Argus.dental.hedis.manager.requested    = Handlebars.compile((Humble.template('dental/HEDISManagerCompletedCallQueue')));
        },
        _formId:    function (f_id) {
            if (f_id !== undefined) {
                form_id = f_id;
                return this;
            }
            return form_id;
        },
        _windowId: function (w_id) {
            if (w_id !== undefined) {
                window_id = w_id;
                return this;
            }
            return window_id;
        },
        finish: function () {

        },
        search: function (text) {
            var win = Desktop.semaphore.checkout(true);
            win._title('Search Results')._open().set('');
            (new EasyAjax('/dental/consultation/searchpage')).add('window_id',win.id).add('text',text).then(function (response) {
                win.set(response);
            }).post();
        },
        reports: function (whichOne) {
            window.open('/dental/campaigns/report?campaign_id='+$('#dental_campaign_id').val()+'&report='+whichOne+'&start_date='+$('#snapshot_start_date').val()+'&end_date='+$('#snapshot_end_date').val(),'csvReport','');
        },
        upload: {
            timer: false,
            status: function () {
                (new EasyAjax('/app/Code/Main/Dental/web/js/upload_status.json')).then(function (response) {
                    var progress = JSON.parse(response);
                    $('#dental-upload-status').html(progress.message);
                    $('#upload-progress-bar').width(progress.percent);
                    Argus.dental.upload.timer = window.setTimeout(Argus.dental.upload.status,3000);
                }).get();
            }
        },
        app:    function (data) {
            data = JSON.parse(data);
            if (data) {
                for (var i in queues) {
                    var queue = queues[i];
                    $('#'+queue+'_queue').html(Argus.dental.queue.inprogress(data[queue]).trim());
                    Pagination.set(queue,data[queue].pagination);
                }
            }
        },
        queue: {
            inprogress: false,
            completed: false,
            page: function (queue_id,page,rows) {
                Argus.singleton.set(queue_id,page);
                (new EasyAjax('/dental/queue/page')).add('queue_id',queue_id).add('page',page).add('rows',rows).then(function (data) {
                    data = JSON.parse(data);
                    $('#'+queue_id+'_queue').html(Argus.dental.queue.inprogress(data[queue_id]).trim());
                    Pagination.set(queue_id,data[queue_id].pagination);
                }).post();
            },
            init: function () {
                (new EasyAjax('/dental/queue/refresh')).then(function (data) {
                    Argus.dental.app(data);
                }).post();
            }
        },
        consultation: {
            searchresults: false,
            pin: function (role,win_id,f_id) {
                signingRole = role;
                window_id   = win_id;
                form_id     = f_id;
                Argus.dashboard.lightbox.open(Handlebars.compile((Humble.template('dental/DentalPinPrompt')).template));
                $('#user-pin-number').focus();
            },
            create: function () {
                if (confirm('Do you wish to create a new consultation?')) {
                    var win = Desktop.semaphore.checkout(true);
                    (new EasyAjax('/dental/consultation/new')).add('window_id',win.id).add('browse',0).then(function (response) {
                        win._open(response)._title('New Dental Consultation')._scroll(true);
                    }).post();
                }
            },
            open: function (consultation_form_id) {
                let w = Argus.teledentistry.windows();
                let win = w.waitingRoom ? w.waitingRoom : Desktop.semaphore.checkout(true);
                win._title('Dental Consultation')._scroll(false);
                (new EasyAjax('/dental/consultation/open')).add('window_id',win.id).add('form_id',consultation_form_id).then(function (response) {
                    win._open(response).dock('L');
                }).post();
            },
            snapshot: {
                analyze_window: false,
                analyze: function (snapshot_id) {
                    Argus.dental.consultation.snapshot.analyze_window = (Argus.dental.consultation.snapshot.analyze_window) ? Argus.dental.consultation.snapshot.analyze_window : Desktop.semaphore.checkout(true);
                    Argus.dental.consultation.snapshot.analyze_window._scroll(false)._static(true)._title('Snapshot Analyzer');
                    (new EasyAjax('/dental/snapshot/analyze')).add('window_id',Argus.dental.consultation.snapshot.analyze_window.id).add('id',snapshot_id).then(function (response) {
                        Argus.dental.consultation.snapshot.analyze_window._open(response);
                    }).post();
                }
            },
            xray: {
                analyze_window: false,
                analyze: function (xray_id) {
                    Argus.dental.consultation.xray.analyze_window = (Argus.dental.consultation.xray.analyze_window) ? Argus.dental.consultation.xray.analyze_window : Desktop.semaphore.checkout(true);
                    Argus.dental.consultation.xray.analyze_window._scroll(false)._static(true)._title('X-Ray Analyzer');
                    (new EasyAjax('/dental/xray/analyze')).add('window_id',Argus.dental.consultation.xray.analyze_window.id).add('id',xray_id).then(function (response) {
                        Argus.dental.consultation.xray.analyze_window._open(response);
                    }).post();
                }
            },
            sign: function () {
                var form_id = Argus.dental._formId();
                if ($('#user-pin-number').val()) {
                    (new EasyAjax('/dental/consultation/sign')).add('pin',$('#user-pin-number').val()).then(function (results) {
                        var pin = JSON.parse(results);
                        if (pin && pin.valid) {
                            $('#'+signingRole+'-sign-button').css('display','none');
                            $('#'+signingRole+'-signature-area').html(pin.signature);
                            $('#'+signingRole+'-signature-box').css('display','inline-block');
                            $('#'+signingRole+'_signature-'+window_id).val(pin.signature).change();
                            Argus.dashboard.socket.emit('messageRelay',{ 'message': 'dentalConsultationSigned', 'role': signingRole, 'signature': pin.signature, 'form_id': form_id })
                        } else {
                            alert('The PIN entered is incorrect');
                        }
                        Argus.dashboard.lightbox.close()
                    }).post();
                } else {
                    Argus.dashboard.lightbox.close();
                }
            },
            start: function (form_id) {
                if (form_id) {
                    (new EasyAjax('/dental/consultation/status')).add('form_id',form_id).add('status','A').then(function (response) {
                        Argus.dashboard.socket.emit('messageRelay',{ "form_id": form_id, "message": 'dentalConsultationStatusChange' });
                    }).post();
                }
            },
            end: function (form_id) {
                if (form_id) {

                }
            },
            print: function (form_id) {
                var win = window.open("/dental/consultation/print?form_id="+form_id, '_blank');
                win.focus();
            },
            search: function (text) {
                var win = Desktop.semaphore.checkout(true);
                win._title('Search Results')._open().set('');
                (new EasyAjax('/dental/consultation/tdsearchpage')).add('window_id',win.id).add('text',text).then(function (response) {
                    win.set(response);
                }).post();                
            }
        },
        scan: {
            attach: function (form_id,window_id) {
                (new EasyAjax('/dental/mouthwatch/scan')).addFiles('scan',$E("dental-form-scan-image-"+window_id)).add('window_id',window_id).add('form_id',form_id).then(function (response) {
                    $('#dental-form-scan-list-'+window_id).html(response);
                    $('#dental-scan-upload-layer-'+window_id).css('display','none');
                    Desktop.window.list[window_id]._scroll(true);
                }).post();
            },
            analyze: function (form_id,scan_id) {
                var win = Desktop.semaphore.checkout(true);
                win._title('Mouthwatch Image')._scroll(false);
                (new EasyAjax('/dental/mouthwatch/analyze')).add('window_id',win.id).add('form_id',form_id).add('scan_id',scan_id).then(function (response) {
                    win._open(response);
                }).post();
            }
        },
        hygenists: false,
        hedis: {
            search: false,
            windows: {

            },
            campaign: {
                snapshot: function () {
                    var win = Desktop.semaphore.checkout(true);
                    win._title('Campaign Snapshot')._scroll(true)._open();
                    (new EasyAjax('/dental/campaigns/snapshot')).add('campaign_id',$('#dental_campaign_id').val()).add('window_id',win.id).then(function (response) {
                        win.set(response);
                    }).post();
                }
            },
            hygenist: {
                template: false,
                completed: false,
                counseled: false,
                app: function (data) {
                    data = JSON.parse(data);
                    if (data) {
                        $('#hygenist-queued-call-queue').html(Argus.dental.hedis.hygenist.template(data['queued']).trim());
                        $('#hygenist-completed-counseling-call-queue').html(Argus.dental.hedis.hygenist.counseled(data['completed-counseling']).trim());
                        $('#hygenist-completed-call-queue').html(Argus.dental.hedis.hygenist.completed(data['completed']));
                        $('#hygenist-onhold-call-queue').html(Argus.dental.hedis.hygenist.template(data['onhold']));
                        Pagination.set('hcm',data['completed'].pagination);
                        Pagination.set('hqd',data['queued'].pagination);
                        Pagination.set('hoh',data['onhold'].pagination);
                        Pagination.set('hcc',data['completed-counseling'].pagination);
                    }
                },
                refresh:  function (queue,queue_id,page,rows) {
                    (new EasyAjax('/dental/hedis/refresh')).add('campaign_id',$('#dental_campaign_id').val()).add('queue_id',queue_id).add('page',page).add('rows',rows).then(function (data) {
                        Argus.singleton.set(queue_id,page);
                        var raw = {
                            "data": JSON.parse(data)
                        }
                        Pagination.set(queue_id,this.getPagination());
                        if (queue_id == 'hcc') {
                            $(queue).html(Argus.dental.hedis.hygenist.counseled(raw).trim());
                        } else if (queue_id == 'hcm') {
                            $(queue).html(Argus.dental.hedis.hygenist.completed(raw).trim());
                        } else {
                            $(queue).html(Argus.dental.hedis.hygenist.template(raw).trim());
                        }
                    }).post();
                },
                open: function (contact_id) {
                    //we need to correlate call ids to windows, and if they open the same packet, we direct to the right window

                    if (Argus.dental.hedis.windows[contact_id]) {
                        Desktop.window.list[Argus.dental.hedis.windows[contact_id]]._tofront();
                    } else {
                        var win = Desktop.semaphore.checkout(true);
                        win.open = function () {
                            Argus.dental.hedis.windows[contact_id] = win.id;
                            (new EasyAjax('/dental/hedis/callinprogress')).add('contact_id',contact_id).add('in_progress','Y').then(function (response) { }).get();
                        }
                        win.close = function () {
                            delete Argus.dental.hedis.windows[contact_id];
                            var call_id     = $('#call_id-'+win.id).val();
                            var attempted   = $('#call_attempted-'+win.id).val();
                            (new EasyAjax('/dental/hedis/callinprogress')).add('call_id',call_id).add('call_attempted',attempted).add('contact_id',contact_id).add('in_progress','N').then(function (response) { }).get();
                            if (attempted !== 'Y') {
                                (new EasyAjax('/dental/hedis/clearcalllog')).add('call_id',call_id).then(function (response) { }).get();
                            }
                            return true;
                        }
                        win._open();
                        win._scroll(true);
                        (new EasyAjax('/dental/hedis/contact')).add('window_id',win.id).add('campaign_id',$('#dental_campaign_id').val()).add('contact_id',contact_id).then(function (response) {
                            win._title('HEDIS Contact Log');
                            win.set(response);
                        }).post();
                    }
                },
                review: function (contact_id) {
                    var win = Desktop.semaphore.checkout(true);
                    win._open();
                    win._scroll(true);
                    (new EasyAjax('/dental/hedis/view')).add('window_id',win.id).add('contact_id',contact_id).then(function (response) {
                        win._title('HEDIS Review');
                        win.set(response);
                    }).post();
                },
                language: function (user_id,cb) {
                    (new EasyAjax('/dental/hedis/language')).add('id',user_id).add(cb.name,((cb.checked) ? "Y" : "N")).then(function (response) {
                        console.log(response);
                    }).post();
                },
                member: function (member_id) {
                    var win = Desktop.semaphore.checkout(true);
                    win._open();
                    win._scroll(true);
                    (new EasyAjax('/dental/hedis/member')).add('window_id',win.id).add('member_id',member_id).then(function (response) {
                        win._title('HEDIS Member');
                        win.set(response);
                    }).post();
                },
                commitment: function (user_id,text_box) {
                    if (text_box.value.trim() !== '') {
                        (new EasyAjax('/dental/hedis/commitment')).add("id",user_id).add('hours_committed',text_box.value).then(function (response) {
                            console.log(response);
                        }).post();
                    }
                },
                returnContacts: function (campaign_id,user_id,user_name) {
                    if (confirm("Do you want to return all of "+user_name+" contacts to unassigned?")) {
                        (new EasyAjax('/dental/hedis/returncontacts')).add('user_id',user_id).add('campaign_id',campaign_id).then(function (response) {
                            $('#container').html(response);
                        }).post();
                    }
                }
            },
            manager: {
                template: false,
                requested: false,
                counseled: false,
                onhold: {
                    giveback: function () {
                        if (confirm('Do you wish to return all of the contacts currently on hold back to the assigned hygienist?')) {
                            (new EasyAjax('/dental/manager/return')).then(function (response) {
                                   Argus.dental.hedis.manager.refresh($E('manager-onhold-call-queue'),'oh',1,14);
                                   Argus.dental.hedis.manager.refresh($E('manager-queued-call-queue'),'qd',1,14);
                            }).post();
                        }
                    },
                    recall: function () {
                        if (confirm('Do you wish to recall all of the contacts currently on hold back to the unassigned queue for reassignement?')) {
                            (new EasyAjax('/dental/manager/recall')).then(function (response) {
                                Argus.dental.hedis.manager.refresh($E('manager-onhold-call-queue'),'oh',1,14);
                                Argus.dental.hedis.manager.refresh($E('unassigned-call-queue'),'ua',1,14);
                            }).post();
                        }
                    }                    
                },
                claims: {
                    run: function () {
                        if (confirm("Do you want to submit current claims?\n\nIf you click yes, it will take a little time, do not move away from this screen until I tell you the claims have been batched.")) {
                            (new EasyAjax('/dental/campaigns/claim')).then(function (response) {
                                alert("Ok, continue being your usual awesome self, I'm done!");
                            }).post()
                        }
                    }
                },
                refresh: function (queue,queue_id,page,rows) {
                    if ($('#dental_campaign_id').val()) {
                        (new EasyAjax('/dental/hedis/refresh')).add('campaign_id',$('#dental_campaign_id').val()).add('queue_id',queue_id).add('page',page).add('rows',rows).then(function (data) {
                            Argus.singleton.set(queue_id,page);
                            var raw = {
                                "data": JSON.parse(data)
                            }
                            Pagination.set(queue_id,this.getPagination());
                            if ((queue_id == 'ra') || (queue_id == 'cm')) {
                                $(queue).html(Argus.dental.hedis.manager.counseled(raw).trim());
                            } else {
                                $(queue).html(Argus.dental.hedis.manager.template(raw).trim());
                            }
                        }).post();
                    }
                },
                app:    function (data) {
                    data = JSON.parse(data);
                    if (data) {
                        $('#unassigned-call-queue').html(Argus.dental.hedis.manager.template(data['unassigned']).trim());
                        $('#manager-queued-call-queue').html(Argus.dental.hedis.manager.template(data['queued']).trim());
                        $('#manager-onhold-call-queue').html(Argus.dental.hedis.manager.template(data['onhold']));
                        $('#manager-returned-call-queue').html(Argus.dental.hedis.manager.template(data['returned']));
                        $('#manager-requested-call-queue').html(Argus.dental.hedis.manager.requested(data['requested']));
                        $('#manager-completed-call-queue').html(Argus.dental.hedis.manager.requested(data['completed']));
                        Pagination.set('qd',data['queued'].pagination);
                        Pagination.set('ua',data['unassigned'].pagination);
                        Pagination.set('cm',data['completed'].pagination);
                        Pagination.set('oh',data['onhold'].pagination);
                        Pagination.set('ra',data['requested'].pagination);
                        Pagination.set('rt',data['returned'].pagination);
                        var hygenist;
                        for (var i=0; i<data['hygenists'].length; i++) {
                            hygenist = data['hygenists'][i];
                            if (hygenist.user_id) {
                                if (hygenist.active_calls > 0) {
                                    $('#hedis-callcenter-employee-'+hygenist.user_id).css('opacity','1.0')
                                } else {
                                    $('#hedis-callcenter-employee-'+hygenist.user_id).css('opacity','0.1');
                                }
                            }
                        }
                    }
                },
                open:   function (contact_id) {
                    var win = Desktop.semaphore.checkout(true);
                    (new EasyAjax('/dental/hedis/contactlog')).add('window_id',win.id).add('campaign_id',$('#dental_campaign_id').val()).add('contact_id',contact_id).then(function (response) {
                        win._open(response);
                    }).post();
                },
                review:   function (member_id) {
                    var win = Desktop.semaphore.checkout(true);
                    (new EasyAjax('/dental/hedis/review')).add('campaign_id',$('#dental_campaign_id').val()).add('window_id',win.id).add('member_id',member_id).then(function (response) {
                        win._open(response);
                    }).post();
                },
                assign: {
                    list: function () {
                        Argus.status('Loading Assign Consultant Display...');
                        (new EasyAjax('/dental/hedis/consultants')).add('campaign_id',$('#dental_campaign_id').val()).then(function (response) {
                            $('#container').html(response);
                            Argus.status('');
                        }).post();
                    },
                    consultant: function () {

                    }
                },
                unassigned: {
                    callqueue: function (rows,page,win) {
                        (function () {
                            rows = (rows) ? rows : 25;
                            page = (page) ? page : 1;
                            (new EasyAjax('/dental/hedis/unassignedcallqueue')).add('rows',rows).add('page',page).then(function (response) {
                                if (win) {
                                    win._close();
                                }
                                $('#unassigned-call-queue').html(response);
                            }).post();
                        })(rows,page,win);
                    }
                }
            }
        },
        archive:  {
            app: function () {
                
            }
        }
    }
 })();
