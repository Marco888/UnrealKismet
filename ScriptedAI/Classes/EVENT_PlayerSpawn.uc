Class EVENT_PlayerSpawn extends EVENTBASE;

var EVENT_PlayerSpawn NextCallback;

var SVariableBase OutPlayer;

var Actor_GameRules Listen;

var() bool bSkipSpectators; // Skip any spectators that spawn in

function BeginPlay()
{
	Listen = class'Actor_GameRules'.Static.GetRules(Level);
	if( Listen!=None )
	{
		NextCallback = Listen.SpawnCallback;
		Listen.SpawnCallback = Self;
		Listen.bNotifySpawnPoint = true;
	}
}

function NotifyPlayer( Pawn Other )
{
	if( !bSkipSpectators || Spectator(Other)==None )
	{
		if( OutPlayer!=None )
			OutPlayer.SetObject(Other);
		SendEvent(0);
	}
}

defaultproperties
{
	MenuName="Player spawned"
	Description="Triggered when a player spawns."
	DrawColor=(R=25,G=211,B=225)
	bSkipSpectators=true
	bRequestBeginPlay=true
	
	VarLinks.Add((Name="Player",PropName="OutPlayer",bOutput=true))
}