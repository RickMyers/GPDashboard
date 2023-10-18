<style type="text/css">
    .pagination_control {
        padding: 2px 5px; color: #333
    }    
</style>
<h3>User and User Roles Management</h3>
<div id="argus-users-display-area" style="height: 465px">

</div>
<table width='100%'>
    <tr style="background-color: #333">
        <td style="padding: 5px 0px 5px 0px; width: 20%">
            <span id='argus-users-from-row'></span>-<span id='argus-users-to-row'></span> of <span id='argus-users-rows'></span>
        </td>
        <td style="padding: 5px 0px 5px 0px" align='center'>
            <input type='button' name='argus-users-previous' id='argus-users-previous' style='' class='pagination_control' value='<' />
            <input type='button' name='argus-users-first' id='argus-users-first' style='' class='pagination_control' value='<<' />
            &nbsp;&nbsp;
            <input type='button' name='argus-users-last' id='argus-users-last' style='' class='pagination_control' value='>>' />
            <input type='button' name='argus-users-next' id='argus-users-next' style='' class='pagination_control' value='>' />
        </td>
        <td style="padding: 5px 4px 5px 0px; width: 20%" align='right' >
           <span id='argus-users-page'></span> of <span id='argus-users-pages'></span>
        </td>
    </tr>
</table>
<script type="text/javascript">   
    Argus.users.starts_with = '';
    Pagination.init('argus-users',function (page,rows) {
        var role_id = $('#user_role').val() ? $('#user_role').val() : '';
        (new EasyAjax('/argus/user/display')).add('role_id',role_id).add('starts_with',Argus.users.starts_with).add('page',page).add('rows',rows).then(function (response) {
            $('#argus-users-display-area').html(response);
            Pagination.set('argus-users',this.getPagination());
        }).post();
    },1,15);    
</script>

