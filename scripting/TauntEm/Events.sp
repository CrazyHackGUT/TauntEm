static const char g_szCommands[][] = {
    "sm_taunt",
    "sm_taunts"
};

public void OnPluginStart() {
    // TauntEm Startup.
    TauntEm_Init();

    for (int i = 0; i < sizeof(g_szCommands); i++) {
        RegConsoleCmd(g_szCommands[i], Cmd_ShowTauntList);
    }

    // Database reload.
    RegServerCmd("sm_tauntem_reload", Cmd_ReloadDB);

    // VIP Core support.
    VIP_OnStartup();

    // Load translations.
    LoadTranslations("TauntEm_Generic.phrases");
    LoadTranslations("TauntEm_Taunts.phrases");
}

public APLRes AskPluginLoad2(Handle hMyPlugin, bool bLate, char[] szError, int iErrMax) {
    if (GetEngineVersion() != Engine_TF2) {
        strcopy(szError, iErrMax, "This plugin works only on Team Fortress 2!");
        return APLRes_Failure;
    }

    __pl_vip_core_SetNTVOptional();
    return APLRes_Success;
}

public void OnPluginEnd() {
    VIP_OnPluginEnd();
}

public void OnMapStart() {
    UTIL_LoadTaunts();
}

public void OnLibraryAdded(const char[] szLibrary) {
    VIP_OnLibraryAdded(szLibrary);
}

public void OnLibraryRemoved(const char[] szLibrary) {
    VIP_OnLibraryRemoved(szLibrary);
}
