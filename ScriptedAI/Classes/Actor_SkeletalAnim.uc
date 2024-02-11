Class Actor_SkeletalAnim extends Effects
	transient;

var ACTOR_SkelPlayAnim Handle;

replication
{
	reliable if ( Role==ROLE_Authority )
		Handle;
}

simulated function PostNetBeginPlay()
{
	if( Handle && Owner )
		Handle.PlayChanAnim(Owner);
}
simulated final function bool Matches( name BoneName )
{
	return (!Handle || Handle.BoneName==BoneName);
}

defaultproperties
{
	bNetTemporary=True
	DrawType=DT_None
	RemoteRole=ROLE_SimulatedProxy
	LifeSpan=1
	bSkipActorReplication=true
	bRepAnimations=false
	bRepMesh=false
	bCarriedItem=true
}