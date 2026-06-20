talk RandomTalk(p)
{
	%{ TalkTimer.RandomTalkQueue = [Chain_VolumeWarning1, Chain_VolumeWarning2]; }
	\b[0]HELLO!! ARE YOU THERE!! MY EYES DON'T WORK!! I NEED NEW ONES!!
}

talk Chain_VolumeWarning1
{
	{Chain}\b[0]THIS IS A JOKE!! MY EYES HAVE NOT CHANGED IN FORM OR FUNCTION!! DID YOU LAUGH!!
}

talk Chain_VolumeWarning2
{
	{Chain}\b[0]HOW DO I TURN THE VOLUME BACK DOWN!!
}

talk RandomTalk(p)
{
	%{ TalkTimer.RandomTalkQueue = [Chain_FaceThing]; }
	\b[2]What's this thing on my face?\_q{ColorAnchorAsChoice}
	
	\_a[OnFaceThing1,{p}]\![*] Your eyes\_a\n[half]
	\_a[OnFaceThing1,{p}]\![*] Your nose\_a\n[half]
	\_a[OnFaceThing1,{p}]\![*] Your mouth\_a
}

talk OnFaceThing1
{
	%{ TalkTimer.RandomTalkQueue = [Chain_FaceThing]; }
	%{ local p = Shiori.Reference[0]; }
	\p[{p}]\b[2]No, not that. The other thing.\_q{ColorAnchorAsChoice}
	
	\_a[OnFaceThing2,{p}]\![*] Your eyes\_a\n[half]
	\_a[OnFaceThing2,{p}]\![*] Your nose\_a\n[half]
	\_a[OnFaceThing2,{p}]\![*] Your mouth\_a
}

talk OnFaceThing2
{
	%{ TalkTimer.RandomTalkQueue.Clear(); }
	\p[{Shiori.Reference[0]}]\b[0]I don't like that name. Make a new one.
}

talk OnFaceThing2
{
	%{ TalkTimer.RandomTalkQueue.Clear(); }
	\p[{Shiori.Reference[0]}]\b[0]Oh. Ew. I want something different.
}

talk OnFaceThing2
{
	%{ TalkTimer.RandomTalkQueue.Clear(); }
	\p[{Shiori.Reference[0]}]\b[0]Are you sure? I think that's my {notface}.
}

talk OnFaceThing2
{
	%{ TalkTimer.RandomTalkQueue.Clear(); }
	\p[{Shiori.Reference[0]}]\b[0]... I knew that.
}

talk OnFaceThing2
{
	%{ TalkTimer.RandomTalkQueue.Clear(); }
	\p[{Shiori.Reference[0]}]\b[0]Nice. You should get a few for yourself.
}

talk Chain_FaceThing
{
	{Chain}\b[0]Fine, don't tell me! I was just testing you anyways. I know what all of my face things are.
}

talk RandomTalk(p)
{
	\b[2]I want to go to {thebeach}.\_q{ColorAnchorAsChoice}
	
	\_a[OnGoBeach1,{p}]\![*] That sounds nice\_a\n[half]
	\_a[OnGoBeach2,{p}]\![*] That's not a good idea\_a
}

talk OnGoBeach1
{
	\p[{Shiori.Reference[0]}]\b[0]No, I want to go now! Take me there!
}

talk OnGoBeach2
{
	\p[{Shiori.Reference[0]}]\b[0]YOU!! Just don't want to put me in the wagon. BUT I!! Have ambitions. I know what I'm about.
}

talk RandomTalk
{
	\b[0]How many snowmen are too many? 
	
	More than 12 because that's as high as I can count.
}

talk RandomTalk
{
	\b[0]How many snowmen do you need before they form an all-powerful hivemind? 
	
	{howmanyinahivemind}
}

talk RandomTalk(p)
{
	\b[2]I'm hungry.\_q{ColorAnchorAsChoice}
	
	\_a[OnHungry1,{p}]\![*] You don't have a stomach\_a\n[half]
	\_a[OnHungry2,{p}]\![*] What do you want to eat?\_a
}

talk OnHungry1
{
	\p[{Shiori.Reference[0]}]\b[0]KEEP YOUR X-RAY VISION AWAY FROM ME!!
}

talk OnHungry2
{
	\p[{Shiori.Reference[0]}]\b[0]Give me {asnowburger}.
}