Class PAWN_LockMovement extends PAWNBASE;

var VAR_OBJECT_BASE InPlayer;

function ReceiveEvent( byte Index )
{
	local int i,l;
	local PlayerPawn P;
	local Actor_FreezePlayer PC;

	if( !InPlayer )
		Warn("No input player?");
	else
	{
		l = InPlayer.GetArraySize();
		for( i=0; i<l; ++i )
		{
			P = PlayerPawn(InPlayer.GetObjectAt(i));
			if( P && P.Health>0 )
			{
				if( Index==0 )
				{
					foreach P.ChildActors(class'Actor_FreezePlayer',PC)
						break;
					if( !PC )
						Level.Spawn(class'Actor_FreezePlayer',P);
				}
				else
				{
					foreach P.ChildActors(class'Actor_FreezePlayer',PC)
						PC.Destroy();
				}
			}
		}
	}
	SendEvent(0);
}

defaultproperties
{
	MenuName="Lock Movement"
	Description="Freeze player movement until unlocked."
	DrawColor=(R=200,G=64,B=32)

	VarLinks.Add((Name="Player",PropName="InPlayer",bInput=true))
	
	InputLinks(0)="Lock"
	InputLinks(1)="Unlock"
}