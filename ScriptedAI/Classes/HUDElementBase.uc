Class HUDElementBase extends ACTIONSBASE
	abstract;

var VAR_OBJECT_BASE InActor;

function ReceiveEvent( byte Index )
{
	local int i,l;
	local ClientDrawHUD C;
	local PlayerPawn PP;

	if( InActor==None )
		Warn("No input actor?");
	else
	{
		l = InActor.GetArraySize();
		for( i=0; i<l; ++i )
		{
			PP = PlayerPawn(InActor.GetObjectAt(i));
			if( PP!=None && PP.Player!=None )
			{
				// Only allow one of these actors per player.
				foreach PP.ChildActors(class'ClientDrawHUD',C)
					if( C.Element==Self )
					{
						C.Destroy();
						break;
					}

				if( Index==0 )
				{
					C = Level.Spawn(class'ClientDrawHUD',PP);
					C.Element = Self;
					InitReplication(C);
				}
			}
		}
	}
	SendEvent(0);
}

function InitReplication( ClientDrawHUD Other );

simulated function DrawHUDFX( Canvas C, ClientDrawHUD Other );

function Reset()
{
	local ClientDrawHUD C;

	foreach Level.AllActors(class'ClientDrawHUD',C)
		if( C.Element==Self )
			C.Destroy();
}

defaultproperties
{
	MenuName="HUD"
	DrawColor=(R=200,G=200,B=32)
	bClientAction=true

	InputLinks(0)="Show"
	InputLinks(1)="Hide"
	VarLinks.Add((Name="Player",PropName="InActor",bInput=true))
}