var StateMachine = (function () {
    /*
     * transition:
     *      role:
     *          form_type: 
     *              from_state:
     *                  to_state:
     */
    
    var emptyTransition = { "elements": { } };

    return {
        transition: function (fromState,toState) {
            var role = this.pcp_staff ? 'pcp_staff' : false;
            role     = role || (this.doctor ? 'doctor' : false);
            role     = role || (this.pcp ? 'pcp' : false);
            role     = role || (this.IPA ? 'IPA' : false);
            role     = role || (this.location ? 'Location' : false);
            if (role) {
                if (this.print) {
                    fromState   = 'C';
                    toState     = 'P';
                }
                var transition = StateMachine.getTransition(role,this.data.form_type,fromState,toState);
                if (transition === emptyTransition) {
                    alert(`For the given role, there is no defined initial state for the form [${role},${this.data.form_type},${fromState},${toState}]`);
                }
                for (var i in transition.elements) {
                    switch (typeof(transition.elements[i])) {
                        case "function" :
                            transition.elements[i].call(this);
                            break;
                        case "object"   :
                            for (var j in transition.elements[i]) {
                                switch (j) {
                                    case "style":
                                        var parts = transition.elements[i][j].split(';');
                                        for (var k in parts) {
                                            var attr = parts[k].split(':');
                                            if (attr[0]) {
                                                $(i).css(attr[0].trim(),attr[1].trim());
                                            }
                                        }
                                        break;
                                    case "class":
                                        var parts = transition.elements[i][j].split(' ');
                                        for (var k in parts) {
                                            $(i).addClass(parts[k].trim());
                                        }
                                        break;
                                    case "html": 
                                        $(i).html(transition.elements[i][j]);
                                        break;
                                    case "value":
                                        $(i).val(transition.elements[i][j]);
                                        break;
                                    case "attr":
                                        break;
                                    default: 
                                        if (typeof(transition.elements[i][j])=="function") {
                                            transition.elements[i][j].call(this);
                                        }
                                        break;
                                }
                            }
                        default:
                            break;
                    }
                }
            } else {
                alert("A role like PCP Tech, IPA, OD, or something relating to vision needs to be defined for you.  I can't figure out how to display this form without a valid role");
            }            
        },
        getTransition: function (role,formType,oldState,newState) {
            oldState = (oldState) ? oldState : newState;                        //If we don't have an original state (because it is new) we just use the new state as the original, and then transition to self
            role     = (Transitions[role]) ? role : 'default';
            console.log('role='+role+",form_type="+formType+",oldState="+oldState+",newState="+newState);
            return (Transitions[role] && Transitions[role][formType] && Transitions[role][formType][oldState] && Transitions[role][formType][oldState][newState]) ? Transitions[role][formType][oldState][newState] : emptyTransition;
        }
    }
})();
