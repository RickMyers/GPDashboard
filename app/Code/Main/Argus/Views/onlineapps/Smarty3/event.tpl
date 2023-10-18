<div style="padding: 10px 10px 10px 40px;">
{$helper->expandEvent($event->load(),'eventExpandedList')}
</div>
<script type="text/javascript">
    $('.eventExpandedList').on('click',function (e) {
        e.stopPropagation();
        $(e.target).find('>:first-child').slideToggle();
    });                    
</script>