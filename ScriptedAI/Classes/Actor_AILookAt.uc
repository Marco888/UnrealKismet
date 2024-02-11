Class Actor_AILookAt extends KismetInfoBase
	transient;

var PAWN_LookAt Handle;
var vector LookPos;
var Actor LookActor;
var rotator LookRotation,OriginalRotation;
var float TurnTimer;
var bool bLookDirection,bDoneTurning,bPostRotation;

replication
{
	unreliable if ( Role==ROLE_Authority )
		Handle,LookPos,LookActor,LookRotation,bLookDirection;
}

simulated function PostBeginPlay()
{
	local PlayerPawn P;
	local Actor_AILookAt A;
	
	if( Level.NetMode==NM_Client )
	{
		P = GetLocalPlayerPawn();
		OriginalRotation = P.ViewRotation;
		
		foreach AllActors(class'Actor_AILookAt',A)
		{
			if( A!=Self )
			{
				OriginalRotation = A.OriginalRotation;
				A.Destroy();
				break;
			}
		}
	}
	else
	{
		P = PlayerPawn(Owner);
		if( P && NetConnection(P.Player) )
		{
			Disable('Tick');
			LifeSpan = 1;
		}
		else if( !P )
			RemoteRole = ROLE_None;
	}
}
simulated function Tick( float Delta )
{
	local Pawn P;
	local rotator R;
	
	if( Level.NetMode==NM_Client )
		P = Level.GetLocalPlayerPawn();
	else P = Pawn(Owner);
	if( !P || P.Health<=0 || P.bDeleteMe )
		Destroy();
	else
	{
		if( bLookDirection )
			R = LookRotation;
		else if( LookActor )
			R = rotator(LookActor.Location-P.Location-vect(0,0,1)*P.EyeHeight);
		else R = rotator(LookPos-P.Location-vect(0,0,1)*P.EyeHeight);
		
		if( P.bIsPlayerPawn )
		{
			TurnTimer += Delta;
			TurnPlayer(PlayerPawn(P),R);
		}
		else TurnAI(P,R);
	}
}

simulated final function TurnPlayer( PlayerPawn P, rotator R )
{
	local float A;

	if( TurnTimer>0.25 )
	{
		if( bPostRotation )
		{
			P.ViewRotation = OriginalRotation;
			Destroy();
			return;
		}
		if( !bDoneTurning )
		{
			bDoneTurning = true;
			LifeSpan = Handle.LookDuration+0.5;
		}
		P.ViewRotation = R;
		if( TurnTimer>(Handle.LookDuration+0.25) )
		{
			if( Handle.bReturnRotation )
			{
				bPostRotation = true;
				TurnTimer = 0.f;
			}
			else Destroy();
		}
	}
	else if( bPostRotation )
	{
		A = TurnTimer*4.f;
		P.ViewRotation = LerpRotation(OriginalRotation, P.ViewRotation, A);
	}
	else
	{
		A = TurnTimer*4.f;
		P.ViewRotation = LerpRotation(R, P.ViewRotation, A);
	}
}
simulated final function TurnAI( Pawn P, rotator R )
{
	local int YDif;

	if( !bDoneTurning )
	{
		YDif = (P.Rotation.Yaw-R.Yaw) & 65535;
		if( YDif<3000 || YDif>{65535-3000} )
		{
			bDoneTurning = true;
			if( Handle.LookDuration<=0 )
				Destroy();
			else LifeSpan = Handle.LookDuration;
		}
	}
	P.DesiredRotation = R;
	P.FaceTarget = None;
	P.MoveTarget = None; // Break MoveToward because it prevents looking at the destination.
	P.Focus = P.Location+vector(R)*10000.f;
}

defaultproperties
{
	RemoteRole=ROLE_SimulatedProxy
	bSkipActorReplication=true
	bNetTemporary=true
	LifeSpan=5
	bOnlyOwnerRelevant=true
}