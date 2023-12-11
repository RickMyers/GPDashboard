<style type="text/css">
</style>
<div id="eis_nav-{$window_id}">
</div>
<div id="eis_member_tab-{$window_id}">
    <form name="eis_member_form" id="eis_member_form-{$window_id}" onsubmit="return false">
        <br />
        <input type="text" name="member_id" id="member_id-{$window_id}" style="" placeholder="Member ID" /><button name="member_id_submit" id="member_id_submit-{$window_id}"> Search </button>
        <hr />
        <div id="member_search_results-{$window_id}">
        </div>
    </form>
</div>
<div id="eis_claim_tab-{$window_id}">
    <form name="eis_claim_form" id="eis_claim_form-{$window_id}" onsubmit="return false">
        <br />
        <input type="text" name="claim_number" id="claim_number-{$window_id}" style="" placeholder="Claim Number" /><button name="claim_number_submit" id="claim_number_submit-{$window_id}"> Search </button>
        <hr />
        <div id="claim_search_results-{$window_id}">
        </div>
    </form>
</div>   
<div id="eis_other_tab-{$window_id}">
    Other
    <hr />
</div>
<script type="text/javascript">
    (function () {
        let tabs = new EasyTab('eis_nav-{$window_id}',100);
        tabs.add('Members',null,'eis_member_tab-{$window_id}');
        tabs.add('Claims',null,'eis_claim_tab-{$window_id}');
        tabs.add('Other',null,'eis_other_tab-{$window_id}');
        tabs.tabClick(0);
        
        let xx = new EasyEdits('','eis_member_search-{$window_id}');
        xx.fetch("/edits/eis/membersearch");
        xx.process(xx.getJSON().replace(/&&win_id&&/g,'{$window_id}'));
        
        let yy = new EasyEdits('','eis_claim_search-{$window_id}');
        yy.fetch("/edits/eis/claimsearch");
        yy.process(yy.getJSON().replace(/&&win_id&&/g,'{$window_id}'));        
    })();
</script>    