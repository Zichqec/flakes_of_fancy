talk OnBoot
{
	Hello, world!
}

function OnAosoraDefaultSaveData
{
	Save.Data.SnowRate = 10;
	Monitor = [];
}

function OnAosoraLoad
{
	LastFlakeTime = Time.GetNowUnixEpoch() - Save.Data.SnowRate;
	Monitor = [];
}

function OnKeyPress
{
	if (Shiori.Reference[0] == "v")
	{
		return "{Monitor[0].left} | {Monitor[0].right} | {Monitor[0].width}\n{Monitor[1].left} | {Monitor[1].right} | {Monitor[1].width}\n{Monitor[2].left} | {Monitor[2].right} | {Monitor[2].width}\n";
	}
}

function OnMouseDoubleClick
{
	if (Shiori.Reference[3] == 0 && Shiori.Reference[5] == 0) return OnMainMenu;
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
		return "\p[{scope}]\![set,alpha,0]\s[1]\![get,property,OnSpawnSnowflake@WidthCheck,currentghost.scope({scope}).rect]\![embed,OnSpawnSnowflake@ChoosePosition,{scope}]";
	}
}

function OnSpawnSnowflake@WidthCheck
{
	local rect = Shiori.Reference[0].Split(",");
	FlakeWidth = abs(rect[2].ToNumber() - rect[0].ToNumber());
}

function OnSpawnSnowflake@ChoosePosition
{
	local monitor = Monitor[Random.GetIndex(0,Monitor.length)];
	local leftbound = monitor.left;
	local position = Random.GetIndex(0,monitor.width - FlakeWidth);
	
	local X = leftbound + position;
	
	return "\p[{Shiori.Reference[0]}]\![move,--X={X}]\s[1]\![set,alpha,100]";
}