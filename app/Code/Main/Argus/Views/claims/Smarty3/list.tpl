{assign var=claim_data value=$claims->listClaims()}
{assign var=total value=0}

<style type="text/css">
    .claim_cell {
        display: inline-block; margin-left: 1px; margin-bottom: 1px; background-color: rgba(202,202,202,.2); overflow: hidden; height: 18px
    }
    .claim_header_cell {
        font-weight: bold; color: #333; text-align: center; font-size: 1em;
    }
    .claim_data_cell {
        font-family: monospace; font-size: .9em; letter-spacing: 1px; padding-left: 10px
    }
</style>
<div style='background-color: rgba(202,202,202,.1)'>
    <div class="claim_cell claim_header_cell" style="width: 7%"> &diams;    </div>
    <div class="claim_cell claim_header_cell" style="width: 7%"> Health Plan  </div>
    <div class="claim_cell claim_header_cell" style="width: 18%"> Claim File </div>
    <div class="claim_cell claim_header_cell" style="width: 13%"> Claim Number </div>
    <div class="claim_cell claim_header_cell" style="width: 5%"> Event ID </div>
    <div class="claim_cell claim_header_cell" style="width: 7%"> Member ID</div>
    <div class="claim_cell claim_header_cell" style="width: 15%"> Member Name </div>
    <div class="claim_cell claim_header_cell" style="width: 5%"> Service Date </div>
    <div class="claim_cell claim_header_cell" style="width: 7%"> Claim Total </div>
    <div class="claim_cell claim_header_cell" style="width: 7%"> Claim Submitted </div>
    <div class="claim_cell claim_header_cell" style="width: 5%"> Aldera Status </div>
</div>
{foreach from=$claim_data item=claim}
{if ($totals)}
    {assign var=total value=$total+$claim.total}
{/if}    
    <div style="height: 18px; background-color: rgba(202,202,202,{cycle values=".1,.4"}); cursor: pointer; margin-bottom: 2px" onclick="Argus.claims.detail('{$claim.id}'); return false">
        <div class="claim_cell claim_data_cell" style="width: 7%; padding-left: 0px; text-align: center; white-space: nowrap"> 
            <img style="cursor: pointer; height: 16px" title="View Form" src="/images/vision/vision.png" onclick='Argus.vision.consultation.open("{$claim.tag}"); return false' />
            &nbsp;<img style="cursor: pointer; height: 16px" title="Print Form" src="/images/vision/print_white.png" onclick='Argus.vision.consultation.print("{$claim.tag}"); return false;'/>
            &nbsp;<img style="cursor: pointer; height: 18px" onclick="Argus.claims.services(this,'{$claim.id}'); return false"  src="/images/dashboard/expand.png" />    </div>
        <div class="claim_cell claim_data_cell" style="width: 7%"> {$claim.screening_client}  </div>
        <div class="claim_cell claim_data_cell" style="width: 18%"> <a href="#" style="color: white" onclick="Argus.claims.download('{$claim.claim_file}');return false">{$claim.claim_file}</a> </div>
        <div class="claim_cell claim_data_cell" style="width: 13%"> {$claim.claim_number} </div>
        <div class="claim_cell claim_data_cell" style="width: 5%"> {if ($claim.event_id)}{$claim.event_id}{else}N/A{/if} </div>
        <div class="claim_cell claim_data_cell" style="width: 7%"> {$claim.member_number} </div>
        <div class="claim_cell claim_data_cell" style="width: 15%"> <a style="color: blue" href="#" onclick="Argus.claims.member('{$claim.member_number}'); return false">{$claim.member_name}</a> </div>
        <div class="claim_cell claim_data_cell" style="width: 5%"> {$claim.event_date|date_format:'m/d/Y'} </div>
        <div class="claim_cell claim_data_cell" style="width: 7%; text-align: center"> {$claim.total} </div>
        <div class="claim_cell claim_data_cell" style="width: 7%"> {$claim.modified|date_format:'m/d/Y'} </div>
        <div class="claim_cell claim_data_cell" style="width: 5%; text-align: center"> 
                    {if ($claim.verified == 'P')}
                        <img src="/images/argus/paid.png" style="height: 20px" />
                    {elseif ($claim.verified == 'M')}
                        <img src="/images/vision/cancel.png" title="Missing Claim in Aldera" style="height: 16px" />
                    {elseif ($claim.verified == 'R')}
                        <img src="/images/argus/denied.png" title="Rejected Claim in Aldera" style="height: 16px" />
                    {elseif ($claim.verified == 'F')}
                        <img src="/images/argus/red_x.png" title="Failed Claim in Aldera" style="height: 16px" />                        
                    {elseif ($claim.verified == 'M')}
                        <img src="/images/argus/missing.png" title="Likely Claim File Error" style="height: 16px" />                        
                    {elseif ($claim.verified == 'Z')}
                        <img src="/images/vision/cancel.png" title="Voided Claim in Aldera" style="height: 20px" />
                    {else}
                        &nbsp;
                    {/if}
        </div
    ></div>
    <div style="display: none; clear: both" id="claim_{$claim.id}_services"></div>                                                                       
{foreachelse}
    <div style="padding: 10px">
        No claims found that match search criteria
    </div>
{/foreach}
{if ($totals)}
    <div style="border-top: 1px solid #333; text-align: right; padding-right: 10px; margin-top: 5px">
        <b>Total</b>: ${$total}
    </div>
{/if}

<script type="text/javascript">
    Argus.claims.pages = '{$claims->_pages()}';
    $('#claims-list-pages').html('Page {$claims->_page()} of {$claims->_pages()}');
    $('#claims-list-rows').html('Rows {$claims->_fromRow()} to {$claims->_toRow()} of {$claims->_rowCount()}');
</script>
