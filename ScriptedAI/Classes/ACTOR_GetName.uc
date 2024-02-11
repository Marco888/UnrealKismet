Class ACTOR_GetName extends ACTORBASE;

var SVariableBase InActor,OutName;

function ReceiveEvent( byte Index )
{
	local Actor A;

	if( InActor==None )
		Warn("Grab name of none input actor?");
	else if( OutName==None )
		Warn("Grab name of actor but output it to nowhere?");
	else
	{
		A = Actor(InActor.GetObject());
		if( A!=None )
			OutName.SetValue(A.GetHumanName());
		else OutName.SetValue("None");
	}
	SendEvent(0);
}

defaultproperties
{
	MenuName="Get Name"
	Description="Grab the actor name"
	bClientAction=true
	DrawColor=(R=64,G=250,B=66)

	VarLinks.Add((Name="Actor",PropName="InActor",bInput=true))
	VarLinks.Add((Name="Output",PropName="OutName",bOutput=true))
}