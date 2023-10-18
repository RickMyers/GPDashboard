{assign var=claiming value=$users->userHasRole('Claiming')}
{assign var=od value=$users->userHasRole('O.D.')}
<style type='text/css'>
    .claims-list-container {
        border: 1px solid rgba(202,202,202,.1); height: 530px; overflow: auto; position: relative
    }
    .claims-pagination-control {
        width: 45px; font-family: sans-serif; font-size: 1.3em; font-weight:bold; color: rgba(100,100,100,.8); border: 1px solid #aaf; padding: 2px; border-radius: 2px; height: 30px
    }
    .claims-list-page {
        width: 50px; text-align: center; height: 30px; font-family: sans-serif; font-size: 1.3em; font-weight:bold; color: rgba(100,100,100,.8); border: 1px solid #aaf; padding: 2px; border-radius: 2px;
    }
    .claims-search-field {
        padding: 10px 5px; float: left; background-color: rgba(202,202,202,.1); font-family: sans-serif; margin-top: 5px; border: 1px solid transparent; font-size: 1.8em; width: 80%; box-sizing: border-box
    }
    .claims-search-field:focus {
        background-color: rgba(202,202,202,.2)
    }
    .claim-search-criteria {
        width: 140px; padding: 2px; border: 1px solid #aaf; border-radius: 2px; color: #333; margin-right: 5px; background-color: #FFEBC9;
    }
    .claim-rows {
        width: 60px; padding: 2px; border: 1px solid #aaf; border-radius: 2px; color: #333; margin-right: 5px; background-color: #FFEBC9;
    }    
    .claim-search-criteria-desc {
        font-family: monospace; font-size: .8em; letter-spacing: 1px; vertical-align: top
    }
    .argus-claim-search-float {
        display: inline-block;  margin-right: 2px; margin-bottom: 2px
    }
    .argus-claim-search-avatar {
        height: 70px; overflow: hidden; cursor: pointer; position: relative;
    }
    .argus-claim-search-field {
        width: 15%; min-width: 165px; height: 33px; border-right: 1px solid rgba(202,202,202,.4); padding-right: 4px; vertical-align: top
    }
    .argus-claim-search-address {
        height: 33px; margin-bottom: 2px; display: inline-block
    }
    .argus-claim-search-cell-title {
        vertical-align: top; font-family: sans-serif; font-size: .7em; letter-spacing: 2px; text-align: left
    }
    .argus-claim-search-cell-value {
        text-align: right; padding-right: 2px; font-family: monospace; font-size: .9em
    }
