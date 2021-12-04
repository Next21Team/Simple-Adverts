#include <amxmodx>
#include <amxmisc>

#define PREFIX_MAXLEN 	32
#define MESSAGE_MAXLEN	128
#define TASK_ADVERTS 	999

enum _:CvarList
{
	CVAR_PRINTMODE,
	CVAR_PREFIX[PREFIX_MAXLEN],
	Float: CVAR_INTERVAL,
	CVAR_ORDER,
	CVAR_EFFECT,
	Float: CVAR_FXTIME,
	Float: CVAR_HOLDTIME,
	Float: CVAR_FADETIME,
	Float: CVAR_FADEOUTTIME,
	CVAR_CHANNEL,
	CVAR_ALIVE,
	CVAR_TEAM,
	CVAR_COLOR,
	CVAR_RED,
	CVAR_GREEN,
	CVAR_BLUE,
	Float: CVAR_POS_X,
	Float: CVAR_POS_Y,
	CVAR_CONSOLE
}

new Array: g_apMessages, g_cvar_[CvarList], g_iArraySize, g_msgSayText

public plugin_init()
{
	register_plugin("Simple HUD Adverts", "1.1", "Oli Desu")
	
	register_srvcmd("n21_ads_reset", "plugin_cfg", .info = "Reset adverts settings")
	
	bind_pcvar_num(register_cvar("n21_ads_printmode", "0"), g_cvar_[CVAR_PRINTMODE])
	bind_pcvar_string(register_cvar("n21_ads_prefix", "!g[Adverts]!y "),
		g_cvar_[CVAR_PREFIX], charsmax(g_cvar_[CVAR_PREFIX]))
	bind_pcvar_num(register_cvar("n21_ads_order", "1"), g_cvar_[CVAR_ORDER])
	bind_pcvar_num(register_cvar("n21_ads_effect", "1"), g_cvar_[CVAR_EFFECT])
	bind_pcvar_float(register_cvar("n21_ads_fxtime", "1.0"), g_cvar_[CVAR_FXTIME])
	bind_pcvar_float(register_cvar("n21_ads_holdtime", "10.0"), g_cvar_[CVAR_HOLDTIME])
	bind_pcvar_float(register_cvar("n21_ads_fadetime", "0.1"), g_cvar_[CVAR_FADETIME])
	bind_pcvar_float(register_cvar("n21_ads_fadeouttime", "0.2"), g_cvar_[CVAR_FADEOUTTIME])
	bind_pcvar_num(register_cvar("n21_ads_channel", "-1"), g_cvar_[CVAR_CHANNEL])
	bind_pcvar_num(register_cvar("n21_ads_alive", "0"), g_cvar_[CVAR_ALIVE])
	bind_pcvar_num(register_cvar("n21_ads_team", "0"), g_cvar_[CVAR_TEAM])
	bind_pcvar_num(register_cvar("n21_ads_color", "0"), g_cvar_[CVAR_COLOR])
	bind_pcvar_num(register_cvar("n21_ads_red", "255"), g_cvar_[CVAR_RED])
	bind_pcvar_num(register_cvar("n21_ads_green", "255"), g_cvar_[CVAR_GREEN])
	bind_pcvar_num(register_cvar("n21_ads_blue", "255"), g_cvar_[CVAR_BLUE])
	bind_pcvar_float(register_cvar("n21_ads_pos_x", "-1.0"), g_cvar_[CVAR_POS_X])
	bind_pcvar_float(register_cvar("n21_ads_pos_y", "0.25"), g_cvar_[CVAR_POS_Y])
	bind_pcvar_num(register_cvar("n21_ads_console", "0"), g_cvar_[CVAR_CONSOLE])
	
	new pCvarInterval = register_cvar("n21_ads_interval", "60.0")
	bind_pcvar_float(pCvarInterval, g_cvar_[CVAR_INTERVAL])
	hook_cvar_change(pCvarInterval, "cvar_interval_changed")

	g_apMessages = ArrayCreate(MESSAGE_MAXLEN)
	g_msgSayText = get_user_msgid("SayText")
}

public plugin_cfg()
{
	new szCfgDir[64], szFilePath[128]
	get_configsdir(szCfgDir, charsmax(szCfgDir))
	add(szCfgDir, charsmax(szCfgDir), "/next21_ads")
	
	if (!dir_exists(szCfgDir))
		if (mkdir(szCfgDir))
			set_fail_state("Enable to create adverts directory")
			
	ArrayClear(g_apMessages)

	formatex(szFilePath, charsmax(szFilePath), "%s/ads.ini", szCfgDir)
	if (!load_adverts(szFilePath))
		write_file(szFilePath, ";Adverts", -1)
		
	new szMapname[32]
	get_mapname(szMapname, charsmax(szMapname))
	formatex(szFilePath, charsmax(szFilePath), "%s/%s-ads.ini", szCfgDir, szMapname)
	load_adverts(szFilePath)
	
	g_iArraySize = ArraySize(g_apMessages)
	remove_task(TASK_ADVERTS)
	if (g_iArraySize)
		set_task(g_cvar_[CVAR_INTERVAL], "show_advert", .id = TASK_ADVERTS, .flags = "b")
}

public cvar_interval_changed(pCvar, const szOldValue[], const szNewValue[])
{
	if (task_exists(TASK_ADVERTS))
		change_task(TASK_ADVERTS, str_to_float(szNewValue))
}

