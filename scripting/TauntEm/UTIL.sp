static const char g_szErrorSMC[] = "An error occured on line %d. Error code: %d, reason: %s";

bool UTIL_IsValidAddress(Address pAddr) {
    if (pAddr == Address_Null)
        return false;

    return ((pAddr & view_as<Address>(0x7FFFFFFF)) >= view_as<Address>(0x10000));
}

bool UTIL_IsValidClient(int iClient) {
    if (iClient > 0 && iClient <= MaxClients && IsClientInGame(iClient)) {
        bool bAlive = IsPlayerAlive(iClient);
        if (!bAlive) {
            PrintToChat(iClient, "%s %T", g_szPrefix, "BeAlive", iClient);
        }

        return bAlive;
    }

    return false;
}

int UTIL_MakeCEIVEnt(int iClient, int iItemDef, int iParticle = 0) {
    static Handle hItem;
    if (!hItem) {
        hItem = TF2Items_CreateItem(OVERRIDE_ALL|PRESERVE_ATTRIBUTES|FORCE_GENERATION);
        TF2Items_SetClassname(hItem, "tf_wearable_vm");
        TF2Items_SetQuality(hItem, 6);
        TF2Items_SetLevel(hItem, 1);
    }

    TF2Items_SetItemIndex(hItem, iItemDef);
    TF2Items_SetNumAttributes(hItem, iParticle ? 1 : 0);
    if (iParticle) {
        TF2Items_SetAttribute(hItem, 0, 2041, float(iParticle));
    }

    return TF2Items_GiveNamedItem(iClient, hItem);
}

/**
 * Errors.
 */
void UTIL_WriteSMCError(int iLine, SMCError iError) {
    switch (iError) {
        case SMCError_StreamOpen:       LogError(g_szErrorSMC, iLine, iError, "Stream failed to open.");
        case SMCError_StreamError:      LogError(g_szErrorSMC, iLine, iError, "The stream died... somehow.");
        case SMCError_InvalidSection1:  LogError(g_szErrorSMC, iLine, iError, "A section was declared without quotes, and had extra tokens.");
        case SMCError_InvalidSection2:  LogError(g_szErrorSMC, iLine, iError, "A section was declared without any header.");
        case SMCError_InvalidSection3:  LogError(g_szErrorSMC, iLine, iError, "A section ending was declared with too many unknown tokens.");
        case SMCError_InvalidSection4:  LogError(g_szErrorSMC, iLine, iError, "A section ending has no matching beginning.");
        case SMCError_InvalidSection5:  LogError(g_szErrorSMC, iLine, iError, "A section beginning has no matching ending.");
        case SMCError_InvalidTokens:    LogError(g_szErrorSMC, iLine, iError, "There were too many unidentifiable strings on one line.");
        case SMCError_TokenOverflow:    LogError(g_szErrorSMC, iLine, iError, "The token buffer overflowed.");
        case SMCError_InvalidProperty1: LogError(g_szErrorSMC, iLine, iError, "A property was declared outside of any section.");
    }
}

/**
 * Taunts loader.
 */
void UTIL_LoadTaunts() {
    if (!g_szDBPath[0])
        BuildPath(Path_SM, g_szDBPath, sizeof(g_szDBPath), "data/TauntEm.cfg");

    UTIL_CleanMemory();
    Config_Read(g_szDBPath);

    // VIP sync.
    VIP_RegisterTauntsFeatures();
}

void UTIL_CleanMemory() {
    if (!g_hTaunts) {
        g_hTaunts = new ArrayList(ByteCountToCells(4));
        return;
    }

    // VIP sync.
    VIP_UnregisterTauntsFeatures();

    int iLength = g_hTaunts.Length;
    for (int i = iLength-1; i >= 0; i--) {
        StringMap hMap = g_hTaunts.Get(i);

        delete hMap;
        g_hTaunts.Erase(i);
    }
}

void UTIL_GetTauntEID(int iID, char[] szBuffer, int iMaxLength) {
    StringMap hMap = g_hTaunts.Get(iID);
    if (!hMap.GetString("EID", szBuffer, iMaxLength))
        strcopy(szBuffer, iMaxLength, "Generic");
}

bool UTIL_IsExistsAvailableTaunts(int iClient) {
    TFClassType eMyClass    = TF2_GetPlayerClass(iClient);
    TFClassType eNeedClass  = TFClass_Unknown;

    int iLength = g_hTaunts.Length;

    for (int i = 0; i<iLength; i++) {
        if (!VIP_ReceiveAccess(iClient, i))
            continue;

        StringMap hTaunt = g_hTaunts.Get(i);
        if (!hTaunt.GetValue("class", eNeedClass)) {
            eNeedClass = TFClass_Unknown;
        }

        if (eNeedClass == TFClass_Unknown || eNeedClass == eMyClass) {
            return true;
        }
    }

    return false;
}

bool UTIL_TrieValueIsset(StringMap hTrie, const char[] szVar) {
    int iTemp;
    return hTrie.GetValue(szVar, iTemp);
}
