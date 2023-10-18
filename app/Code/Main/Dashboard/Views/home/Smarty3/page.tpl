<!DOCTYPE html>
<html>
{assign var=SYSTEM      value=Environment::status(true)}{* True here means don't use the cached copy of the system status *}
{assign var=ts          value=$settings->_getTimeStamp()}
{assign var=admin       value=$role->userHasRole('System Administrator')}
{assign var=editor       value=$role->userHasRole('News Editor')}
{assign var=DDS         value=$role->userHasRole('DDS')}
{assign var=OD          value=$role->userHasRole('O.D.')}
{assign var=appl        value=$appellations->load(true)}
{if ($member->getWhiteLabelId())}
    {assign var=junk value=$whitelabel->setId($member->getWhiteLabelId())}
{else}
    {assign var=junk value=$whitelabel->setId(1)}
{/if}
{if (!$admin)}
    {if ($SYSTEM['status']['quiescing']=='1')}
<script>
    window.location.href = '/index.html?message=Please Try Again Later, the System Is Shutting Down';
</script>        
    {elseif ($SYSTEM['status']['enabled']=='0')}
<script>
    window.location.href = '/index.html?message=Please Try Again Later, the System Is Disabled For Maintenance';
</script>                
    {/if}
{/if}
{assign var=branding value=$whitelabel->load()}
    <head>
        <title> Portal | Argus </title>
        <link rel="shortcut icon" href="/favicon.ico" />
        <link rel='stylesheet' href='/css/bootstrap?cachebust={$ts}'/>
        <link rel='stylesheet' href='/css/theme?cachebust={$ts}'/>
        <link rel="stylesheet" href="/css/widgets?cachebust={$ts}" />
        <link rel='stylesheet' href='/css/activedesktop?cachebust={$ts}'/>
        <link rel='stylesheet' href='/css/dashboard?cachebust={$ts}'/>
        <style type="text/css">
            #argus-landing-logout-countdown {
                position: absolute; top: 10px; left: 10px; padding: 20px; border-radius: 20px;
                border: 1px solid #333; background-color: white; font-family: sans-serif;
                width: 220px; display: none; z-index: 1000
            }
            #landing-logout-countdown {
                font-size: 5em; font-family: monospace; color: #333; text-align: center;
            }
            div > i {
                color: #333; font-size: 22px
            }
            div:hover > i {
                color: #bc2328;
            }
            .dashboard-alert-icon {
                margin-left: 15px; opacity: .4
            }
            .desktop-dock {
                height: 25px; position: absolute; bottom: -35px; background-color: red; z-index: 99; width: 100%
            }
            ::-webkit-scrollbar {
              width: 20px;
            }
            ::-webkit-scrollbar-track {
              background-color: transparent;
            }
            ::-webkit-scrollbar-thumb {
              background-color: #d6dee1;
              border-radius: 20px;
              border: 6px solid transparent;
              background-clip: content-box;
            }    
            ::-webkit-scrollbar-thumb:hover {
              background-color: #a8bbbf;
            }            
        </style>
        <!--script type='text/javascript' src='/js/backbone'></script-->
        <script type="text/javascript">
            var UseTranparentWindows = '{$settings->getTransparentWindows()}';
            var Branding = {
                icon: '{$branding.window_icon}',
                name: '{$branding.short_name}',
                id: '{$user->getUid()}',
                label:  "{$branding.label}",
                socket: '{$manager->getSocketServer()}'
            }
        </script>
        <script type='text/javascript' src='/js/jquery?cachebust={$ts}'></script>
        <script type='text/javascript' src='/js/common?cachebust={$ts}'></script>
        <script type='text/javascript' src='/js/activedesktop?cachebust={$ts}'></script>
        <script type='text/javascript' src='/js/argus?cachebust={$ts}'></script>
        <script type='text/javascript' src='/js/dashboard?cachebust={$ts}'></script>        
        <script type='text/javascript' src='/js/bootstrap?cachebust={$ts}'></script>
        <script type='text/javascript' src='/js/widgets?cachebust={$ts}'></script>
        <script type='text/javascript'>
            {assign var=tab_id value=$manager->browserTabId()}
            EasyAjax.always.add('browser_tab_id','{$tab_id}')
            EasyAjax.always.add('csrf_buster','{$manager->csrfBuster($tab_id)}');
            EasyAjax.always.add('session_user_id','{$user->getUid()}');
      //      EasyAjax.always.show();
            $(document).ready(function () {
                
                $(document.body).css('background-image','url(/images/dashboard/backgrounds/'+(('{$settings->getBackgroundImage()}') ? '{$settings->getBackgroundImage()}' : 'blue_background.jpg')+')');
                $('#hide-apps-column').on('click',function () {
                    $('#apps-column').css('display','none');
                    $('#container-column').width($(window).width() - $('#widgets-column').width());
                });
                Argus.dashboard.lightbox.ref = $E('desktop-lightbox');
                $(window).resize(Argus.dashboard.lightbox.resize);
                var f = function (response) {
                    var system = JSON.parse(response);
                    if (system && system.quiescing) {
                        if (!Argus.logout.inprogress) {
                            $('#argus-landing-logout-countdown').fadeIn();
                            Argus.logout.inprogress = true;
                            Argus.logout.time = Argus.logout.period;
                            Argus.logout.countdown();
                        }
                    } else if (Argus.logout.inprogress) {
                        Argus.logout.inprogress = false;
                        window.clearTimeout(Argus.logout.timer);
                        $('#argus-landing-logout-countdown').fadeOut();
                    }
                    if (system && system.active) {
                        //nop, you are GTG!
                    } else {
                        //window.location.href = '/index.html?m=Argus Is Offline';
                    }
                }
            {if ($SYSTEM['status']['polling'] == '1')}
                Heartbeat.register('argus',true,'isSystemActive',f,2);
                Heartbeat.init('dashboard-heartbeat-indicator');
            {/if}
                window.addEventListener("unload",function (e) {
                    //on unload proccessing... the user is logging out
                    Argus.finish();
                    for (var namespace in Argus) {
                        if (Argus[namespace].finish) {
                            Argus[namespace].finish();
                        }
                    }
                });
            });
        </script>

    </head>
    <body style="overflow: hidden">
        <!-- This hidden sizing layer is used to calculate the width of text... by fetching the "scrollAmount", we can determine the width of any block of text placed in the layer -->
        
        <div style="position: absolute; top: -100px; left: -200px; overflow: auto; width: 1px" id="hiddenSizingLayer"></div>
        <div id="desktop-lightbox" style="position: absolute; z-index: 9999; top: 0px; left: 0px; background-color: rgba(50,50,50,.5); display: none">
        </div>
        <div id="paradigm-virtual-desktop" style="margin: 0px; padding: 0xp; height: 100%; width: 100%; position: absolute; top: 0px; left: 0px;">


            <div id='navigation-bar' style="position: relative;">

                <ul style='position: relative; top: 0px; display: inline-block; z-index: 3;'><!-- argus_logo_white.png -->
                   <li style='padding-top: 8px'><img src='{$branding.banner_light}' style='height: {$branding.banner_height}px;' alt="logo" /></li>
                   <li class='active'><a href='#'>Places</a>
                      <ul>
                         <li><a target="_blank" href='/admin/'>Administration</a></li>
                         <li><a href='#'>Documentation</a>
                            <ul>
                               <li><a target="_blank" href='/internal/docs/'>Developer Documentation</a></li>
                               <li><a target="_blank" href='/docs/'>API Documentation</a></li>
                               <li><a target="_blank" href='#'>Administration Documentation</a></li>
                            </ul>
                         </li>
                         <li><a target="_blank" href='/paradigm/actions/open'>Workflow Editor</a></li>
                         <li style="border-top: 1px solid silver; "><a href='#' onclick="Argus.dashboard.logout(); return false">Logout</a>
                      </ul>
                   </li>
                   {if (($permissions->getAdmin() == 'Y') || ($admin))}
                    <li><a href='#'>Tools</a>
                        <ul>
                         <li><a href='#'>Prestige</a>
                            <ul>
                               <li><a href='#' onclick="Argus.prestige.provider.reconciliation(); return false">Provider Reconciliation</a></li>
                            </ul>
                         </li>
                         <li><a href='#'>WebRTC</a>
                            <ul>
                               <li><a href='#' onclick="Argus.teledentistry.test.page(); return false">Call Test</a></li>
                            </ul>
                         </li>
                         <li><a href='#'>Heartbeat</a>
                            <ul>
                               <li><a href='#' onclick="Heartbeat.stop(); return false">Stop</a></li>
                               <li><a href='#' onclick="Heartbeat.reset(); return false">Start/Reset</a></li>
                            </ul>
                         </li>                         
                        </ul>
                    </li>
                    {/if}
                   {if ($admin)}
                       <li><a href='#'>Admin</a>
                           <ul>
                                <li><a href='#' onclick='Argus.admin.add.user(); return false'>Add User</a></li>
                                <li><a href='#' onclick='Argus.admin.broadcast.message(); return false'>Broadcast A Message</a></li>
                                <li><a href='#' onclick='Argus.admin.add.list(); return false'>Manage User Lists</a></li>
                                <li><a href='#' onclick='Argus.dashboard.desktop.access(); return false'>Grant desktop app access</a></li>
                                <li><a href='#' onclick='Argus.provider.recred.form(); return false'>Recred Request</a></li>
                                <li><a href='#' onclick='Argus.dashboard.app.create(); return false'>Create A New App</a></li>
                                <li><a href='#' onclick='Argus.admin.reset.global(); return false'>Global Password Reset</a></li>
                           </ul>
                       </li>
                   {/if}
                   <li><a href='#'>About</a></li>
                   <li><a href='#'>Contact</a></li>
                </ul>
                   
                <div onclick="Argus.dashboard.im.open()" title="Toggle IM" style="cursor: pointer; position: absolute; top: 35px; right: 65px; color: ghostwhite"><img src="/images/dashboard/sms.png" style="height: 16px; display: inline-block; margin-right: 4px" /><span id="users_online"></span> Users Online</div>
                <div style="float: right; cursor: pointer" title="Logout..." onclick='Argus.dashboard.logout()'><img src='/images/dashboard/logoff_icon.png' style='height: 35px; margin-top: 8px; margin-right: 2px' /></div>
                <div id='dashboard-clock' class='landing-clock'></div>
                <div id='dashboard-alerts' style='position: absolute; top: 7px; width: 400px; padding: 5px; border-radius: 5px; border: 1px solid rgba(202,202,202,.4)'>
                    <div style='float: left; margin-right: 10px; color: ghostwhite; margin-top: 5px'>
                        Alerts:
                    </div>
               
                    <img src="/images/dashboard/ricks_familiar.png" id="ricks_familiar" style=" cursor: pointer; height: 20px; opacity: .3; float: right; margin-right: 4px" class="dashboard-alert-icon" />
                    <img src="/images/dashboard/heartbeat2.png" style="float: right; margin-top: 4px; opacity: 1; height: 12px" id="dashboard-heartbeat-indicator" />
                    <!--img class='dashboard-alert-icon' src='/images/argus/mail-asterisk-icon.png'    style='position: relative;  height: 20px'/-->
                    {*if ($DDS)}
                        <img id='dental-waiting-room-alert' title="Open Tele-Dentistry Waiting Room" class='dashboard-alert-icon' src='/images/dental/dental_waiting_room.png'  style='position: relative; cursor: pointer; height: 20px'/>
                    {else if ($role->userHasRole('Tele Hygienist'))}
                        <img id='dental-waiting-room-alert' title="Enter Tele-Dentistry Waiting Room" onclick="Argus.teledentistry.waitingRoom.queue(this)" class='dashboard-alert-icon' src='/images/dental/dental_waiting_room.png'  style='position: relative; cursor: pointer; height: 20px'/>
                    {/if*}
                    {if ($role->userHasRole('HEDIS Vision Manager'))}
                        <img class='dashboard-alert-icon' src='/images/vision/claim_alert.png' title="Claims Available Indicator" id="vision_claims_indicator"  style='position: relative;  height: 22px; opacity: .3; cursor: pointer' />
                        <img class='dashboard-alert-icon' src='/images/vision/noncontracted2.png' title="Non-Contracted Claims Indicator" id="noncontracted_claims_indicator"  style='position: relative;  height: 24px; opacity: .3; cursor: pointer' />
                    {/if}
                    <img class="dashboard-alert-icon connection-icon" id='connection_on_icon' src='/images/argus/connection_on.png' title='Active Connection To Demographics Server'  style='position: relative; display: none;  height: 20px; opacity: 1.0; cursor: pointer' />
                    <img class="dashboard-alert-icon connection-icon" id='connection_off_icon'src='/images/argus/connection_off.png' title='Demographic Server Unavailable!' style='position: relative; display: none; height: 20px; opacity: 1.0; cursor: pointer'  />
                    <!--img class='dashboard-alert-icon' src='/images/vision/vision_waiting_room.png'  style='position: relative;  height: 20px'/-->
                    
                    <!--img class='dashboard-alert-icon' src='/images/argus/yellow_alert.png'          style='position: relative;  height: 20px'/-->
                </div>
            </div>
            <div id='main-container'>
                <div style='float: left; overflow: hidden' id='widgets-column'>
                    <div class='dashboard-mini-icon' title='Dashboard' onclick='Argus.dashboard.home()'>
                        <i class="glyphicons glyphicons-dashboard glyph-active"></i>
                    </div>
                    <div class='dashboard-mini-icon' title='Toggle Profile' onclick='Argus.profile.toggle()'>
                        <i class="glyphicons glyphicons-vcard glyph-active"></i>
                    </div>
                    <div class='dashboard-mini-icon' title='Toggle Profile' onclick="$('#dashboard-user-graphs').slideToggle()">
                        <i class="glyphicons glyphicons-charts glyph-active"></i>
                    </div>
                    <div class='dashboard-mini-icon' title='Switch to Desktop' onclick="Argus.dashboard.desktop.toggle()">
                        <i class="glyphicons glyphicons-macbook glyph-active"></i>
                    </div>                    
                    <div class='dashboard-mini-icon' title='Profile' onclick='Argus.profile.home()' >
                        <i class="glyphicons glyphicons-cogwheel"></i>
                    </div>
                    <!-- now get the list of available dashboard controls -->
                    {foreach from=$controls->availableByMyRoles() item=control}
                        <div class='dashboard-mini-icon' title='{$control.title}' onclick="{$control.method}" style="{$control.style}">
                            <i class="{$control.icon_class}"></i>
                        </div>
                    {/foreach}
                    <hr style="margin-bottom: 10px; margin-top: 10px"/>
                    <div class='dashboard-mini-icon' title='Calculator' onclick="Argus.dashboard.widgets.calculator()">
                        <i class="glyphicons glyphicons-calculator"></i>
                    </div>
                    <!--div class='dashboard-mini-icon' title='Log Bug or New Feature Request' onclick="Desktop.icon.position(); return false; Argus.dashboard.feature.request()">
                        <a  href="mailto:ITSupport@argusdentalvision.com?subject=HEDIS Feature Request Or Defect Detected">
                            <i class="glyphicons glyphicons-bug" style='font-size: 24px;'></i>
                        </a>                        
                    </div-->                    
                    <div class='dashboard-mini-icon' title='Support Ticket'>
                    <a  href="mailto:support@argusdentalvision.com">
                        <i class="glyphicons glyphicons-message-plus" style='font-size: 24px; color: #CC0000'></i>
                    </a>
                    </div>
                    <hr style="margin-bottom: 10px; margin-top: 10px"/>
                    <div id="landing-minimized-windows" style=" width: 100%; height: 400px; padding-top: 5px; padding-bottom: 5px; border: 1px solid transparent; border-radius: 5px;">

                    </div>
                </div>
                <div style='float: left; overflow: hidden;' id='apps-column'>
                    <div id='user-roles'>
                        {if ($admin)}Administrator{else}&nbsp;{/if}{if ($permissions->getSuperUser() == "Y")}, Super User{/if}
                        {if ($role->userHasRole('Primary Care Physician'))}Primary Care Physician{/if}
                        {if ($role->userHasRole('IPA'))}IPA{/if}
                    </div>
                    <div style='position: relative;'>
                    <div class='user-portrait' id='user-portrait'>
                        <img onload="Argus.tools.image.align(this)" src='/images/argus/avatars/{$user->getUid()}.jpg?cachebust={$ts}' onerror='this.src="/images/argus/placeholder-{$member->getGender()}.png"' style='margin-right: auto; margin-left: auto; height: 150px' />
                    </div>
                    <div id='user-identification'>
                        <div id='user-name'>
                            {assign var=data value=$info->userData()}
                              {if ($appl && isset($appl.appellation_id))}
                                {assign var=appl value=$appellation->setId($appl.appellation_id)->load()}
                            {/if}
                            {if (isset($data.entity_name) && $data.entity_name )}{$data.entity_name}{else}
                                {if (($appl) && (isset($appl.appellation)))}{$appl.appellation}{/if}
                                {if ($member->getUsePreferredName() == 'Y')}
                                    {$member->getPreferredName()}
                                {else}
                                    {$member->getFirstName()}
                                {/if}
                             {$member->getLastName()}
                             {/if}
                        </div>
                        <div id='user-email'>{$user->getEmail()}</div>
                    </div>
                    <div id="argus-landing-logout-countdown" style='position: absolute; top: 0px; left: 0px; width: 100%; height: 100%; z-index: 999'>
                        The system is going down, please save your work.  The system will log you out in
                        <div id="landing-logout-countdown">
                            01
                        </div>
                        <div style="text-align: center; padding: 4px">
                            SECONDS
                        </div>
                    </div>
                    </div>
                    <div id='user-calendar'></div>
                    <!--div id='office-news-header' class='app-header'>
                        HEDIS News {if ($editor)}<a class="add-article" href="#" style="float: right;" onclick="Argus.hedis.article.form(); return false">Add Article</a>{/if}
                    </div>
                    <div id='office-news-data' style='overflow:auto; height:140px;' class='app-data'>
                        {* where news will go dynamically *}
                    </div-->
                    <div id='office-alerts'>
                        <div id='office-alerts-header' class='app-header'>
                            Office Information
                        </div>
                        <div id='office-alerts-data' class='app-data'>
                        </div>
                    </div>
                </div>
                <div style='float: left' id='container-column' style="position: relative">
                    <div id='container' style='padding: 0px 5px; position: relative; display: block'></div>
                    <div id="container-desktop" style="padding: 5px; position: relative; display: none"></div>
                </div>
                <div style='clear: both;'></div>
            </div>
            <div id='status-bar'>
                <div id='activity-bar'></div>
                
                <div style="float: right;">&copy; 2016-Present {$branding.label}, all rights reserved</div>
                <div style="display: inline-block; overflow: visible; " id="minimized_windows_tray">

                </div>
            </div>
        </div>

    </body>
</html>
