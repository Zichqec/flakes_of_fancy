function OnMainMenu(state)
{
	local m = "";
	if (BalloonIsOpen() && state != "init") m += "\C\![lock,balloonrepaint]\c";
	
	m += "\0\b[2]\![quicksection,1]\![set,autoscroll,disable]\![no-autopause]";
	m += "\![__MAIN_MENU__]"; //Don't have SHIORI3FW.LastTalk in Aosora, so trying this...
	
	local snowamounts = SnowAmounts();
	
	m += "Snow amount:\n{ColorAnchorAsChoice}";
	
	foreach (local snow in snowamounts)
	{
		if (snow.amount == Save.Data.SnowAmount)
		{
			m += "{UnColorAnchorAsChoice}\f[underline,1]\_a[OnChangeSnowRate,{snow.amount}]{snow.label}\_a\f[underline,0]{ColorAnchorAsChoice}  ";
		}
		else
		{
			m += "\_a[OnChangeSnowRate,{snow.amount}]{snow.label}\_a  ";
		}
	}
	m += "\n\n";
	
	local talkrates = [
		{label: "Off", time: 0},
		{label: "1m", time: 60},
		{label: "3m", time: 180},
		{label: "5m", time: 300},
		{label: "10m", time: 600},
		{label: "15m", time: 900},
	];
	
	if (SnowmanScopes().length > 0)
	{
		m += "Talk rate:\n{ColorAnchorAsChoice}";
		
		foreach (local rate in talkrates)
		{
			if (rate.time == Save.Data.TalkInterval)
			{
				m += "{UnColorAnchorAsChoice}\f[underline,1]\_a[OnChangeTalkInterval,{rate.time}]{rate.label}\_a\f[underline,0]{ColorAnchorAsChoice}  ";
			}
			else
			{
				m += "\_a[OnChangeTalkInterval,{rate.time}]{rate.label}\_a  ";
			}
		}
		m += "\n\n";
	}
	m += "\![*]\_a[OnCloseMainMenu]Done\_a";
	
	m += "\![unlock,balloonrepaint]";
	
	return m;
}

function OnChangeSnowRate
{
	Save.Data.SnowAmount = Shiori.Reference[0].ToNumber();
	local time = Time.GetNowUnixEpoch();
	LastFlakeTime = time;
	LastDriftTime = time;
	return OnMainMenu;
}

function OnChangeTalkInterval
{
	Save.Data.TalkInterval = Shiori.Reference[0];
	TalkTimer.RandomTalkIntervalSeconds = Save.Data.TalkInterval;
	TalkTimer.RandomTalkElapsedSeconds = 0;
	
	return OnMainMenu;
}

function OnCloseMainMenu
{
	return "\0\b[-1]";
}