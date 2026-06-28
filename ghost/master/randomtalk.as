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
	\b[2]What's this thing on my face?\_q{ColorAnchorAsChoice}{Choices}{ResetBalloonTimeout}
	
	\_a[OnFaceThing1,{p}]\![*] Your eyes\_a\n[half]
	\_a[OnFaceThing1,{p}]\![*] Your nose\_a\n[half]
	\_a[OnFaceThing1,{p}]\![*] Your mouth\_a
}

talk OnFaceThing1
{
	%{ TalkTimer.RandomTalkQueue = [Chain_FaceThing]; }
	%{ local p = Shiori.Reference[0]; }
	\p[{p}]\b[2]No, not that. The other thing.\_q{ColorAnchorAsChoice}{Choices}{ResetBalloonTimeout}
	
	\_a[OnFaceThing2,{p}]\![*] Your eyes\_a\n[half]
	\_a[OnFaceThing2,{p}]\![*] Your nose\_a\n[half]
	\_a[OnFaceThing2,{p}]\![*] Your mouth\_a
}

talk OnFaceThing2
{
	%{ TalkTimer.RandomTalkQueue.Clear(); }{ResetBalloonTimeout}
	\p[{Shiori.Reference[0]}]\b[0]I don't like that name. Make a new one.
}

talk OnFaceThing2
{
	%{ TalkTimer.RandomTalkQueue.Clear(); }{ResetBalloonTimeout}
	\p[{Shiori.Reference[0]}]\b[0]Oh. Ew. I want something different.
}

talk OnFaceThing2
{
	%{ TalkTimer.RandomTalkQueue.Clear(); }{ResetBalloonTimeout}
	\p[{Shiori.Reference[0]}]\b[0]Are you sure? I think that's my {notface}.
}

talk OnFaceThing2
{
	%{ TalkTimer.RandomTalkQueue.Clear(); }{ResetBalloonTimeout}
	\p[{Shiori.Reference[0]}]\b[0]... I knew that.
}

talk OnFaceThing2
{
	%{ TalkTimer.RandomTalkQueue.Clear(); }{ResetBalloonTimeout}
	\p[{Shiori.Reference[0]}]\b[0]Nice. You should get a few for yourself.
}

talk Chain_FaceThing
{
	{Chain}\b[0]Fine, don't tell me! I was just testing you anyways. I know what all of my face things are.
}

talk RandomTalk(p)
{
	\b[2]I want to go to {thebeach}.\_q{ColorAnchorAsChoice}{Choices}{ResetBalloonTimeout}
	
	\_a[OnGoBeach1,{p}]\![*] That sounds nice\_a\n[half]
	\_a[OnGoBeach2,{p}]\![*] That's not a good idea\_a
}

talk OnGoBeach1
{
	\p[{Shiori.Reference[0]}]\b[0]No, I want to go now! Take me there!{ResetBalloonTimeout}
}

talk OnGoBeach2
{
	\p[{Shiori.Reference[0]}]\b[0]YOU!! Just don't want to put me in the wagon. BUT I!! Have ambitions. I know what I'm about.{ResetBalloonTimeout}
}

talk RandomTalk(p)
{
	\b[2]How many snowmen are too many?
	
	More than 12 because that's as high as I can count.
}

talk RandomTalk(p)
{
	\b[2]How many snowmen do you need before they form an all-powerful hivemind?
	
	{howmanyinahivemind}
}

talk RandomTalk(p)
{
	\b[2]I'm hungry.\_q{ColorAnchorAsChoice}{Choices}{ResetBalloonTimeout}
	
	\_a[OnHungry1,{p}]\![*] You don't have a stomach\_a\n[half]
	\_a[OnHungry2,{p}]\![*] What do you want to eat?\_a
}

talk OnHungry1
{
	\p[{Shiori.Reference[0]}]\b[0]KEEP YOUR X-RAY VISION AWAY FROM ME!!{ResetBalloonTimeout}
}

talk OnHungry2
{
	\p[{Shiori.Reference[0]}]\b[0]Give me {asnowburger}.{ResetBalloonTimeout}
}

talk RandomTalk(p)
{
	\b[0]Bring me inside. I'm freezing out here.
}

