Class Actor_SkeletalLipSync extends Effects
	transient;

var ACTOR_SkelLipSync Handle;
var Sound SoundFX;

replication
{
	reliable if ( Role==ROLE_Authority )
		Handle,SoundFX;
}

simulated function PostNetBeginPlay()
{
	if( Handle && Owner && SoundFX )
		Handle.StartLipSync(SoundFX,Owner);
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