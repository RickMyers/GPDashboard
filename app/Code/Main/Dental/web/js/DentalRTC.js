Argus.dental.RTC = function () {
    Argus.dashboard.socket.on('patientArrived', function () {
        if (Argus.teledentistry.dentist) {
            $('#dental-waiting-room-alert').css('opacity','1.0').on('click',Argus.teledentistry.open.waitingRoom);
        } else {
            (new EasyAjax('/argus/user/hasrole')).add('role','DDS').then(function (response) {
                Argus.teledentistry.dentist = (JSON.parse(response)).role;
                if (Argus.teledentistry.dentist === true) {
                    $('#dental-waiting-room-alert').css('opacity','1.0').on('click',Argus.teledentistry.open.waitingRoom);
                }
            }).get();            
        }
    });
    Argus.dashboard.socket.on('patientLeft', function () {
        if (Argus.teledentistry.dentist) {
            $('#dental-waiting-room-alert').css('opacity','0.4').off('click',Argus.teledentistry.open.waitingRoom);
        }
    });
    //The dentist might log on after a patient has been waiting.  This event gets triggered if there's a patient in the waiting room when the dentist logs on.
    Argus.dashboard.socket.on('patientWaiting',function () {
        if (Argus.teledentistry.dentist) {
            $('#dental-waiting-room-alert').css('opacity','1.0').on('click',Argus.teledentistry.open.waitingRoom);
        } else {
            (new EasyAjax('/argus/user/hasrole')).add('role','DDS').then(function (response) {
                Argus.teledentistry.dentist = (JSON.parse(response)).role;
                if (Argus.teledentistry.dentist === true) {
                    $('#dental-waiting-room-alert').css('opacity','1.0').on('click',Argus.teledentistry.open.waitingRoom);
                }
            }).get();            
        }        
    });
 };