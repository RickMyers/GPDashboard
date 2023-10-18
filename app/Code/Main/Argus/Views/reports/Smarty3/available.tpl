<br />
The Following Reports Are Available:
<ul>
{foreach from=$reports->available() item=report}
    <li> <a href="#" style="color: blue" onclick="Argus.reports.setup('{$report.name}')" >{$report.name}</a> -{$report.description}</li>
{foreachelse}
<li> No reports available
{/foreach}
</ul>
