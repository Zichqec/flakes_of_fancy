talk OnBoot
{
	\1\s[-1]\0\s[0]
}

//These have to be cleared when restoring, otherwise they get stuck
function OnWindowStateRestore
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
	}
	
	InMainMenu = false;
	if (talkstr.Contains("\![__MAIN_MENU__]")) InMainMenu = true;
	
	return talkstr;
}

function OnAosoraDefaultSaveData
{
	Save.Data.SnowAmount = 1;
	Save.Data.TalkInterval = 180;
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

function SnowmanScopes
{
	local scopes = [];
	for (local i = 400; i < 500; i++)
	{
		if (Surfaces.Contains("{i}") && Surfaces["{i}"] != -1)
		{
			scopes.Add("{i}");
		}
	}
	return scopes;
}

function SnowdriftScopes
{
	local scopes = [];
	for (local i = 200; i < 300; i++)
	{
		if (Surfaces.Contains("{i}") && Surfaces["{i}"] != -1)
		{
			scopes.Add("{i}");
		}
	}
	return scopes;
}

function OnKeyPress
{
	if (Shiori.Reference[0] == "t") return OnAITalk;
	else if (Shiori.Reference[0] == "f1") return "\![open,readme]";
}

function OnMouseDoubleClick
{
	if (Shiori.Reference[3] == 0 && Shiori.Reference[5] == 0) return OnMainMenu("new");
	else if (Shiori.Reference[3] >= 200 && Shiori.Reference[3] < 500) return "\p[{Shiori.Reference[3]}]\s[-1]"; //Remove item
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

function OnSurfaceChange
{
	local ref = Shiori.Reference[2].Split(",");
	Surfaces["{ref[0]}"] = ref[1].ToNumber();
}

//Don't forget the ()!!!!!!
function BalloonIsOpen
{
	local status = Shiori.Headers.Status.ToString();
	if (status.Contains("balloon")) return 1;
	return 0;
}

function OnMainMenu(indicator)
{
	local m = "";
	if (BalloonIsOpen() && indicator != "new") m += "\C\![lock,balloonrepaint]\c";
	
	m += "\0\b[2]\![quicksection,1]\![set,autoscroll,disable]";
	m += "\![__MAIN_MENU__]"; //Don't have SHIORI3FW.LastTalk in Aosora, so trying this...
	
	local snowamounts = [
		{label: "None", amount: -1},
		{label: "Light", amount: 1},
		{label: "Medium", amount: 3},
		{label: "Heavy", amount: 5},
		{label: "Blizzard", amount: 7},
	];
	
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
	
	m += "\![*]\_a[OnCloseMainMenu]Done\_a";
	
	m += "\![unlock,balloonrepaint]";
	
	return m;
}

function OnChangeSnowRate
{
	Save.Data.SnowAmount = Shiori.Reference[0].ToNumber();
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

//It's a little janky, but since the main menu uses anchors instead of choices, this avoids having it be really touchy and closing if you miss clicking a choice...
function OnBalloonBreak, OnBalloonClose
{
	if (Shiori.Reference[0].Contains("\![__MAIN_MENU__]")) return "\C\![__MAIN_MENU__] \c[char,1]";
}

function OnDisplayChangeEx
{
	Monitor.Clear();
	
	//First reference we can ignore since it's not display data
	for (local i = 1; i < Shiori.Reference.length; i++)
	{
		local info = Shiori.Reference[i].Split(",");
		local left = info[0].ToNumber();
		local right = info[2].ToNumber();
		
		local width = abs(abs(right) - abs(left));
		Monitor.Add({left: left, right: right, width: width});
	}
}

function abs(num)
{
	if (num < 0) num *= -1;
	return num;
}

function OnSecondChange
{
	local cantalk = true;
	if (Shiori.Reference[3] == "0") cantalk = false;
	//TODO I don't know why I have to write out the == false here and can't just write !cantalk...... i'm losing my mind a bit right now, i'll revisit this. can't get the debugging functions working either
	//TalkLatch is a latch that makes it get the TalkEndTime *one* time after a dialogue ends (without this latch it just constantly updates)
	if (cantalk == false && TalkLatch == true) TalkEndTime = Time.GetNowUnixEpoch();
	else TalkLatch = false;
	
	//This check is the conditions for a randomtalk happening. This is necessary because otherwise snowflake spawns block the talking... oopsie
	if (TalkTimer.RandomTalkElapsedSeconds >= TalkTimer.RandomTalkIntervalSeconds && cantalk == true) return;
	
	if (Save.Data.SnowAmount != -1)
	{
		local currenttime = Time.GetNowUnixEpoch();
		
		local C = "";
		//Hoping that by checking for when the last dialogue ended, we can avoid the problem of the balloon staying open forever...
		//TODO ugh... this is gonna be weird when flakes don't fall every second. But maybe it's okay...?
		if (InMainMenu) C = "\C\![__MAIN_MENU__]";
		else if (BalloonIsOpen() && currenttime - TalkEndTime < 15) C = "\C";
		
		//Snow drifts
		//TODO i want increased flake amount to decrease the time it takes to spawn a drift...
		if (currenttime - LastDriftTime >= (60) && cantalk == true)
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

function OnSpawnSnowflake
{
	local cmd = "";
	for (local i = 100; i < 200; i++)
	{
		cmd += ",currentghost.scope({i}).animation.num";
	}
	
	local output = "";
	if (InMainMenu) output += "\C\![__MAIN_MENU__]";
	else if (BalloonIsOpen()) output += "\C";
	output += "\![get,property,OnSpawnSnowflake@ActiveCheck" + cmd + "]";
	return output;
}

function OnSpawnSnowflake@ActiveCheck
{
	local scopes = [];
	for (local i = 0; i < Shiori.Reference.length; i++)
	{
		if (Shiori.Reference[i] == "")
		{
			scopes.Add(i + 100);
			if (scopes.length >= Save.Data.SnowAmount) break;
		}
	}
	
	if (scopes.length > 0)
	{
		local output = "";
		if (InMainMenu) output += "\C\![__MAIN_MENU__]";
		else if (BalloonIsOpen()) output += "\C";
		
		for (local i = 0; i < scopes.length; i++)
		{
			local rand = Random.GetIndex(0,SnowFlakeVariants.length);
			local variant = SnowFlakeVariants[rand];
		
			local scope = scopes[i];
			output += "\p[{scope}]\![set,alpha,0]\s[1]\![bind,Snowflake variant,{variant},1]";
			output += "\![get,property,OnSpawnSnowflake@WidthCheck,currentghost.scope({scope}).rect]";
			output += "\![embed,OnSpawnSnowflake@ChoosePosition,{scope},1]";
		}
		return output;
	}
}

function OnSpawnSnowflake@WidthCheck
{
	local rect = Shiori.Reference[0].Split(",");
	FlakeWidth = abs(rect[2].ToNumber() - rect[0].ToNumber());
}

function OnSnowDriftPos
{
	local rect = Shiori.Reference[0].Split(",");
	local left = rect[0].ToNumber();
	local right = rect[2].ToNumber();
	local width = abs(right - left);
	local center = right - (width /  2).Floor();
	
	SnowDriftPos = {left: left, right: right, center: center, width: width};
}

function OnSpawnSnowflake@ChoosePosition
{
	local monitor = Monitor[Random.GetIndex(0,Monitor.length)];
	local leftbound = monitor.left;
	local position = Random.GetIndex(0,monitor.width - FlakeWidth);
	
	local X = leftbound + position;
	
	local output = "";
	if (InMainMenu) output += "\C\![__MAIN_MENU__]";
	else if (BalloonIsOpen()) output += "\C";
	//TODO there's an issue where sometimes it spawns a flake and repeatedly fades it in... but that might be because I was messing with timerraise
	output += "\p[{Shiori.Reference[0]}]\![move,--X={X}]\s[{Shiori.Reference[1]}]\![set,alpha,100,500]";
	return output;
}

function OnSpawnSnowdrift
{
	local scope = -1;
	for (local i = 200; i < 300; i++)
	{
		if (Surfaces["{i}"] == -1 || !Surfaces.Contains("{i}"))
		{
			scope = i;
			break;
		}
	}
	
	if (scope != -1)
	{
		local rand = Random.GetIndex(0,SnowDriftVariants.length);
		local variant = SnowDriftVariants[rand];
	
		local output = "";
		if (InMainMenu) output += "\C\![__MAIN_MENU__]";
		else if (BalloonIsOpen()) output += "\C";
		output += "\p[{scope}]\![set,alpha,0]\s[2]\![bind,Snow drift variant,{variant},1]\![bind,Snow drift stage,0,1]";
		output += "\![get,property,OnSpawnSnowflake@WidthCheck,currentghost.scope({scope}).rect]";
		output += "\![embed,OnSpawnSnowflake@ChoosePosition,{scope},2]";
		return output;
	}
}

function OnIncreaseSnowdrift
{
	local eligible = [];
	for (local i = 200; i < 300; i++)
	{
		if (Surfaces["{i}"] != -1 && SnowDriftHeight["{i}"] < SnowDriftHeight.length) eligible.Add(i);
	}
	
	if (eligible.length == 0) return;
	
	local rand = Random.GetIndex(0,eligible.length);
	local character = eligible[rand];
	local height = SnowDriftHeight["{character}"];
	
	local output = "";
	if (InMainMenu) output += "\C\![__MAIN_MENU__]";
	else if (BalloonIsOpen()) output += "\C";
	output += "\p[{character}]\![bind,Snow drift stage,{height + 1},1]";
	return output;
}

function OnMakeSnowBall
{
	local scope = -1;
	for (local i = 300; i < 400; i++)
	{
		if (Surfaces["{i}"] == -1 || !Surfaces.Contains("{i}"))
		{
			scope = i;
			break;
		}
	}
	
	if (scope != -1)
	{
		local rand = Random.GetIndex(0,SnowBallVariants.length);
		local variant = SnowBallVariants[rand];
	
		local output = "";
		if (InMainMenu) output += "\C\![__MAIN_MENU__]";
		else if (BalloonIsOpen()) output += "\C";
		output += "\p[{scope}]\![set,alpha,0]\s[3]\![bind,Snow ball variant,{variant},1]";
		output += "\![get,property,OnSpawnSnowflake@WidthCheck,currentghost.scope({scope}).rect]";
		output += "\![embed,OnSpawnSnowBall@ChoosePosition,{scope},{Shiori.Reference[0]}]";
		return output;
	}
}

function OnSpawnSnowBall@ChoosePosition
{
	//FlakeWidth
	//SnowDriftPos
	
	local X = SnowDriftPos.center - (FlakeWidth / 2).Floor();
	
	local output = "";
	if (InMainMenu) output += "\C\![__MAIN_MENU__]";
	else if (BalloonIsOpen()) output += "\C";
	output += "\p[{Shiori.Reference[1]}]\s[-1]\p[{Shiori.Reference[0]}]\![move,--X={X}]\s[3]\![set,alpha,100]";
	return output;
}

function OnSpawnSnowman(p)
{
	local scope = -1;
	for (local i = 400; i < 500; i++)
	{
		if (Surfaces["{i}"] == -1 || !Surfaces.Contains("{i}"))
		{
			scope = i;
			break;
		}
	}
	
	local rand = Random.GetIndex(0,SnowManVariants.length);
	local variant = SnowManVariants[rand];
	
	local output = "";
	if (InMainMenu) output += "\C\![__MAIN_MENU__]";
	else if (BalloonIsOpen()) output += "\C";
	output += "\p[{scope}]\![set,alpha,0]\s[4]\![bind,Snowman variant,{variant},1]";
	output += "\![get,property,OnSpawnSnowflake@WidthCheck,currentghost.scope({scope}).rect]";
	output += "\![get,property,OnSpawnSnowman@WidthCheck,currentghost.scope({p[0]}).rect,currentghost.scope({p[1]}).rect,currentghost.scope({p[2]}).rect]";
	output += "\![embed,OnSpawnSnowman@Move,{p[0]},{p[1]},{p[2]},{scope}]";
	return output;
}

function OnSpawnSnowman@WidthCheck
{
	local ref0 = Shiori.Reference[0].Split(",");
	local ref1 = Shiori.Reference[1].Split(",");
	local ref2 = Shiori.Reference[2].Split(",");
	
	local left = ref0[0].ToNumber();
	if (ref1[0].ToNumber() < left) left = ref1[0].ToNumber();
	if (ref2[0].ToNumber() < left) left = ref2[0].ToNumber();
	
	local right = ref0[2].ToNumber();
	if (ref1[2].ToNumber() > right) right = ref1[2].ToNumber();
	if (ref2[2].ToNumber() > right) right = ref2[2].ToNumber();
	
	local width = abs(right - left);
	AllTogetherCenter = right - (width /  2).Floor();
}

function OnSpawnSnowman@Move
{
	//TODO for some reason the snowman doesn't appear in the center of the snowballs properly like it should even though i have triple checked... I'll come back to this
	local X = AllTogetherCenter - (FlakeWidth / 2).Floor();
	
	local output = "";
	if (InMainMenu) output += "\C\![__MAIN_MENU__]";
	else if (BalloonIsOpen()) output += "\C";
	output += "\p[{Shiori.Reference[3]}]\![move,--X={X}]\s[4]\![set,alpha,100]\p[{Shiori.Reference[0]}]\s[-1]\p[{Shiori.Reference[1]}]\s[-1]\p[{Shiori.Reference[2]}]\s[-1]"; // + "{AllTogetherCenter}, {FlakeWidth} / 2 = {(FlakeWidth / 2).Floor()}, together {X}";
	return output;
}

function ColorAnchorAsChoice
{
	return "\f[anchor.font.color,default.cursor]\f[anchor.visited.font.color,default.cursor]";
}

function UnColorAnchorAsChoice
{
	return "\f[anchor.font.color,default]\f[anchor.visited.font.color,default]";
}

function Chain
{
	TalkLatch = true;
	return "\p[{LastScope}]";
}

function OnNotifyDressupInfo
{
	SnowFlakeVariants = [];
	SnowDriftVariants = [];
	SnowBallVariants = [];
	SnowManVariants = [];
	
	SnowDriftHeight = {};
	
	for (local i = 0; i < Shiori.Reference.length; i++)
	{
		local dressup = Shiori.Reference[i].Split((1).ToAscii());
		
		//I could make these single if checks, but it's just so long and cumbersome to read...
		//I don't want these to be associative, but I can't find a basic array search function...
		if (dressup[1] == "Snowflake variant")
		{
			if (InArray(dressup[2],SnowFlakeVariants) == 0) SnowFlakeVariants.Add(dressup[2]);
		}
		if (dressup[1] == "Snow drift variant")
		{
			if (InArray(dressup[2],SnowDriftVariants) == 0) SnowDriftVariants.Add(dressup[2]);
		}
		if (dressup[1] == "Snow ball variant")
		{
			if (InArray(dressup[2],SnowBallVariants) == 0) SnowBallVariants.Add(dressup[2]);
		}
		if (dressup[1] == "Snowman variant")
		{
			if (InArray(dressup[2],SnowManVariants) == 0) SnowManVariants.Add(dressup[2]);
		}
		
		//Get snow drift height
		if (dressup[4] == "0") continue;
		local character = dressup[0].ToNumber();
		
		//[character ID, category name, part name, option, on-1/off-0, thumbnail path]
		if (character >= 200 && character < 300) //Snow drifts
		{
			//If this is the stage dressup, save the character ID and stage number
			if (dressup[1] == "Snow drift stage") SnowDriftHeight["{character}"] = dressup[2].ToNumber();
		}
	}
}

//there must be a better way... but i'm head empty......
function InArray(key, array)
{
	for (local i = 0; i < array.length; i++)
	{
		if (key == array[i]) return 1;
	}
	return 0;
}

//Communication event:
//How hard it's snowing, Wind speed, Wind direction, How many snow drifts, How many snow balls, How many snowmen, Snow drift depth dressups
//OnFlakesOfFancyStateNotify
//OnFOFSnowStateNotify