//What a collosal mess lol
//I'll clean this up after jam
//please don't judge me by this i swear i can write clean code
//look at hydrate... so clean...

//TODO i'm not sure if snow drifts are building up anymore...? it seems like they waited until I had 25, but I'm not quite sure...
//TODO ↓ i could also try an embed method mid dialogue, but if i group them then it may remove the need for this...
//TODO if i make the snowflakes be multiple per-character, then they can fall down even if the character is talking...
//Here's a wild idea: handle it ALL shell side, by simply... oh hell lol, if people move the snowflakes it will be obvious what's happened lol
//But if I were to spawn enough characters to cover the full screen, then... i could just control the amount by making each character poke the snowflake button at different rates based on a dressup or something? maybe that could solve it (though SSP still might not like this, shell stuff is heavy I think)
//Of course, they wouldn't be randomly distributed that way without a lot of copy-pasting...
//But I mean like... if they just snow down a few times, then move randomly and do it again... that's pretty good and keeps the random distributon more or less
//TODO changing the snow amount in the menu needs to send the notify event lol
//TODO it might be fun if clicking a snowflake made it disappear (but, if I group them together, this is perhaps not a good idea...)
//TODO some of the chain dialogues are disappearing... weird??

function OnBoot
{
	local output = "";
	if (Save.Data.ProgrammerArtUnlocked == false) output += "\![set,property,currentghost.shelllist(Programmer art).menu,hidden]";
	output += "\1\s[-1]\0\s[0]\![embed,OnSendStats]";
	return output;
}

talk OnClose
{
	\![embed,OnSendStats]
}

function homeurl
{
	return "https://raw.githubusercontent.com/Zichqec/flakes_of_fancy/refs/heads/main/";
}

function sakura@recommendsites
{
	return "Blue{(1).ToAscii}https://www.tumblr.com/bluetheanimator{(2).ToAscii}" + "Galla{(1).ToAscii}https://gallathegalla.github.io/gtg-ghosts/{(2).ToAscii}" + "Zichqec{(1).ToAscii}https://ukagaka.zichqec.com/{(2).ToAscii}";
}

function sakura@portalsites
{
	return "Leave a Review{(1).ToAscii}https://docs.google.com/forms/d/e/1FAIpQLScIiGvw1euLnlG2iF3K4DRw-WKdHPH_aKfS1lgeCZDGrcOUMA/viewform{(2).ToAscii}";
}

//I don't know which i need to hit so i'm just gonna hit em all!!!!!!
function OnOtherGhostBooted, OnOtherGhostChanged, OnGhostCalled, OnGhostCallComplete
{
	return "\![embed,OnSendStats]";
}

function OnHourTimeSignal
{
	return "\![embed,OnSendStats]";
}

function OnShellChanged
{
	//return "\![embed,OnSendStats]";
	ShellChangeStatsLatch = true;
}

function OnInstallComplete
{
	CheckShellLockLatch = true;
}

//These have to be cleared when restoring, otherwise they get stuck
//TODO i was going to have OnShellChanged here, but that seems to kill everything but the main surface...??? weird
function OnWindowStateRestore //, OnShellChanged
{
	local snowflakes = "";
	for (local i = 100; i < 200; i++)
	{
		snowflakes += "\p[{i}]\s[-1]";
	}
	return snowflakes + "\1\s[-1]\0\s[0]";
}

function OnTranslate
{
	local talkstr = Shiori.Reference[0];
	
	if (!talkstr.Contains("\![no-autopause]"))
	{
		talkstr = talkstr.Replace(", ",",\w4 ");
		talkstr = talkstr.Replace(". ",".\w8\w8 ");
		talkstr = talkstr.Replace("? ","?\w8\w8 ");
		talkstr = talkstr.Replace("! ","!\w8\w8 ");
		talkstr = talkstr.Replace(": ",":\w8\w8 ");
		talkstr = talkstr.Replace("; ",";\w8\w8 ");
		talkstr = talkstr.Replace("\![ap-n]","\w8\w8"); //linebreaks, because it's awkward to not explicitly show them...
	}
	
	InMainMenu = false;
	if (talkstr.Contains("\![__MAIN_MENU__]")) InMainMenu = true;
	
	return talkstr;
}

function OnAosoraDefaultSaveData
{
	Save.Data.SnowAmount = 1;
	Save.Data.TalkInterval = 300;
	Save.Data.ProgrammerArtUnlocked = false;
}

