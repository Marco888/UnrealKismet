Class ACTOR_SetPhysics extends ACTORBASE;

var() Actor.EPhysics Physics;

var VAR_OBJECT_BASE InActor;

function ReceiveEvent( byte Index )
{
	local int i,l;

	if( InActor==None )
		Warn("No input actor?");
	else if( InActor.bIsArray )
	{
		l = InActor.GetArraySize();
		for( i=0; i<l; ++i )
			SetPhysics(Actor(InActor.GetObjectAt(i)));
	}
	else SetPhysics(Actor(InActor.GetObject()));
	SendEvent(0);
}

final function SetPhysics( Actor A )
{
	if( A!=None )
		A.SetPhysics(Physics);
}

defaultproperties
{
	MenuName="Set Physics"
	Description="Change actor movement physics"
	DrawColor=(R=200,G=150,B=85)

	VarLinks.Add((Name="Actor",PropName="InActor",bInput=true))
}