{assign var=totals value=$claims->getTotals()}
Results of claiming:<br /><br />
<table>
{foreach from=$claims->getTotals() item=total key=category}
    <tr><td align='right'>{$category}:</td><td style='padding-left: 25px'>{$total}</td></tr>
{/foreach}
</table><br /><br />
<center>
    <button onclick="$('#desktop-lightbox').css('display','none').html(''); return false">Click to Close</button>
</center>
