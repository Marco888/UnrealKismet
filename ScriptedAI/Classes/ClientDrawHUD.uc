Class ClientDrawHUD extends HudOverlay
	NoUserCreate;

var bool bDelaySetup,bHasInit;
var string RepText;
var HUDElementBase Element;

replication
{
	// Relationships.
	reliable if ( Role==ROLE_Authority )
		RepText,Element;
}

simulated function PostBeginPlay()
{
	local PlayerPawn P;
	
	if( Level.NetMode==NM_DedicatedServer )
		return;

	P = Level.GetLocalPlayerPawn();

	if( Level.NetMode==NM_Client || (P==Owner && Owner!=None) )
	{
		if( P==None || P.myHUD==None )
			bDelaySetup = true;
		else
		{
			myHUD = P.myHUD;
			myHUD.Overlays[Array_Size(myHUD.Overlays)] = Self;
		}
	}
}
simulated function Tick( float Delta )
{
	local PlayerPawn P;

	if( bDelaySetup )
	{
		P = Level.GetLocalPlayerPawn();
		if( P!=None && P.myHUD!=None )
		{
			myHUD = P.myHUD;
			myHUD.Overlays[Array_Size(myHUD.Overlays)] = Self;
			bDelaySetup = false;
		}
	}
	else Disable('Tick');
}
simulated function PostRender( canvas Canvas )
{
	if( Element!=None )
	{
		Element.DrawHUDFX(Canvas,Self);
		bHasInit = true;
	}
}

defaultproperties
{
	RemoteRole=ROLE_SimulatedProxy
	bSkipActorReplication=true
}