function OnAosoraLoad
{
	LastFlakeTime = Time.GetNowUnixEpoch();
	LastDriftTime = Time.GetNowUnixEpoch();
	Monitor = [];
	Surfaces = {};
	stroke = 0;
	TalkTimer.RandomTalkIntervalSeconds = Save.Data.TalkInterval;
	TalkTimer.RandomTalk = OnTimedTalk;
	LastScope = -1;
	TalkScope = -1;
	TalkEndTime = Time.GetNowUnixEpoch();
	TalkLatch = false;
	InMainMenu = false;
	ShellChangeStatsLatch = false;
	Save.Data.ProgrammerArtUnlocked = false;
	CheckShellLockLatch = false;
	//TalkBuilder.Default.AutoLineBreak = "\n\w8";
}

function OnInitialize
{
	if (Shiori.Reference[0] != "reload")
	{
		Surfaces.Clear();
	}
}

//IIRC the below calls this one, and this one does the actual call to randomtalk...
//NOTE: chain talks don't come through this function............. or at least not if i prompt them
function OnTimedTalk
{
	if (SnowmanScopes().length > 0)
	{
		TalkEndTime = Time.GetNowUnixEpoch(); //Set this here too to prevent possible leakage if dialogues happen at just the wrong time...
		TalkLatch = true;
		local scopes = SnowmanScopes();
		local rand = Random.GetIndex(0,scopes.length);
		local scope = scopes[rand];
		
		//If a scope has been sent by the mouse click event
		if (TalkScope != -1) scope = TalkScope;
		LastScope = scope;
		
		local dialogue = Reflection.Get("RandomTalk")(scope);
		dialogue = dialogue.Replace("\0","\p[{scope}]");
		
		LastTalk = dialogue;
		return LastTalk;
	}
	TalkScope = -1;
	TalkLatch = false;
}

function OnAITalk(scope)
{
	if (!scope.IsNull()) TalkScope = scope;
	else TalkScope = -1;
	LastTalk = TalkTimer.CallRandomTalk();
	return LastTalk;
}

function OnKeyPress
{
	if (Shiori.Reference[0] == "t") return OnAITalk;
	else if (Shiori.Reference[0] == "f1") return "\![open,readme]";
}

function OnMouseDoubleClick
{
	if (Shiori.Reference[3] == 0 && Shiori.Reference[5] == 0) return OnMainMenu("new");
	else if (Shiori.Reference[3] >= 200 && Shiori.Reference[3] < 500)
	{
		if (Shiori.Reference[3] == LastScope) TalkTimer.RandomTalkQueue.Clear();
		
		return "\p[{Shiori.Reference[3]}]\s[-1]\![embed,OnSendStats]"; //Remove item
	}
}

function OnMouseMove, OnMouseWheel
{
	if (Shiori.Reference[3] >= 200 && Shiori.Reference[3] < 300)
	{
		stroke++;
		if (stroke % 40 == 0)
		{
			local output = "";
			if (BalloonIsOpen()) output += "\C";
			output += "\![get,property,OnSnowDriftPos,currentghost.scope({Shiori.Reference[3]}).rect]";
			output += "\![embed,OnMakeSnowBall,{Shiori.Reference[3]}]";
			return output;
		}
	}
	else if (Shiori.Reference[3] >= 400 && Shiori.Reference[3] < 500) //Make snowmen talk. Would another action be better...?
	{
		stroke++;
		if (stroke % 40 == 0)
		{
			if (Shiori.Reference[3] != LastScope) TalkTimer.RandomTalkQueue.Clear();
			
			return OnAITalk(Shiori.Reference[3]);
		}
	}
}

function OnMouseLeaveAll
{
	stroke = 0;
}

function OnOverlap
{
	//return "\0\b[4]\_q" + Shiori.Reference[0] + "\n" + Shiori.Reference[1];
	local reference = Shiori.Reference[0].Split((1).ToAscii());
	local overlaps = []; //Temporary list of all the overlapping scopes
	local scopes = []; //Final scopes to remove
	
	//Avoids a runtime error...
	if (Shiori.Reference[0].length == 0) return;
	
	foreach (ref in reference)
	{
		local snowball = ref.Split("-");
		snowball[0] = snowball[0].ToNumber();
		snowball[1] = snowball[1].ToNumber();
		
		//Ignore any overlaps that are not snow balls (not in the 300 range)
		if ((snowball[0] >= 300 && snowball[0] < 400) && (snowball[1] >= 300 && snowball[1] < 400))
		{
			//All we have to do is find an existing overlap, and if this matches at least one of the numbers, then we have a chain of 3 (because we already filtered out any non-snowballs)
			foreach (overlap in overlaps)
			{
				local pair = overlap.Split("-");
				local found;
				
				if (overlap.Contains(snowball[0])) found = snowball[1];
				if (overlap.Contains(snowball[1])) found = snowball[0];
				
				if (!found.IsNull())
				{
					scopes.Add(pair[0]);
					scopes.Add(pair[1]);
					scopes.Add(found);
					return OnSpawnSnowman(scopes);
				}
			}
			overlaps.Add(ref);
		}
	}
}

