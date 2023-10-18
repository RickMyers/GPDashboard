<table style="width: 100%; height: 100%">
    <tr>
        <td align="center">
            <img src="/images/argus/inprogress.gif" /><br /><br />
            A Dentist will be with you shortly.<br /><br />
            Please Wait...
        </td>
    </tr>
</table>
<script type="text/javascript">
    Argus.dashboard.socket.on('dentistStartedFacetime', function (data) {
        let w = Argus.teledentistry.windows();
        (new EasyAjax('/dental/consultation/open')).add('window_id',w.waitingRoom.id).add('room_id',data.room_id).then(function (response) {
            Argus.teledentistry.waitingRoom.refresh(response);
        }).post();
    });      
</script>
