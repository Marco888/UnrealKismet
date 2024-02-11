Class Actor_SkeletalHead extends Effects
	transient;

var Actor LookSrc,LookTarget;

replication
{
	reliable if ( Role==ROLE_Authority )
		LookSrc,LookTarget;
}

function BeginPlay()
{
	LookSrc = Owner;
}
simulated function Tick( float Delta )
{
	local IK_HeadTurn H;
	
	if( !LookSrc || LookSrc.bDeleteMe || (LookSrc.bIsPawn && Pawn(LookSrc).Health<=0) || !LookTarget || LookTarget.bDeleteMe )
	{
		Destroy();
		return;
	}
	if( Level.NetMode==NM_DedicatedServer )
		return;
	H = IK_HeadTurn(LookSrc.GetIKSolver(Class'IK_HeadTurn'));
	if( H )
	{
		H.ViewPosition = LookTarget.Location;
		if( !H.bEnabled )
			H.SetEnabled(true,0.25f);
	}
}
simulated function Destroyed()
{
	local IK_HeadTurn H;
	
	if( LookSrc && !LookSrc.bDeleteMe && Level.NetMode!=NM_DedicatedServer )
	{
		H = IK_HeadTurn(LookSrc.GetIKSolver(Class'IK_HeadTurn'));
		if( H && H.bEnabled )
			H.SetEnabled(false,0.25f);
			
	}
}

defaultproperties
{
	bNetTemporary=False
	DrawType=DT_None
	RemoteRole=ROLE_SimulatedProxy
	bSkipActorReplication=true
	bRepAnimations=false
	bRepMesh=false
	bCarriedItem=true
	Physics=PHYS_Trailer
}