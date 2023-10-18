Argus.librio = (function ($) {
    return {
        win: false,
        home: function () {
            (new EasyAjax('/librio/documents/home')).then(function (response) {
                $('#sub-container').html(response);
            }).get();
        },
        project: {
            current: false,
            win: false,
            add: function () {
                Argus.librio.project.win = (Argus.librio.project.win)  ? Argus.librio.project.win : Desktop.semaphore.checkout(true);
                Argus.librio.project.win._title('New Document')._static(true)._open();
                (new EasyAjax('/librio/project/new')).add('window_id',Argus.librio.project.win.id).then(function (response) {
                    Argus.librio.project.win.set(response);
                }).get();                    
            },
            contents: function (project_id) {
                Argus.librio.project.current = project_id;
                (new EasyAjax('/librio/project/contents')).add('id',project_id).then(function (response) {
                    $('#librio-content-container').html(response);
                }).post();
            }
        },         
        document: {
            add: function () {
                Argus.librio.win = (Argus.librio.win)  ? Argus.librio.win : Desktop.semaphore.checkout(true);
                Argus.librio.win._title('New Document')._static(true)._open();
                (new EasyAjax('/librio/document/new')).add('window_id',Argus.librio.win.id).then(function (response) {
                    Argus.librio.win.set(response);
                }).get();
            },
            checkout: function () {
                //mark as checked out
            },
            checkin: function () {
                //upload and mark as check in
            },
            signin: function () {
                //just signin, no upload
            }
        },
        category: {
            current: false,
            add: function () {
                //open a window 
            },
            contents: function (project_id,category_id) {
                Argus.librio.document.category.current = category_id;
                (new EasyAjax('/librio/category/contents')).add('id',category_id).then(function (response) {
                    $('#librio-project-'+project_id+'-category-'+category_id+'-management-tab').html(response);
                }).post();
            }
        }
    }
})($);  
        