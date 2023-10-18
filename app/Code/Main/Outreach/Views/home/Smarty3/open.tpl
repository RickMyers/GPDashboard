{assign var=manager value=true}
<style type="text/css">
    .outreach-queue {
        min-width: 250px; background-image: linear-gradient(135deg, rgba(100,100,255,.3), dodgerblue); border: 1px solid ghostwhite; display: inline-block; margin-left: .5%; margin-right: .5%; width: 23.75%
    }
    .outreach-queue-header {
        padding: 2px; text-align: center; font-weight: bolder; color: ghostwhite; font-family: monospace; letter-spacing: 1px; border-bottom: 1px solid ghostwhite; white-space: nowrap
    }
    .outreach-queue-body {
        overflow-y: auto; overflow-x: hidden  
    }
    .outreach-queue-footer {
        padding: 2px; text-align: center; font-family: monospace; letter-spacing: 1px; border-top: 1px solid ghostwhite; position: relative
    }
    .outreach-cell {
        display: inline-block; overflow: hidden; white-space: nowrap; margin: 0px 
    }    
    .outreach-desc {
        font-weight: bolder; color: ghostwhite; font-family: monospace; font-size: .85em; overflow: hidden; margin: 0px
    }
    .outreach-field {
        padding-left: 15px; font-size: .95em; color: #333; font-family: sans-serif; overflow: hidden; margin: 0px
    }
    .outreach-rows { 
        position: absolute; left: 2px;
    }
    .outreach-pages {
        float: right;
    }
    .outreach-coordinator-contact-assignment {
        width: 40px; font-size: .9em; color: #333; padding: 2px; border-radius: 2px; border: 1px solid #aaf; background-color: lightcyan; text-align: center; font-family: monospace
    }
