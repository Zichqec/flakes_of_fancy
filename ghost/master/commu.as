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
	output += "\![notifyother,__SYSTEM_ALL_GHOST__,OnFlakesOfFancyStateNotify";
	output += `,{snowlevel}`;
	output += `,"{shellname}"`;
	output += `,{SnowdriftScopes().length}`;
	output += `,{SnowballScopes().length}`;
	output += `,{SnowmanScopes().length}`;
	output += `,"{driftheights}"`;
	output += "]";
	return output;
}

//The above event is sent by more than the events listed below, but the ones listed here are exclusively used for the purposes of sending this event

//I don't know which i need to hit so i'm just gonna hit em all!!!!!!
function OnOtherGhostBooted, OnOtherGhostChanged, OnGhostCalled, OnGhostCallComplete
{
	return "\![embed,OnSendStats]";
}

function OnHourTimeSignal
{
	return "\![embed,OnSendStats]";
}

function OnClose
{
	return "\![embed,OnSendStats]";
}