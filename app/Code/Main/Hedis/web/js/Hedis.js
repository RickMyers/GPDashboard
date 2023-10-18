Argus.hedis = (function hedis($) {
    return {
        init: function () {
            Argus.hedis.vision.ipatemplate      = Handlebars.compile((Humble.template('hedis/HedisIPAList')));
            Argus.hedis.vision.locationtemplate = Handlebars.compile((Humble.template('hedis/HedisLocationList')));
            Argus.hedis.vision.addresstemplate  = Handlebars.compile((Humble.template('hedis/HedisAddressList')));
            (new EasyAjax('/hedis/news/list')).then(function (response) {
                $('#office-news-data').html(response);
            }).get();
        },
        article: {
            form: function() {
                let win = Desktop.semaphore.checkout(true);
                win._open()._title("Article Entry");
                (new EasyAjax('/hedis/news/form')).then(function (response) {
                    win.set(response);
                }).get();
            }
        },
        configuration: function () {
            (new EasyAjax('/hedis/configuration/home')).then(function (response) {
                $('#sub-container').html(response);
            }).get();
        },
        campaign: {
            add: function () {
                (new EasyAjax('/hedis/configuration/addcampaign')).add('category_id',1).add('campaign',$('#new_dental_campaign_name').val()).then(function (response) {
                    $('#app-dental-campaigns-body').html(response);
                }).post();
            },
            archive: function () {
                //removes a campaigns row and 
            },
            toggle: function (campaign_id,el) {
                var val = (el.checked) ? 'Y' : 'N';
                (new EasyAjax('/hedis/configuration/togglecampaign')).add('id',campaign_id).add('active',val).then(function (response) {
                    console.log(response);
                }).post();
            }
        },
        vision: {
            ipatemplate:        false,
            locationtemplate:   false,
            addresstemplate:    false,
            current: {
                client:     false,
                ipa:        false,
                location:   false,
                address:    false
            },
            client: {
                add: function () {
                    (new EasyAjax('/hedis/vision/newclient')).then(function (response) {
                        $('#desktop-lightbox').html(response).css('display','block');
                    }).post();
                }
            },
            ipa: {
                add: function () {
                    (new EasyAjax('/hedis/vision/newipa')).add('client_id',Argus.hedis.vision.current.client).then(function (response) {
                        $('#desktop-lightbox').html(response).css('display','block');
                    }).post();
                },
                edit: function (evt,id) {
                    evt.stopPropagation();
                    evt.preventDefault();
                    (new EasyAjax('/hedis/vision/editipa')).add('id',id).add('client_id',Argus.hedis.vision.current.client).then(function (response) {
                        $('#desktop-lightbox').html(response).css('display','block');
                    }).post();                    
                },
                remove: function (evt,id) {
                    evt.stopPropagation();
                    evt.preventDefault();
                    if (confirm('Delete that IPA?')) {
                        (new EasyAjax('/vision/ipa/remove')).add('client_id',Argus.hedis.vision.current.client).add('id',id).then(function (response) {
                            var raw = {
                                data: JSON.parse(response)
                            }
                            $('#ipa_list').html(Argus.hedis.vision.ipatemplate(raw).trim());
                        }).post();                    
                    }
                },
                list: function (id) {
                    if (Argus.hedis.vision.current.client) {
                        $('#vision_client_'+Argus.hedis.vision.current.client).css('color','ghostwhite');
                    }
                    $('#location_list').html(' ');
                    $('#address_list').html(' ');
                    $('#vision_client_'+id).css('color','red');
                    Argus.hedis.vision.current.client = id;
                    (new EasyAjax('/vision/ipa/list')).add('client_id',id).then(function (response) {
                        var raw = {
                            data: JSON.parse(response)
                        }
                        $('#ipa_list').html(Argus.hedis.vision.ipatemplate(raw).trim());
                    }).get();
                }
            },
            location: {
                add: function () {
                    (new EasyAjax('/hedis/vision/newlocation')).add('ipa_id',Argus.hedis.vision.current.ipa).add('client_id',Argus.hedis.vision.current.client).then(function (response) {
                        $('#desktop-lightbox').html(response).css('display','block');
                    }).post();
                },                
                edit: function (evt,id) {
                    evt.stopPropagation();
                    evt.preventDefault();
                    (new EasyAjax('/hedis/vision/editlocation')).add('ipa_id',Argus.hedis.vision.current.ipa).add('id',id).add('client_id',Argus.hedis.vision.current.client).then(function (response) {
                        $('#desktop-lightbox').html(response).css('display','block');
                    }).post();                    
                },
                remove: function (evt,id) {
                    evt.stopPropagation();
                    evt.preventDefault();
                    if (confirm('Delete that Location?')) {
                        (new EasyAjax('/vision/location/remove')).add('id',id).add('ipa_id',Argus.hedis.vision.current.ipa).then(function (response) {
                            var raw = {
                                data: JSON.parse(response)
                            }
                            $('#location_list').html(Argus.hedis.vision.locationtemplate(raw).trim());
                        }).post();                    
                    }
                },
                
                list: function (id) {
                    if (Argus.hedis.vision.current.ipa) {
                        $('#client_ipa_'+Argus.hedis.vision.current.ipa).css('color','ghostwhite');
                    }
                    $('#client_ipa_'+id).css('color','red'); 
                    $('#address_list').html(' ');
                    Argus.hedis.vision.current.ipa = id;
                    (new EasyAjax('/vision/location/list')).add('ipa_id',id).then(function (response) {
                        var raw = {
                            data: JSON.parse(response)
                        }
                        $('#location_list').html(Argus.hedis.vision.locationtemplate(raw).trim());
                    }).get();                    
                }
            },
            address: {
                add: function () {
                    (new EasyAjax('/hedis/vision/newaddress')).add('location_id',Argus.hedis.vision.current.location).add('ipa_id',Argus.hedis.vision.current.ipa).add('client_id',Argus.hedis.vision.current.client).then(function (response) {
                        $('#desktop-lightbox').html(response).css('display','block');
                    }).post();
                },
                remove: function (evt,id) {
                    evt.stopPropagation();
                    evt.preventDefault();
                    if (confirm('Delete that Address?')) {
                        (new EasyAjax('/vision/addresses/remove')).add('location_id',Argus.hedis.vision.current.location).add('ipa_id',Argus.hedis.vision.current.ipa).add('client_id',Argus.hedis.vision.current.client).add('id',id).then(function (response) {
                            var raw = {
                                data: JSON.parse(response)
                            }
                            $('#address_list').html(Argus.hedis.vision.addresstemplate(raw).trim());
                        }).post();                    
                    }
                },
                edit: function (evt,id) {
                    evt.stopPropagation();
                    evt.preventDefault();
                    if (Argus.hedis.vision.current.address) {
                        $('#ipa_location_address_'+Argus.hedis.vision.current.address).css('color','ghostwhite');
                    }
                    $('#ipa_location_address_'+id).css('color','red');
                    Argus.hedis.vision.current.address = id;
                    (new EasyAjax('/hedis/vision/editaddress')).add('id',id).add('location_id',Argus.hedis.vision.current.location).add('ipa_id',Argus.hedis.vision.current.ipa).add('client_id',Argus.hedis.vision.current.client).then(function (response) {
                        $('#desktop-lightbox').html(response).css('display','block');
                    }).post();                     
                },
                list: function (id) {
                    if (Argus.hedis.vision.current.location) {
                        $('#ipa_location_'+Argus.hedis.vision.current.location).css('color','ghostwhite');
                    }
                    $('#ipa_location_'+id).css('color','red');                        
                    Argus.hedis.vision.current.location = id;
                    (new EasyAjax('/vision/addresses/list')).add('location_id',id).then(function (response) {
                        var raw = {
                            data: JSON.parse(response)
                        }
                        $('#address_list').html(Argus.hedis.vision.addresstemplate(raw).trim());
                    }).post();                    
                }
            }
        }
        
    }
})($);