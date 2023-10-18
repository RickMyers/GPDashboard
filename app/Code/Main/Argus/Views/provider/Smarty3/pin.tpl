{assign var=data value=$form->load(true)}
{
    "valid": {if ($data)}true{else}false{/if}
}