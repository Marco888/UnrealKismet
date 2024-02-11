Class ACTOR_USER_SetStr extends ACTOR_USERDATA;

var() string Value;
var SVariableBase InValue;

function Process( Actor Other )
{
	if( InValue!=None )
		Value = InValue.GetValue();
	Other.UserData[DataID].SetString(Value);
}

defaultproperties
{
	MenuName="Set String"
	VarLinks.Add((Name="Value",PropName="InValue",bInput=true))
}