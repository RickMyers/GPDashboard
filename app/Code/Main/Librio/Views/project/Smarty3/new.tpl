<style type="text/css">
    .new-librio-project-fielddesc {
        letter-spacing: 2px; font-family: monospace;
    }
</style>
<table style="width: 100%; height: 100%">
    <tr>
        <td>
            <div style="width: 500px; margin-left: auto; margin-left: auto; padding: 10px">
                To create a new project, please fill out the information below, or close the window to cancel creating a new project.<br /><br />
                <form name="librio-new-project-form" id="librio-new-project-form" onsubmit="return false">
                    <input type="text" name="project" id="new-librio-project" /><br />
                    <div class="new-librio-project-fielddesc">Project Name</div>
                    <br />
                    <input type="text" name="description" id="new-librio-project-description" /><br />
                    <div class="new-librio-project-fielddesc">Description</div>
                    <br />
                    <input type="button" id="new-librio-project-submit" value="Create" class="new-librio-project-submit" />
                </form>
            </div>
        </td>
    </tr>
</table>
<script type="text/javascript">
    new EasyEdits('/edits/librio/project','new-librio-project');
</script>