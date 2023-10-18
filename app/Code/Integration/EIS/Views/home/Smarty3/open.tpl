<style type="text/css">
</style>
<div id="eis_nav-{$window_id}">
</div>
<div id="eis_member_tab-{$window_id}">
    Member
</div>
<div id="eis_claim_tab-{$window_id}">
    Claim
</div>   
<div id="eis_other_tab-{$window_id}">
    Other
</div>
<script type="text/javascript">
    (function () {
        let tabs = new EasyTab('eis_nav-{$window_id}',100);
        tabs.add('Members',null,'eis_member_tab-{$window_id}');
        tabs.add('Claims',null,'eis_claim_tab-{$window_id}');
        tabs.add('Other',null,'eis_other_tab-{$window_id}');
        tabs.tabClick(0);
    })();
</script>    