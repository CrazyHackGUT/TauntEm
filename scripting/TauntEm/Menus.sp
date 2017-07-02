bool Menu_RenderTaunts(int iClient) {
    if (!UTIL_IsValidClient(iClient))
        return false;

    Menu hMenu = new Menu(MyMenuHandler);
    Menu_FillTaunts(hMenu, iClient);
    if (hMenu.ItemCount > 0) {
        hMenu.SetTitle("%T", "MenuTitle", iClient);
        hMenu.Display(iClient, 0);
        return true;
    } else {
        delete hMenu;
        PrintToChat(iClient, "%s %T", g_szPrefix, "NoTaunts", iClient);
        return false;
    }
}

void Menu_FillTaunts(Menu hMenu, int iClient) {
    if (!UTIL_IsExistsAvailableTaunts(iClient))
        return;

    int iLength = g_hTaunts.Length;

    char szDisplay[128];    // display
    char szData[12];        // data

    TFClassType iNeedClass;
    TFClassType iMyClass = TF2_GetPlayerClass(iClient);

    int iID;

    for (int i = 0; i<iLength; i++) {
        StringMap hTaunt = g_hTaunts.Get(i);
        if (!hTaunt.GetValue("class", iNeedClass)) {
            iNeedClass = TFClass_Unknown;
        }

        if ((iNeedClass != TFClass_Unknown && iNeedClass != iMyClass) || (!hTaunt.GetValue("id", iID) || !IntToString(iID, szData, sizeof(szData)))) {
            continue;
        }

        if (!hTaunt.GetString("Name", szDisplay, sizeof(szDisplay))) {
            strcopy(szDisplay, sizeof(szDisplay), "Unknown");
        }

        if (UTIL_TrieValueIsset(hTaunt, "Translation")) {
            Format(szDisplay, sizeof(szDisplay), "%T", szDisplay, iClient);
        }

        bool bAllow = VIP_ReceiveAccess(iClient, i);
        if (!bAllow) {
            Format(szDisplay, sizeof(szDisplay), "%s [%T]", szDisplay, "Access Denied", iClient);
        }

        hMenu.AddItem(szData, szDisplay, bAllow ? ITEMDRAW_DEFAULT : ITEMDRAW_DISABLED);
    }
}

public int MyMenuHandler(Menu hMenu, MenuAction iAction, int iParam1, int iParam2) {
    switch (iAction) {
        case MenuAction_End:    delete hMenu;
        case MenuAction_Select: {
            if (!UTIL_IsValidClient(iParam1)) {
                return;
            }

            char szID[12];
            hMenu.GetItem(iParam2, szID, sizeof(szID));

            TauntEm_Run(iParam1, StringToInt(szID));
        }
    }
}
