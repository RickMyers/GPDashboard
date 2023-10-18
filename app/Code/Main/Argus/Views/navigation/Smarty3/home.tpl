<style type="text/css">
    .navigation-row {
        width: 100%
    }
    .navigation-cell {
        display: inline-block; padding: 5px; background-color: rgba(202,202,202,.35);  overflow: hidden;
    }
    .navigation-cell-header {
        display: inline-block; padding: 5px; background-color: rgba(50,50,50,.75);  overflow: hidden; color: ghostwhite
    }    
</style>
<div class="navigation-row" id="navigation-row-0">
    <div class="navigation-cell-header" style="width: 2%; text-align: center">
        &diam;
    </div>        
    <div class="navigation-cell-header" style="width: 2.5%; text-align: center">
        Image
    </div>
    <div class="navigation-cell-header" style="width: 15%">
        Title
    </div>        
    <div class="navigation-cell-header" style="width: 10%">
        Class
    </div>
    <div class="navigation-cell-header" style="width: 15%">
        JavaScript Method
    </div>
    <div class="navigation-cell-header" style="width: 22%">
        Icon Style
    </div>
    <div class="navigation-cell-header" style="width: 22%">
        Image Style
    </div>
</div>
{foreach from=$options->fetch() item=navigation}
    <div class="navigation-row" id="navigation-row-{$navigation.id}">
        <div class="navigation-cell" style="width: 2%; text-align: center">
            <a href="#" onclick="Argus.configuration.navigation.edit('{$navigation.id}');return false">edit</a>
        </div>        
        <div class="navigation-cell" style="width: 2.5%; text-align: center">
            <img src="{$navigation.image}" style="height: 20px" />
        </div>
        <div class="navigation-cell" style="width: 15%">
            {$navigation.title}
        </div>        
        <div class="navigation-cell" style="width: 10%">
            {$navigation.class}
        </div>
        <div class="navigation-cell" style="width: 15%">
            {$navigation.method}
        </div>
        <div class="navigation-cell" style="width: 22%">
            {$navigation.style}&nbsp;
        </div>
        <div class="navigation-cell" style="width: 22%">
            {$navigation.image_style}&nbsp;
        </div>
        <div id="navigation-edit-row-{$navigation.id}" style="display: none"></div>
    </div>
{/foreach}
<a href="#" onclick="$('#new-navigation-option-layer').slideToggle(); return false">New...</a><br/>
<div id="new-navigation-option-layer" style="display: none">
    <form name="new-navigation-option-form" id="new-navigation-option-form" onsubmit="return false">
        <div class="navigation-row" id="navigation-row-new">
            <div class="navigation-cell" style="width: 15%;">
                <input type="text" name="image" id="new_navigation_option_image" />
            </div>
            <div class="navigation-cell" style="width: 15%">
                <input type="text" name="title" id="new_navigation_option_title" />
            </div>        
            <div class="navigation-cell" style="width: 10%">
                <input type="text" name="class" id="new_navigation_option_class" />
            </div>
            <div class="navigation-cell" style="width: 15%">
                <input type="text" name="method" id="new_navigation_option_method" />
            </div>
            <div class="navigation-cell" style="width: 15%">
                <input type="text" name="style" id="new_navigation_option_style" />
            </div>
            <div class="navigation-cell" style="width: 15%">
                <input type="text" name="image_style" id="new_navigation_option_image_style" />
            </div>
            <div class="navigation-cell" style="width: 15%">
                <input type="button" name="option_submit" id="new_navigation_option_submit" />
            </div>            
        </div> 
        <div class="navigation-row" id="navigation-row-new-desc">
            <div class="navigation-cell" style="width: 15%;">
                Image
            </div>
            <div class="navigation-cell" style="width: 15%">
                Nav Option Title
            </div>        
            <div class="navigation-cell" style="width: 10%">
                Nav Option Class
            </div>
            <div class="navigation-cell" style="width: 15%">
                JavaScript Method
            </div>
            <div class="navigation-cell" style="width: 15%">
                Option Style
            </div>
            <div class="navigation-cell" style="width: 15%">
                Image Style
            </div>
        </div>
    </form>
    <script type="text/javascript">
        new EasyEdits('/edits/argus/navoption','new-nav-option-form');
    </script>
</div>