{assign var=status      value=$application->getStatus()}
{assign var=form        value=$application->getExtractedData()|json_decode:true}
{assign var=subscriber  value=$form['subscriber']}
{assign var=payment     value=$form['payment']}
{assign var=charges     value=$payment['charges']}
<style type="text/css">
    .online-app-cell {
        display: inline-block; background-color: rgba(50,50,50,.2); padding: 0px 0px 5px 0px;
    }
    .online-app-header {
        font-family: monospace; background-color: rgba(50,50,50,.3);  padding: 5px 2px;
    }
    .online-app-field {
        padding-left: 5px 5px 5px 25px;
    }
    .eventExpandedList {
       
    }
    
</style>
<div id="online-application-navigation-{$window_id}">
</div>
{assign var=mimetype value=$application->getApplicationMimeType()}
<div id="online-application-viewer-{$window_id}" style="height: 100%; padding: 5px">
    
    {if ($mimetype=="application/pdf")}
    <center>
    <iframe id="online-application-iframe-{$window_id}" frameborder='0' style="margin-left: auto; margin-right: auto" width="90%" height="100%" src="/argus/onlineapps/pdf?app_id={$application->getApplicationId()}"></iframe>
    </center>
    {elseif ($mimetype=="text/csv")}
    {elseif ($mimetype=="application/edi-x12")}
    {/if}
</div>
<div id="online-application-event-{$window_id}" style="overflow: auto">

</div>

<div id="online-application-data-{$window_id}" style="overflow: auto">

    <div style="width: 805px; white-space: nowrap; margin-left: auto; margin-right: auto; padding-top: 40px">
    <h3>Application Data</h3>
    <div style="width: 400px; display: inline-block">
        <ul>
            <li>Plan
                <ul>
                    <li>Application ID: <b>{$form['application-id']}</b></li>
                    <li>Effective Date: <b>{$form['start-date']}</b></li>
                    <li>Termination Date: <b>{$form['end-date']}</b></li>
                    <li>Broker: <b>{*$form['source']*}</b></li>
                </ul>
            </li>
            <li>Subscriber
                <ul>
                    <li>First Name: <b>{$subscriber['first-name']}</b></li>
                    <li>Last Name: <b>{$subscriber['last-name']}</b></li>
                    <li>Gender: <b>{$subscriber['gender']}</b></li>
                    <li>DOB: <b>{$subscriber['DOB']}</b></li>
                    <li>SSN: <b>{$subscriber['ssn']}</b></li>
                    <li>Phone #: <b>{$subscriber['phone']}</b></li>
                    <li>E-Mail: <b>{$subscriber['email']}</b></li>
                </ul>
            </li>

            <li>Payment
                <ul>
                    <li>Card Number: <b>{$payment['credit-card']['number']}</b></li>
                    <li>Card Type: <b>{if (isset($payment['credit-card']['type']))}{$payment['credit-card']['type']}{/if}</b></li>
                    <li>Expiration: <b>{$payment['credit-card']['expiration']['month']}-{$payment['credit-card']['expiration']['year']}</b></li>
                </ul>
            </li>
            <li>Charges
                <ul>
                    <li>Initial: <b></b></li>
                    <li>Recurring: <b></b></li>
                </ul>
            </li>
        </ul>
    </div>
    <div style="display: inline-block; vertical-align: top; width: 400px">
        <ul>
            <li>Dependents
                {foreach from=$subscriber['dependents'] item=dependent}
                <ul>
                    <li>Name: <b>{$dependent['first-name']} {$dependent['last-name']} </b>
                        <ul>
                            <li>Gender: <b>{$dependent['gender']}</b></li>
                            <li>DOB: <b>{$dependent['DOB']}</b></li>
                            <li>SSN: <b>{if (isset($dependent['ssn']) && ($dependent['ssn']))}{$dependent['ssn']}{/if}</b></li>
                            <li>Relationship: <b>{$dependent['relation']}</b></li>                            
                        </ul>
                    </li>
                </ul>
                {/foreach}
            </li>
        </ul>
    </div>
    </div>
</div>
<div id="online-application-viewer-controls-{$window_id}" style="text-align: center; padding: 5px">
        
        
        <div style="width: 830px; margin-left: auto; margin-right: auto">
            <div class="online-app-cell" style="background-color: ghostwhite;">
                <img src="/images/argus/refund.png" style="height: 50px; cursor: pointer;  margin-bottom: 15px" />
            </div>
            <div class="online-app-cell">
                <div class="online-app-header">
                    Date Received
                </div>
                <div class="online-app-field">
                    {$application->getModified()|date_format:"m/d/Y"}&nbsp;
                </div>                
            </div>
            <div class="online-app-cell">
                <div class="online-app-header">
                    Requested Date
                </div>
                <div class="online-app-field">
                    {$application->getRequestedEffectiveDate()|date_format:"m/d/Y"}&nbsp;
                </div>                
            </div>
            <div class="online-app-cell" style="background-color: inherit">
                <b>Current State</b><br />
                <select name="status" id="online-application-status" style="background-color: lightcyan; padding: 4px; border-radius: 4px; border: 1px solid #aaf">
                    <option value="N">New Application</option>
                    <option value="I">Processing...</option>
                    <option value="E">Errored</option>
                    <option value="A">Declined</option>
                    <option value="A">Approved</option>
                    <option value="V">Archived</option>
                </select>
            </div>
            <div class="online-app-cell">
                <div class="online-app-header">
                    Last Action
                </div>
                <div class="online-app-field">
                    {$application->getLastAction()|ucfirst}&nbsp;
                </div>                
            </div>
            <div class="online-app-cell">
                <div class="online-app-header">
                    Last Action Date
                </div>
                <div class="online-app-field">
                    {$application->getLastActionDate()|date_format:"m/d/Y"}&nbsp;
                </div>                
            </div>   
            <div class="online-app-cell" style="background-color: ghostwhite;">
                <img src="/images/argus/void.png" style="height: 30px; margin-bottom: 20px; cursor: pointer;" />                    
            </div>
        </div>

    
</div>
<script type="text/javascript">
    (function ($) {
        /*Argus.apps('{$window_id}',
            new Vue({
                el: '#online-apps-event-log-{$window_id}',
                data: {
                    'event': ''
                }
            })
        );*/       
        var win = Desktop.window.list['{$window_id}'];
        win.resize = function () {
            $('#online-application-viewer-{$window_id}').height(win.content.offsetHeight - $('#online-application-viewer-controls-{$window_id}').height() - 45);
            $('#online-application-iframe-{$window_id}').height(win.content.offsetHeight - $('#online-application-viewer-controls-{$window_id}').height() - 35);
            $('#online-application-data-{$window_id}').height(win.content.offsetHeight - $('#online-application-viewer-controls-{$window_id}').height() - 45);
            $('#online-application-event-{$window_id}').height(win.content.offsetHeight - $('#online-application-viewer-controls-{$window_id}').height() - 45);
        }
        win._resize();
        var tabs = new EasyTab('online-application-navigation-{$window_id}',150);
        tabs.add('Application',false,"online-application-viewer-{$window_id}");
        tabs.add('Form Data',false,"online-application-data-{$window_id}");
        tabs.add('Event Log',
            (function (mongo_id,tab) {
                (new EasyAjax('/argus/onlineapps/event')).add('window_id','{$window_id}').add('id',mongo_id).then(function (response) {
                    $(tab).html(response);
                }).post();            
            })('{$application->getMongoId()}',$E('online-application-event-{$window_id}')),
            'online-application-event-{$window_id}'
        );
        tabs.tabClick(0);

    })($)
</script>