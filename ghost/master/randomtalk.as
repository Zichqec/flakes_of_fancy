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