#undef REQUIRE_PLUGIN
#pragma newdecls optional
#include <vip_core>

bool g_bVIPLoaded;

void VIP_OnStartup() {
    g_bVIPLoaded = LibraryExists("vip_core");

    if (g_bVIPLoaded && VIP_IsVIPLoaded()) {
        VIP_OnVIPLoaded();
    }
}

/** 
 * Scratches with default SourceMod events.
 */
void VIP_OnLibraryAdded(const char[] szLibrary) {
    if (!strcmp(szLibrary, "vip_core")) {
        g_bVIPLoaded = true;
    }
}

void VIP_OnLibraryRemoved(const char[] szLibrary) {
    if (!strcmp(szLibrary, "vip_core")) {
        g_bVIPLoaded = false;
    }
}

void VIP_OnPluginEnd() {
    if (!g_bVIPLoaded)
        return;

    // Unregister menu.
    VIP_UnregisterFeature("TauntEm_Menu");

    // Unregister "root" feature.
    VIP_UnregisterFeature("TauntEm_AllTaunts");

    // Unregister taunts features.
    VIP_UnregisterTauntsFeatures();
}

/**
 * Taunt Features.
 */
bool VIP_ReceiveAccess(int iClient, int iTaunt) {
    if (!g_bVIPLoaded || VIP_IsClientFeatureUse(iClient, "TauntEm_AllTaunts"))
        return true;

    char szID[48];
    UTIL_GetTauntEID(iTaunt, szID, sizeof(szID));
    Format(szID, sizeof(szID), "TauntEm_%s", szID);

    return VIP_IsClientFeatureUse(iClient, szID);
}

void VIP_RegisterTauntsFeatures() {
    if (!g_bVIPLoaded)
        return;

    char szID[48];

    int iLength = g_hTaunts.Length;
    for (int i = 0; i < iLength; i++) {
        UTIL_GetTauntEID(i, szID, sizeof(szID));
        Format(szID, sizeof(szID), "TauntEm_%s", szID);
        if (!VIP_IsValidFeature(szID))
            VIP_RegisterFeature(szID, BOOL, HIDE);
    }
}

void VIP_UnregisterTauntsFeatures() {
    if (!g_bVIPLoaded)
        return;

    char szID[48];

    int iLength = g_hTaunts.Length;
    for (int i = 0; i < iLength; i++) {
        UTIL_GetTauntEID(i, szID, sizeof(szID));
        Format(szID, sizeof(szID), "TauntEm_%s", szID);
        if (VIP_IsValidFeature(szID))
            VIP_UnregisterFeature(szID);
    }
}

int VIP_GetAvailableTaunts(int iClient) {
    int iLength = g_hTaunts.Length;

    // Check all taunts permissions.
    if (VIP_IsClientFeatureUse(iClient, "TauntEm_AllTaunts"))
        return iLength;

    char szID[48];
    int iAvailableTaunts = 0;

    for (int i = 0; i < iLength; i++) {
        UTIL_GetTauntEID(i, szID, sizeof(szID));
        Format(szID, sizeof(szID), "TauntEm_%s", szID);
        if (VIP_IsClientFeatureUse(iClient, szID))
            iAvailableTaunts++;
    }

    return iAvailableTaunts;
}

/**
 * VIP Core events.
 */
public void VIP_OnVIPLoaded() {
    VIP_RegisterFeature("TauntEm_Menu",         VIP_NULL,   SELECTABLE, VIP_OnNeedMenuOpen, VIP_OnNeedRenderItem, VIP_OnNeedDrawItem);
    VIP_RegisterFeature("TauntEm_AllTaunts",    BOOL,       HIDE);

    if (g_hTaunts && g_hTaunts.Length > 0) {
        VIP_RegisterTauntsFeatures();
    }
}

public bool VIP_OnNeedMenuOpen(int iClient, const char[] szFeature) {
    return !Menu_RenderTaunts(iClient);
}

public bool VIP_OnNeedRenderItem(int iClient, const char[] szFeature, char[] szDisplay, int iMaxLength) {
    // FormatEx(szDisplay, iMaxLength, "Насмешки: Доступно %d из %d", VIP_GetAvailableTaunts(iClient), g_hTaunts.Length);
    FormatEx(szDisplay, iMaxLength, "%T", "VIPItem", iClient, VIP_GetAvailableTaunts(iClient), g_hTaunts.Length);
    return true;
}

public int VIP_OnNeedDrawItem(int iClient, const char[] szFeature, int iStyle) {
    int iTaunts     = VIP_GetAvailableTaunts(iClient);
    bool bThisClass = UTIL_IsExistsAvailableTaunts(iClient);
    return (iTaunts > 0 && bThisClass) ? ITEMDRAW_DEFAULT : ITEMDRAW_DISABLED;
}

#pragma newdecls required