talk OnBoot
{
	Hello, world!
}

function OnAosoraDefaultSaveData
{
	Config@SnowRate = 10;
}

function OnAosoraLoad
{
	LastFlakeTime = Time.GetNowUnixEpoch() - Config@SnowRate;
}

function OnSecondChange
{
	local currenttime = Time.GetNowUnixEpoch();
	if (currenttime - LastFlakeTime >= Config@SnowRate && Shiori.Reference[3] == 1)
	{
		LastFlakeTime = Time.GetNowUnixEpoch();
		
		return OnSpawnSnowflake();
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
		return "\p[{scope}]\s[1]";
	}
}