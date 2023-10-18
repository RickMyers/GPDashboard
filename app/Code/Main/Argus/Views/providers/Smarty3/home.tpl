<style type='text/css'>
    #providers-list-container {
        border: 1px solid rgba(202,202,202,.1); height: 550px; overflow: auto; position: relative
    }
    .providers-list-pagination-control {
        width: 45px; font-family: sans-serif; font-size: 1.3em; font-weight:bold; color: rgba(100,100,100,.8); border: 1px solid #aaf; padding: 2px; border-radius: 2px; height: 30px
    }
    .providers-list-page {
        width: 50px; text-align: center; height: 30px; font-family: sans-serif; font-size: 1.3em; font-weight:bold; color: rgba(100,100,100,.8); border: 1px solid #aaf; padding: 2px; border-radius: 2px;
    }
    .providers-search-field {
        padding: 10px 5px; float: left; background-color: rgba(202,202,202,.1); font-family: sans-serif; margin-top: 5px; border: 1px solid transparent; font-size: 1.8em; width: 80%; box-sizing: border-box
    }
    .providers-search-field:focus {
        background-color: rgba(202,202,202,.2)
    }
    .member-search-criteria {
        width: 170px; padding: 2px; border: 1px solid #aaf; border-radius: 2px; color: #333; margin-right: 10px; background-color: #FFEBC9;
    }
    .member-search-criteria-desc {
        font-family: monospace; font-size: .8em; letter-spacing: 1px; vertical-align: top
    }
    .argus-member-search-float {
        display: inline-block;  margin-right: 2px; margin-bottom: 2px
    }
    .argus-member-search-avatar {
        height: 70px; overflow: hidden; cursor: pointer; position: relative;
    }
    .argus-member-search-field {
        width: 15%; min-width: 175px; height: 33px; border-right: 1px solid rgba(202,202,202,.4); padding-right: 4px; vertical-align: top
    }
    .argus-member-search-address {
        height: 33px; margin-bottom: 2px; display: inline-block
    }
    .argus-member-search-cell-title {
        vertical-align: top; font-family: sans-serif; font-size: .7em; letter-spacing: 2px; text-align: left
    }
    .argus-member-search-cell-value {
        text-align: right; padding-right: 2px; font-family: monospace; font-size: .9em
    }
</style>
<div id="providers-top" style="position: relative">
    <hr style='opacity: .4' />
    <div style="float: right; font-size: .9em;"><span style="cursor: pointer" onclick="Landing.dashboard.home()">home</span> | <span onclick="Landing.help.home()" style="cursor: pointer">help</span></div><span style='font-size: 1.2em'>MEMBERS</span>
    <hr style='opacity: .4' />
    <div class='dashboard-icon' onclick='Landing.providers.home()'>
        <img src='/images/argus/providers.png' style='' />
        <div style='text-align: center;'>
            Members
        </div>
    </div>
    <div>
        <form name="argus-member-search-form" id="argus-member-search-form" onkeydown="Landing.providers.searchForm(event)">
        <input type='text' class='providers-search-field' name='providers-search-field' id='providers-search-field' placeholder='Member Name' />
        <div style='background-color: rgba(55,55,55,.3); padding: 13px; margin-top: 5px;  display: inline-block; cursor: pointer' title="Search for matching members" onclick="Landing.providers.search()">
           <img src='/images/argus/search.png' style='height: 32px' />
        </div><br />
        <div id="argus-criteria-layer" style="margin-top: 2px; display: block">
            <table cellspacing="0" cellpadding="0">
                <tr>
                    <td>
                        <select name="program" id="argus-program" class="member-search-criteria">
                        <option value=""></option>
                                                    <option value="1">Prestige</option>
                                                    <option value="2">WelMed</option>
                                                </select>
                    </td>
                    <td>
                        <select name="status" id="argus-status" class="member-search-criteria">
                        <option value="">Any</option>
                        <option value="A">Active</option>
                        <option value="I">Inactive</option>
                        </select>
                    </td>
                    <td>
                        <input type="text" name="ssn" id="argus-ssn" class="member-search-criteria" />
                    </td>
                    <td>
                        <input type="text" name="medicaid_id" id="argus-medicaid_id" class="member-search-criteria" />
                    </td>
                    <td>
                        <input type="text" name="phone" id="argus-phone" class="member-search-criteria" />
                    </td>
                </tr>
                <tr>
                    <td class="member-search-criteria-desc">
                        Program
                    </td>
                    <td class="member-search-criteria-desc">
                        Role
                    </td>
                    <td class="member-search-criteria-desc">
                        Status
                    </td>
                    <td class="member-search-criteria-desc">
                        Social Security Number
                    </td>
                    <td class="member-search-criteria-desc">
                        Medicaid ID
                    </td>
                    <td class="member-search-criteria-desc">
                        Phone Number
                    </td>
                </tr>
            </table>
        </div>
        </form>
    </div>
    <div style='clear: both'></div>
    <hr style='opacity: .4' />
</div>
<div id='providers-list-container'>
    <div id="argus-member-display" style="position: absolute; top: 0px; left: 0px; width: 100%; height: 100%; z-index: 99;"></div>
</div>
<hr style='opacity: .4' />
<div id='providers-list-pages' style="float: right"></div>
<div id='providers-list-rows' style="float: left"></div>
<div style='width: 300px; margin-right: auto; margin-left: auto; text-align: center; position: relative' id="providers-pagination-controls">
    <input type='button' class='providers-list-pagination-control' id="providers-list-previous" value='<' />
    <input type='button' class='providers-list-pagination-control' id="providers-list-first" value='<<' />
    &nbsp;&nbsp;
    <input type='button' class='providers-list-pagination-control' id="providers-list-last" value='>>' />
    <input type='button' class='providers-list-pagination-control' id="providers-list-next" value='>' />
</div>
<script>
    $('#providers-search-field').on('keypress',function (evt) {
        if (evt.keyCode && (evt.keyCode == 13)) {
            Landing.providers.search();
        }
    });
    Landing.providers.page = 0;
    Landing.providers.pages = 0;
    if (!Landing.providers.loaded) {
        Landing.providers.loaded = true;  //this prevents multiple loadings of the resizer to the resize event
        var tt = function () {
            if ($E('providers-list-container')) {
                var h = $('#main-container').height() - $('#providers-top').height() - $('#providers-pagination-controls').height() - 100;
                h = (h<200) ? 200 : h;
                $('#providers-list-container').height(h);
            }
        }
        $(window).resize(tt);
    }
    $(window).resize();
    $('#providers-list-previous').on("click",function () {
        Landing.providers.page = Landing.providers.page - 1;
        if (Landing.providers.page < 1) {
            Landing.providers.page = Landing.providers.pages;
        }
        Landing.providers.search(Landing.providers.page);
    });
    $('#providers-list-first').on("click",function () {
        Landing.providers.search(1);
    });
    $('#providers-list-last').on("click",function () {
        Landing.providers.search(Landing.providers.pages);
    });
    $('#providers-list-next').on("click",function () {
        Landing.providers.page = Landing.providers.page + 1;
        if (Landing.providers.page > Landing.providers.pages) {
            Landing.providers.page = 1;
        }
        Landing.providers.search(Landing.providers.page);
    });
    (new EasyAjax('/argus/providers/favorites')).then(function (response) {
        $('#providers-list-container').html(response);
    }).get(); //let's do get, its a bit faster
</script>