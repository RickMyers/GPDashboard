{assign var=current_user value=Environment::whoAmI()}
{foreach from=$comments->fetch() item=comment}
    <div style="background-color: rgba(220,220,220,{cycle values=".2,.4"}); border-bottom: 1px solid #bbb; clear: both"
        ><div style="float: left; border-right: 1px solid #bbb; margin-right: 2px; min-width: 125px">
          {if ($comment.user_id == $current_user)}
              <img src="/images/vision/cancel.png" title="Delete Note" style="display: inline-block; height: 16px; cursor: pointer; vertical-align: middle" onclick="Argus.vision.comment.remove('{$form_id}','{$comment.id}'); return false" />
              <img src="/images/vision/leave_note.png" title="Edit Note" style="display: inline-block; height: 18px; cursor: pointer; vertical-align: middle" onclick="Argus.vision.comment.edit('{$comment.id}'); return false" />
          {/if}  
          {$comment.commenter} <div style="font-family: monospace; font-size: .6em">{$comment.posted|date_format:"m/d/Y H:i:s"}</div>
        </div
        ><div style="padding: 1px 5px 1px 5px; min-height: 28px; vertical-align: top">
            {$comment.comment}
        </div
    ></div>
{/foreach}    