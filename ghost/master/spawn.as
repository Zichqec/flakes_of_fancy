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

//This is separate because I think the different types of spawning are overlapping and causing a bug...
//Update: actually it was probably unnecessary to split this but i don't have time to undo that and test aaaaaa
function OnSpawning@WidthCheck
{
	local rect = Shiori.Reference[0].Split(",");
	NonFlakeWidth = abs(rect[2].ToNumber() - rect[0].ToNumber());
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
	output += "\p[{Shiori.Reference[0]}]\![move,--X={X},--base=primaryscreen]\s[{Shiori.Reference[1]}]\![set,alpha,100,500]";
	return output;
}

//split this so i can embed stats thing
function OnSpawnSnowdrift@ChoosePosition
{
	local monitor = Monitor[Random.GetIndex(0,Monitor.length)];
	local leftbound = monitor.left;
	local position = Random.GetIndex(0,monitor.width - FlakeWidth);
	
	local X = leftbound + position;
	
	local output = "";
	if (InMainMenu) output += "\C\![__MAIN_MENU__]";
	else if (BalloonIsOpen()) output += "\C";
	//TODO there's an issue where sometimes it spawns a flake and repeatedly fades it in... but that might be because I was messing with timerraise
	output += "\p[{Shiori.Reference[0]}]\![move,--X={X},--base=primaryscreen]\s[{Shiori.Reference[1]}]\![set,alpha,100,500]\![embed,OnSendStats]";
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
		output += "\![get,property,OnSpawning@WidthCheck,currentghost.scope({scope}).rect]";
		output += "\![embed,OnSpawnSnowdrift@ChoosePosition,{scope},2]";
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
	output += "\p[{character}]\![bind,Snow drift stage,{height + 1},1]\![embed,OnSendStats]";
	return output;
}

//TODO there was an odd bug here for a bit where i rolled up snowballs but they appeared in the wrong places... no idea why, investigate later?
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
		output += "\![get,property,OnSpawning@WidthCheck,currentghost.scope({scope}).rect]";
		output += "\![embed,OnSpawnSnowBall@ChoosePosition,{scope},{Shiori.Reference[0]}]";
		return output;
	}
}

function OnSpawnSnowBall@ChoosePosition
{
	local X = SnowDriftPos.center - (NonFlakeWidth / 2).Floor();
	
	local output = "";
	if (InMainMenu) output += "\C\![__MAIN_MENU__]";
	else if (BalloonIsOpen()) output += "\C";
	output += "\p[{Shiori.Reference[1]}]\s[-1]\p[{Shiori.Reference[0]}]\![move,--X={X},--base=primaryscreen]\s[3]\![set,alpha,100]\![embed,OnSendStats]";
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
	output += "\![get,property,OnSpawning@WidthCheck,currentghost.scope({scope}).rect]";
	output += "\![get,property,OnSpawnSnowman@WidthCheck,currentghost.scope({p[0]}).rect,currentghost.scope({p[1]}).rect,currentghost.scope({p[2]}).rect]";
	output += "\![embed,OnSpawnSnowman@Move,{p[0]},{p[1]},{p[2]},{scope}]";
	if (SnowmanScopes().length >= 11 && Save.Data.ProgrammerArtUnlocked == false)
	{
		Save.Data.ProgrammerArtUnlocked = true;
		output += "\![set,property,currentghost.shelllist(Programmer art).menu,menu]";
	}
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
	local X = AllTogetherCenter - (NonFlakeWidth / 2).Floor();
	
	local output = "";
	if (InMainMenu) output += "\C\![__MAIN_MENU__]";
	else if (BalloonIsOpen()) output += "\C";
	output += "\p[{Shiori.Reference[3]}]\![move,--X={X},--base=primaryscreen]\s[4]\![set,alpha,100]\p[{Shiori.Reference[0]}]\s[-1]\p[{Shiori.Reference[1]}]\s[-1]\p[{Shiori.Reference[2]}]\s[-1]\![embed,OnSendStats]"; // + "{AllTogetherCenter}, {NonFlakeWidth} / 2 = {(NonFlakeWidth / 2).Floor()}, together {X}";
	return output;
}
