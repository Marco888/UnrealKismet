Class Actor_PlayerController extends KismetInfoBase
	NoUserCreate;

var int NumTries;
var PlayerPawn PlayerOwner;
var Actor Goal;
var LATENT_MoveToActor Callback;
var float MoveTimer;
var bool bWalk,bRemoteUser;

var vector RepMoveTarget;
var Actor_PInteraction Interaction;

replication
{
	// Variables the server should send to the client.
	reliable if ( Role==ROLE_Authority )
		RepMoveTarget,bWalk;
}

simulated function PostBeginPlay()
{
	if( Level.NetMode==NM_Client )
		PlayerOwner = GetLocalPlayerPawn();
	else
	{
		PlayerOwner = PlayerPawn(Owner);
		if( !PlayerOwner || !PlayerOwner.Player )
			Destroy();
		else
		{
			bRemoteUser = bool(NetConnection(PlayerOwner.Player));
			RepMoveTarget = PlayerOwner.Location;
		}
	}
}

simulated function Tick( float Delta )
{
	if( !PlayerOwner || PlayerOwner.bDeleteMe || PlayerOwner.Health<=0 || (Level.NetMode!=NM_Client && (!Goal || Goal.bDeleteMe)) )
	{
		Destroy();
		return;
	}
	if( Level.NetMode!=NM_Client )
	{
		if( Target )
		{
			if( VSize2DSq(Target.Location-PlayerOwner.Location)<Square(50.f) )
			{
				if( Target==Goal )
				{
					FinishedMove(0);
					return;
				}
				Target = None;
			}
			else if( MoveTimer<Level.TimeSeconds )
			{
				if( --NumTries<0 )
				{
					FinishedMove(1);
					return;
				}
				Target = None;
			}
			else if( VSizeSq(RepMoveTarget-Target.Location)>1.f )
				RepMoveTarget = Target.Location;
		}
		if( !Target )
		{
			if( PlayerOwner.ActorReachable(Goal) )
			{
				Target = Goal;
				MoveTimer = Level.TimeSeconds + (VSize2D(Goal.Location-PlayerOwner.Location) / {Human.GroundSpeed * 0.25}) + 1.f;
			}
			else
			{
				Target = PlayerOwner.FindPathToward(Goal);
				if( !Target )
				{
					if( --NumTries<0 )
					{
						FinishedMove(1);
						return;
					}
					return;
				}
				MoveTimer = Level.TimeSeconds + (VSize2D(Target.Location-PlayerOwner.Location) / {Human.GroundSpeed * 0.25}) + 1.f;
			}
			if( Target )
				RepMoveTarget = Target.Location;
		}
	}
	if( !bRemoteUser )
	{
		if( !Interaction )
			Interaction = Actor_PInteraction(PlayerOwner.AddInteraction(class'Actor_PInteraction',true));

		if( VSize2DSq(RepMoveTarget-PlayerOwner.Location)<Square(45.f) )
			Interaction.bRequestForward = false;
		else
		{
			Interaction.bRequestForward = RotateCamera(Delta);
			Interaction.bWalkMove = bWalk;
		}
	}
}

simulated final function bool RotateCamera( float Delta )
{
	local rotator R;
	local int yDiff;
	
	R = rotator(RepMoveTarget-PlayerOwner.Location);
	if( Abs(PlayerOwner.Location.Z-RepMoveTarget.Z)<35.f )
		R.Pitch = 0;
	PlayerOwner.ViewRotation = LerpRotation(R, PlayerOwner.ViewRotation, Delta*25.f);
	yDiff = (PlayerOwner.ViewRotation.Yaw-R.Yaw) & 65535;
	return (yDiff<6000 || yDiff>{65535-6000});
}

final function FinishedMove( byte Result )
{
	Destroy();
	if( Callback.OutActor )
		Callback.OutActor.SetObject(PlayerOwner);
	Callback.SendEvent(Result);
}

simulated function Destroyed()
{
	local Actor_PlayerController P;
	
	if( Interaction )
	{
		foreach AllActors(class'Actor_PlayerController',P,,,true)
			if( P!=Self && P.Interaction==Interaction )
			{
				Interaction = None;
				return;
			}
		PlayerOwner.bRun = 0;
		PlayerOwner.RemoveInteraction(Interaction);
		delete Interaction;
		Interaction = None;
	}
}

defaultproperties
{
	RemoteRole=ROLE_SimulatedProxy
	bSkipActorReplication=true
	bOnlyOwnerRelevant=true
}