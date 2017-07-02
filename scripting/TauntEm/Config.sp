#define DBPARSER_UNASSIGNED     0
#define DBPARSER_MAINSECTION    1
#define DBPARSER_TAUNTLOADING   2

SMCParser g_hSMC;
int g_iProblemLine;
int g_iState;

StringMap g_hCurrentTaunt;

void Config_InitSMC() {
    if (!g_hSMC) {
        g_hSMC = new SMCParser();
        g_hSMC.OnRawLine        = Config_RawLine;
    }

    g_hSMC.OnEnterSection   = TauntsParser_OnEnterSection;
    g_hSMC.OnLeaveSection   = TauntsParser_OnLeaveSection;
    g_hSMC.OnKeyValue       = TauntsParser_OnKV;
}

void Config_Read(const char[] szPath) {
    Config_InitSMC();

    SMCError iResult;
    if ((iResult = g_hSMC.ParseFile(szPath)) != SMCError_Okay) {
        UTIL_WriteSMCError(g_iProblemLine, iResult);
    }
}

/**
 * Taunts parser.
 */
public SMCResult TauntsParser_OnEnterSection(SMCParser hSMC, const char[] szName, bool bOptQuotes) {
    if (StrEqual(szName, "TauntEm")) {
        g_iState = DBPARSER_MAINSECTION;
    } else if (g_iState == DBPARSER_MAINSECTION) {
        g_iState = DBPARSER_TAUNTLOADING;
        g_hCurrentTaunt = new StringMap();
    }
}

public SMCResult TauntsParser_OnLeaveSection(SMCParser hSMC) {
    if (g_iState == DBPARSER_MAINSECTION) {
        g_iState = DBPARSER_UNASSIGNED;
    } else if (g_iState == DBPARSER_TAUNTLOADING) {
        g_iState = DBPARSER_MAINSECTION;
        g_hTaunts.Push(g_hCurrentTaunt);
    }
}

public SMCResult TauntsParser_OnKV(SMCParser hSMC, const char[] szKey, const char[] szValue, bool bKeyQuotes, bool bValueQuotes) {
    if (g_iState != DBPARSER_TAUNTLOADING) {
        LogError("TauntsParser_OnKV(): Unexpected KeyValue. Stopping...");
        return SMCParse_HaltFail;
    }

    if (StrEqual(szKey, "Index")) {
        g_hCurrentTaunt.SetValue("id", StringToInt(szValue), true);
    } else if (StrEqual(szKey, "Class")) {
        g_hCurrentTaunt.SetValue("class", TF2_GetClass(szValue), true);
    } else if (StrEqual(szKey, "Name") && szValue[0] == '#') {
        g_hCurrentTaunt.SetString("Name", szValue[1], true);
        g_hCurrentTaunt.SetValue("Translation", true);
    } else {
        g_hCurrentTaunt.SetString(szKey, szValue, true);
    }

    return SMCParse_Continue;
}

/**
 * Generic.
 */
public SMCResult Config_RawLine(SMCParser hSMC, const char[] szLine, int iLineNumber) {
    g_iProblemLine = iLineNumber;
}
