Class ACTOR_SkelHeadTurn extends SKELBASE;

var() float HeadTurnDuration; // For how long should the head turn at actor (0 = infinite)
var() bool bNetworkToClient; // Should perform this action locally only or network to all clients?

var VAR_OBJECT_BASE InActor,InLookTarget;

function ReceiveEvent( byte Index )
{
	local int i,l;
	local Actor A;

	if( !InActor )
		Warn("No input actor?");
	else
	{
		if( InLookTarget )
			A = Actor(InLookTarget.GetObject());

		l = InActor.GetArraySize();
		for( i=0; i<l; ++i )
			StartHeadTurn(A, Actor(InActor.GetObjectAt(i)));
	}
	SendEvent(0);
}

function StartHeadTurn( Actor LookAt, Actor A )
{
	local IK_HeadTurn H;
	local Actor_SkeletalHead Sk;
	
	if( !A || A.bDeleteMe || (A.bIsPawn && Pawn(A).Health<=0) )
		return;
	
	if( Level.NetMode!=NM_DedicatedServer )
	{
		H = IK_HeadTurn(A.GetIKSolver(Class'IK_HeadTurn'));
		if( !H )
			return; // Do not spawn handle if no IK solver present on this mesh.
	}
	
	// Make sure they don't overlap if many start rapidly.
	foreach A.ChildActors(Class'Actor_SkeletalHead',Sk)
		Sk.Destroy();

	if( !LookAt || LookAt.bDeleteMe )
		return;
	Sk = A.Spawn(class'Actor_SkeletalHead',A);
	Sk.LookTarget = LookAt;
	Sk.LifeSpan = HeadTurnDuration;
	if( !bNetworkToClient )
		Sk.RemoteRole = ROLE_None;
}

defaultproperties
{
	MenuName="Head turn"
	Description="Play a lipsync animation on an actor."
	DrawColor=(R=128,G=200,B=68)
	
	bNetworkToClient=true

	VarLinks.Add((Name="Actor",PropName="InActor",bInput=true))
	VarLinks.Add((Name="LookTarget",PropName="InLookTarget",bInput=true))
}