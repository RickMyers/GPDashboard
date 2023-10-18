<style type="text/css">
    .new-project-input-desc {
        font-family: monospace; letter-spacing: 2px; font-size: .8em; padding-bottom: 12px
    }
    .new-project-input-field {
        padding: 2px; border: 1px solid #aaf; border-radius: 2px
    }
    .new-report-input-desc {
        font-family: monospace; letter-spacing: 2px; font-size: .8em; padding-bottom: 12px
    }
    .new-report-input-field {
        padding: 2px; border: 1px solid #aaf; border-radius: 2px
    }    
    .project-header {
        padding-top: 20px; font-size: 2.4em; border-bottom: 1px solid rgba(202,202,202,.5);
    }
</style>
<ul>
<a href="#" onclick="$('#new-project-form-layer').slideToggle(); return false">New Project...</a><br />
<div id="new-project-form-layer" style="display: none">
    
    <form name="new-project-form" id="new-project-form" onsubmit="return false">
        <br />
        <div class="new-project-input-area">
            <input type="text" name="project_name" id="project_name" class="new-project-input-field" />
        </div>
        <div class="new-project-input-desc">
            Project Name
        </div>
        <div class="new-project-input-area">
            <textarea name="project_description" id="project_description"  class="new-project-input-field" >
                
            </textarea>
        </div>
        <div class="new-project-input-desc">
            Project Description
        </div>        
        <div class="new-project-input-area">
            <input type='button' id='new_project_submit' value='Create New Project' />
        </div>
    </form>
</div>
{assign var=p_id value=''}
{foreach from=$projects->contents() item=project}
    {if ($project.project_id != $p_id)}
        {if ($p_id != '')}</ul>{/if}
    <div class="project-header">
        {$project.project_name}
    </div><ul>
    <a href="#" onclick="$('#new-report-form-layer-{$project.project_id}').slideToggle(); return false">New Report...</a><br />
    <div id="new-report-form-layer-{$project.project_id}" style="display: none">
        <br />
        <form name="new-project-report-form-{$project.project_id}" id="new-project-report-form-{$project.project_id}" onsubmit="return false">
            <input type="hidden" name="project_id" id="project_id-{$project.project_id}" value="{$project.project_id}" />
            <div class="new-report-input-area">
                <input type="text" name="report_name" id="report_name-{$project.project_id}" class="new-report-input-field" />
            </div>
            <div class="new-report-input-desc">
                Report Name
            </div>
            <div class="new-report-input-area">
                <textarea name="report_description" id="report_description-{$project.project_id}"  class="new-report-input-field" >

                </textarea>
            </div>
            <div class="new-report-input-desc">
                Report Description
            </div>      
            <div class="new-report-input-area">
                <br />
                <input type='button' name="new_report_submit" id='new_report_submit-{$project.project_id}' value='Create New Report' />
            </div>            
        </form>
        <script type="text/javascript">
            var ee = new EasyEdits(null,"new-report-form-{$project.project_id}");
            ee.fetch("/edits/argus/newreport", function () {
                this.process(this.getJSON().replace(/&&pid&&/g,'{$project.project_id}'));
            });
        </script>
    </div>    
    {assign var=p_id value=$project.project_id}
    {/if}
    
{/foreach}
</ul>
<script type="text/javascript">
    (new EasyEdits('/edits/argus/newproject','new-project-form'));
</script>