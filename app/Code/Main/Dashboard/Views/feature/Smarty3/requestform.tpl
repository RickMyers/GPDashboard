<style type="text/css">
    .dashboard-bug-tab {
        font-size: 1em; color: #333; padding: 5px
    }
    .dashboard-request-descriptor {
        font-family: monospace; font-size: .9em; letter-spacing: 1px
    }
    .dashboard-bug-description {
        width: 100%; height: 200px; display: inline-block;
    }
    .dashboard-request-row {
        white-space: nowrap; overflow: hidden;
    }
    .dashboard-request-cell {
        display: inline-block; overflow: hidden; white-space: nowrap
    }
    .dashboard-select {
        width: 100%; min-width: 150px
    }
    .dashboard-request-button {
        background-color: navy; padding: 2px 5px; display: inline-block; color: ghostwhite
    }
</style>
<div id="dashboard_request_form_tabs">
    
</div>
<div id="dashboard_bug_tab" class="dashboard-bug-tab">
    <form name="dashboard_bug_form" id="dashboard_bug_form" onsubmit="return false">
        <input type="hidden" name="request_type" id="bug_request_type" value="Bug" />
        <fieldset class="dashboard-request-instructions"><legend>Instructions</legend>
            Please identify below the component/module that had the bug, set a priority, and describe in some detail what the issue is.  You may take screenshots of the issue and paste them 
            into the area identified below to attach one or more screenshots.
        </fieldset>
        <br />
        <div class="dashboard-request-row">
            <div class="dashboard-request-cell" style="width: 29%">
                <select name="module" id="dashboard_bug_module" class="dashboard-select">
                    <option value=""></option>
                    {foreach from=$modules->fetch() item=module}
                        <option value="{$module.id}" title="{$module.description}">{$module.module}</option>
                    {/foreach}
                </select><input type="text" name="dashboard_bug_module_combo" id="dashboard_bug_module_combo" value="" placeholder="Select or type a value" /><br />
                <div class="dashboard-request-descriptor">
                    Component/Module
                </div>
            </div>
            <div class="dashboard-request-cell" style="width: 29%">
                <select name="feature" id="dashboard_bug_feature" class="dashboard-select">
                    <option value=""></option>
                    {foreach from=$features->fetch() item=feature}
                        <option value="{$feature.id}" title="{$feature.description}">{$feature.feature}</option>
                    {/foreach}
                    
                </select><input type="text" name="dashboard_bug_feature_combo" id="dashboard_bug_feature_combo" value=""  placeholder="Select or type a value" /><br />
                <div class="dashboard-request-descriptor">
                    Feature
                </div>
            </div>
            <div class="dashboard-request-cell" style="width: 29%">
                <select name="priority" id="dashboard_bug_priority" class="dashboard-select">
                    <option value=""></option>
                    <option value="1" style="color: green">Low</option>
                    <option value="2" style="color: orange">Medium</option>
                    <option value="3" style="color: red">High</option>
                </select><br />
                <div class="dashboard-request-descriptor">
                    Priority
                </div>
            </div>
            <div class="dashboard-request-cell" style="width: 10%; vertical-align: top">                
                <button class="dashboard-request-button" id="dashboard_bug_submit">Report Bug</button>
            </div>
        </div>
        <br />
        <div class="dashboard-request-row">
            <div class="dashboard-request-cell" style="width: 100%">
                <input type="text" name="subject" id="dashboard_bug_subject" class="dashboard-select" style="width: 90%" />
                
                <div class="dashboard-request-descriptor">
                    Subject of Bug
                </div>
            </div>
        </div>
        <br />
        <div class="dashboard-request-cell" style="width: 49%">
            <textarea name="description" id="dashboard_bug_description" class="dashboard-bug-description"></textarea>
            <div class="dashboard-request-descriptor">
                Bug Description
            </div>            
        </div>
        <div class="dashboard-request-cell" style="width: 49%; vertical-align: top">
            <img src="" id="dashboard_bug_screenshot" style="width: 100%; height: 200px" />
            <center>
                <button id="dashboard_bug_screenshot_attach" style="background-color: cadetblue; color: ghostwhite; padding: 2px 5px; border: 1px solid darkblue; border-radius: 2px">Attach Screenshot</button>
            </center>
        </div>
<br />
    </form>
