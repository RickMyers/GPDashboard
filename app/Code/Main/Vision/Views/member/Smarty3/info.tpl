<style type="text/css">
    .vision-member-field {
        font-family: sans-serif; font-size: 1.0em
    }
    .vision-member-descriptor {
        font-family: monospace; letter-spacing: 2px; font-size: .9em; padding-bottom: 10px
    }
    .vision-member-input {
        background-color: lightcyan; padding: 2px; border: 1px solid #aaf; border-radius: 2px
    }
</style>
<div id="member_add_form-{$window_id}">
</div>
<script type="text/javascript">
    (function () {
        var app = new Vue({
            el: '#member_add_form-{$window_id}',
            data: {
                health_plan_id: "",
                event_id: "",
                first_name: "",
                last_name: "",
                member_number: "",
                address: "",
                city: "",
                state: "",
                zip_code: "",
                gender: "",
                date_of_birth: "",
                hba1c: "",
                hba1c_date: "",
                fbs: "",
                fbs_date: ""
            },
            template: Humble.template('vision/member_update'),
            created: function () {
                var me = this;
                (new EasyAjax('/vision/member/missing')).add('id','{$id}').then(function (response) {
                    var data = JSON.parse(response);
                    me.health_plan_id = data.health_plan_id;
                    me.first_name = data.first_name;
                    me.last_name  = data.last_name;
                    me.member_number  = data.member_number;
                    me.event_id   = data.event_id;
                    if (data.data) {
                        me.hba1c        = data.data['HBA1C'];
                        me.hba1c_date   = data.data['HBA1C DATE'];
                        me.fbs          = data.data['FBS'];
                        me.fbs_date     = data.data['FBS DATE'];
                    }
                }).post();
            },
            methods: {
                createNewMember: function () {
                    (new EasyAjax('/vision/member/add')).addModel(this).then(function (response) {
                        alert(response);
                    }).post();
                }
            }
        });
        Argus.apps('{$window_id}',app);
        //console.log(app);
    })();
</script>
