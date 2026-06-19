talk OnBoot
{
	Hello, world!
}

function OnAosoraDefaultSaveData
{
	Save.Data.SnowRate = 10;
	Monitor = [];
	Surfaces = {};
}

function OnAosoraLoad
{
	LastFlakeTime = Time.GetNowUnixEpoch() - Save.Data.SnowRate;
	LastDriftTime = Time.GetNowUnixEpoch() - Save.Data.SnowRate;
	Monitor = [];
	Surfaces = {};
	stroke = 0;
}

function OnKeyPress
{
	if (Shiori.Reference[0] == "v")
	{
		local display = "\0\_q\b[4]";
		for (local i = 0; i < Surfaces.length; i++)
		{
			display += "{i}: {Surfaces[i]}\n";
		}
		return display;
	}
}

function OnMouseDoubleClick
{
	if (Shiori.Reference[3] == 0 && Shiori.Reference[5] == 0) return OnMainMenu;
	else if (Shiori.Reference[3] >= 200 && Shiori.Reference[3] < 400) return "\p[{Shiori.Reference[3]}]\s[-1]"; //Remove snow drift/snow ball
}

function OnMouseMove, OnMouseWheel
{
	if (Shiori.Reference[3] >= 200 && Shiori.Reference[3] < 300)
	{
		stroke++;
		if (stroke % 40 == 0)
		{
			return "\![get,property,OnSnowDriftPos,currentghost.scope({Shiori.Reference[3]}).rect]\![embed,OnMakeSnowBall,{Shiori.Reference[3]}]";
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

function OnMainMenu
{
	local m = "\0\b[2]\![quicksection,1]\![set,autoscroll,disable]";
	
	local snowrates = [
		{label: "None", time: -1},
		{label: "Light", time: 10},
		{label: "Medium", time: 5},
		{label: "Heavy", time: 2},
		{label: "Blizzard", time: 1},
	];
	
	m += "Snow amount:\n";
	
	foreach (local rate in snowrates)
	{
		if (rate.time == Save.Data.SnowRate)
		{
			m += "\f[underline,1]\_a[OnChangeSnowRate,{rate.time}]{rate.label}\_a\f[underline,0]  ";
		}
		else
		{
			m += "\__q[OnChangeSnowRate,{rate.time}]{rate.label}\__q  ";
		}
	}
	m += "\n\n";
	
	m += "\![*]\__q[blank]Done\__q";
	
	return m;
}

function OnChangeSnowRate
{
	Save.Data.SnowRate = Shiori.Reference[0].ToNumber();
	return OnMainMenu;
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
	if (Save.Data.SnowRate != -1)
	{
		local currenttime = Time.GetNowUnixEpoch();
		
		//Snow drifts
		if (currenttime - LastDriftTime >= (Save.Data.SnowRate * 10) && Shiori.Reference[3] == 1)
		{
			LastDriftTime = Time.GetNowUnixEpoch();
			
			return OnSpawnSnowdrift();
		}
		
		//Snowflakes
		if (currenttime - LastFlakeTime >= Save.Data.SnowRate && Shiori.Reference[3] == 1)
		{
			LastFlakeTime = Time.GetNowUnixEpoch();
			
			return OnSpawnSnowflake();
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
	
	return "\![get,property,OnSpawnSnowflake@ActiveCheck" + cmd + "]";
}

function OnSpawnSnowflake@ActiveCheck
{
	local scope = -1;
	for (local i = 0; i < Shiori.Reference.length; i++)
	{
		if (Shiori.Reference[i] == "")
		{
			scope = i + 100;
			break;
		}
	}
	
	if (scope != -1)
	{
		//TODO need to set up something to make sure it doesn't interrupt balloons
		return "\p[{scope}]\![set,alpha,0]\s[1]\![get,property,OnSpawnSnowflake@WidthCheck,currentghost.scope({scope}).rect]\![embed,OnSpawnSnowflake@ChoosePosition,{scope},1]";
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
	
	return "\p[{Shiori.Reference[0]}]\![move,--X={X}]\s[{Shiori.Reference[1]}]\![set,alpha,100]";
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
		return "\p[{scope}]\![set,alpha,0]\s[2]\![get,property,OnSpawnSnowflake@WidthCheck,currentghost.scope({scope}).rect]\![embed,OnSpawnSnowflake@ChoosePosition,{scope},2]";
	}
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
		return "\p[{scope}]\![set,alpha,0]\s[3]\![get,property,OnSpawnSnowflake@WidthCheck,currentghost.scope({scope}).rect]\![embed,OnSpawnSnowBall@ChoosePosition,{scope},{Shiori.Reference[0]}]";
	}
}

function OnSpawnSnowBall@ChoosePosition
{
	//FlakeWidth
	//SnowDriftPos
	
	local X = SnowDriftPos.center - (FlakeWidth / 2).Floor();
	
	return "\p[{Shiori.Reference[1]}]\s[-1]\p[{Shiori.Reference[0]}]\![move,--X={X}]\s[3]\![set,alpha,100]";
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
	
	return "\p[{scope}]\![set,alpha,0]\s[4]\![get,property,OnSpawnSnowflake@WidthCheck,currentghost.scope({scope}).rect]\![get,property,OnSpawnSnowman@WidthCheck,currentghost.scope({p[0]}).rect,currentghost.scope({p[1]}).rect,currentghost.scope({p[2]}).rect]\![embed,OnSpawnSnowman@Move,{p[0]},{p[1]},{p[2]},{scope}]";
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
	return "\p[{Shiori.Reference[3]}]\![move,--X={X}]\s[4]\![set,alpha,100]\p[{Shiori.Reference[0]}]\s[-1]\p[{Shiori.Reference[1]}]\s[-1]\p[{Shiori.Reference[2]}]\s[-1]" + "{AllTogetherCenter}, {FlakeWidth} / 2 = {(FlakeWidth / 2).Floor()}, together {X}";
}