public show_advert()
{	
	new szMessage[MESSAGE_MAXLEN], szPlayerName[32]
	
	static iCounter = -1
	
	if (g_cvar_[CVAR_ORDER])
	{
		iCounter = (iCounter + 1) % g_iArraySize
	}
	else
	{
		new iRandomNum = random(g_iArraySize)
		if (g_iArraySize > 1)
			while (iCounter == iRandomNum)
				iRandomNum = random(g_iArraySize)
		iCounter = iRandomNum
	}
	
	ArrayGetString(g_apMessages, iCounter, szMessage, charsmax(szMessage))
	format(szMessage, charsmax(szMessage), "%s%s", g_cvar_[CVAR_PREFIX], szMessage) 
	
	switch (g_cvar_[CVAR_PRINTMODE])
	{
		case 1: set_hudmessage(
			g_cvar_[CVAR_COLOR] ? random(256) : g_cvar_[CVAR_RED],
			g_cvar_[CVAR_COLOR] ? random(256) : g_cvar_[CVAR_GREEN],
			g_cvar_[CVAR_COLOR] ? random(256) : g_cvar_[CVAR_BLUE],
			g_cvar_[CVAR_POS_X],
			g_cvar_[CVAR_POS_Y],
			g_cvar_[CVAR_EFFECT],
			g_cvar_[CVAR_FXTIME],
			g_cvar_[CVAR_HOLDTIME],
			g_cvar_[CVAR_FADETIME],
			g_cvar_[CVAR_FADEOUTTIME],
			g_cvar_[CVAR_CHANNEL])
		case 2: set_dhudmessage(
			g_cvar_[CVAR_COLOR] ? random(256) : g_cvar_[CVAR_RED],
			g_cvar_[CVAR_COLOR] ? random(256) : g_cvar_[CVAR_GREEN],
			g_cvar_[CVAR_COLOR] ? random(256) : g_cvar_[CVAR_BLUE],
			g_cvar_[CVAR_POS_X],
			g_cvar_[CVAR_POS_Y],
			g_cvar_[CVAR_EFFECT],
			g_cvar_[CVAR_FXTIME],
			g_cvar_[CVAR_HOLDTIME],
			g_cvar_[CVAR_FADETIME],
			g_cvar_[CVAR_FADEOUTTIME])		
	}
	
	new iTeamState = g_cvar_[CVAR_TEAM],
		iPrintState = g_cvar_[CVAR_PRINTMODE],
		iConsoleState = g_cvar_[CVAR_CONSOLE]
	
	new aPlayers[MAX_PLAYERS], iPlayersNum, szTeam[10]
	new GetPlayersFlags: iPlayersFlags = GetPlayers_ExcludeBots
	switch (g_cvar_[CVAR_ALIVE])
	{
		case 1: iPlayersFlags |= GetPlayers_ExcludeDead
		case 2: iPlayersFlags |= GetPlayers_ExcludeAlive
	}
	if (iTeamState > 0 && iTeamState < 4)
	{
		iPlayersFlags |= GetPlayers_MatchTeam
		switch (iTeamState)
		{
			case 1: szTeam = "TERRORIST"
			case 2: szTeam = "CT"
			case 3: szTeam = "SPECTATOR"
		}
	}

	get_players_ex(aPlayers, iPlayersNum, iPlayersFlags, szTeam)
	for (new i, iPlayer; i < iPlayersNum; i++)
	{
		iPlayer = aPlayers[i]		
		get_user_name(iPlayer, szPlayerName, charsmax(szPlayerName))
		replace_all(szMessage, charsmax(szMessage), "%name%", szPlayerName)
		
		switch (iPrintState)
		{
			case 1:
			{
				remove_specific_symbols(szMessage, charsmax(szMessage))
				show_hudmessage(iPlayer, szMessage)
				if (iConsoleState)
					client_print(iPlayer, print_console, "%s", szMessage)
			}
			case 2:
			{
				remove_specific_symbols(szMessage, charsmax(szMessage))
				show_dhudmessage(iPlayer, szMessage)
				if (iConsoleState)
					client_print(iPlayer, print_console, "%s", szMessage)
			}
			default:
			{
				replace_all(szMessage, charsmax(szMessage), "!g", "^4")
				replace_all(szMessage, charsmax(szMessage), "!y", "^1")
				replace_all(szMessage, charsmax(szMessage), "!t", "^3")
	
				message_begin(MSG_ONE_UNRELIABLE, g_msgSayText, _, iPlayer)
				write_byte(iPlayer)
				write_string(szMessage)
				message_end()
			}
		}
	}
}

bool: load_adverts(szFilePath[])
{
	new pFile = fopen(szFilePath, "rt")
	if (!pFile)
		return false

	new szHostname[64], szIP[32], szMapname[32], szLine[MESSAGE_MAXLEN]
	get_user_ip(0, szIP, charsmax(szIP))
	get_cvar_string("hostname", szHostname, charsmax(szHostname))
	get_mapname(szMapname, charsmax(szMapname))

	while (!feof(pFile))
	{
		fgets(pFile, szLine, charsmax(szLine))
		trim(szLine)
		if(szLine[0] && szLine[0] != ';')
		{
			replace_all(szLine, charsmax(szLine), "%ip%", szIP)
			replace_all(szLine, charsmax(szLine), "%hostname%", szHostname)
			replace_all(szLine, charsmax(szLine), "%mapname%", szMapname)
			replace_all(szLine, charsmax(szLine), "%new%", "^n")
			ArrayPushArray(g_apMessages, szLine)
		}
	}

	fclose(pFile)
	return true
}

remove_specific_symbols(szMessage[], iStrLen)
{
	replace_all(szMessage, iStrLen, "!g", "")
	replace_all(szMessage, iStrLen, "!y", "")
	replace_all(szMessage, iStrLen, "!t", "")
}