</style>
<div id="claiming_nav" style="color: #333">
</div>
{if ($claiming)}
<div id="claiming_batching">
    <hr style='opacity: .4' />
    <div style="float: right; font-size: .9em;"><span style="cursor: pointer" onclick="Landing.dashboard.home()">home</span> | <span onclick="Landing.help.home()" style="cursor: pointer">help</span></div><span style='font-size: 1.2em'>CLAIMS - Batching</span>
    <hr style='opacity: .4' />
    <div class='dashboard-icon'>
        <img src='/images/argus/claims.png' style='height: 50px; margin-top: 1px; margin-bottom: 1px' />
        <div style='text-align: center;'>
            Claims
        </div>
    </div>    
    <form name="argus-claim-batching-form" id="argus-claim-batching-form" onkeydown="Argus.claims.batching.scan(event)" onsubmit="return false">
    <input type='text' class='claims-search-field' name='batching_member_name' id='batching_member_name' placeholder='Member Name' />
    <div style='background-color: rgba(55,55,55,.3); padding: 13px; margin-top: 5px;  display: inline-block; cursor: pointer' title="Search for matching claims" onclick="Argus.claims.batching.list(1)">
       <img src='/images/argus/search.png' style='height: 32px' />
    </div><br />
    <div id="argus-criteria-layer" style="margin-top: 2px; display: block">
        <table cellspacing="0" cellpadding="0">
            <tr>
                <td>
                    <select name="claim_type" id="batching_claim_type" class="claim-search-criteria">
                        <option value="Vision">HEDIS Vision</option>
                        <option value="Dental">HEDIS Dental</option>
                    </select>                    
                </td>
                <td>
                    <select name="client_id" id="batching_client_id" class="claim-search-criteria">
                        <option value=""></option>
                        {foreach from=$clients->fetch() item=client}
                            <option value="{$client.id}">{$client.client}</option>
                        {/foreach}
                    </select>
                </td>
                <td>
                    <input type="text" name="member_number" id="batching_member_number" class="claim-search-criteria" />
                </td>
                <td>
                    <select name="event_id" id="batching_event_id" class="claim-search-criteria">
                        <option value=""></option>
                        {foreach from=$events item=event}
                            <option value="{$event.event_id}">{$event.event_id} - []</option>
                        {/foreach}
                    </select>
                </td>
                <td>
                    <select name="provider" id="batching_provider_id"  class="claim-search-criteria">
                        <option value=""></option>
                        {foreach from=$users->getUsersByRoleName('O.D.') item=provider}
                            <option value="{$provider.user_id}">{$provider.appellation} {$provider.first_name} {$provider.last_name}</option>
                        {/foreach}
                    </select>
                </td>
                <td>
                    <select name="status" id="batching_status"  class="claim-search-criteria">
                        <option value=""></option>
                        <option value="N">Not-Paid</option>
                        <option value="P">Pending</option>
                        <option value="M">Missing</option>
                        <option value="E">Error (Unknown)</option>
                    </select>                    
                </td>
                <td>
                    <select name="rows" id="batching_rows"  class="claim-rows">
                        <option value=""></option>
                        <option value="25">25</option>
                        <option value="50" selected="selected">50</option>
                        <option value="100">100</option>
                        <option value="0">All</option>
                    </select>
                </td>
                <td>
                    <button onclick="Argus.claims.batching.report(); return false" style="padding: 0px 10px 0px 10px; color: #333; margin-left: 20px">Export</button>
                </td>
            </tr>
            <tr>
                <td class="claim-search-criteria-desc">
                    Claim Type
                </td>                    
                <td class="claim-search-criteria-desc">
                    Health Plan
                </td>                    
                <td class="claim-search-criteria-desc">
                    Member ID
                </td>
                <td class="claim-search-criteria-desc">
                    Event ID
                </td>
                <td class="claim-search-criteria-desc">
                    Provider
                </td>
                <td class="claim-search-criteria-desc">
                    Status
                </td>                
                <td class="claim-search-criteria-desc">
                    Rows
                </td>           
                <td>&nbsp</td>
            </tr>
        </table>
    </div>
    </form>
    <div style='clear: both'></div>
    <hr style='opacity: .4' />
    <div id='claims-batching-container' class="claims-list-container">
        
    </div>
    <hr style='opacity: .4' />
    <div id='claims-batching-pages' style="float: right">Page 0 of 0</div>
    <div id='claims-batching-rows' style="float: left">Rows 0 of 0</div>
    <div style='width: 300px; margin-right: auto; margin-left: auto; text-align: center; position: relative' id="claims-batching-controls">
        <input type='button' class='claims-pagination-control' id="claims-batching-previous" value='<' />
        <input type='button' class='claims-pagination-control' id="claims-batching-first" value='<<' />
        &nbsp;&nbsp;
        <input type='button' class='claims-pagination-control' id="claims-batching-last" value='>>' />
        <input type='button' class='claims-pagination-control' id="claims-batching-next" value='>' />
    </div>

    <script>
        $('#claims-batching-search-field').on('keypress',Argus.claims.batching.scan);
        $('#claims-batching-previous').on('click',function () {
            Argus.claims.batching.list(--Argus.claims.batching.page);
        });
        $('#claims-batching-first').on('click',function () {
            Argus.claims.batching.list(1);
        });
        $('#claims-batching-last').on('click',function () {
            Argus.claims.batching.list(Argus.claims.batching.pages);
        });
        $('#claims-batching-next').on('click',function () {
            Argus.claims.batching.list(++Argus.claims.batching.page);
        });  
   
    </script>        
</div>
{/if}
<script type='text/javascript'>
    (function () {
        var tabs = new EasyTab('claiming_nav',175);
        tabs.add('Review',false,'claiming_review');
        {if ($claiming)}
            tabs.add('Batching',false,'claiming_batching');
        {/if}
        {if ($od)}        
            var f = (function () {
                return function () {
                    (new EasyAjax('/argus/claims/analytics')).add('year',new Date().getFullYear()).then(function (response) {
                        $('#claiming_analytics').html(response);
                    }).get();
                }
            })();
            tabs.add('Analytics',f,'claiming_analytics');
        {/if}
        tabs.tabClick(0);
    })();     
