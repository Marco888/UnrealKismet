Class ACTOR_SkelPlayAnim extends SKELBASE;

var() name BoneName; // Bone to start from.
var() name AnimationSequence; // Animation to play, if None it will stop animation at this bone.
var() float TweenInTime,TweenOutTime; // Tween time.
var() float AnimRate; // Animation rate.
var() bool bLoopAnim; // Should loop the animation.
var() bool bNetworkToClient; // Should perform this action locally only or network to all clients?

var VAR_OBJECT_BASE InActor;

function ReceiveEvent( byte Index )
{
	local int i,l;

	if( !InActor )
		Warn("No input actor?");
	else
	{
		l = InActor.GetArraySize();
		for( i=0; i<l; ++i )
			PlayChanAnim(Actor(InActor.GetObjectAt(i)));
	}
	SendEvent(0);
}

simulated function PlayChanAnim( Actor A )
{
	local int i;
	local Actor_SkeletalAnim Sk;
	
	if( !A || A.bDeleteMe || (A.bIsPawn && Pawn(A).Health<=0) )
		return;
	
	if( Level.NetMode!=NM_DedicatedServer )
	{
		i = A.GetBoneIndex(string(BoneName));
		if( i>=0 )
		{
			if( AnimationSequence=='' )
				A.StopSkelAnim(i,TweenOutTime);
			else A.SkelPlayAnim(i,AnimationSequence,AnimRate,TweenInTime,bLoopAnim,TweenOutTime);
		}
	}
	if( bNetworkToClient && Level.NetMode!=NM_Client && (Level.NetMode!=NM_StandAlone || Level.bIsDemoRecording) )
	{
		// Make sure they don't overlap if many start rapidly.
		foreach A.ChildActors(Class'Actor_SkeletalAnim',Sk)
		{
			if( Sk.Matches(BoneName) )
				Sk.Destroy();
		}
		
		Sk = A.Spawn(class'Actor_SkeletalAnim',A);
		Sk.Handle = Self;
	}
}

defaultproperties
{
	MenuName="Play Bone Anim"
	Description="Play an animation from a bone tree."
	DrawColor=(R=38,G=128,B=128)
	
	TweenInTime=0.1
	TweenOutTime=0.1
	AnimRate=1
	bNetworkToClient=true

	VarLinks.Add((Name="Actor",PropName="InActor",bInput=true))
}