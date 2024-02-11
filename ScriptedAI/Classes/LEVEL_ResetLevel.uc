Class LEVEL_ResetLevel extends LEVELSBASE;

var() bool bNetworkToClient; // Have clients reset their level on client side too!

function ReceiveEvent( byte Index )
{
	local Actor A;
	
	foreach Level.AllActors(class'Actor',A)
		A.Reset();
	
	if( bNetworkToClient && (Level.NetMode==NM_ListenServer || Level.NetMode==NM_DedicatedServer) )
		Level.Spawn(class'Actor_NetReset');
}

defaultproperties
{
	MenuName="Reset level"
	Description="Soft reset the level."
	DrawColor=(R=255,G=0,B=0)
	bNetworkToClient=true

	OutputLinks.Empty()
}