//It's a little janky, but since the main menu uses anchors instead of choices, this avoids having it be really touchy and closing if you miss clicking a choice...
function OnBalloonBreak, OnBalloonClose
{
	if (Shiori.Reference[0].Contains("\![__MAIN_MENU__]")) return "\C\![__MAIN_MENU__] \c[char,1]";
	else if (Shiori.Reference[0].Contains("\![__CHOICES__]")) return "\C\p[{LastScope}]\![__CHOICES__] \c[char,1]";
}

function OnSecondChange
{
	local cantalk = true;
	if (Shiori.Reference[3] == "0") cantalk = false;
	//TODO I don't know why I have to write out the == false here and can't just write !cantalk...... i'm losing my mind a bit right now, i'll revisit this. can't get the debugging functions working either
	//TalkLatch is a latch that makes it get the TalkEndTime *one* time after a dialogue ends (without this latch it just constantly updates)
	if (ShellChangeStatsLatch == true)
	{
		ShellChangeStatsLatch = false;
		return "\![embed,OnSendStats]";
	}
	
	if (CheckShellLockLatch == true)
	{
		CheckShellLockLatch = false;
		return "\![set,property,currentghost.shelllist(Programmer art).menu,hidden]";
	}
	
	if (cantalk == false && TalkLatch == true) TalkEndTime = Time.GetNowUnixEpoch();
	else TalkLatch = false;
	
	//This check is the conditions for a randomtalk happening. This is necessary because otherwise snowflake spawns block the talking... oopsie
	if (TalkTimer.RandomTalkElapsedSeconds >= TalkTimer.RandomTalkIntervalSeconds && cantalk == true) return;
	
	if (Save.Data.SnowAmount > 0)
	{
		local currenttime = Time.GetNowUnixEpoch();
		
		local C = "";
		//Hoping that by checking for when the last dialogue ended, we can avoid the problem of the balloon staying open forever...
		//TODO ugh... this is gonna be weird when flakes don't fall every second. But maybe it's okay...?
		if (InMainMenu) C = "\C\![__MAIN_MENU__]";
		else if (BalloonIsOpen() && currenttime - TalkEndTime < 15) C = "\C";
		
		//Snow drifts
		local basetime = 300; //Going with 5 minutes if you have it set to the slowest snow speed
		if (currenttime - LastDriftTime >= (basetime / Save.Data.SnowAmount).Floor() && cantalk == true)
		{
			LastDriftTime = Time.GetNowUnixEpoch();
			
			//Using raise for these just so it'll break the balloon when desired...
			
			local count = SnowdriftScopes().length;
			local action = "new";
			//TODO it might be nice to have the option to change the snow drift limit... for now, 25 is enough to prevent Problems™
			if (count >= 25) action = "increase";
			else if (count >= 5 && Random.GetIndex(0,3) == 0) action = "increase";
			
			if (action == "increase") return C + "\![raise,OnIncreaseSnowdrift]";
			else return C + "\![raise,OnSpawnSnowdrift]";
		}
		
		//Snowflakes
		//currenttime - LastFlakeTime >= Save.Data.SnowRate && 
		else if (cantalk == true)
		{
			LastFlakeTime = Time.GetNowUnixEpoch();
			
			return C + "\![raise,OnSpawnSnowflake]";
		}
	}
}

//Communication event:
//How hard it's snowing, How many snow drifts, How many snow balls, How many snowmen, Snow drift depth dressups, Wind speed, Wind direction,
//OnFlakesOfFancyStateNotify

//!!! THIS IS UNFINISHED AND MAY CHANGE AFTER JAM !!! THIS IS NOT SET IN STONE, IMPLEMENT AT YOUR OWN RISK !!!
function OnSendStats
{
	local snowlevel = 0;
	local snowamounts = SnowAmounts();
	for (local i = 0; i < snowamounts.length; i++)
	{
		if (snowamounts[i].amount == Save.Data.SnowAmount) snowlevel = i;
	}
	
	local driftheights = "";
	local drifts = SnowDriftHeight.Keys();
	for (local i = 0; i < drifts.length; i++)
	{
		local p = i + 200;
		if (Surfaces.Contains("{p}") && Surfaces["{p}"] != -1)
		{
			if (i > 0) driftheights += ",";
			driftheights += SnowDriftHeight["{drifts[i]}"];
		}
	}
	
	local shellname = CurrentShell.Replace('"','""');
	local output = "";
	output += "\![notifyother,OnFlakesOfFancyStateNotify";
	output += `,{snowlevel}`;
	output += `,"{shellname}"`;
	output += `,{SnowdriftScopes.length}`;
	output += `,{SnowballScopes.length}`;
	output += `,{SnowmanScopes.length}`;
	output += `,"{driftheights}"`;
	output += "]";
	return output;
}