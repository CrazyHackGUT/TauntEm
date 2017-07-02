#include <tf2_stocks>
#include <sdktools>
#include <tf2items>
#include <tf2>

#pragma newdecls required

ArrayList   g_hTaunts;
char        g_szDBPath[PLATFORM_MAX_PATH];

#include "TauntEm/Defines.sp"
#include "TauntEm/Config.sp"
#include "TauntEm/Events.sp"
#include "TauntEm/Taunts.sp"
#include "TauntEm/Menus.sp"
#include "TauntEm/UTIL.sp"
#include "TauntEm/Cmd.sp"

// Sync with other plugins.
#include "TauntEm/VIP.sp"

public Plugin myinfo = {
    description = PLUGIN_DESCRIPTION,
    version     = PLUGIN_VERSION,
    author      = PLUGIN_AUTHOR,
    name        = PLUGIN_NAME,
    url         = PLUGIN_URL
};
