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

function Choices
{
	return "\![__CHOICES__]";
}

function abs(num)
{
	if (num < 0) num *= -1;
	return num;
}

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