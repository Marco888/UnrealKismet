Class ACTOR_Destroy extends ACTORBASE;

var VAR_OBJECT_BASE InActor;

function ReceiveEvent( byte Index )
{
	local Actor A;
	local int i,l;

	if( InActor==None )
		Warn("Ran destroy actor, but no input actor?");
	else if( InActor.bIsArray )
	{
		l = InActor.GetArraySize();
		for( i=0; i<l; ++i )
		{
			A = Actor(InActor.GetObjectAt(i));
			if( A!=None )
			{
				if( PlayerPawn(A)!=None )
					Pawn(A).KilledBy(None);
				else A.Destroy();
			}
		}
	}
	else
	{
		A = Actor(InActor.GetObject());
		if( A!=None )
		{
			if( PlayerPawn(A)!=None )
				Pawn(A).KilledBy(None);
			else A.Destroy();
		}
	}
	SendEvent(0);
}

defaultproperties
{
	MenuName="Destroy Actor"
	Description="Instantly destroy an actor"
	bClientAction=true
	DrawColor=(R=128,G=2,B=2)

	VarLinks.Add((Name="Actor",PropName="InActor",bInput=true))
}