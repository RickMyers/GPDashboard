    function openCommentLayer() {
        $('#form-comment-layer').css('display','block');
        $('#comment_attach_button').css('visibility','visible');
        $E('vision_form_comments').focus();        
    }
    function setAdminOptions(data) {
        $('#form_reset_claim').css('visibility',((data.claim_status == 'E') || (data.claim_status == 'Y')) ? 'visible' : 'hidden');
        $('#release_to_pcp_portal').css('visibility',data.pcp_portal_withhold == 'Y' ? 'visible' : 'hidden');
        $('#mark_form_as_claimed_button').css('visibility',data.claim_status !== 'Y' ? 'visible' : 'hidden');
        $('#clear_signature_button').css('visibility',data.previous_status == 'C' ? 'visible' : 'hidden');
    }
    var Transitions = {
        "pcp": {
            "scanning": {
                "C": {
                    "C": {
                        "elements": {
                            "#header_section_1": {
                                "class": "form"
                            },
                            "#highlight_block_1": {
                                "class": "form"
                            },
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            ".form_input": {
                                "style": "display: none"
                            },
                            ".form_text": {
                                "style": "display: block"
                            },
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#header_signature_field": {
                                "html": "Technician: "
                            },
                            "#form_type_label": {
                                "html": "Scanning"
                            },
                            "#refer_for_administration": {
                                "style": "display: inline-block"
                            },
                            "#add_scan_button": {
                                "style": "display: none"
                            },
                            '#unscannable_option': {
                                "style": "display: block"
                            },                            
                            init: function () {
                                new EasyEdits("/edits/vision/browse","consultation_form");
                                $('.doctor_field').prop('disabled',true);
                                $('.pcp_staff').prop('disabled',true);
                                this.signature(); this.preparer();
                            }
                        }                    
                    },
                    "P": {
                        "elements": {
                            "#form_recall_button": {
                                "style": "display: none"
                            },
                            "#header_section_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_1": {
                                "class": "form-active"
                            },
                            "#vision-package": {
                                "style": "color: #000; font-size: .8em; overflow: visible"
                            },
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            ".form_input": {
                                "style": "display: none"
                            },
                            ".form_text": {
                                "style": "display: block"
                            },
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#header_signature_field": {
                                "html": "Technician: "
                            },
                            "#form_type_label": {
                                "html": "Scanning"
                            },
                            "#add_scan_button": {
                                "style": "display: none"
                            },
                            '#unscannable_option': {
                                "style": "display: block"
                            },                            
                            init: function () {
                                new EasyEdits("/edits/vision/consultation","consultation_form");
                                $('.doctor_field').prop('readonly',true);
                                this.signature(); this.preparer();
                            }
                        }                
                    }
                   }
            },
            "screening": {
                "C": {
                    "C": {
                        "elements": {
                            "#header_section_1": {
                                "class": "form"
                            },
                            "#highlight_block_1": {
                                "class": "form"
                            },
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            ".form_input": {
                                "style": "display: none"
                            },
                            ".form_text": {
                                "style": "display: block"
                            },
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#header_signature_field": {
                                "html": "Technician: "
                            },
                            "#refer_for_administration": {
                                "style": "display: inline-block"
                            },                            
                            "#form_type_label": {
                                "html": "Scanning"
                            },
                            "#add_scan_button": {
                                "style": "display: none"
                            },
                            init: function () {
                                new EasyEdits("/edits/vision/browse","consultation_form");
                                $('.doctor_field').prop('disabled',true);
                                $('.pcp_staff').prop('disabled',false);
                                this.signature(); this.preparer();
                            }
                        }                     
                    },
                    "P": {
                        "elements": {
                            "#form_recall_button": {
                                "style": "display: none"
                            },
                            "#header_section_1": {
                                "class": "form-active"
                            },
                            "#vision-package": {
                                "style": "color: #000; font-size: .8em; overflow: visible"
                            },
                            "#highlight_block_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            ".form_input": {
                                "style": "display: none"
                            },
                            ".form_text": {
                                "style": "display: block"
                            },
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#header_signature_field": {
                                "html": "Technician: "
                            },
                            "#form_type_label": {
                                "html": "Scanning"
                            },
                            "#add_scan_button": {
                                "style": "display: none"
                            },
                            init: function () {
                                new EasyEdits("/edits/vision/consultation","consultation_form");
                                $('.doctor_field').prop('readonly','readonly');
                                this.signature(); this.preparer();
                            }
                        }                    
                    }  
                }
            }
        }, 
        "IPA": {
            "scanning": {
                "C": {
                    "C": {
                        "elements": {
                            "#header_section_1": {
                                "class": "form"
                            },
                            "#highlight_block_1": {
                                "class": "form"
                            },
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            ".form_input": {
                                "style": "display: none"
                            },
                            ".form_text": {
                                "style": "display: block"
                            },
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#header_signature_field": {
                                "html": "Technician: "
                            },
                            "#form_type_label": {
                                "html": "Scanning"
                            },
                            "#refer_for_administration": {
                                "style": "display: none"
                            },
                            "#add_scan_button": {
                                "style": "display: none"
                            },
                            '#unscannable_option': {
                                "style": "display: block"
                            },                            
                            init: function () {
                                new EasyEdits("/edits/vision/browse","consultation_form");
                                $('.doctor_field').prop('disabled',true);
                                $('.pcp_staff').prop('disabled',true);
                                this.signature(); this.preparer();
                            }
                        }                    
                    },
                    "P": {
                        "elements": {
                            "#form_recall_button": {
                                "style": "display: none"
                            },
                            "#header_section_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_1": {
                                "class": "form-active"
                            },
                            "#vision-package": {
                                "style": "color: #000; font-size: .8em; overflow: visible"
                            },
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            ".form_input": {
                                "style": "display: none"
                            },
                            ".form_text": {
                                "style": "display: block"
                            },
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#refer_for_administration": {
                                "style": "display: none"
                            },                            
                            "#header_signature_field": {
                                "html": "Technician: "
                            },
                            "#form_type_label": {
                                "html": "Scanning"
                            },
                            "#add_scan_button": {
                                "style": "display: none"
                            },
                            '#unscannable_option': {
                                "style": "display: block"
                            },                            
                            init: function () {
                                new EasyEdits("/edits/vision/consultation","consultation_form");
                                $('.doctor_field').prop('readonly',true);
                                this.signature(); this.preparer();
                            }
                        }                
                    }
                   }
            },
            "screening": {
                "C": {
                    "C": {
                        "elements": {
                            "#header_section_1": {
                                "class": "form"
                            },
                            "#highlight_block_1": {
                                "class": "form"
                            },
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            ".form_input": {
                                "style": "display: none"
                            },
                            ".form_text": {
                                "style": "display: block"
                            },
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#header_signature_field": {
                                "html": "Technician: "
                            },
                            "#refer_for_administration": {
                                "style": "display: none"
                            },                            
                            "#form_type_label": {
                                "html": "Scanning"
                            },
                            "#add_scan_button": {
                                "style": "display: none"
                            },
                            '#unscannable_option': {
                                "style": "display: block"
                            },                            
                            init: function () {
                                new EasyEdits("/edits/vision/browse","consultation_form");
                                $('.doctor_field').prop('disabled',true);
                                $('.pcp_staff').prop('disabled',false);
                                this.signature(); this.preparer();
                            }
                        }                     
                    },
                    "P": {
                        "elements": {
                            "#form_recall_button": {
                                "style": "display: none"
                            },
                            "#header_section_1": {
                                "class": "form-active"
                            },
                            "#vision-package": {
                                "style": "color: #000; font-size: .8em; overflow: visible"
                            },
                            "#highlight_block_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            ".form_input": {
                                "style": "display: none"
                            },
                            ".form_text": {
                                "style": "display: block"
                            },
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#header_signature_field": {
                                "html": "Technician: "
                            },
                            "#refer_for_administration": {
                                "style": "display: none"
                            },                            
                            "#form_type_label": {
                                "html": "Scanning"
                            },
                            "#add_scan_button": {
                                "style": "display: none"
                            },
                            init: function () {
                                new EasyEdits("/edits/vision/consultation","consultation_form");
                                $('.doctor_field').prop('readonly','readonly');
                                this.signature(); this.preparer();
                            }
                        }                    
                    }  
                }
            }
        },   
        "Location": {
            "scanning": {
                "C": {
                    "C": {
                        "elements": {
                            "#header_section_1": {
                                "class": "form"
                            },
                            "#highlight_block_1": {
                                "class": "form"
                            },
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            ".form_input": {
                                "style": "display: none"
                            },
                            ".form_text": {
                                "style": "display: block"
                            },
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#header_signature_field": {
                                "html": "Technician: "
                            },
                            "#form_type_label": {
                                "html": "Scanning"
                            },
                            "#refer_for_administration": {
                                "style": "display: none"
                            },
                            "#add_scan_button": {
                                "style": "display: none"
                            },
                            '#unscannable_option': {
                                "style": "display: block"
                            },                            
                            init: function () {
                                new EasyEdits("/edits/vision/browse","consultation_form");
                                $('.doctor_field').prop('disabled',true);
                                $('.pcp_staff').prop('disabled',true);
                                this.signature(); this.preparer();
                            }
                        }                    
                    },
                    "P": {
                        "elements": {
                            "#form_recall_button": {
                                "style": "display: none"
                            },
                            "#header_section_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_1": {
                                "class": "form-active"
                            },
                            "#vision-package": {
                                "style": "color: #000; font-size: .8em; overflow: visible"
                            },
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            ".form_input": {
                                "style": "display: none"
                            },
                            ".form_text": {
                                "style": "display: block"
                            },
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#refer_for_administration": {
                                "style": "display: none"
                            },                            
                            "#header_signature_field": {
                                "html": "Technician: "
                            },
                            "#form_type_label": {
                                "html": "Scanning"
                            },
                            "#add_scan_button": {
                                "style": "display: none"
                            },
                            '#unscannable_option': {
                                "style": "display: block"
                            },                            
                            init: function () {
                                new EasyEdits("/edits/vision/consultation","consultation_form");
                                $('.doctor_field').prop('readonly',true);
                                this.signature(); this.preparer();
                            }
                        }                
                    }
                   }
            },
            "screening": {
                "C": {
                    "C": {
                        "elements": {
                            "#header_section_1": {
                                "class": "form"
                            },
                            "#highlight_block_1": {
                                "class": "form"
                            },
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            ".form_input": {
                                "style": "display: none"
                            },
                            ".form_text": {
                                "style": "display: block"
                            },
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#header_signature_field": {
                                "html": "Technician: "
                            },
                            "#refer_for_administration": {
                                "style": "display: none"
                            },                            
                            "#form_type_label": {
                                "html": "Scanning"
                            },
                            "#add_scan_button": {
                                "style": "display: none"
                            },
                            '#unscannable_option': {
                                "style": "display: block"
                            },                            
                            init: function () {
                                new EasyEdits("/edits/vision/browse","consultation_form");
                                $('.doctor_field').prop('disabled',true);
                                $('.pcp_staff').prop('disabled',false);
                                this.signature(); this.preparer();
                            }
                        }                     
                    },
                    "P": {
                        "elements": {
                            "#form_recall_button": {
                                "style": "display: none"
                            },
                            "#header_section_1": {
                                "class": "form-active"
                            },
                            "#vision-package": {
                                "style": "color: #000; font-size: .8em; overflow: visible"
                            },
                            "#highlight_block_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            ".form_input": {
                                "style": "display: none"
                            },
                            ".form_text": {
                                "style": "display: block"
                            },
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#header_signature_field": {
                                "html": "Technician: "
                            },
                            "#refer_for_administration": {
                                "style": "display: none"
                            },                            
                            "#form_type_label": {
                                "html": "Scanning"
                            },
                            "#add_scan_button": {
                                "style": "display: none"
                            },
                            init: function () {
                                new EasyEdits("/edits/vision/consultation","consultation_form");
                                $('.doctor_field').prop('readonly','readonly');
                                this.signature(); this.preparer();
                            }
                        }                    
                    }  
                }
            }
        },   
        
        "pcp_staff": {
            "scanning": {
                "A": {
                    "C": {
                        "elements": {
                            "#header_section_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            ".form_input": {
                                "style": "display: none"
                            },
                            ".form_text": {
                                "style": "display: block"
                            },
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#header_signature_field": {
                                "html": "Technician: "
                            },
                            "#form_type_label": {
                                "html": "Scanning"
                            },
                            "#refer_for_administration": {
                                "style": "display: inline-block"
                            },                            
                            "#add_scan_button": {
                                "style": "display: none"
                            },
                            "#regenerate_screening_form_button": {
                                "style": "display: block; float: right"
                            },
                            '#unscannable_option': {
                                "style": "display: block"
                            },                            
                            init: function () {
                                new EasyEdits("/edits/vision/browse","consultation_form");
                                $('.doctor_field').prop('disabled',true);
                                $('.pcp_staff').prop('disabled',false);
                                this.signature(); this.preparer();
                            }
                        }                    
                    },
                    "A": {
                        "elements": {
                            "#form_recall_button": {
                                "style": "display: none"
                            },
                            "#return_referral": {
                                "style": "display: inline-block"
                            },
                            "#header_section_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_1": {
                                "class": "form-active"
                            },
                            "#vision-package": {
                                "style": "color: #000; font-size: .8em; overflow: auto"
                            },
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            ".form_input": {
                                "style": "display: block"
                            },
                            ".form_text": {
                                "style": "display: none"
                            },
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#header_signature_field": {
                                "html": "Technician: "
                            },
                            "#form_type_label": {
                                "html": "Scanning"
                            },
                            "#add_scan_button": {
                                "style": "display: block"
                            },
                            '#unscannable_option': {
                                "style": "display: block"
                            }, 
                            '#form_admin_panel': {
                                "style": "display: inline-block"
                            },
                            init: function () {
                                new EasyEdits("/edits/vision/consultation","consultation_form");
                                $('.doctor_field').prop('disabled',true);
                                $('.pcp_staff').prop('disabled',false);
                                this.active();
                                this.signature();
                                this.preparer();
                                setAdminOptions(this.data);
                            }
                        }  
                    }
                },
                "N": {
                    "N": {
                        "elements": {
                            "#form_recall_button": {
                                "style": "display: none"
                            },
                            "#header_section_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            "#submit_for_review_button": {
                                "style": "display: block; float: right"
                            },
                            ".form_input": {
                                "style": "display: block"
                            },
                            ".form_text": {
                                "style": "display: none"
                            },
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#header_signature_field": {
                                "html": "Technician: "
                            },
                            "#form_type_label": {
                                "html": "Scanning"
                            },
                            "#refer_for_administration": {
                                "style": "display: inline-block"
                            },
                            "#add_scan_button": {
                                "style": "display: block"
                            },
                            ".lookups": {
                                "style": "display: block"
                            },
                            '#unscannable_option': {
                                "style": "display: block"
                            },
                            init: function () {
                                if (CurrentForm.window_id) {                    //We are going to do a final save of only the fields with data when the user closes the form
                                    var win = Desktop.window.list[CurrentForm.window_id];
                                    win.close = function () {
                                        var form = $E('new-retina-consultation-form');
                                        var val = '';
                                        var ao = new EasyAjax('/vision/consultation/save');
                                        ao.add('id',CurrentForm.form_id);
                                        for (var i=0; i<form.elements.length; i++) {
                                            if (form.elements[i].type && form.elements[i].id) {
                                                if ((form.elements[i].type == 'text') || (form.elements[i].type == 'select-one')) {
                                                    val = ao.getValue(form.elements[i].id);
                                                    if (val) {
                                                        ao.add(form.elements[i].id,val);
                                                    }
                                                }
                                            }
                                        }
                                        ao.then(function (response) {
                                            console.log(response);
                                        }).post(false);
                                   }
                                }
                                var me = this;
                                new EasyEdits("/edits/vision/consultation","consultation_form");
                                $('.doctor_field').prop('disabled',true);
                                $('.pcp_staff').prop('disabled',false);
                                if (!this.data.technician) {
                                    var oldStatus = this.data.status;
                                    if (confirm('No technician has been assigned to this consultation.  Would you like to be assigned the role of technician?')) {
                                        (new EasyAjax('/vision/consultation/assign')).add('form_id',this.data.id).add('role','technician').then(function (response) {
                                            //have to update
                                            StateMachine.transition(oldStatus,me.data.status);
                                        }).post();
                                    }
                                } else {
                                    $('#submit_for_review_button').on('click',function () {
                                        if (me.data.pcp_staff_has_signed && (me.data.pcp_staff_has_signed == 'Y') && confirm("Do you wish to submit this scanning for review?")) {
                                            me.submitForReview();
                                        } else {
                                            alert('Please sign the form before submitting');
                                        }
                                    });
                                }
                                $('#member_unscannable').on('click',function (evt) {
                                    if (this.checked) {
                                        if (confirm('Do you wish to mark this patient as unable to scan?\n\nDoing so will complete this scanning and close this window.')) {
                                            (new EasyAjax('/vision/consultation/save')).add('id',me.data.id).add('status','C').then(function (response) {
                                                CurrentForm.close();
                                            }).post();
                                        } else {
                                            evt.stopPropagation();
                                            return false;
                                        }
                                    }
                                });
                                $('#comment_area').on('click',openCommentLayer);
                                this.memberCheck(); this.active(); this.signature(); this.preparer();
                            },
                            technician: function () {
                                if (this.user_id == this.data.technician) {
                                    if ((!this.data.pcp_staff_has_signed) || (this.data.pcp_staff_has_signed=="N")) {
                                        $('#preparer_sign_button').css('display','block').on('click',function () {
                                            CurrentForm.signingFunction = CurrentForm.preparerSign;
                                            CurrentForm.pin();
                                        });
                                    } 
                                }
                            },
                            scans: function () {
                                $('#add_scan_button').on('click',function () {
                                    $('#scan_upload_layer').css('display','block');
                                });
                            }
                        }
                    },
                    "S": {
                        "elements": {
                            "#form_recall_button": {
                                "style": "display: block"
                            },
                            "#header_section_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            ".form_input": {
                                "style": "display: none"
                            },
                            ".form_text": {
                                "style": "display: block"
                            },
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#header_signature_field": {
                                "html": "Technician: "
                            },
                            "#form_type_label": {
                                "html": "Scanning"
                            },
                            "#add_scan_button": {
                                "style": "display: none"
                            },
                            '#unscannable_option': {
                                "style": "display: block"
                            },                            
                            init: function () {
                                new EasyEdits("/edits/vision/browse","consultation_form");
                                $('.doctor_field').prop('disabled',true);
                                $('.pcp_staff').prop('disabled',true);
                                this.signature(); this.preparer();
                            }
                        }
                    },
                    "A": {
                        "elements": {
                            "#form_recall_button": {
                                "style": "display: none"
                            },
                            "#return_referral": {
                                "style": "display: inline-block"
                            },
                            "#header_section_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_1": {
                                "class": "form-active"
                            },
                            "#vision-package": {
                                "style": "color: #000; font-size: .8em; overflow: auto"
                            },
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            ".form_input": {
                                "style": "display: block"
                            },
                            ".form_text": {
                                "style": "display: none"
                            },
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#header_signature_field": {
                                "html": "Technician: "
                            },
                            "#form_type_label": {
                                "html": "Scanning"
                            },
                            "#add_scan_button": {
                                "style": "display: block"
                            },
                            '#unscannable_option': {
                                "style": "display: block"
                            }, 
                            '#form_admin_panel': {
                                "style": "display: inline-block"
                            },
                            init: function () {
                                new EasyEdits("/edits/vision/consultation","consultation_form");
                                $('.doctor_field').prop('disabled',true);
                                $('.pcp_staff').prop('disabled',false);
                                this.active();
                                this.signature();
                                this.preparer();
                                setAdminOptions(this.data);
                            }
                        }  
                    }
                },
                "S": {
                    "R": {
                        "elements": {
                            "#form_recall_button": {
                                "style": "display: none"
                            },
                            "#header_section_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            ".form_input": {
                                "style": "display: none"
                            },
                            ".form_text": {
                                "style": "display: block"
                            },
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#header_signature_field": {
                                "html": "Technician: "
                            },
                            "#form_type_label": {
                                "html": "Scanning"
                            },
                            "#add_scan_button": {
                                "style": "display: none"
                            },
                            '#unscannable_option': {
                                "style": "display: block"
                            },                            
                            init: function () {
                                $('.doctor_field').prop('disabled',true);
                                $('.pcp_staff').prop('disabled',true);
                                new EasyEdits("/edits/vision/browse","consultation_form");
                                this.signature(); this.preparer();
                                if (this.data.technician == this.user_id) {
                                    if (confirm('This form has been returned to you.\n\nDo you wish to begin reviewing this form again?')) {
                                        this.setStatus('N');
                                    }
                                }
                            }
                        }                    
                    },                    
                    "S": {
                        "elements": {
                            "#form_recall_button": {
                                "style": "display: block"
                            },
                            "#header_section_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            ".form_input": {
                                "style": "display: none"
                            },
                            ".form_text": {
                                "style": "display: block"
                            },
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#header_signature_field": {
                                "html": "Technician: "
                            },
                            "#form_type_label": {
                                "html": "Scanning"
                            },
                            "#add_scan_button": {
                                "style": "display: none"
                            },
                            '#unscannable_option': {
                                "style": "display: block"
                            },                            
                            init: function () {
                                new EasyEdits("/edits/vision/browse","consultation_form");
                                $('.doctor_field').prop('disabled',true);
                                $('.pcp_staff').prop('disabled',true);
                                this.signature(); this.preparer();                            }

                        }                    
                    },
                    "N": {
                        "elements": {
                             "#form_recall_button": {
                                "style": "display: none"
                            },
                            "#header_section_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            ".form_input": {
                                "style": "display: block"
                            },
                            ".form_text": {
                                "style": "display: none"
                            },
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#header_signature_field": {
                                "html": "Technician: "
                            },
                            "#submit_for_review_button": {
                                "style": "display: block; float: right"
                            },                            
                            "#form_type_label": {
                                "html": "Scanning"
                            },
                            "#add_scan_button": {
                                "style": "display: block"
                            },
                            "#refer_for_administration": {
                                "style": "display: inline-block"
                            },
                            '#unscannable_option': {
                                "style": "display: block"
                            },                            
                            init: function () {
                                var me = this;
                                new EasyEdits("/edits/vision/consultation","consultation_form");
                                $('.doctor_field').prop('disabled',true);
                                $('.pcp_staff').prop('disabled',false);
                                if (!this.data.technician) {
                                    var oldStatus = this.data.status;
                                    if (confirm('No technician has been assigned to this consultation.  Would you like to be assigned the role of technician?')) {
                                        (new EasyAjax('/vision/consultation/assign')).add('form_id',this.data.id).add('role','technician').then(function (response) {
                                            //have to update
                                            StateMachine.transition(oldStatus,me.data.status);
                                        }).post();
                                    }
                                } else {
                                    $('#submit_for_review_button').on('click',function () {
                                        if (me.data.pcp_staff_has_signed && (me.data.pcp_staff_has_signed == 'Y') && confirm("Do you wish to submit this scanning for review?")) {
                                            me.submitForReview();
                                        } else {
                                            alert('Please sign the form before submitting');
                                        }
                                    });                                    
                                }
                                this.active();
                                this.signature(); this.preparer();
                            },
                            technician: function () {
                                if (this.user_id == this.data.technician) {
                                    if ((!this.data.pcp_staff_has_signed) || (this.data.pcp_staff_has_signed=="N")) {
                                        $('#preparer_sign_button').css('display','block').on('click',function () {
                                            CurrentForm.signingFunction = CurrentForm.preparerSign;
                                            CurrentForm.pin();
                                        });
                                    }
                                }
                            },
                            scans: function () {
                                $('#add_scan_button').on('click',function () {
                                    $('#scan_upload_layer').css('display','block');
                                });
                            }
                        }
                    }
                },
                "R": {
                    "R": {
                        "elements": {
                            "#form_recall_button": {
                                "style": "display: none"
                            },
                            "#header_section_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            ".form_input": {
                                "style": "display: none"
                            },
                            ".form_text": {
                                "style": "display: block"
                            },
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#header_signature_field": {
                                "html": "Technician: "
                            },
                            "#form_type_label": {
                                "html": "Scanning"
                            },
                            "#add_scan_button": {
                                "style": "display: none"
                            },
                            '#unscannable_option': {
                                "style": "display: block"
                            },                            
                            init: function () {
                                $('.doctor_field').prop('disabled',true);
                                $('.pcp_staff').prop('disabled',true);
                                this.signature(); this.preparer();
                                new EasyEdits("/edits/vision/browse","consultation_form");
                                if (this.data.technician == this.user_id) {
                                    if (confirm('This form has been returned to you.\n\nDo you wish to begin reviewing this form again?')) {
                                        this.setStatus('N');
                                    }
                                }
                            }
                        }                    
                    },
                    "N": {
                        "elements": {
                            "#form_recall_button": {
                                "style": "display: none;"
                            },
                            "#header_section_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            ".form_input": {
                                "style": "display: block"
                            },
                            ".form_text": {
                                "style": "display: none"
                            },
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#header_signature_field": {
                                "html": "Technician: "
                            },
                            "#submit_for_review_button": {
                                "style": "display: block; float: right"
                            },                            
                            "#form_type_label": {
                                "html": "Scanning"
                            },
                            "#add_scan_button": {
                                "style": "display: block"
                            },
                            '#unscannable_option': {
                                "style": "display: block"
                            },                            
                            init: function () {
                                var me = this;
                                new EasyEdits("/edits/vision/consultation","consultation_form");
                                $('.doctor_field').prop('disabled',true);
                                $('.pcp_staff').prop('disabled',false);
                                if (!this.data.technician) {
                                    var oldStatus = this.data.status;
                                    if (confirm('No technician has been assigned to this consultation.  Would you like to be assigned the role of technician?')) {
                                        (new EasyAjax('/vision/consultation/assign')).add('form_id',this.data.id).add('role','technician').then(function (response) {
                                            //have to update
                                            StateMachine.transition(oldStatus,me.data.status);
                                        }).post();
                                    }
                                } else {
                                    $('#submit_for_review_button').on('click',function () {
                                        if (me.data.pcp_staff_has_signed && (me.data.pcp_staff_has_signed == 'Y') && confirm("Do you wish to submit this scanning for review?")) {
                                            me.submitForReview();
                                        } else {
                                            alert('Please sign the form before submitting');
                                        }
                                    });
                                }
                                this.active();
                                this.signature(); this.preparer();
                            },
                            technician: function () {
                                if (this.user_id == this.data.technician) {
                                    if ((!this.data.pcp_staff_has_signed) || (this.data.pcp_staff_has_signed=="N")) {
                                        $('#preparer_sign_button').css('display','block').on('click',function () {
                                            CurrentForm.signingFunction = CurrentForm.preparerSign;
                                            CurrentForm.pin();
                                        });
                                    }
                                }
                            },
                            scans: function () {
                                $('#add_scan_button').on('click',function () {
                                    $('#scan_upload_layer').css('display','block');
                                });
                            }
                        }                           
                    }
                },
                "C": {
                    "A": {
                        "elements": {
                            "#form_recall_button": {
                                "style": "display: none"
                            },
                            "#return_referral": {
                                "style": "display: inline-block"
                            },
                            "#header_section_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_1": {
                                "class": "form-active"
                            },
                            "#vision-package": {
                                "style": "color: #000; font-size: .8em; overflow: auto"
                            },
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            ".form_input": {
                                "style": "display: block"
                            },
                            ".form_text": {
                                "style": "display: none"
                            },
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#header_signature_field": {
                                "html": "Technician: "
                            },
                            "#form_type_label": {
                                "html": "Scanning"
                            },
                            "#add_scan_button": {
                                "style": "display: block"
                            },
                            '#unscannable_option': {
                                "style": "display: block"
                            },
                            '#form_admin_panel': {
                                "style": "display: inline-block"
                            },
                            init: function () {
                                new EasyEdits("/edits/vision/consultation","consultation_form");
                                $('.doctor_field').prop('disabled',true);
                                $('.pcp_staff').prop('disabled',false);
                                this.active();
                                this.signature();
                                this.preparer();
                            }
                        }  
                    },                    
                    "C": {
                        "elements": {
                            "#header_section_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            ".form_input": {
                                "style": "display: none"
                            },
                            ".form_text": {
                                "style": "display: block"
                            },
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#header_signature_field": {
                                "html": "Technician: "
                            },
                            "#form_type_label": {
                                "html": "Scanning"
                            },
                            "#refer_for_administration": {
                                "style": "display: inline-block"
                            },                            
                            "#add_scan_button": {
                                "style": "display: none"
                            },
                            "#regenerate_screening_form_button": {
                                "style": "display: block; float: right"
                            },
                            '#unscannable_option': {
                                "style": "display: block"
                            },                            
                            init: function () {
                                new EasyEdits("/edits/vision/browse","consultation_form");
                                $('.doctor_field').prop('disabled',true);
                                $('.pcp_staff').prop('disabled',false);
                                this.signature(); this.preparer();
                            }
                        }                    
                    },
                    "P": {
                        "elements": {
                            "#form_recall_button": {
                                "style": "display: none"
                            },
                            "#header_section_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_1": {
                                "class": "form-active"
                            },
                            "#vision-package": {
                                "style": "color: #000; font-size: .8em; overflow: visible"
                            },
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            ".form_input": {
                                "style": "display: none"
                            },
                            ".form_text": {
                                "style": "display: block"
                            },
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#header_signature_field": {
                                "html": "Technician: "
                            },
                            "#form_type_label": {
                                "html": "Scanning"
                            },
                            "#add_scan_button": {
                                "style": "display: none"
                            },
                            '#unscannable_option': {
                                "style": "display: block"
                            },                            
                            init: function () {
                                new EasyEdits("/edits/vision/consultation","consultation_form");
                                $('.doctor_field').prop('readonly',true);
                                $('.pcp_staff').prop('readonly',false);                                
                                this.signature(); this.preparer();
                            }
                        }                    
                    } 
                }
            },
            "screening": {
                "A": {
                    "A": {
                        "elements": {
                            "#form_recall_button": {
                                "style": "display: none"
                            },
                            "#return_referral": {
                                "style": "display: inline-block"
                            },
                            "#header_section_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_1": {
                                "class": "form-active"
                            },
                            "#vision-package": {
                                "style": "color: #000; font-size: .8em; overflow: auto"
                            },
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            ".form_input": {
                                "style": "display: block"
                            },
                            ".form_text": {
                                "style": "display: none"
                            },
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#header_signature_field": {
                                "html": "Technician: "
                            },
                            "#form_type_label": {
                                "html": "Scanning"
                            },
                            "#add_scan_button": {
                                "style": "display: block"
                            },
                            '#unscannable_option': {
                                "style": "display: block"
                            },   
                            '#form_admin_panel': {
                                "style": "display: inline-block"
                            },
                            init: function () {
                                new EasyEdits("/edits/vision/consultation","consultation_form");
                                $('.doctor_field').prop('disabled',true);
                                $('.pcp_staff').prop('disabled',false);
                                this.active();
                                this.signature();
                                this.preparer();
                            }
                        }  
                    }
                },
                "S": {
                    "S": {
                        "elements": {
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            ".form_input": {
                                "style": "display: none"
                            },
                            ".form_text": {
                                "style": "display: block"
                            },
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#header_signature_field": {
                                "html": "Doctor: "
                            },
                            "#form_type_label": {
                                "html": "Screening"
                            },
                            "#add_scan_button": {
                                "style": "display: none"
                            },
                            init: function () {
                                $('.pcp_staff').prop('disabled',true);
                                $('.doctor_field').prop('disabled',true);
                            }
                        }                    
                    }
                },
                "C": {
                    "C": {
                        "elements": {
                            "#header_section_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            ".form_input": {
                                "style": "display: none"
                            },
                            ".form_text": {
                                "style": "display: block"
                            },
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#header_signature_field": {
                                "html": "Technician: "
                            },
                            "#refer_for_administration": {
                                "style": "display: inline-block"
                            },                            
                            "#form_type_label": {
                                "html": "Screening"
                            },
                            "#add_scan_button": {
                                "style": "display: none"
                            },
                            "#regenerate_screening_form_button": {
                                "style": "display: block; float: right"
                            },
                            init: function () {
                                new EasyEdits("/edits/vision/browse","consultation_form");
                                //$('.doctor_field').prop('disabled',true);
                                $('.doctor_field').prop('disabled',true);
                                $('.pcp_staff').prop('disabled',true);                                
                                this.signature(); 
                                this.preparer();
                               // this.active();
                            }
                        }                    
                    },
                    "A": {
                        "elements": {
                            "#form_recall_button": {
                                "style": "display: none"
                            },
                            "#return_referral": {
                                "style": "display: inline-block"
                            },
                            "#header_section_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_1": {
                                "class": "form-active"
                            },
                            "#vision-package": {
                                "style": "color: #000; font-size: .8em; overflow: auto"
                            },
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            ".form_input": {
                                "style": "display: block"
                            },
                            ".form_text": {
                                "style": "display: none"
                            },
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#header_signature_field": {
                                "html": "Technician: "
                            },
                            "#form_type_label": {
                                "html": "Scanning"
                            },
                            "#add_scan_button": {
                                "style": "display: block"
                            },
                            '#form_admin_panel': {
                                "style": "display: inline-block"
                            },
                            init: function () {
                                new EasyEdits("/edits/vision/consultation","consultation_form");
                                $('.doctor_field').prop('disabled',true);
                                $('.pcp_staff').prop('disabled',false);
                                this.active();
                                this.signature();
                                this.preparer();
                            }
                        }  
                    },                    
                    "P": {
                        "elements": {
                            "#form_recall_button": {
                                "style": "display: none"
                            },
                            "#header_section_1": {
                                "class": "form-active"
                            },
                            "#vision-package": {
                                "style": "color: #000; font-size: .8em; overflow: visible"
                            },
                            "#highlight_block_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            ".form_input": {
                                "style": "display: none"
                            },
                            ".form_text": {
                                "style": "display: block"
                            },
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#header_signature_field": {
                                "html": "Technician: "
                            },
                            "#form_type_label": {
                                "html": "Scanning"
                            },
                            "#add_scan_button": {
                                "style": "display: none"
                            },
                            init: function () {
                                new EasyEdits("/edits/vision/consultation","consultation_form");
                                $('.doctor_field').prop('readonly',true);
                                $('.pcp_staff').prop('readonly',true);
                                this.signature(); this.preparer();
                            }
                        }                    
                    } 
                }
            }
        },
        "doctor": {
            "scanning": {
                "S": {
                    "S": {
                        "elements": {
                            "#form_recall_button": {
                                "style": "display: none"
                            },
                            "#header_section_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            ".form_input": {
                                "style": "display: none"
                            },
                            "#refer_for_administration": {
                                "style": "display: inline-block"
                            },                                
                            ".form_text": {
                                "style": "display: block"
                            },
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#header_signature_field": {
                                "html": "Technician: "
                            },
                            "#form_type_label": {
                                "html": "Scanning"
                            },
                            "#add_scan_button": {
                                "style": "display: none"
                            },
                            init: function () {
                                var me = this;
                                new EasyEdits("/edits/vision/consultation","consultation_form");
                                $('.doctor_field').prop('disabled',true);
                                this.signature(); this.preparer();
                                if (!this.data.reviewer) {
                                    if (confirm('A reviewer has not been assigned, would you like to be assigned the role of reviewer?')) {
                                        (new EasyAjax('/vision/consultation/assign')).add('form_id',this.data.id).add('role','reviewer').add('status','I').then(function (response) {
                                            me.load();
                                        }).post()
                                    }
                                } else if (this.data.reviewer == this.user_id) {
                                    if (confirm('Would you like to begin reviewing this form?')) {
                                        this.setStatus('I');
                                    }
                                }                               
                            }

                        }                    
                    },
                    "I": {
                        "elements": {
                            "#form_recall_button": {
                                "style": "display: none"
                            },
                            "#header_section_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            "#private_note_icon": {
                                "style": "display: block"
                            },                            
                            ".form_input": {
                                "style": "display: block"
                            },
                            ".form_text": {
                                "style": "display: none"
                            },
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#refer_for_administration": {
                                "style": "display: inline-block"
                            },                            
                            "#header_signature_field": {
                                "html": "Technician: "
                            },
                            "#form_type_label": {
                                "html": "Scanning"
                            },
                            "#add_scan_button": {
                                "style": "display: none"
                            },
                            "#return_to_submitter_button": {
                                "style": "display: block; float: left"
                            },
                            ".lookups": {
                                "style": "display: block"
                            },
                            init: function () {
                                new EasyEdits("/edits/vision/consultation","consultation_form");
                                $('.doctor_field').prop('disabled',false);
                                $('.referral_field').prop('disabled',true);                                
                                this.codes();
                                this.active();
                                this.signature();
                                this.preparer();
                                if ((!this.data.doctor_has_signed) || (this.data.doctor_has_signed!=='Y')) {
                                    $('#doctor_sign_and_complete_button').css('display','block').on('click',function () {
                                        CurrentForm.signingFunction = CurrentForm.signAndComplete;
                                        CurrentForm.pin();
                                    });
                                }  
                                $('#comment_area').on('click',openCommentLayer);
                            },
                            returnToSubmitter: function () {
                                var me = this;
                                $("#return_to_submitter_button").on("click",function () {
                                    if (confirm("Would you like to return this form to the submitter?")) {
                                        me.setStatus('R');
                                        CurrentForm.close();
                                    }
                                });
                            }
                        }
                    }
                },
                "I": {
                    "I": {
                        "elements": {
                            "#form_recall_button": {
                                "style": "display: none"
                            },
                            "#header_section_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_1": {
                                "class": "form-active"
                            },
                            "#private_note_icon": {
                                "style": "display: block"
                            },
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            ".form_input": {
                                "style": "display: block"
                            },
                            ".form_text": {
                                "style": "display: none"
                            },
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#header_signature_field": {
                                "html": "Technician: "
                            },
                            "#refer_for_administration": {
                                "style": "display: inline-block"
                            },                            
                            "#form_type_label": {
                                "html": "Scanning"
                            },
                            "#add_scan_button": {
                                "style": "display: none"
                            },
                            "#return_to_submitter_button": {
                                "style": "display: block"
                            },
                            ".lookups": {
                                "style": "display: block"
                            },                            
                            init: function () {
                                new EasyEdits("/edits/vision/consultation","consultation_form");
                                $('.doctor_field').prop('disabled',false);
                                $('.referral_field').prop('disabled',true);                                
                                this.active();
                                this.signature(); this.preparer();
                                this.codes();
                                if ((!this.data.doctor_has_signed) || (this.data.doctor_has_signed!=='Y')) {
                                    $('#doctor_sign_and_complete_button').css('display','block').on('click',function () {
                                        CurrentForm.signingFunction = CurrentForm.signAndComplete;
                                        CurrentForm.pin();
                                    });
                                }
                                $('#comment_area').on('click',openCommentLayer);                                
                            },
                            returnToSubmitter: function () {
                                var me = this;
                                $("#return_to_submitter_button").on("click",function () {
                                    if (confirm("Would you like to return this form to the submitter?")) {
                                        me.setStatus('R');
                                        CurrentForm.close();
                                    }
                                })
                            }

                        }                    
                    },
                    "R": {
                        "elements": {
                            "#form_recall_button": {
                                "style": "display: none"
                            },
                            "#header_section_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            ".form_input": {
                                "style": "display: none"
                            },
                            ".form_text": {
                                "style": "display: block"
                            },
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#refer_for_administration": {
                                "style": "display: inline-block"
                            },                                
                            "#header_signature_field": {
                                "html": "Technician: "
                            },
                            "#form_type_label": {
                                "html": "Scanning"
                            },
                            "#add_scan_button": {
                                "style": "display: none"
                            },
                            '#unscannable_option': {
                                "style": "display: block"
                            },                            
                            init: function () {
                                new EasyEdits("/edits/vision/consultation","consultation_form");
                                $('.doctor_field').prop('disabled',true);
                                $('.pcp_staff').prop('disabled',true);
                                this.signature(); this.preparer();
                            }
                        }
                    },
                    "C": {
                        "elements": {
                            "#form_recall_button": {
                                "style": "display: block"
                            },
                            "#header_section_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_1": {
                                "class": "form-active"
                            },
                            "#private_note_icon": {
                                "style": "display: block"
                            },                            
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            ".form_input": {
                                "style": "display: block"
                            },
                            ".form_text": {
                                "style": "display: none"
                            },
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#header_signature_field": {
                                "html": "Technician: "
                            },
                            "#form_type_label": {
                                "html": "Scanning"
                            },
                            "#add_scan_button": {
                                "style": "display: none"
                            },
                            '#unscannable_option': {
                                "style": "display: block"
                            },                            
                            init: function () {
                                new EasyEdits("/edits/vision/browse","consultation_form");
                                $('.doctor_field').prop('disabled',true);
                                $('.pcp_staff').prop('disabled',true);
                                this.signature(); this.preparer();
                            }
                        }                    
                    },
                    "A": {
                        "elements": {
                            "#form_recall_button": {
                                "style": "display: none"
                            },
                            "#return_referral": {
                                "style": "display: inline-block"
                            },
                            "#header_section_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_1": {
                                "class": "form-active"
                            },
                            "#vision-package": {
                                "style": "color: #000; font-size: .8em; overflow: auto"
                            },
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            ".form_input": {
                                "style": "display: block"
                            },
                            ".form_text": {
                                "style": "display: none"
                            },
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#header_signature_field": {
                                "html": "Technician: "
                            },
                            "#form_type_label": {
                                "html": "Scanning"
                            },
                            "#add_scan_button": {
                                "style": "display: block"
                            },
                            '#unscannable_option': {
                                "style": "display: block"
                            }, 
                            '#form_admin_panel': {
                                "style": "display: inline-block"
                            },
                            init: function () {
                                new EasyEdits("/edits/vision/consultation","consultation_form");
                                $('.doctor_field').prop('disabled',true);
                                $('.pcp_staff').prop('disabled',false);
                                this.active();
                                this.signature();
                                this.preparer();
                                setAdminOptions(this.data);
                            }
                        }  
                    }                    
                },
                "R": {
                    "R": {
                        "elements": {
                            "#form_recall_button": {
                                "style": "display: none"
                            },
                            "#header_section_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            ".form_input": {
                                "style": "display: none"
                            },
                            ".form_text": {
                                "style": "display: block"
                            },
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#header_signature_field": {
                                "html": "Technician: "
                            },
                            "#form_type_label": {
                                "html": "Scanning"
                            },
                            "#add_scan_button": {
                                "style": "display: none"
                            },
                            '#unscannable_option': {
                                "style": "display: block"
                            },                            
                            init: function () {
                                new EasyEdits("/edits/vision/consultation","consultation_form");
                                $('.doctor_field').prop('disabled',true);
                                $('.pcp_staff').prop('disabled',true);
                                this.signature(); this.preparer();
                            }
                        }
                    }                    
                },
                "C": {
                    "C": {
                        "elements": {
                            "#form_recall_button": {
                                "style": "display: none"
                            },
                            "#header_section_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            "#private_note_icon": {
                                "style": "display: none"
                            },                            
                            ".form_input": {
                                "style": "display: none"
                            },
                            ".form_text": {
                                "style": "display: block"
                            },
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#header_signature_field": {
                                "html": "Technician: "
                            },
                            "#form_type_label": {
                                "html": "Scanning"
                            },
                            "#add_scan_button": {
                                "style": "display: none"
                            },
                        
                            init: function () {
                                new EasyEdits("/edits/vision/browse","consultation_form");
                                $('.doctor_field').prop('disabled',true);
                                $('.pcp_staff').prop('disabled',true);
                                this.signature(); 
                                this.preparer();
                                this.active();
                            }
                        }                    
                    },
                    "V": {
                        "elements": {
                            "#form_recall_button": {
                                "style": "display: none"
                            },
                            "#header_section_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            ".form_input": {
                                "style": "display: block"
                            },
                            ".form_text": {
                                "style": "display: none"
                            },
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#header_signature_field": {
                                "html": "Technician: "
                            },
                            "#form_type_label": {
                                "html": "Scanning"
                            },
                            "#add_scan_button": {
                                "style": "display: none"
                            },
                            init: function () {
                                new EasyEdits("/edits/vision/browse","consultation_form");
                                $('.doctor_field').prop('disabled',true);
                                $('.pcp_staff').prop('disabled',true);
                                this.signature(); this.preparer();
                            }
                        }                    
                    },
                    "P": {
                        "elements": {
                            "#form_recall_button": {
                                "style": "display: none"
                            },
                            "#header_section_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_1": {
                                "class": "form-active"
                            },
                            "#vision-package": {
                                "style": "color: #000; font-size: .8em; overflow: visible"
                            },
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            ".form_input": {
                                "style": "display: none"
                            },
                            ".form_text": {
                                "style": "display: block"
                            },
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#header_signature_field": {
                                "html": "Technician: "
                            },
                            "#form_type_label": {
                                "html": "Scanning"
                            },
                            "#add_scan_button": {
                                "style": "display: none"
                            },
                            '#unscannable_option': {
                                "style": "display: block"
                            },                            
                            init: function () {
                                new EasyEdits("/edits/vision/browse","consultation_form");
                                $('.doctor_field').prop('disabled',true);
                                $('.pcp_staff').prop('disabled',true);
                                this.signature(); this.preparer();
                            }
                        }                    
                    } 
                }
            },
            "screening": {
                "N": {
                    "N": {
                        "elements": {
                            "#form_recall_button": {
                                "style": "display: none"
                            },
                            "#header_section_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            "#submit_for_review_button": {
                                "style": "display: block; float: right"
                            },
                            ".form_input": {
                                "style": "display: block"
                            },
                            ".form_text": {
                                "style": "display: none"
                            },
                            "#refer_for_administration": {
                                "style": "display: inline-block"
                            },                                
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#header_signature_field": {
                                "html": "Technician: "
                            },
                            "#form_type_label": {
                                "html": "Scanning"
                            },
                            "#add_scan_button": {
                                "style": "display: block"
                            },
                            ".lookups": {
                                "style": "display: block"
                            },
                            init: function () {
                                new EasyEdits("/edits/vision/consultation","consultation_form");
                                $('.doctor_field').prop('disabled',false);
                                $('.referral_field').prop('disabled',true);                                
                                this.active();
                                this.signature(); this.preparer();
                                this.codes();
                                if ((!this.data.doctor_has_signed) || (this.data.doctor_has_signed!=='Y')) {
                                    $('#doctor_sign_and_complete_button').css('display','block').on('click',function () {
                                        CurrentForm.signingFunction = CurrentForm.signAndComplete;
                                        CurrentForm.pin();
                                    });
                                }
                                $('#comment_area').on('click',openCommentLayer);                                
                            }
                        }
                    },
                    "A": {
                        "elements": {
                            "#form_recall_button": {
                                "style": "display: none"
                            },
                            "#return_referral": {
                                "style": "display: inline-block"
                            },
                            "#header_section_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_1": {
                                "class": "form-active"
                            },
                            "#vision-package": {
                                "style": "color: #000; font-size: .8em; overflow: auto"
                            },
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            ".form_input": {
                                "style": "display: block"
                            },
                            ".form_text": {
                                "style": "display: none"
                            },
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#header_signature_field": {
                                "html": "Technician: "
                            },
                            "#form_type_label": {
                                "html": "Scanning"
                            },
                            "#add_scan_button": {
                                "style": "display: block"
                            },
                            '#unscannable_option': {
                                "style": "display: block"
                            }, 
                            '#form_admin_panel': {
                                "style": "display: inline-block"
                            },
                            init: function () {
                                new EasyEdits("/edits/vision/consultation","consultation_form");
                                $('.doctor_field').prop('disabled',true);
                                $('.pcp_staff').prop('disabled',false);
                                this.active();
                                this.signature();
                                this.preparer();
                                setAdminOptions(this.data);
                            }
                        }  
                    }
                },
                "S": {
                    "S": {
                        "elements": {
                            "#form_recall_button": {
                                "style": "display: none"
                            },
                            "#header_section_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            ".form_input": {
                                "style": "display: none"
                            },
                            ".form_text": {
                                "style": "display: block"
                            },
                            "#additional_consent": {
                                "style": "display: block"
                            },
                            "#refer_for_administration": {
                                "style": "display: inline-block"
                            },                                
                            "#header_signature_field": {
                                "html": "Doctor: "
                            },
                            "#form_type_label": {
                                "html": "Screening"
                            },
                            "#add_scan_button": {
                                "style": "display: none"
                            },
                            init: function () {
                                var me = this;
                                new EasyEdits("/edits/vision/browse","consultation_form");
                                $('.doctor_field').prop('disabled',true);
                                $('.pcp_staff').prop('disabled',true);
                                this.signature(); this.preparer();
                                if (!this.data.reviewer) {
                                    if (confirm('A reviewer has not been assigned, would you like to be assigned the role of reviewer?')) {
                                        (new EasyAjax('/vision/consultation/assign')).add('form_id',this.data.id).add('role','reviewer').add('status','I').then(function (response) {
                                            me.load();
                                        }).post()
                                    }
                                } else if (this.data.reviewer == this.user_id) {
                                    if (confirm('Would you like to begin reviewing this form?')) {
                                        this.setStatus('I');
                                    }
                                }                                     
                            }
                        }                          
                    },
                    "I": {
                        "elements": {
                            "#form_recall_button": {
                                "style": "display: none"
                            },
                            "#header_section_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_1": {
                                "class": "form-active"
                            },
                            "#private_note_icon": {
                                "style": "display: block"
                            },                            
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            ".form_input": {
                                "style": "display: block"
                            },
                            ".form_text": {
                                "style": "display: none"
                            },
                            "#additional_consent": {
                                "style": "display: block"
                            },
                            "#refer_for_administration": {
                                "style": "display: inline-block"
                            },                                
                            "#header_signature_field": {
                                "html": "Doctor: "
                            },
                            "#form_type_label": {
                                "html": "Screening"
                            },
                            "#add_scan_button": {
                                "style": "display: none"
                            },
                            ".lookups": {
                                "style": "display: block"
                            },                            
                            init: function () {
                                new EasyEdits("/edits/vision/consultation","consultation_form");
                                $('.doctor_field').prop('disabled',false);
                                $('.referral_field').prop('disabled',true);
                                this.active();
                                this.signature(); this.preparer();
                                this.codes();
                                if ((!this.data.doctor_has_signed) || (this.data.doctor_has_signed!=='Y')) {
                                    $('#doctor_sign_and_complete_button').css('display','block').on('click',function () {
                                        CurrentForm.signingFunction = CurrentForm.signAndComplete;
                                        CurrentForm.pin();
                                    });
                                }
                                $('#comment_area').on('click',openCommentLayer);                                
                            }
                        }                          
                    }
                },
                "I": {
                    "I": {
                        "elements": {
                            "#form_recall_button": {
                                "style": "display: none"
                            },
                            "#header_section_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_1": {
                                "class": "form-active"
                            },
                            "#private_note_icon": {
                                "style": "display: block"
                            },                            
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            ".form_input": {
                                "style": "display: block"
                            },
                            ".form_text": {
                                "style": "display: none"
                            },
                            "#additional_consent": {
                                "style": "display: block"
                            },
                            "#header_signature_field": {
                                "html": "Doctor: "
                            },
                            "#refer_for_administration": {
                                "style": "display: inline-block"
                            },                                
                            "#form_type_label": {
                                "html": "Screening"
                            },
                            "#add_scan_button": {
                                "style": "display: none"
                            },
                            ".lookups": {
                                "style": "display: block"
                            },                            
                            init: function () {
                                new EasyEdits("/edits/vision/consultation","consultation_form");
                                $('.doctor_field').prop('disabled',false);
                                $('.referral_field').prop('disabled',true);
                                this.active();
                                this.signature(); this.preparer();
                                this.codes();
                                if ((!this.data.doctor_has_signed) || (this.data.doctor_has_signed!=='Y')) {
                                    $('#doctor_sign_and_complete_button').css('display','block').on('click',function () {
                                        CurrentForm.signingFunction = CurrentForm.signAndComplete;
                                        CurrentForm.pin();
                                    });
                                }
                                $('#comment_area').on('click',openCommentLayer);                                
                            }
                        }                    
                    },
                    "C": {
                        "elements": {
                            "#form_recall_button": {
                                "style": "display: none"
                            },
                            "#header_section_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_1": {
                                "class": "form-active"
                            },
                            "#private_note_icon": {
                                "style": "display: block"
                            },                            
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            ".form_input": {
                                "style": "display: none"
                            },
                            ".form_text": {
                                "style": "display: block"
                            },
                            "#additional_consent": {
                                "style": "display: block"
                            },
                            "#header_signature_field": {
                                "html": "Doctor: "
                            },
                            "#form_type_label": {
                                "html": "Screening"
                            },
                            "#add_scan_button": {
                                "style": "display: none"
                            },
                            init: function () {
                                new EasyEdits("/edits/vision/browse","consultation_form");
                                $('.doctor_field').prop('disabled',true);
                                $('.pcp_staff').prop('disabled',true);
                                this.signature(); this.preparer();
                            }
                        }                    
                    }
                },
                "C": {
                    "C": {
                        "elements": {
                            "#form_recall_button": {
                                "style": "display: none"
                            },
                            "#header_section_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            "#private_note_icon": {
                                "style": "display: block"
                            },                            
                            ".form_input": {
                                "style": "display: none"
                            },
                            ".form_text": {
                                "style": "display: block"
                            },
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#header_signature_field": {
                                "html": "Doctor: "
                            },
                            "#form_type_label": {
                                "html": "Screening"
                            },
                            "#add_scan_button": {
                                "style": "display: none"
                            },
                        
                            init: function () {
                                new EasyEdits("/edits/vision/browse","consultation_form");
                                $('.doctor_field').prop('disabled',true);
                                $('.pcp_staff').prop('disabled',true);
                                this.signature(); 
                                this.preparer();
                                this.active();
                            }
                        }                    
                    },
                    "S": {
                        "elements": {
                            "#form_recall_button": {
                                "style": "display: none"
                            },
                            "#header_section_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            ".form_input": {
                                "style": "display: none"
                            },
                            ".form_text": {
                                "style": "display: block"
                            },
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#header_signature_field": {
                                "html": "Doctor: "
                            },
                            "#form_type_label": {
                                "html": "Screening"
                            },
                            "#add_scan_button": {
                                "style": "display: none"
                            },
                            init: function () {
                                new EasyEdits("/edits/vision/browse","consultation_form");
                                $('.doctor_field').prop('disabled',true);
                                $('.pcp_staff').prop('disabled',true);
                                this.signature(); 
                                this.preparer();
                                this.active();
                            }
                        }                    
                    },                    
                    "V": {
                        "elements": {
                            "#form_recall_button": {
                                "style": "display: none"
                            },
                            "#header_section_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            ".form_input": {
                                "style": "display: none"
                            },
                            ".form_text": {
                                "style": "display: block"
                            },
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#header_signature_field": {
                                "html": "Doctor: "
                            },
                            "#form_type_label": {
                                "html": "Screening"
                            },
                            "#add_scan_button": {
                                "style": "display: none"
                            },
                            init: function () {
                                new EasyEdits("/edits/vision/browse","consultation_form");
                                $('.doctor_field').prop('disabled',true);
                                $('.pcp_staff').prop('disabled',true);
                                this.signature(); this.preparer();
                            }
                        }
                    },
                    "P": {
                        "elements": {
                            "#form_recall_button": {
                                "style": "display: none"
                            },
                            "#header_section_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_1": {
                                "class": "form-active"
                            },
                            "#highlight_block_2": {
                                "style": "background-color: ghostwhite"
                            },
                            "#vision-package": {
                                "style": "color: #000; font-size: .8em; overflow: visible"
                            },
                            ".form_input": {
                                "style": "display: none"
                            },
                            ".form_text": {
                                "style": "display: block"
                            },
                            "#additional_consent": {
                                "style": "display: none"
                            },
                            "#header_signature_field": {
                                "html": "Technician: "
                            },
                            "#form_type_label": {
                                "html": "Scanning"
                            },
                            "#add_scan_button": {
                                "style": "display: none"
                            },
                            init: function () {
                                new EasyEdits("/edits/vision/consultation","consultation_form");
                                $('.doctor_field').prop('readonly',true);
                                this.signature(); this.preparer();
                            }
                        }                    
                    } 
                }
            }
        }
};