</script>
<div id="claiming_review">
    <div id="claims-top" style="position: relative">
        <hr style='opacity: .4' />
        <div style="float: right; font-size: .9em;"><span style="cursor: pointer" onclick="Landing.dashboard.home()">home</span> | <span onclick="Landing.help.home()" style="cursor: pointer">help</span></div><span style='font-size: 1.2em'>CLAIMS - Review</span>
        <hr style='opacity: .4' />
        <div class='dashboard-icon'>
            <img src='/images/argus/claims.png' style='height: 50px; margin-top: 1px; margin-bottom: 1px' />
            <div style='text-align: center;'>
                Claims
            </div>
        </div>
        <div>
            <form name="argus-claim-search-form" id="argus-claim-search-form" onkeydown="Argus.claims.scan(event)" onsubmit="return false">
            <input type='text' class='claims-search-field' name='claim_member_name' id='claim_member_name' placeholder='Member Name' />
            <div style='background-color: rgba(55,55,55,.3); padding: 13px; margin-top: 5px;  display: inline-block; cursor: pointer' title="Search for matching claims" onclick="Argus.claims.list(1)">
               <img src='/images/argus/search.png' style='height: 32px' />
            </div><br />
            <div id="argus-criteria-layer" style="margin-top: 2px; display: block">
                <table cellspacing="0" cellpadding="0">
                    <tr>
                        <td>
                            <select name="health_plan_id" id="health_plan_id" class="claim-search-criteria">
                                <option value=""></option>
                                {foreach from=$clients->fetch() item=client}
                                    <option value="{$client.id}">{$client.client}</option>
                                {/foreach}
                            </select>
                        </td>
                        <td>
                            <select name="claim_type" id="claim_type" class="claim-search-criteria">
                                <option value="Vision">HEDIS Vision</option>
                            </select>
                        </td>                    
                        <td>
                            <input type="text" name="member_number" id="claim_member_number" class="claim-search-criteria" />
                        </td>
                        <td>
                            <input type="text" name="event_id" id="claim_event_id" class="claim-search-criteria" />
                        </td>
                        <td>
                            <select name="provider" id="claim_provider"  class="claim-search-criteria">

                                {if (($users->userHasRole('HEDIS Vision Manager')) || ($users->userHasRole('System Administrator')))}
                                        <option value=""></option>
                                    {foreach from=$users->getUsersByRoleName('O.D.') item=provider}
                                        <option value="{$provider.user_id}">{$provider.appellation} {$provider.first_name} {$provider.last_name}</option>
                                    {/foreach}
                                {else}
                                    {if ($users->userHasRole('O.D.'))}
                                        <option value="{$user->getId()}">{$user->getLastName()}, {$user->getFirstName()}</option>
                                    {/if}
                                {/if}
                            </select>
                        </td>
                        <td>
                            <input type="text" name="event_date" id="claim_event_date" class="claim-search-criteria" />
                        </td>
                        <td>
                            <input type="text" name="claim_date" id="claim_date" class="claim-search-criteria" />
                        </td>
                        <td>
                            <select name="status" id="claim_status"  class="claim-search-criteria">
                                <option value=""></option>
                                <option value="Y">Paid</option>
                                <option value="A">Accepted</option>
                                <option value="D">Denied</option>
                                <option value="P">In-Process</option>
                                <option value="I">Pending</option>
                                <option value="M">Missing</option>
                            </select>
                        </td>                    
                        <td>
                            <select name="rows" id="rows"  class="claim-rows">
                                <option value=""></option>
                                <option value="25">25</option>
                                <option value="50" selected="selected">50</option>
                                <option value="100">100</option>
                                <option value="0">All</option>
                            </select>
                        </td>
                        <td>
                            <input type='hidden' name='totals' id="total" value="Y" />
                            <input type="button" value=" Export " onclick="alert('clicked'); Argus.claims.report(); return false" style="padding: 0px 10px 0px 10px; color: #333; margin-left: 20px" />
                        </td>
                    </tr>
                    <tr>
                        <td class="claim-search-criteria-desc">
                            Health Plan
                        </td>                    
                        <td class="claim-search-criteria-desc">
                            Claim Type
                        </td>                    
                        <td class="claim-search-criteria-desc">
                            Member ID
                        </td>
                        <td class="claim-search-criteria-desc">
                            Event ID
                        </td>
                        <td class="claim-search-criteria-desc">
                            Provider
                        </td>
                        <td class="claim-search-criteria-desc">
                            Event Date
                        </td>
                        <td class="claim-search-criteria-desc">
                            Claim Date
                        </td>  
                        <td class="claim-search-criteria-desc">
                            Claim Status
                        </td>                      
                        <td class="claim-search-criteria-desc">
                            Rows
                        </td>           
                        <td>&nbsp</td>
                    </tr>
                </table>
            </div>
            </form>
        </div>
        <div style='clear: both'></div>
        <hr style='opacity: .4' />
    </div>
    <div id='claims-list-container' class="claims-list-container">
        <!--div id="argus-claim-display" style="position: absolute; top: 0px; left: 0px; width: 100%; height: 100%; z-index: 99;"></div-->
    </div>
    <hr style='opacity: .4' />
    <div id='claims-list-pages' style="float: right">Page 0 of 0</div>
    <div id='claims-list-rows' style="float: left">Rows 0 of 0</div>
    <div style='width: 300px; margin-right: auto; margin-left: auto; text-align: center; position: relative' id="claims-pagination-controls">
        <input type='button' class='claims-pagination-control' id="claims-list-previous" value='<' />
        <input type='button' class='claims-pagination-control' id="claims-list-first" value='<<' />
        &nbsp;&nbsp;
        <input type='button' class='claims-pagination-control' id="claims-list-last" value='>>' />
        <input type='button' class='claims-pagination-control' id="claims-list-next" value='>' />
    </div>
</div>
{if ($od || $claiming)}
    <div id="claiming_analytics">

    </div>
{/if}
<script>
    $('#claims-search-field').on('keypress',Argus.claims.scan);
    $('#claims-list-previous').on('click',function () {
        Argus.claims.list(--Argus.claims.page);
    });
    $('#claims-list-first').on('click',function () {
        Argus.claims.list(1);
    });
    $('#claims-list-last').on('click',function () {
        Argus.claims.list(Argus.claims.pages);
    });
    $('#claims-list-next').on('click',function () {
        Argus.claims.list(++Argus.claims.page);
    });  
</script>