</style>
<div id="outreach_app" style='padding-left: 10px'>
    <div id="outreach_tabs">
    </div>
    <div id="outreach_queues_tab">
        <div id="outreach_header">
            <div style="float: right; white-space: nowrap">
                <div style="width: 200px; height: 100px; display: inline-block; margin-right: 4px;  background-color: rgba(202,202,202,.3)">
                    <div style=" background-color: rgba(202,202,202,.3)">By Status</div>
                    <canvas style="width: 100%; height: 80px;" id="outreach_graph_1"></canvas>
                </div>
                <div style="width: 200px; height: 100px; display: inline-block; margin-right: 2px;  background-color: rgba(202,202,202,.3)">
                    <div style=" background-color: rgba(202,202,202,.3)">By Participant</div>
                    <canvas style="width: 100%; height: 80px;" id="outreach_graph_2"></canvas>
                </div>
                <div style="width: 200px; height: 100px; display: inline-block; margin-right: 2px; background-color: rgba(202,202,202,.3)">
                    <div style=" background-color: rgba(202,202,202,.3)">Total</div>
                    <canvas style="width: 100%; height: 80px;" id="outreach_graph_3"></canvas>
                </div>            
            </div>
            <div style="display: inline-block">
                <form name="outreach_campaign_selection_form" id="outreach_campaign_selection_form" onsubmit="return false">
                    <select name="campaign" id="outreach_campaign">
                        <option value=""> </option>
                        {foreach from=$campaigns->involved() item=campaign}
                            <option value="{$campaign.id}"> {$campaign.campaign} </option>
                        {/foreach}
                    </select><br />
                    <span style='font-family: monospace; font-size: .9em; letter-spacing: 1px; white-space: nowrap'>Campaign</span>
                </form>
            </div>
        </div>

        <div style="clear: both"></div>
        <div id="outreach_coordinators" style="height: 60px; text-align: center; white-space: nowrap">
            <table style="width: 100%"><tr>
            {foreach from=$coordinators->usersWithRoleName('Outreach') item=coordinator}
                <td><div style='overflow: hidden; width: 60px; height: 60px; display: inline-block; border: 1px solid #d7d7d7; position: relative; margin-left: auto; margin-right: auto'>
                    <img id='outreach_coordinator_{$coordinator.user_id}' onload="Argus.tools.image.align(this)" src="/images/argus/avatars/{$coordinator.user_id}.jpg?cachebust=1650460115.6192" onerror="this.src='/images/argus/placeholder-{$coordinator.gender}.png'" style="display: inline-block; height: 100%; opacity: .3" />
                    <div style='position: absolute; width: 100%; bottom: 1px; font-size: .7em; text-align: center; font-family: sans-serif; color: #333'>{$coordinator.last_name}</div>
                    </div></td>
            {/foreach}</tr>
            </table>
        </div>        
        <div id="outreach_queues" style="white-space: nowrap; width: 100%">
            <div id="outreach_unassigned_queue" class="outreach-queue">
                <div class="outreach-queue-header">
                    <img src="/images/outreach/upload.png" id='outreach_upload_icon' onclick="Argus.outreach.upload.form(); return false" style="cursor: pointer; height: 20px; float: left" title="Upload Member List"/>
                    <img src="/images/outreach/assign.png" id='outreach_assign_icon' onclick="Argus.outreach.assign.page(); return false" style="cursor: pointer; height: 20px; float: right" title="Assign Contacts"/>Unassigned
                </div>
                <div class="outreach-queue-body" id="outreach_queue_unassigned">
                </div>
                <div class="outreach-queue-footer">
                    <div id="outreach_rows_unassigned" class="outreach-rows"></div>
                    <button class="outreach-app-pagination" queue="unassigned" page="-1"> &lt; </button>
                    <button class="outreach-app-pagination" queue="unassigned" page="0"> &lt;&lt; </button>
                    &nbsp; &nbsp;
                    <button class="outreach-app-pagination" queue="unassigned" page="99"> &gt;&gt; </button>
                    <button class="outreach-app-pagination" queue="unassigned" page="1"> &gt; </button>
                    <div id="outreach_pages_unassigned" class="outreach-pages"></div>
                </div>
            </div>
            <div id="outreach_assigned_queue" class="outreach-queue">
                <div class="outreach-queue-header">
                    Assigned
                </div>
                <div class="outreach-queue-body" id="outreach_queue_assigned">
                </div>
                <div class="outreach-queue-footer">
                    <div id="outreach_rows_assigned" class="outreach-rows"></div>
                    <button class="outreach-app-pagination" queue="assigned" page="01"> &lt; </button>
                    <button class="outreach-app-pagination" queue="assigned" page="0"> &lt;&lt; </button>
                    &nbsp; &nbsp;
                    <button class="outreach-app-pagination" queue="assigned" page="99"> &gt;&gt; </button>
                    <button class="outreach-app-pagination" queue="assigned" page="1"> &gt; </button>
                    <div id="outreach_pages_assigned" class="outreach-pages"></div>
                </div>
            </div>
            <div id="outreach_returned_queue" class="outreach-queue">
                <div class="outreach-queue-header">
                    Returned
                </div>
                <div class="outreach-queue-body" id="outreach_queue_returned">
                </div>
                <div class="outreach-queue-footer">
                    <div id="outreach_rows_returned" class="outreach-rows"></div>
                    <button class="outreach-app-pagination" queue="returned" page="-1"> &lt; </button>
                    <button class="outreach-app-pagination" queue="returned" page="0"> &lt;&lt; </button>
                    &nbsp; &nbsp;
                    <button class="outreach-app-pagination" queue="returned" page="99"> &gt;&gt; </button>
                    <button class="outreach-app-pagination" queue="returned" page="1"> &gt; </button>
                    <div id="outreach_pages_returned" class="outreach-pages"></div>
                </div>
            </div>
            <div id="outreach_completed_queue" class="outreach-queue">
                <div class="outreach-queue-header">
                    Completed
                </div>
                <div class="outreach-queue-body" id="outreach_queue_completed">
                </div>
                <div class="outreach-queue-footer">
                    <div id="outreach_rows_completed" class="outreach-rows"></div>
                    <button class="outreach-app-pagination" queue="completed" page="-1"> &lt; </button>
                    <button class="outreach-app-pagination" queue="completed" page="0"> &lt;&lt; </button>
                    &nbsp; &nbsp;
                    <button class="outreach-app-pagination" queue="completed" page="99"> &gt;&gt; </button>
                    <button class="outreach-app-pagination" queue="completed" page="1"> &gt; </button>
                    <div id="outreach_pages_completed" class="outreach-pages"></div>
                </div>
            </div>
        </div>
    </div>
    {if ($manager)}
    <div id="outreach_admin_tab">
        
        


    </div>
    {/if}
