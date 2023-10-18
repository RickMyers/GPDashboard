/**
 * Overrideable elements are set here
 */
var ParadigmConfig = {
    desktop: {
        default: {
            window: {
                icon: "/images/paradigm/icons/humble_icon.png",
                name: "Argus Dental &amp; Vision"
            }
        },
        window: {
            icon: false,
            name: "Argus"
            
        }
    },
    workflow: {
        default: {
            banner: ""
        },
        editor: {
            banner: ""
        }
    }
}
if (!(typeof Branding === 'undefined' || !Branding)) {
    ParadigmConfig.desktop.window.name = (Branding.name) ? Branding.name : ParadigmConfig.desktop.window.name;
    ParadigmConfig.desktop.window.icon = (Branding.icon) ? Branding.icon : ParadigmConfig.desktop.window.icon;
}
