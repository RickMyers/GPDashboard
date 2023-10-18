<div style="font-family: monospace; color: #333; font-size: 1.3em; letter-spacing: 3px">
    Current Queries
</div>
<ul>
{foreach from=$queries->fetch() item=query}
    <li class="quick-query-{$window_id}" query_id="{$query.id}">{$query.description}</li>
{/foreach}
</ul>
<div style="float: right">
    Page {$queries->_page()} of {$queries->_pages()}
</div>
<div>
Row {$queries->_fromRow()} to {$queries->_toRow()} of {$queries->_rowCount()}
</div>