</div>
<div id='outreach_graph_data'>
</div>
<script type="text/javascript">
    (function () {
        var win = Argus.outreach.win = Argus.outreach.win ? Argus.outreach.win : Desktop.window.list['{$window_id}'];
        
        win.close = function () {
            $('.outreach-app-pagination').unbind('click');
            return true;
        }
        console.log(win);
        win._scroll(true);
        Argus.outreach.queues.ref.unassigned = $E('outreach_queue_unassigned');
        Argus.outreach.queues.ref.assigned   = $E('outreach_queue_assigned');
        Argus.outreach.queues.ref.returned   = $E('outreach_queue_returned');
        Argus.outreach.queues.ref.completed  = $E('outreach_queue_completed');
        win._static(true);   //there shall only ever be one window
        var tabs = new EasyTab('outreach_tabs',120);
        tabs.add('Queues',null,'outreach_queues_tab');
        {if ($manager)}
            let f = function () { 
                (new EasyAjax('/outreach/campaign/admin')).then(function (response) {
                    $('#outreach_admin_tab').html(response);
                }).get();
            }
            tabs.add('Administration',f,'outreach_admin_tab');
        {/if}
        win.splashScreen('<table style="width: 100%; height: 100%"><tr><td align="center"><img src="/images/outreach/outreach_logo.png"/><br /><h2 style="color: ghostwhite">Argus Member Outreach</h1></td></tr></table>');
        window.setTimeout(function () { win.splashScreen(''); tabs.tabClick(0); win.resize() },1500);
        win.resize = function () {
            var h = win.content.offsetHeight - $E('outreach_tabs').offsetHeight - 160 - $E('outreach_coordinators').offsetHeight - $('.outreach-queue-footer').height();
            //console.log(win.content.offsetHeight,$E('outreach_tabs').offsetHeight,$E('outreach_coordinators').offsetHeight,$('.outreach-queue-footer').height(),h);
            $('.outreach-queue-body').height(h);
        };
        $('.outreach-app-pagination').on('click',function (evt) {
            let queue = evt.target.getAttribute('queue');
            let offset = +evt.target.getAttribute('page');
            if (offset === 99) {
                Argus.outreach.queues.page[queue].current = Argus.outreach.queues.page[queue].total;
            } else if (offset === 0) {
                Argus.outreach.queues.page[queue].current = 1;
            } else {
                Argus.outreach.queues.page[queue].current += offset;
                if (Argus.outreach.queues.page[queue].current > Argus.outreach.queues.page[queue].total) {
                    Argus.outreach.queues.page[queue].current = 1;
                } else if (Argus.outreach.queues.page[queue].current < 1) {
                    Argus.outreach.queues.page[queue].current = Argus.outreach.queues.page[queue].total
                }
            }
            Argus.outreach.queues.refresh($('#outreach_campaign').val(),queue);
        });
        win.close = function () {
            Argus.outreach.listeners.close();
        }
        (new EasyEdits('/edits/outreach/campaign','outreach_campaign'));
    })();
</script>