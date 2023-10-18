var Argus = {
    templates: {
        list: {

        },
        load: function () {
            (new EasyAjax('/argus/templates/load')).then(function (response) {
                Argus.templates.list = JSON.parse(response);
            }).post(false);            
        },
        fetch: function (whichOne) {
            return (Argus.templates.list[whichOne]) ? Argus.templates.list[whichOne] : { };
        }
    },
    tools: {
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
        }
    }
}