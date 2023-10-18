    <div id="configuration-top" style="position: relative">
        <hr style='opacity: .4' />
        <div style="float: right; font-size: .9em;"><span style="cursor: pointer" onclick="Argus.dashboard.home()">home</span> | <span onclick="Argus.help.home()" style="cursor: pointer">help</span></div><span style='font-size: 1.2em'><i class="glyphicons glyphicons-cogwheels"></i> PORTAL CONFIGURATION</span> 
        <hr style='opacity: .4' />
        {foreach from=$navigation->optionsByRole() item=option}
            <div class='{$option.class}' onclick='{$option.method}' style='{$option.style}'>
                <img src='{$option.image}' style='{$option.image_style}' />
                <div style='text-align: center;'>
                    {$option.title}
                </div>
            </div>
        {/foreach}
        <div style='clear: both'></div>
        <hr style='opacity: .4' />
    </div>
    <div id="sub-container">
    </div>