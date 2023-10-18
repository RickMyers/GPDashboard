{assign var=window_id value=''}
<script>
    Argus.vision.current_scans=0;
    </script>
{foreach from=$scans->fetch() item=scan}
    <script>
    Argus.vision.current_scans++;
    </script>
    <div style="float: left; margin-right: 5px; margin-bottom: 5px; padding: 5px; border-radius: 5px; border: 1px solid #333" onclick='Argus.vision.scan.analyze("{$scan.form_id}","{$scan.id}")'>
    <img title='{$scan.file_name}' src='/app/scans.php?method=tn&form_id={$scan.form_id}&scan_id={$scan.id}'
         style='vertical-align: top; width: 250px;  cursor: pointer' /><br />
    {if ($scan.file_name)}
        <div style="background-color: red; color: white; font-size: .7em; font-family: monospace; text-align: center; letter-spacing: 2px; cursor: pointer;
             border: 1px outset #333" onclick="Argus.vision.scan.remove('{$window_id}','{$scan.form_id}','{$scan.id}')">DELETE</div>
             <div style='text-align: center; background-color: silver; font-size: 1.2em'>
                 <b>{$scan.file_name}</b>
             </div>
    {/if}
    </div>
{/foreach}
<div style="clear: both"></div>