talk RandomTalk(p)
{
	\b[2]Are {carrots} a type of {vegetable}?\_q{ColorAnchorAsChoice}{Choices}{ResetBalloonTimeout}
	
	\_a[OnCarrotVegetable1,{p}]\![*] Yes\_a\n[half]
	\_a[OnCarrotVegetable2,{p}]\![*] No\_a\n[half]
	\_a[OnCarrotVegetable3,{p}]\![*] Sort of\_a
}

talk OnCarrotVegetable1
{
	\p[{Shiori.Reference[0]}]\b[0]Wow. What a world we live in.{ResetBalloonTimeout}
}

talk OnCarrotVegetable1
{
	\p[{Shiori.Reference[0]}]\b[0]Ew! They should rethink that.{ResetBalloonTimeout}
}

talk OnCarrotVegetable1
{
	\p[{Shiori.Reference[0]}]\b[0]Yeah, I could tell. It's instinctual how good I am.{ResetBalloonTimeout}
}

talk OnCarrotVegetable2
{
	\p[{Shiori.Reference[0]}]\b[0]What are you, some kind of expert?{ResetBalloonTimeout}
}

talk OnCarrotVegetable2
{
	\p[{Shiori.Reference[0]}]\b[0]That's probably for the best. Imagine the {social} ramifications...{ResetBalloonTimeout}
}

talk OnCarrotVegetable2
{
	\p[{Shiori.Reference[0]}]\b[0]AH!! WHEN DID YOU GET HERE!!{ResetBalloonTimeout}
}

talk OnCarrotVegetable3
{
	\p[{Shiori.Reference[0]}]\b[0]WHAT DOES THAT EVEN MEAN!!{ResetBalloonTimeout}
}

talk OnCarrotVegetable3
{
	\p[{Shiori.Reference[0]}]\b[0]We gotta get scientists on this. The world needs answers.{ResetBalloonTimeout}
}

talk OnCarrotVegetable3
{
	\p[{Shiori.Reference[0]}]\b[0]Wait, but it was a yes or no question?{ResetBalloonTimeout}
}

talk RandomTalk(p)
{
	%{ TalkTimer.RandomTalkQueue = [Chain_FavoriteColor]; }
	\b[0]I'd tell you my favorite color, but it's one you can only see if you have snow for brains.
}

talk Chain_FavoriteColor
{
	{Chain}\b[0]It's called {snorange}. You wouldn't get it.
}

talk RandomTalk(p)
{
	\b[0]I can't wait to see {summer}.
}

talk RandomTalk(p)
{
	\b[2]Have you ever wondered what it would be like if it suddenly started raining {fingersandtoes}?
	
	Yeah, well, I'm a snowman in the snow.
}

talk RandomTalk(p)
{
	\b[0]HELP!! I CAN'T FIND MY TOES!!
}

talk RandomTalk(p)
{
	\b[0]Next time you build me, I want to be {taller}. DON'T FORGET!!
}

talk RandomTalk(p)
{
	\b[0]I've really got a handle on this {standing} thing.
}

talk RandomTalk(p)
{
	\b[0]I think I caught a cold.
}

talk RandomTalk(p)
{
	%{ TalkTimer.RandomTalkQueue = [Chain_GoSleep1, Chain_GoSleep2, Chain_GoSleep3, Chain_GoSleep4, Chain_GoSleep5]; }
	\b[0]Going to sleep now. Do not disturb.
}

talk Chain_GoSleep1
{
	{Chain}\b[0]Honk shoo.
}

talk Chain_GoSleep2
{
	{Chain}\b[0]Mimimimimi.
}

talk Chain_GoSleep3
{
	{Chain}\b[0]Z z z
}

talk Chain_GoSleep4
{
	{Chain}\b[0]SNURK!!
}

talk Chain_GoSleep5
{
	{Chain}\b[0]OK I'm awake now.
}
talk RandomTalk(p)
{
	\b[0]Where does snow come from anyway...
}

talk RandomTalk(p)
{
	\b[2]Shh I'm counting snowflakes.
	
	1... 2... 3... 4... 5... 6... 7... 8... 9... 10... 11... 12...
	
	... Yep, that's all of them.
}

talk RandomTalk(p)
{
	\b[0]Sometimes I wonder if I have a doppelganger out there, plotting against me.
}

talk RandomTalk(p)
{
	\b[0]Where does the snowman end and the snowdrifts begin?
}

talk SnowDozenTalk
{
	TODO
}