Class Actor_ViewInterpolate extends KismetInfoBase
	NoUserCreate;

var PAWN_SetViewTarget Action;
var Actor ViewTarget;
var PlayerPawn PlayerOwner;

var vector SourcePos;
var rotator SourceRot,StartRot;

var float IPTime;

replication
{
	unreliable if ( Role==ROLE_Authority )
		Action,ViewTarget;
}

simulated function PostBeginPlay()
{
	if( Level.NetMode==NM_Client )
		PlayerOwner = GetLocalPlayerPawn();
	else
	{
		PlayerOwner = PlayerPawn(Owner);
		if( !PlayerOwner || !PlayerOwner.Player )
		{
			Destroy();
			return;
		}
	}
	PlayerOwner.ViewTarget = Self;
	PlayerOwner.bBehindView = false;
	SourcePos = PlayerOwner.CalcCameraLocation;
	SourceRot = PlayerOwner.CalcCameraRotation;
	StartRot = PlayerOwner.ViewRotation;
}

function SetViewTarget( PAWN_SetViewTarget A, Actor Other )
{
	Action = A;
	LifeSpan = FMax(A.InterpolationTime,0.001f);
	if( !Other )
		Other = PlayerOwner;
	ViewTarget = Other;
	if( !Viewport(PlayerOwner.Player) ) // Just instantly network from viewtarget POV.
		SetLocation(Other.Location);
	bForceNetUpdate = true;
}

function OwnerChanged()
{
	if( !Owner )
		Destroy();
}

function Expired()
{
	if( ViewTarget==PlayerOwner )
		PlayerOwner.ViewTarget = None;
	else PlayerOwner.ViewTarget = ViewTarget;
}

simulated event SetInitialState()
{
	if( !PlayerOwner || !Viewport(PlayerOwner.Player) ) // Do not tick for network client serverside.
		Disable('Tick');
}

simulated function Tick( float Delta )
{
	if( !Action || !ViewTarget )
		return;

	IPTime+=Delta;
	if( IPTime>=Action.InterpolationTime )
	{
		if( ViewTarget==PlayerOwner )
			PlayerOwner.ViewTarget = None;
		else
		{
			SetLocation(ViewTarget.Location);
			SetRotation(ViewTarget.Rotation);
		}
		return;
	}
	SetInterpolation(IPTime/Action.InterpolationTime);
}

simulated final function SetInterpolation( float Alpha )
{
	local vector TargetPos;
	local rotator TargetRot;
	
	if( ViewTarget==PlayerOwner )
	{
		TargetPos = PlayerOwner.Location+vect(0,0,1)*PlayerOwner.EyeHeight;
		PlayerOwner.ViewRotation = StartRot;
		TargetRot = StartRot;
	}
	else
	{
		TargetPos = ViewTarget.Location;
		TargetRot = ViewTarget.Rotation;
	}
	if( Action.bSplineInterpolation )
		Alpha = Smerp(Alpha,0.f,1.f);
	
	SetLocation(LerpVector(TargetPos,SourcePos,Alpha));
	SetRotation(SlerpRotation(TargetRot,SourceRot,Alpha));
}

defaultproperties
{
	bOnlyOwnerRelevant=true
	RemoteRole=ROLE_SimulatedProxy
	bOnlyDirtyReplication=true
	NetUpdateFrequency=5
	bSkipActorReplication=true
}