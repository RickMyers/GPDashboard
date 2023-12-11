//main
var Argus = function ($) {
    var vars = { };
    var apps = { };
    var monthChangeHandlers = [];
    return {
        apps: function (window_id,app) {
            if (app) {
                apps[window_id] = app;
            }
            //console.log(apps);
            return apps[window_id];
        },
        DateFormats: {
            short:      "MM/DD/YYYY",
            stamp:      "MM/DD/YYYY H:m:s",
            isoshort:   "YYYYMMDD",
            isolong:    "YYYY-MM-DD"
        },
        finish: function () {
           /* (new EasyAjax('/argus/user/logout')).then(function () {
                
            }).post(false);*/
        },
        claims: {
            page:   1,
            rows:   25,
            pages:  1,
            template: false,
            home: function () {
                (new EasyAjax('/argus/claims/home')).then(function (response) {
                    $('#container').html(response);
                }).get();
            },
            list: function (page) {
                if (page<1) {
                    Argus.claims.page = Argus.claims.pages;
                } else if (page > Argus.claims.pages) {
                    Argus.claims.page = 1;
                } else {
                    Argus.claims.page = page;
                }
                (new EasyAjax('/argus/claims/list')).add('year',$('#claim_year').val()).add('verified',$('#claim_status').val()).add('rows',$('#rows').val()).add('member_name',$('#claim_member_name').val()).add('provider',$('#claim_provider').val()).add('member_number',$('#claim_member_number').val()).add('event_id',$('#claim_event_id').val()).add('event_date',$('#claim_event_date').val()).add('claim_date',$('#claim_date').val()).add('page',Argus.claims.page).then(function (response) {
                    $('#claims-list-container').html(response);
                }).post();
            },
            member: function (member) {
                if (member) {
                    (new EasyAjax('/vision/members/demographics')).add('member_id',member).then(function (response) {
                        member = JSON.parse(response);
                        if (member) {
                            $('#desktop-lightbox').css('display','block').html(Argus.claims.template( member[0]).trim());
                        }
                    }).get();
                }
            },
            scan: function (evt) {
                if (evt.keyCode && (evt.keyCode == 13)) {
                    Argus.claims.list(1);
                }
            },
            services: function (button,id) {
                window.event.stopPropagation();
                button.src = (button.src.indexOf('expand')!=-1) ? '/images/dashboard/collapse.png' : '/images/dashboard/expand.png';
                if (button.src.indexOf('expand')!=-1) {
                    $('#claim_'+id+'_services').slideToggle();
                } else {
                    (new EasyAjax('/argus/claims/services')).add('claim_id',id).then(function (response){
                        $('#claim_'+id+'_services').html(response).slideToggle();
                    }).post();
                }
            },
            detail: function (id) {
                var win = Desktop.semaphore.checkout(true);
                win._title('Claim Details')._open('');
                (new EasyAjax('/argus/claims/detail')).add('window_id',win.id).add('id',id).then(function (response) {
                    win.set(response);
                }).post();
            },
            report: function () {
                window.open('/argus/claims/export?provider_id='+$('#claim_provider').val()+'&event_id='+$('#claim_event_id').val()+'&member_number='+$('#claim_member_number').val()+'&status='+$('#claim_status').val());
            },
            download: function (claim_file) {
                if (confirm("Do you wish to download file "+claim_file+"?")) {
                    window.open('/argus/claims/download?claim_file='+claim_file);
                }
            },
            batching: {
                inprogress: false,
                page:   1,
                rows:   25,
                pages:  1,
                template: false,
                list: function (page) {
                    if (page<1) {
                        Argus.claims.batching.page = Argus.claims.batching.pages;
                    } else if (page > Argus.claims.batching.pages) {
                        Argus.claims.batching.page = 1;
                    } else {
                        Argus.claims.batching.page = page;
                    }
                    (new EasyAjax('/argus/claims/available')).add('status',$('#batching_status').val()).add('client_id',$('#batching_client_id').val()).add('type',$('#batching_claim_type').val()).add('rows',$('#batching_rows').val()).add('member_name',$('#batching_member_name').val()).add('provider_id',$('#batching_provider_id').val()).add('member_number',$('#batching_member_number').val()).add('event_id',$('#batching_event_id').val()).add('page',Argus.claims.batching.page).then(function (response) {
                        var raw = {
                            'data': JSON.parse(response)
                        }
                        var d = this.getPagination();
                        $('#claims-batching-pages').html('Page '+d.pages.current+' of '+d.pages.total);
                        $('#claims-batching-rows').html('Rows '+d.rows.from+' to '+d.rows.to+' of '+d.rows.total);
                        $('#claims-batching-container').html(Argus.claims.batching.template(raw));
                    }).post();
                },
                scan: function (evt) {
                    if (evt.keyCode && (evt.keyCode == 13)) {
                        Argus.claims.batching.list(1);
                    }
                    return false;
                },
                all: function () {
                    let i;
                    let form = $E('claims-batching-form');
                    for (i in form.elements) {
                        form.elements[i].checked = (form.elements[i].type == 'checkbox');
                    }
                },
                status: function () {
                    (new EasyAjax('/claim_status.txt')).then(function (response) {
                        $('#desktop-lightbox').css('display','block').html("<table width='100%' height='100%'><tr><td style='font-size: 3em; color: ghostwhite' align='center'>Progress: "+response+"</td></tr></table>");                        
                        if (response != 'Done.') {
                            window.setTimeout(Argus.claims.batching.status,500);
                        } else {
                            window.setTimeout(function () { $('#desktop-lightbox').css('display','none').html(' '); },1000)
                        }
                    }).get();
                },
                run: function () {
                    if (Argus.connection.state && !Argus.connection.state.active) {
                        alert('Presently the connection to the Data Warehouse.\n\nPlease try again when it is re-established.');
                        return;
                    }
                    let form = $E('claims-batching-form');
                    let claims = [];
                    for (var i in form.elements) {
                        if (form.elements[i].type == 'checkbox') {
                            if (form.elements[i].checked) {
                                claims[claims.length] = form.elements[i].value;
                            } 
                        }
                    }
                    if (!Argus.claims.batching.inprogress) {
                        if (confirm('Batch and run these '+claims.length+' claims?')) {
                            Argus.claims.batching.inprogress = true;
                            window.setTimeout(Argus.claims.batching.status,500);
                            (new EasyAjax('/argus/claims/batching')).add('number',claims.length).add('claims',JSON.stringify(claims)).add('claim_type',$('#batching_claim_type').val()).then(function (response) {
                               // console.log(response);
                                Argus.claims.batching.inprogress = false;
                            }).post();
                        }
                    } else {
                        alert("A claims batching run is currently in progress, please wait until that one finishes");
                    }
                    
                },
                report: function () {
                    (new EasyAjax('/argus/claims/batchingexport')).add('verified',$('#status').val()).add('member_name',$('#claims_member_name').val()).add('provider',$('#provider').val()).add('member_number',$('#member_number').val()).add('event_id',$('#claim_event_id').val()).add('event_date',$('#claim_event_date').val()).add('claim_date',$('#claim_date').val()).then(function (response) {
                        //$('#claims-list-container').html(response);
                    }).post();
                }
            }
        },
        addMonthChangeHandler: function (f) {
            var add = true;
            for (var i in monthChangeHandlers) {
                add = add && (monthChangeHandlers[i] !== f)
            }
            if (add) {
                monthChangeHandlers[monthChangeHandlers.length] = f;
            }
        },
        runMonthChangeHandlers: function () {
            for (var i in monthChangeHandlers) {
                if (monthChangeHandlers[i]) {
                    monthChangeHandlers[i]();
                }
            }
        },
        templates: {
            list: {

            },
            load: function () {
                //(new EasyAjax('/argus/templates/load')).then(function (response) {
                 //   Argus.templates.list = JSON.parse(response);
                //}).post(false);            
            },
            fetch: function (whichOne) {
                return (Argus.templates.list[whichOne]) ? Argus.templates.list[whichOne] : { };
            },
            compile: function () {
                Argus.claims.template           = Handlebars.compile((Humble.template('argus/ClaimMember')));
                Argus.claims.batching.template  = Handlebars.compile((Humble.template('argus/AvailableClaims')));              
            }
        },
        singleton: {
            list: function () {
                var args = [];
                for (var j in vars) {
                    args[args.length] = j;
                }
                return args;
            },
            set: function (v,val) {
                vars[v] = val;
            },
            get: function (v) {
                return vars[v];
            },
            show: function () {
                console.log(vars);
            }
        },
        status: function (text) {
            if ($E('activity-bar')) {
                $E('activity-bar').innerHTML = text;
            }
        },
        connection: {
            state: false,
            timer: false,
            status: function (data) {
                Argus.connection.state = JSON.parse(data);
                $('.connection-icon').css('display','none');
                if (Argus.connection.state.active) {
                    $('#connection_on_icon').css('display','inline-block');
                } else {
                    $('#connection_off_icon').css('display','inline-block')
                }
            }
        },
        DynamicCalendars: [],
        activity: {
            recent: function (data) {

            }
        },
        tools: {
            encryptFiles: function (source,callback) {
                fileInput   = (typeof source === 'string') ? $E(source) : source;
                if (fileInput.files) {
                    files = fileInput.files;
                    let fp = { }
                    for (let i in files){ 
                        if (files[i].lastModified) {
                            fp[i] = {
                                reader: new FileReader(),
                                source: files[i].name,
                                converted: false
                            }
                        }
                    }
                    for (i in fp) {
                        fp[i].reader.readAsBinaryString(files[i]);
                        fp[i].reader.onload = (function (num) {
                                                //num num closure
                                                return function (event) {
                                                    fp[num].converted = btoa(event.target.result);
                                                    let isDone = true;
                                                    for (let j in fp) {
                                                        isDone = isDone && fp[j].converted;
                                                    }
                                                    if (isDone) {
                                                        callback(fp);
                                                    }
                                                };
                           })(i);
                    }
                }
            },
            id: function (len) {
                len = len ? len : 9;                                            //If nothing passed in, create a 9 character ID
                var alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';                    
                var id = '';
                for (var i=0; i<len; i++) {
                    id += alphabet.substr(Math.floor(Math.random() * Math.floor(26)),1);
                }
                return id;
            },
            value:  {
                set: function (form,field_id,field_name,value) {
                    form    = $E(form);
                    if (!form) {
                        return;
                    }
                    field   = $E(field_id) ? $E(field_id) : form.elements[field_name];
                    if (!field) {
//                        console.log('Missing Field: '+field_name+','+field_id);
                        return;
                    }
                    if (NodeList.prototype.isPrototypeOf(field)) {
                        if (typeof(value)=='string') {
                            value = value.toLowerCase();
                        }
                        for (var i=0; i<field.length; i++) {
                            field[i].checked = field[i].value.toLowerCase() == value;
                        }
                    } else {
                        if (field.type) {
                            switch (field.type.toLowerCase()) {
                                case "checkbox" :
                                    if ((value == 'ON') || (value == 'on')) {
                                        field.checked = true;
                                    } else {
                                        field.checked = (field.value == value);
                                    }
                                    break;
                                default : 
                                    $(field).val(value);
                                    break;
                            }
                        } else if (field.length) {
                            for (var i=0; i<field.length; i++) {
                                field[i].checked = (field[i].value == value)
                            };
                        } else {
                            var cbtitle= $E(field.id);
                            cbtitle.innerHTML=value;
                        }
                    }
                }
            },
            date: function (d) {
                return (d.length==10) ? d.substr(6)+'-'+d.substr(0,2)+'-'+d.substr(3,2) : '';
            },
            image: {
                align: function (photo) {
                    var offset;
                    if (photo.offsetWidth >= photo.offsetHeight) {
                        photo.style.height = '100%';
                        if ((offset = photo.offsetWidth - photo.parentNode.offsetWidth) > 50) {
                            photo.style.left = (-1*Math.round(offset/2))+"px";
                        }
                    } else {
                        photo.style.width = '100%';
                        if ((offset = photo.offsetHeight - photo.parentNode.offsetHeight) > 50) {
                            photo.style.top = (-1*Math.round(offset/2))+"px";
                        }
                    }
                }
            },
            toggle: function (t) {
                t.src = (t.src.indexOf('expand.png')==-1) ? "/images/dashboard/expand.png" : "/images/dashboard/collapse.png";
            }
        },
        profile: {
            visible: true,
            toggle: function () {
                $('#apps-column').css('display',(Argus.profile.visible ? 'none':'block'));
                Argus.profile.visible = !Argus.profile.visible;
                $(window).resize();
            },
            home: function () {
                Argus.status('Loading Profile...');
                (new EasyAjax('/argus/user/profile')).then(function (response) {
                    $('#container').html(response);
                    Argus.status('');
                }).post();
            },
        },
        helpers: function () {
            Handlebars.registerHelper("formatDate", function(datetime, format) {
                if (moment) {
                    format = Argus.DateFormats[format] || format;
                    return moment(datetime,'YYYY-MM-DD H:i:s').format(format);
                } else {
                    return datetime;
                }
            });    
        },
        dateAndTime: function () {
            let now = new Date();
            new DigitalClock('dashboard-clock',now.getHours(),now.getMinutes());
            EasyCalendar.create('user-calendar',now.getMonth()+1,now.getFullYear()).render({
                "controls": true,
                "callback": Scheduler.calendar.day,
                "onMonthChange": function () {
                    Scheduler.calendar.update.apply(this);
                }
            });
            let x = EasyCalendar.get('user-calendar');
            x.add('user_id',Branding.id);
            x.options.onMonthChange.apply(x);
        },
        init: function () {
            Argus.helpers();
            Desktop.init(Desktop.enable); //THIS HAS TO GO FIRST!
            Argus.resize();
            Argus.dashboard.home();
            Argus.office.info();
            Argus.dateAndTime();
            for (var namespace in Argus) {
                if (Argus[namespace].init) {
                    Argus[namespace].init();
                }
            }               
            Argus.templates.compile();
        },
        resize: function () {
            var nh     = $(window).height() - $('#status-bar').height() - $('#navigation-bar').height();
            $('#paradigm-virtual-desktop').height($(window).height()-$('#status-bar').height());
            $('#main-container').height(nh);
            $('#widgets-column').height(nh);
            $('#apps-column').height(nh);
            $('#container-column').height(nh);
            $('#container-column').width($(window).width() - $E('widgets-column').offsetWidth - $E('apps-column').offsetWidth-1);
            $('#dashboard-alerts').css('left',Math.round(($(window).width() - $E('dashboard-alerts').offsetWidth)/2)+'px');
        },
      /*  minimized: {
            renderer: function (minimizedWindows) {
                var HTML = '<center>';
                for (var i in minimizedWindows) {
                    HTML += '<img src="/images/argus/window.png" style="width: 30px; margin-left: auto; margin-right: auto; cursor: pointer; margin-bottom: 6px" title="'+minimizedWindows[i]._title()+'" onclick="Desktop.minimized.windows.restore(\''+i+'\')" />';
                    //generate HTML here
                }
                HTML += '</center>'
                $('#argus-minimized-windows').html(HTML);
            }
        },*/
        logout: {
            period: 60,
            time:   0,
            timer:  null,
            inprogress: false,
            countdown: function () {
                $("#landing-logout-countdown").html(Argus.logout.time);
                if (Argus.logout.time) {
                    Argus.logout.time--;
                    Argus.logout.timer = window.setTimeout(Argus.logout.countdown,1000);
                } else {
                    window.location.href='/index.html?message=Portal is now Offline';
                }
            }
        },
        office: {
            info: function () {
                Argus.status('Loading Office Info...');
                (new EasyAjax('/argus/office/info')).then(function (response) {
                    $('#office-alerts-data').html(response);
                    Argus.status('');
                }).post();
            }
        },
        reports: {
            fields: [],
            home: function () {
                Argus.status('Loading Reports...');
                (new EasyAjax('/argus/reports/home')).then(function (response) {
                    $('#sub-container').html(response);
                    Argus.status('');
                }).post();                
            },
            setup: function (report) {
                var win = Desktop.semaphore.checkout(true);
                (new EasyAjax('/argus/reports/setup')).add('window_id',win.id).add('namespace',$('#report_module_namespace').val()).add('report',report).then(function (response) {
                    win._title(report)._open(response);
                }).post()
            }
        },
        configuration: {
            app: function (app) {
                if (parseInt(app.getAttribute('value'))==0) {
                    (new EasyAjax('/dashboard/app/install')).add('app_id',app.getAttribute('app_id')).then(function (response) {
                        $(app).css('background-color','rgba(255,255,255,.5)');
                        app.setAttribute('value',1);
                    }).post();
                } else {
                    (new EasyAjax('/dashboard/app/uninstall')).add('app_id',app.getAttribute('app_id')).then(function (response) {
                        $(app).css('background-color','rgba(202,202,202,.15)');
                        app.setAttribute('value',0);
                    }).post();                    
                }
            },
            home: function () {
                Argus.status('Loading Configuration Home...');
                (new EasyAjax('/argus/configuration/home')).then(function (response) {
                    $('#container').html(response);
                    Argus.status('');
                }).post();
            },
            navigation:  {
                home: function () {
                    (new EasyAjax('/argus/navigation/home')).then(function (response) {
                        $('#sub-container').html(response);
                    }).post();
                },
                edit: function (option_id) {
                    (new EasyAjax('/argus/navigation/edit')).add('id',option_id).then(function (response) {
                        $('#navigation-edit-row-'+option_id).html(response);
                        $('#navigation-edit-row-'+option_id).slideToggle();
                    }).post();                    
                },
                unlink: function (option_id,navigation_id) {
                    (new EasyAjax('/argus/navigation/unlink')).add('id',option_id).add('navigation_id',navigation_id).then(function (response) {
                        $('#navigation-edit-row-'+option_id).html(response);
                    }).post();                    
                },
                update: function (nav_id) {
                    if (nav_id) {
                        (new EasyAjax('/argus/navigation/update')).add('id',nav_id).add('image',$('#navigation_image-'+nav_id).val()).add('title',$('#navigation_title-'+nav_id).val()).add('class',$('#navigation_class-'+nav_id).val()).add('style',$('#navigation_style-'+nav_id).val()).add('image_style',$('#navigation_image_style-'+nav_id).val()).add('method',$('#navigation_method-'+nav_id).val()).then(function (response) {
                            
                        }).post();
                    }
                }
            },
            reports: function () {
                Argus.status('Loading Reports Configuration...');
                (new EasyAjax('/argus/reports/configuration')).then(function (response) {
                    $('#sub-container').html(response);
                    Argus.status('');
                }).post();                
            },
            report: {
                projects: function () {
                    Argus.status('Loading Report Access...');
                    (new EasyAjax('/argus/reports/projects')).then(function (response) {
                        $('#sub-container').html(response);
                        Argus.status('');
                    }).post();                       
                },
                access: function () {
                    Argus.status('Loading Report Access...');
                    (new EasyAjax('/argus/reports/access')).then(function (response) {
                        $('#sub-container').html(response);
                        Argus.status('');
                    }).post();                         
                },
                grant: function (cb,project_id,role_id) {
                    if (cb && role_id && project_id) {
                        var action = (cb.checked) ? 'set' :'remove';
                        (new EasyAjax('/argus/reports/'+action)).add('project_id',project_id).add('role_id',role_id).then(function (response){
                            console.log(response);
                        }).post();
                    }
                },
                users: function (project_id,role_id) {
                    if (project_id && role_id) {
                        (new EasyAjax('/argus/reports/users')).add('project_id',project_id).add('role_id',role_id).then(function (response) {
                            $('#sub-container').html(response);
                        }).post();
                    }
                }
            },
            project: {
                deny: function (cb,project_id,role_id,user_id) {
                    var action = (cb.checked) ? 'remove' :'set';
                    (new EasyAjax('/argus/reports/projectaccess')).add('project_id',project_id).add('role_id',role_id).add('user_id',user_id).add('action',action).then(function (response){
                        console.log(response);
                    }).post();
                    
                }
            },
            entity: {
                home: function () {
                    (new EasyAjax('/argus/entity/home')).then(function (response) {
                        $('#sub-container').html(response);
                    }).post();
                },
                relations: {
                    open: function (entity_id) {
                        (new EasyAjax('/argus/entity/relations')).add('id',entity_id).then(function (response) {
                            $('#sub-container').html(response);
                        }).post();                        
                    }
                },
                remove: {

                    type: function (id,type) {
                        if (confirm("Do you want to remove Entity Type: "+type+"?\n\nRemoving the type will also remove any entities of that type and their relationships.")) {
                            (new EasyAjax('/argus/entity/removetype')).add('id',id).then(function () {
                                Argus.configuration.entity.home();
                            });
                        }
                    },
                    entity: function (id,name) {
                        if (confirm("Do you want to remove Entity: "+name+"?\n\nRemoving the entity will also remove any relationships the entity had.")) {
                            (new EasyAjax('/argus/entity/remove')).add('id',id).then(function () {
                                Argus.configuration.entity.home();
                            });
                        }                        
                    },
                    relationship: function (id) {
                        
                    }                    
                }
            }
        },
        scheduler: {
            month: function () {
                (new EasyAjax('/argus/scheduler/month')).then(function (response) {
                    $('#container').html(response);
                }).get();
            },
            planner: {
                fetch: function (mm,dd,yyyy) {
                    
                }
            },
            year: function () {
                
            }
        },
        counseling: {
            createCall: function () {
                var win = Desktop.semaphore.checkout(true);
                win._title('New Counseling Attempt');
                (new EasyAjax('/dental/counseling/create')).then(function (response) {
                    win._open(response);
                }).post();
            },
            uploadForm: function () {
                if ($('#dental_campaign_id').val()) {
                    var win = Desktop.semaphore.checkout(true);
                    win._title('Upload HEDIS Call Schedule');
                    (new EasyAjax('/dental/counseling/uploadform')).add('campaign_id',$('#dental_campaign_id').val()).add('window_id',win.id).then(function (response) {
                        win._open(response);
                    }).post();
                } else {
                    alert("Please choose a campaign to upload to first");
                }
            }
        },
        admin: {
            add: {
                user: function () {
                    var win = Desktop.semaphore.checkout(true);
                    win._title('Add User Form');
                    (new EasyAjax('/argus/admin/adduserform')).add('window_id',win.id).then(function (response) {
                        win._open(response);
                    }).post();
                }
            },
            reset: {
                password: function (uid) {
                    var pwd;
                    if (pwd = prompt('Set New Password','argus1234')) {
                        (new EasyAjax('/argus/user/passwordreset')).add('password',pwd).add('uid',uid).then(function (response) {
                            alert('Password Reset to '+pwd);
                        }).post();
                    }
                },
                global: function () {
                    if (confirm('WARNING!\n\nThis action will force ALL users to reset their password!\n\nAre you sure you want to do that?')) {
                        (new EasyAjax('/humble/users/resetpasswords')).then(function (response) {
                            alert(response);
                        }).post();
                    }
                }
            },
            broadcast: {
                message: function () {
                    let message = prompt('Please Enter Message Below:');
                    if (message) {
                        Argus.dashboard.socket.emit('messageRelay',{ 'message': 'broadcastMessage', 'text': message })
                    }
                }
            }
            
        },
        roles: {
            display: function () {
                Argus.status('Loading Roles Display...');
                (new EasyAjax('/argus/roles/display')).then(function (response) {
                    $('#sub-container').html(response);
                    Argus.status('');
                }).post();
            },
            remove: function (role_id,role_name) {
                if (confirm('Do you wish to delete the role "'+role_name+'"?')) {
                    (new EasyAjax('/argus/roles/delete')).add('id',role_id).then(function (response) {
                        $('#sub-container').html(response);
                    }).post();                
                }
            }
        },
        user: {
            role: function (cb,user_id,role_id) {
                if (cb && user_id && role_id) {
                    var action = (cb.checked) ? 'set' :'remove';
                    (new EasyAjax('/argus/roles/'+action)).add('user_id',user_id).add('role_id',role_id).then(function (response){
                        console.log(response);
                    }).post();
                }
            }
        },
        users: {
            starts_with: '',
            display: function (starts_with) {
                Argus.users.starts_with = starts_with;
                (new EasyAjax('/argus/user/display')).add('starts_with',starts_with).add('role_id',$('#user_role').val()).add('page',1).add('rows',15).then(function (response) {
                    $('#argus-users-display-area').html(response);
                    Pagination.set('argus-users',this.getPagination());
                }).post();
            },
            home: function () {
                Argus.status('Loading User Display...');
                (new EasyAjax('/argus/user/home')).then(function (response) {
                    $('#sub-container').html(response);
                    Argus.status('');
                }).post();
            },
            view: function (user_id) {
                var win = Desktop.semaphore.checkout(true);
                (new EasyAjax('/argus/user/view')).add('user_id',user_id).add('window_id',win.id).then(function (response) {
                    win._open(response);
                }).post();                
            }
        },
        provider: {
            recred: {
                form: function () {
                    var win = Desktop.semaphore.checkout(true);
                    (new EasyAjax('/argus/recred/form')).add('window_id',win.id).then(function (response) {
                        win._open(response);
                    }).post();                
                },
                request: function (email) {
                    (new EasyAjax('/argus/recred/request')).add('email',email).add('window_id',win.id).then(function (response) {
                        alert("Request Sent!");
                    }).post();                    
                }
            }
        },
        members: {
            home: function () {
                (new EasyAjax('/argus/members/home')).then(function (response) {
                    $('#container').html(response);
                }).get();
            }
        },
        credentialing: {
            template: false,
            archived: false,
            app: function (data) {
                if (!Argus.credentialing.template) {
                    Argus.credentialing.template = Handlebars.compile((Humble.template('argus/CredentialingQueue')));
                };
                if (!Argus.credentialing.archived) {
                    Argus.credentialing.archived = Handlebars.compile((Humble.template('argus/CredentialingArchiveQueue')));
                };                
                data = JSON.parse(data);
                if (data) {
                    $('#credentialing_inbound_queue').html(Argus.credentialing.template(data['icq']).trim());
                    $('#credentialing_processed_queue').html(Argus.credentialing.template(data['pcq']).trim());
                    $('#credentialing_archived_queue').html(Argus.credentialing.archived(data['acq']));
                    Pagination.set('icq',data['icq'].pagination);
                    Pagination.set('pcq',data['pcq'].pagination);
                    Pagination.set('acq',data['acq'].pagination);
                }
            },
            refresh: function (queue,queue_id,page,rows) {
                (new EasyAjax('/argus/credentialing/refresh')).add('queue_id',queue_id).add('page',page).add('rows',rows).then(function (data) {
                    Argus.singleton.set(queue_id,page);
                    if (!Argus.credentialing.template) {
                        Argus.credentialing.template = Handlebars.compile((Humble.template('argus/CredentialingQueue')));
                    };
                    if (!Argus.credentialing.archived) {
                        Argus.credentialing.archived = Handlebars.compile((Humble.template('argus/CredentialingArchiveQueue')));
                    };    
                    var raw = {
                        "data": JSON.parse(data)
                    };
                    Pagination.set(queue_id,this.getPagination());
                    if (queue_id == 'acq') {
                        $(queue).html(Argus.credentialing.archived(raw.data[queue_id]).trim());
                    } else {
                        $(queue).html(Argus.credentialing.template(raw.data[queue_id]).trim());
                    }
                }).post();      
            } 
        },
        online: {
            templates: {
                standard: false,
                completed: false,
                errored: false
            },
            applications: {
                fetch: function () {
                    Animate.run('online-application-fetch-icon');
                    (new EasyAjax('/argus/onlineapps/fetch')).then(function (response) {
                        alert("Response:\n\n"+response);
                        Animate.stop();
                    }).get();
                }
            },
            compile: function () {
                if (!Argus.online.templates.standard) {
                    Argus.online.templates.standard = Handlebars.compile((Humble.template('ehealth/OnlineAppsNewInprogressQueue')));
                }
                if (!Argus.online.templates.completed) {
                    Argus.online.templates.completed = Handlebars.compile((Humble.template('ehealth/OnlineAppsCompletedQueue')));
                }
                if (!Argus.online.templates.declined) {
                    Argus.online.templates.errored = Handlebars.compile((Humble.template('ehealth/OnlineAppsErroredQueue')));
                }               
            },
            app: function (data) {
                Argus.online.compile();
                data = JSON.parse(data);
                if (data) {
                    $('#online-new-application-queue').html(Argus.online.templates.standard(data['oainq']).trim());
                    $('#online-inprogress-application-queue').html(Argus.online.templates.standard(data['oaipq']).trim());
                    $('#online-completed-application-queue').html(Argus.online.templates.completed(data['oacaq']).trim());
                    $('#online-errored-application-queue').html(Argus.online.templates.errored(data['oaerr']).trim());
                    Pagination.set('oainq',data['oainq'].pagination);
                    Pagination.set('oaipq',data['oaipq'].pagination);
                    Pagination.set('oacaq',data['oacaq'].pagination);
                    Pagination.set('oaerr',data['oaerr'].pagination);
                }
            },
            refresh:  function (queue,queue_id,page,rows) {
                (new EasyAjax('/argus/onlineapps/queue')).add('queue_id',queue_id).add('page',page).add('rows',rows).then(function (data) {
                    Argus.singleton.set(queue_id,page);
                    Argus.online.compile();
                    var raw = {
                        "data": JSON.parse(data)
                    }
                    Pagination.set(queue_id,this.getPagination());
                    if (queue_id == 'oacaq') {
                        $(queue).html(Argus.online.templates.completed(raw).trim());
                    } else if (queue_id == 'oaerr') {
                        $(queue).html(Argus.online.templates.errored(raw).trim());
                    } else {
                        $(queue).html(Argus.online.templates.standard(raw).trim());
                    }
                }).post();
            },
            application: {
                view: function (app_id) {
                    var win = Desktop.semaphore.checkout(true);
                    win._open()._title('Online Application Viewer');
                    (new EasyAjax('/argus/onlineapps/view')).add('id',app_id).add('window_id',win.id).then(function (response) {
                        win.set(response);
                    }).post();
                }
            },
            authorize: function (form_id) {
                (new EasyAjax('/online/application/authorize')).add('form_id',form_id).then(function (response) {
                    alert(response);
                }).post();
            },
            capture: function (form_id) {
                (new EasyAjax('/online/application/capture')).add('form_id',form_id).then(function (response) {
                    alert(response);
                }).post            
            }        
        },
        analytics: {
            home: function () {
                (new EasyAjax('/argus/analytics/home')).then(function (response) {
                    $('#container').html(response);
                }).get();
            },
            remove: function (id) {
                if (confirm("Remove Chart From Analytics?")) {
                    (new EasyAjax('/argus/analytics/delete')).add('chart_id',id).then(function (response) {
                        $('#container').html(response);
                    }).post();
                }
            }
        }
    }

}($);
$(document).ready(function () {
    Humble.init(Argus.init);
    $(window).resize(Argus.resize);
});
