<div style="color: #333; font-size: 2em">Claim Reconciliation Results</div>
<hr />
<ul>
{foreach from=$claims->unfinishedClaims() item=claim}
    <li>{$claim.claim_number}: {$aldera->evaluateClaim($claim,$aldera,$entity)}</li>
{/foreach}
{assign var=junk value=$aldera->writeReport()}
</ul>
