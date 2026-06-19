talk RandomTalk
{
	%{ TalkTimer.RandomTalkQueue = [Chain_VolumeWarning1, Chain_VolumeWarning2]; }
	\b[0]HELLO!! ARE YOU THERE!! MY EYES DON'T WORK!! I NEED NEW ONES!!
}

talk Chain_VolumeWarning1
{
	\b[0]THIS IS A JOKE!! MY EYES HAVE NOT CHANGED IN FORM OR FUNCTION!! DID YOU LAUGH!!
}

talk Chain_VolumeWarning2
{
	\b[0]HOW DO I TURN THE VOLUME BACK DOWN!!
}

talk RandomTalk
{
	%{ TalkTimer.RandomTalkQueue = [Chain_FaceThing]; }
	\b[2]What's this thing on my face?
	
	\__q[OnFaceThing1]\![*] Your eyes\__q\n[half]
	\__q[OnFaceThing1]\![*] Your nose\__q\n[half]
	\__q[OnFaceThing1]\![*] Your mouth\__q
}

talk OnFaceThing1
{
	%{ TalkTimer.RandomTalkQueue = [Chain_FaceThing]; }
	\b[2]No, not that. The other thing.
	
	\__q[OnFaceThing2]\![*] Your eyes\__q\n[half]
	\__q[OnFaceThing2]\![*] Your nose\__q\n[half]
	\__q[OnFaceThing2]\![*] Your mouth\__q
}

talk OnFaceThing2
{
	%{ TalkTimer.RandomTalkQueue.Clear(); }
	\b[0]I don't like that name. Make a new one.
}

talk OnFaceThing2
{
	%{ TalkTimer.RandomTalkQueue.Clear(); }
	\b[0]Oh. Ew. I want something different.
}

talk OnFaceThing2
{
	%{ TalkTimer.RandomTalkQueue.Clear(); }
	\b[0]Are you sure? I think that's my {notface}.
}

talk OnFaceThing2
{
	%{ TalkTimer.RandomTalkQueue.Clear(); }
	\b[0]... I knew that.
}

talk OnFaceThing2
{
	%{ TalkTimer.RandomTalkQueue.Clear(); }
	\b[0]Nice. You should get a few for yourself.
}

talk Chain_FaceThing
{
	\b[0]Fine, don't tell me! I was just testing you anyways. I know what all of my face things are.
}