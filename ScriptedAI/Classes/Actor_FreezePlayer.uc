Class Actor_FreezePlayer extends KismetInfoBase
	NoUserCreate;

var PlayerPawn PlayerOwner;
var bool bRemoteUser;
var Actor_PInteractionFreeze Interaction;

simulated function PostBeginPlay()
{
	if( Level.NetMode==NM_Client )
		PlayerOwner = GetLocalPlayerPawn();
	else
	{
		PlayerOwner = PlayerPawn(Owner);
		if( !PlayerOwner || !PlayerOwner.Player )
			Destroy();
		else bRemoteUser = bool(NetConnection(PlayerOwner.Player));
	}
}

simulated function Tick( float Delta )
{
	if( !PlayerOwner || PlayerOwner.bDeleteMe || PlayerOwner.Health<=0 )
		Destroy();
	else if( !bRemoteUser )
	{
		if( !Interaction )
			Interaction = Actor_PInteractionFreeze(PlayerOwner.AddInteraction(class'Actor_PInteractionFreeze',true));
	}
}

simulated function Destroyed()
{
	local Actor_FreezePlayer P;
	
	if( Interaction )
	{
		foreach AllActors(class'Actor_FreezePlayer',P,,,true)
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