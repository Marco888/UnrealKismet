Class ScriptedAI extends Keypoint
	NoUserCreate;

#exec Texture Import File=Textures/S_AIScript.pcx Name=S_AIScript Mips=Off

var export array<SObjectBase> Actions;
var SActionBase TickList;
var SObjectBase BeginPlayList; // BeginPlay list is setup in editor by C++ codes.

// Editor:
struct GroupBoxInfo
{
	var string GroupInfo;
	var int Location[2],Size[2];
};
var float WinPos[2],WinZoom;
var const array<GroupBoxInfo> GroupsInfo;
var transient bool bInit;
var() bool bLogMessages; // Dump to log events.

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
	Role = ROLE_Authority; // Make it client authority.
	SetupDestroyNotify();
}

simulated function BeginPlay()
{
	local SObjectBase S;

	Disable('Tick');
	for( S=BeginPlayList; S; S=S.NextBeginPlay )
		S.BeginPlay();
}

simulated function PostBeginPlay()
{
	local SObjectBase S;

	for( S=BeginPlayList; S; S=S.NextBeginPlay )
		if( S.bReqPostBeginPlay )
			S.PostBeginPlay();
}

simulated function Tick( float Delta )
{
	local SActionBase S;
	
	if( TickList==None )
	{
		Disable('Tick');
		return;
	}
	for( S=TickList; S; S=S.NextTimed )
		S.Tick(Delta);
}

simulated function Reset()
{
	local SActionBase S,N;
	local SObjectBase O;

	if( TickList!=None ) // Disable all ticking events (if event needs ticking, it should restart on reset event).
	{
		Disable('Tick');
		for( S=TickList; S; S=N )
		{
			N = S.NextTimed;
			S.NextTimed = None;
			S.bTickEnabled = false;
		}
		TickList = None;
	}
	
	foreach Actions(O)
		O.Reset();

	if( bStatic )
		PostBeginPlay();
	else SetTimer(0.001,false,'PostBeginPlay');
}

event PostLoadGame()
{
	local SObjectBase S;

	SetupDestroyNotify();
	for( S=BeginPlayList; S; S=S.NextBeginPlay )
		S.PostLoadGame();
}

simulated final function SetupDestroyNotify()
{
	local SObjectBase S;
	
	foreach Actions(S)
		if( S.bContainsActorRef )
			Level.CleanupDestroyedNotify.Add(S);
}

defaultproperties
{
	bStatic=true
	bNoDelete=true
	RemoteRole=ROLE_None
	Texture=Texture'S_AIScript'
	DrawScale=0.2
	WinZoom=1.0
}