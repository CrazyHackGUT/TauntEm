Handle g_hPlayTaunt;
static const char g_szCallName[] = "CTFPlayer::PlayTauntSceneFromItem";

void TauntEm_Init() {
    Handle hConf = LoadGameConfigFile("tf2.tauntem");
    if (!hConf) {
        SetFailState("[Taunt'Em] Unable to load gamedata/tf2.tauntem.txt.");
        return;
    }

    StartPrepSDKCall(SDKCall_Player);
    PrepSDKCall_SetFromConf(hConf, SDKConf_Signature, g_szCallName);
    PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
    PrepSDKCall_SetReturnInfo(SDKType_Bool, SDKPass_Plain);
    g_hPlayTaunt = EndPrepSDKCall();

    delete hConf;

    if (!g_hPlayTaunt) {
        SetFailState("[Taunt'Em] Unable to initialize call to %s.", g_szCallName);
        return;
    }
}

bool TauntEm_Run(int iClient, int iTauntID, int iParticle = 0) {
    int iEnt = UTIL_MakeCEIVEnt(iClient, iTauntID, iParticle);
    if (!IsValidEntity(iEnt)) {
        LogError("TauntEm_Run(): Couldn't create entity for taunt.");
        return false;
    }

    Address pEconItemView = GetEntityAddress(iEnt) + view_as<Address>(FindSendPropInfo("CTFWearable", "m_Item"));
    if (!UTIL_IsValidAddress(pEconItemView)) {
        LogError("TauntEm_Run(): Couldn't find CEconItemView for taunt.");
        return false;
    }

    bool bResult = SDKCall(g_hPlayTaunt, iClient, pEconItemView);
    AcceptEntityInput(iEnt, "Kill");
    return bResult;
}
