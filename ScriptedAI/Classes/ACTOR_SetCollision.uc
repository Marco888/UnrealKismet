Class ACTOR_SetCollision extends ACTORBASE;

var() bool bBlockActors;
var() bool bBlockPlayers;
var() bool bProjTarget;
var() bool bCollideActors;

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
			SetCollision(Actor(InActor.GetObjectAt(i)));
	}
	else SetCollision(Actor(InActor.GetObject()));
	SendEvent(0);
}

final function SetCollision( Actor A )
{
	if( A!=None )
	{
		A.SetCollision(bCollideActors,bBlockActors,bBlockPlayers);
		A.bProjTarget = bProjTarget;
	}
}

defaultproperties
{
	MenuName="Set Collision"
	Description="Change actor collision state"
	DrawColor=(R=200,G=150,B=25)

	VarLinks.Add((Name="Actor",PropName="InActor",bInput=true))
}