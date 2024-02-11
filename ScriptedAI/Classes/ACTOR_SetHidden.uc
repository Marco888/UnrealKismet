Class ACTOR_SetHidden extends ACTORBASE;

var VAR_OBJECT_BASE InActor;

function ReceiveEvent( byte Index )
{
	local int i,l;
	local Actor A;

	if( InActor==None )
		Warn("No input actor?");
	else if( InActor.bIsArray )
	{
		l = InActor.GetArraySize();
		for( i=0; i<l; ++i )
		{
			A = Actor(InActor.GetObjectAt(i));
			if( A!=None )
				A.bHidden = (Index==0);
		}
	}
	else
	{
		A = Actor(InActor.GetObject());
		if( A!=None )
			A.bHidden = (Index==0);
	}
	SendEvent(0);
}

defaultproperties
{
	MenuName="Set Hidden"
	Description="Toggle actor hidden"
	DrawColor=(R=64,G=8,B=128)
	
	InputLinks(0)="Hide"
	InputLinks(1)="UnHide"

	VarLinks.Add((Name="Actor",PropName="InActor",bInput=true))
}