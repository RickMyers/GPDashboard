Argus.outreach = (function () {
    let initialLoad = true;
    return {
        win:         false,
        campaign_id: false,
        listeners: {
            ref: {
                
            },
            close: function () {
                for (var i in Argus.outreach.listeners.ref) {
                    Argus.dashboard.socket.removeListener(i);
                }
                Argus.outreach.listeners.ref = { };
            },
            manage: function (campaign_id) {
                //since we are no longer relying on periodic poll, we have to "manage" our sockets per campaign... no broadcast, all selective sockets
                Argus.outreach.listeners.close();
                let f = (function (campaign_id) {
                    return function () {
                        Argus.outreach.queues.refresh(campaign_id,'unassigned');
                    }
                })(campaign_id);
                Argus.outreach.listeners.ref['campaign'+campaign_id+'MemberListUploaded'] = Argus.dashboard.socket.on('campaign'+campaign_id+'MemberListUploaded',f);
                f = (function (campaign_id) {
                    return function () {
                        Argus.outreach.queues.refresh(campaign_id,'assigned');
                        Argus.outreach.queues.refresh(campaign_id,'completed');
                    }
                })(campaign_id);
                Argus.outreach.listeners.ref['campaign'+campaign_id+'ContactCompleted'] = Argus.dashboard.socket.on('campaign'+campaign_id+'ContactCompleted',f);                
                f = (function (campaign_id) {
                    return function () {
                        Argus.outreach.queues.refresh(campaign_id,'assigned');
                        Argus.outreach.queues.refresh(campaign_id,'returned');
                    }
                })(campaign_id);
                Argus.outreach.listeners.ref['campaign'+campaign_id+'ContactReturned'] = Argus.dashboard.socket.on('campaign'+campaign_id+'ContactReturned',f);                
                f = (function (campaign_id) {
                    return function () {
                        Argus.outreach.queues.refresh(campaign_id,'assigned');
                    }
                })(campaign_id);
                Argus.outreach.listeners.ref['coordinator'+Branding.id+'Campaign'+campaign_id+'ContactsAssigned'] = Argus.dashboard.socket.on('coordinator'+Branding.id+'Campaign'+campaign_id+'ContactsAssigned',f);
                f = (function (data) {
                    console.log(data);
                    if ($E('outreach_coordinator_'+data.user_id)) {
                        $E('outreach_coordinator_'+data.user_id).style.opacity = '1.0';
                        $E('outreach_coordinator_'+data.user_id).title = "Reviewing "+data.member;
                    }
                    return true;
                });
                Argus.outreach.listeners.ref['outreachContactOpened'] = Argus.dashboard.socket.on('outreachContactOpened',f);                
                f = (function (data) {
                     console.log({closed: data});
                    if ($E('outreach_coordinator_'+data.user_id)) {
                        $E('outreach_coordinator_'+data.user_id).style.opacity = '0.3';
                        $E('outreach_coordinator_'+data.user_id).title = '';
                    }                     
                });
                Argus.outreach.listeners.ref['outreachContactClosed'] = Argus.dashboard.socket.on('outreachContactClosed',f);                
            }
        },
        init: function () {
            Argus.outreach.queues.templates.unassigned  = Handlebars.compile((Humble.template('outreach/UnassignedQueue')));            
            Argus.outreach.queues.templates.assigned    = Handlebars.compile((Humble.template('outreach/AssignedQueue')));
            Argus.outreach.queues.templates.returned    = Handlebars.compile((Humble.template('outreach/ReturnedQueue')));            
            Argus.outreach.queues.templates.completed   = Handlebars.compile((Humble.template('outreach/CompletedQueue')));            
        },
        RPC: function () {
            //all real time stuff will be set when this app is opened so nothing is needed here
        },
        queues: {
            ref: {
                unassigned: false,
                assigned:   false,
                returned:   false,
                completed:  false
            },
            templates: {
                unassigned: false,
                assigned:   false,
                returned:   false,
                completed:  false
            },
            page: {
                unassigned: { current: 1, total: false},
                assigned:   { current: 1, total: false},
                returned:   { current: 1, total: false},
                completed:  { current: 1, total: false}
            },
            status: {
                unassigned: 'N',
                assigned:   'A',
                returned:   'R',
                completed:  'C'
            },
            refresh: function (campaign_id,whichOne) {
                (new EasyAjax('/outreach/queues/refresh')).add('status',Argus.outreach.queues.status[whichOne]).add('page',Argus.outreach.queues.page[whichOne].current).add('campaign_id',campaign_id).then(function (response) {
                    $(Argus.outreach.queues.ref[whichOne]).html(Argus.outreach.queues.templates[whichOne]({ "data": JSON.parse(response) }).trim());
                    let p = this.getPagination() ;
                    $('#outreach_rows_'+whichOne).html(p.rows.from+'-'+p.rows.to+'/'+p.rows.total);
                    $('#outreach_pages_'+whichOne).html(p.pages.current+'/'+p.pages.total);
                    Argus.outreach.queues.page[whichOne].total = p.pages.total;
                    if (!initialLoad) {
//                        Argus.outreach.queues.graphs(campaign_id);
                    }
                }).post();
            },
            graphs: function (campaign_id) {
                (new EasyAjax('/outreach/queues/graphs')).add('campaign_id',campaign_id).then(function (response) {
                    $('#outreach_graph_data').html(response);
                }).post();
            },
            load: function (campaign_id) {
                Argus.outreach.queues.refresh(campaign_id,'unassigned');
                Argus.outreach.queues.refresh(campaign_id,'assigned');
                Argus.outreach.queues.refresh(campaign_id,'returned');
                Argus.outreach.queues.refresh(campaign_id,'completed');
                Argus.outreach.queues.graphs(campaign_id);
                initialLoad = false;
            }
        },
        upload: {
            form: function () {
                (new EasyAjax('/outreach/upload/form')).then(function (response) {
                    Argus.outreach.win.splashScreen(response);
                }).post();
            }
        },
        contact: {
            open: function (contact_id) {
                let win = Desktop.semaphore.checkout(true);
                (new EasyAjax('/outreach/contacts/open')).add('window_id',win.id).add('contact_id',contact_id).then(function (response) {
                    win._title('Outreach Contact')._scroll(true).dock('TL')._open(response);
                }).post();
            },
            attempt: function () {
                let evt = event;
                (new EasyAjax('/outreach/contacts/call')).add('contact_id',event.target.getAttribute('contact_id')).then(function (response) {
                    $('#outreach_attempts-'+evt.target.getAttribute('window_id')).html(response);
                }).post();                
            },
            complete: function () {
                if (confirm('Complete call for '+event.target.getAttribute('member')+'?')) {
                    let evt = event;
                    (new EasyAjax('/outreach/contacts/complete')).add('contact_id',event.target.getAttribute('contact_id')).then(function (response) {
                        Argus.dashboard.socket.emit('messageRelay',{ 'contact_id': evt.target.getAttribute('contact_id'), 'message': 'campaign'+evt.target.getAttribute('campaign_id')+'ContactCompleted' });
                        Desktop.window.list[evt.target.getAttribute('window_id')]._close();
                    }).post()
                }                
            },
            return: function () {
                if (confirm('Return the contact for '+event.target.getAttribute('member')+'?')) {
                    let evt = event;
                    (new EasyAjax('/outreach/contacts/return')).add('contact_id',event.target.getAttribute('contact_id')).then(function (response) {
                        Argus.dashboard.socket.emit('messageRelay',{ 'contact_id': evt.target.getAttribute('contact_id'), 'message': 'campaign'+evt.target.getAttribute('campaign_id')+'ContactReturned' });
                        Desktop.window.list[evt.target.getAttribute('window_id')]._close();
                    }).post()
                }                
            },
            followup: function () {
                (new EasyAjax('/outreach/contacts/followup')).add('contact_id',event.target.getAttribute('contact_id')).add('follow_up',((event.target.checked) ? 'Y' : '')).then(function (response) { }).post();
            },
            log: function () {
                if (event.keyCode === 13) {
                    let evt = event;
                    (new EasyAjax('/outreach/contacts/log')).add('contact_id',event.target.getAttribute('contact_id')).add('window_id',event.target.getAttribute('window_id')).add('log',$(event.target).val()).then(function (response) {
                        Desktop.window.list[evt.target.getAttribute('window_id')].set(response);
                    }).post();
                }                
            }
        }
    }
})();