</div>
<div id="dashboard_feature_tab" class="dashboard-bug-tab">
    <form name="dashboard_feature_form" id="dashboard_feature_form" onsubmit="return false">
        <input type="hidden" name="request_type" id="feature_request_type" value="Feature" />
        <fieldset class="dashboard-request-instructions"><legend>New Feature Request Instructions</legend>
            Please identify below the component/module that requires the new functionality, set a priority, and describe in some detail what you would like. If you have a BRD of some kind, please
            attach it below.
        </fieldset>
        <br />
        <div class="dashboard-request-row">
            <div class="dashboard-request-cell" style="width: 29%">
                <select name="module" id="dashboard_feature_module" class="dashboard-select">
                    <option value=""></option>
                    {foreach from=$modules->fetch() item=module}
                        <option value="{$module.id}" title="{$module.description}">{$module.module}</option>
                    {/foreach}
                </select><input type="text" name="dashboard_feature_module_combo" id="dashboard_feature_module_combo" value="" placeholder="Select or type a value" /><br />
                <div class="dashboard-request-descriptor">
                    Component/Module
                </div>
            </div>
            <div class="dashboard-request-cell" style="width: 29%">
                <select name="feature" id="dashboard_feature" class="dashboard-select">
                    <option value=""></option>
                    {foreach from=$features->fetch() item=feature}
                        <option value="{$feature.id}" title="{$feature.description}">{$feature.feature}</option>
                    {/foreach}
                    
                </select><input type="text" name="dashboard_feature_combo" id="dashboard_feature_combo" value=""  placeholder="Select or type a value" /><br />
                <div class="dashboard-request-descriptor">
                    Feature
                </div>
            </div>
            <div class="dashboard-request-cell" style="width: 29%">
                <select name="priority" id="dashboard_feature_priority" class="dashboard-select">
                    <option value=""></option>
                    <option value="1" style="color: green">Low</option>
                    <option value="2" style="color: orange">Medium</option>
                    <option value="3" style="color: red">High</option>
                </select><br />
                <div class="dashboard-request-descriptor">
                    Priority
                </div>
            </div>
            <div class="dashboard-request-cell" style="width: 10%; vertical-align: top">                
                <button class="dashboard-request-button" id="dashboard_feature_submit">Request Feature</button>
            </div>
        </div>
        <br />
        <div class="dashboard-request-cell" style="width: 100%">
            <input type="text" name="subject" id="dashboard_subject" class="dashboard-select" style="width: 90%" />

            <div class="dashboard-request-descriptor">
                Short Description of Feature
            </div>
        </div><br /><br />
        <div class="dashboard-request-cell" style="width: 100%">
            <textarea name="description" id="dashboard_feature_description" class="dashboard-bug-description"></textarea>
            <div class="dashboard-request-descriptor">
                Full Feature Description
            </div>            
        </div>
        <table style="width: 100%">
            <tr>
                <td width="100">BRD: </td>
                <td><input type="file" name="feature_brd" id="feature_brd" width="100%" /></td>
            </tr>
        </table>
        </div>
    <br />
    </form>
    
</div>
<div id="dashboard_requests_tab" class="dashboard-bug-tab">
    <form name="feature-filter-form" id="feature-filter-form" style="position: relative" onsubmit="return false">
        <select name="module" id="filter-module">
            <option value=""></option>
            {foreach from=$modules->fetch() item=module}
                <option value="{$module.id}" title="{$module.description}">{$module.module}</option>
            {/foreach}            
        </select>
        <select name="feature" id="filter-feature">
            <option value=""></option>
            {foreach from=$features->fetch() item=feature}
                <option value="{$feature.id}" title="{$feature.description}">{$feature.feature}</option>
            {/foreach}            
        </select>
        <select name="submitter" id="filter-submitter">
            <option value=""></option>
        </select>
        <select name="status" id="filter-status">
            <option value=""></option>
            <option value="N">New</option>
            <option value="I">In-Progress</option>
            <option value="H">On-Hold</option>
            <option value="C">Completed</option>
        </select>
        <select name="priority" id="filter-priority">
            <option value=""></option>
            <option value="1" style="color: green">Low</option>
            <option value="2" style="color: orange">Medium</option>
            <option value="3" style="color: red">High</option>            
        </select>
        <input type="button" name="filter-submit" id="filter-submit" value="" />
    </form>
    <div id="dashboard_feature_request_list" style="border-top: 3px solid #333; overflow: auto; margin-top: 1px"></div>
</div>

<script type="text/javascript">
  
    async function getClipboardContents() {
        const clipboardItems = await navigator.clipboard.read();
        for (const clipboardItem of clipboardItems) {
            for (const type of clipboardItem.types) {
                const blob = await clipboardItem.getType(type);
            }
        }        
    }
  
    function _arrayBufferToBase64( buffer ) {
        var binary = '';
        var bytes = new Uint8Array( buffer );
        var len = bytes.byteLength;
        for (var i = 0; i < len; i++) {
            binary += String.fromCharCode( bytes[ i ] );
        }
        return window.btoa( binary );
    }
    (function () {
        $('#dashboard_bug_screenshot_attach').on('click',function (evt) {
            navigator.permissions.query({ name: "clipboard-read" }).then(result => {
                if (result.state == "granted" || result.state == "prompt") {
                     navigator.clipboard.read().then(clipboardItems => {
                        for (const clipboardItem of clipboardItems) {
                            for (const type of clipboardItem.types) {
                                const blob = clipboardItem.getType(type).then(function (image) {
                                    const blob = new Blob([image],{ type: 'image/png' });
                                    blob.arrayBuffer().then(data => {
                                        $E('dashboard_bug_screenshot').src = "data:image/png;base64,"+_arrayBufferToBase64(data);
                                    });
                                });
                            }
                        }
                    });
                } else {
                    alert('Didnt get permission');
                };
            });
        });          
        var xy = new EasyEdits('/edits/dashboard/bugreport','dashboard-bug-report');
        var xx = new EasyEdits('/edits/dashboard/featurerequest','dashboard-feature-request');
        new EasyEdits('/edits/dashboard/featurefilter','dashboard-feature-filter')
        Argus.dashboard.feature.win.resize = function () {
            EasyEdits.resetCombos(xy);
            EasyEdits.resetCombos(xx);
            $('#dashboard_feature_request_list').height(Argus.dashboard.feature.win.content.offsetHeight - $E('feature-filter-form').offsetHeight - $E('dashboard_request_form_tabs').offsetHeight -15);
        }        
        var tabs = new EasyTab('dashboard_request_form_tabs',135);
        tabs.add('Report Bug',function () { EasyEdits.resetCombos(xy);  },'dashboard_bug_tab');
        tabs.add('Feature Request',function () { EasyEdits.resetCombos(xx);  },'dashboard_feature_tab');
        tabs.add('Bug/Requests List',Argus.dashboard.feature.list,'dashboard_requests_tab');
        tabs.tabClick(0);
    })();
</script>