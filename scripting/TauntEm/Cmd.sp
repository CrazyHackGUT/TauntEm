public Action Cmd_ReloadDB(int iArgs) {
    UTIL_LoadTaunts();
    return Plugin_Handled;
}

public Action Cmd_ShowTauntList(int iClient, int iArgs) {
    if (iClient)
        Menu_RenderTaunts(iClient);
    return Plugin_Handled;
}
