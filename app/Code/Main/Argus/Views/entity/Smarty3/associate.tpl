{foreach from=$associations->fetch() item=association}
    <li>
        <a href="">X</a>
        {$association.entity} - {$association.effective_start_date|date_format:"m/d/Y"} - {$association.effective_end_date|date_format:"m/d/Y"}
    </li>    
{/foreach}