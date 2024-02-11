Class Actor_NetReset extends KismetInfoBase
	transient;

simulated function PostBeginPlay()
{
	local Actor A;
	
	if( Level.NetMode==NM_Client )
	{
		foreach Level.AllActors(class'Actor',A)
			A.Reset();
	}
}

defaultproperties
{
	RemoteRole=ROLE_SimulatedProxy
	bSkipActorReplication=true
	LifeSpan=1
	bNetTemporary=true
}