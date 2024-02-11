Class ACTOR_USER_SetObj extends ACTOR_USERDATA;

var() Object Value;
var SVariableBase InValue;

function Process( Actor Other )
{
	if( InValue!=None )
		Value = InValue.GetObject();
	Other.UserData[DataID].SetObject(Value);
}

defaultproperties
{
	MenuName="Set Object"
	VarLinks.Add((Name="Value",PropName="InValue",bInput=true))
	bContainsActorRef=true
}