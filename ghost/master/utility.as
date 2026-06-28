//———————————————————— Pure functions ————————————————————

//Equivalent to YAYA ASEARCH (except it's just a yes or no, not a position finder)
//there must be a better way... but i'm head empty......
function InArray(key, array)
{
	for (local i = 0; i < array.length; i++)
	{
		if (key == array[i]) return 1;
	}
	return 0;
}

function abs(num)
{
	if (num < 0) num *= -1;
	return num;
}


//———————————————————— Formatting shortcuts (fixed output, mostly) ————————————————————
function ColorAnchorAsChoice
{
	return "\f[anchor.font.color,default.cursor]\f[anchor.visited.font.color,default.cursor]";
}

function UnColorAnchorAsChoice
{
	return "\f[anchor.font.color,default]\f[anchor.visited.font.color,default]";
}

function SnowAmounts
{
	return [
		{label: "None", amount: 0},
		{label: "Light", amount: 1},
		{label: "Medium", amount: 3},
		{label: "Heavy", amount: 5},
		{label: "Blizzard", amount: 7},
	];
}

function Choices
{
	return "\![__CHOICES__]";
}

function Chain
{
	TalkLatch = true;
	ResetBalloonTimeout(); //TODO test this -- not working... hm
	return "\p[{LastScope}]";
}

function ResetBalloonTimeout
{
	TalkLatch = true;
}


//———————————————————— Helper shortcuts (variable output, for checks) ————————————————————
//Don't forget the ()!!!!!!
function BalloonIsOpen
{
	local status = Shiori.Headers.Status.ToString();
	if (status.Contains("balloon")) return 1;
	return 0;
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

function SnowballScopes
{
	local scopes = [];
	for (local i = 300; i < 400; i++)
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


//———————————————————— Notify (information saved for later use) ————————————————————
function OnNotifyShellInfo
{
	CurrentShell = Shiori.Reference[0];
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
		if (dressup[0] == 100 || dressup[0] == 200 || dressup[0] == 300 || dressup[0] == 400)
		{
			//I could make these single if checks, but it's just so long and cumbersome to read...
			//I don't want these to be associative, but I can't find a basic array search function...
			if (dressup[1] == "Snowflake variant")
			{
				if (InArray(dressup[2],SnowFlakeVariants) == 0) SnowFlakeVariants.Add(dressup[2]);
			}
			else if (dressup[1] == "Snow drift variant")
			{
				if (InArray(dressup[2],SnowDriftVariants) == 0) SnowDriftVariants.Add(dressup[2]);
			}
			else if (dressup[1] == "Snow ball variant")
			{
				if (InArray(dressup[2],SnowBallVariants) == 0) SnowBallVariants.Add(dressup[2]);
			}
			else if (dressup[1] == "Snowman variant")
			{
				if (InArray(dressup[2],SnowManVariants) == 0) SnowManVariants.Add(dressup[2]);
			}
		}
		
		//TODO this really needs infinite loop protection lol
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

