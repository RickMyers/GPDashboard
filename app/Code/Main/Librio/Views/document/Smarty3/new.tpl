<style type="text/css">
    #librio-document-upload-header {
        background-color: #333; color: ghostwhite;
    }
    #librio-document-upload-body {
        
    }
    #librio-document-upload-footer {
        background-color: #333; color: ghostwhite; font-size: .85em
    }    
</style>
<div id="librio-new-document-navigation">
    
</div>
<div id="librio-new-document-selection" style="overflow: auto;">
    <div id="librio-new-document-upload">
        New Document Upload
    </div>
    <div id="librio-new-document-create">
        <textarea name="librio_new_document" id="librio_new_document">
            
        </textarea>
    </div>
</div>
<div id="librio-document-upload-footer">
    &copy; 2017, Aflac Benefits Solutions
</div>
<script type="text/javascript">
    (function () {
        var id = '{$window_id}';
        var tabs = new EasyTab('librio-new-document-navigation',150);
        var f = (function (win) {
            win._resize();
        })(Desktop.window.list[id]);
        tabs.add('Upload Document',null,'librio-new-document-upload');
        tabs.add('Create Document',f,'librio-new-document-create');
        tabs.tabClick(0);
        
        CKEDITOR.replace('librio_new_document');
        Desktop.window.list[id].resize = function () {
            var h = this.content.offsetHeight - $E('librio-document-upload-footer').offsetHeight - $E('librio-new-document-navigation').offsetHeight;
            var h1 = h - $('.cke_top').height() - $('.cke_bottom').height();
            $('#cke_librio_new_document').height(h);
            $('.cke_contents').height(h1);
            $('#librio-new-document-selection').height(h);
            
            //Going to resize the ckeditor now...
        };
    })();
    Desktop.window.list['{$window_id}']._resize();
</script>
