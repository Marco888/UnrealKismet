Class ACTOR_USERDATA extends ACTORBASE
	abstract;

var() name DataID; // Unique ID for this userdata.
var VAR_OBJECT_BASE InActor;

function ReceiveEvent( byte Index )
{
	local Actor A;
	
	if( InActor )
	{
		A = Actor(InActor.GetObject());
		if( A && !A.bDeleteMe )
			Process(A);
	}
	SendEvent(0);
}

function Process( Actor Other );

defaultproperties
{
	MenuName="User Data"
	DrawColor=(R=156,G=186,B=200)
	VarLinks.Add((Name="Actor",PropName="InActor",bInput=true))
	DataID="User"
}