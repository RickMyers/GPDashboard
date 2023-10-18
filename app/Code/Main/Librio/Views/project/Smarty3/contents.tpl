<style type="text/css">
</style>


{foreach from=$categories item=category}
    <div id="librio-project-category-{$category.id}-head" class="librio-project-category-head">
        <img src="/images/librio/expand.png" onclick="Argus.librio.category.toggle(this)" style="vertical-align: middle"/> {$category.category}
    </div>
    <div id="librio-project-category-{$category.id}-content" class="librio-project-category-content">
        Stuff goes here
    </div>
{/foreach}
