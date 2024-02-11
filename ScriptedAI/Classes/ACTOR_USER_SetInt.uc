Class ACTOR_USER_SetInt extends ACTOR_USERDATA;

var() int Value;
var SVariableBase InValue;

function Process( Actor Other )
{
	if( InValue!=None )
		Value = InValue.GetInt();
	Other.UserData[DataID].SetInt(Value);
}

defaultproperties
{
	MenuName="Set Int"
	VarLinks.Add((Name="Value",PropName="InValue",bInput=true))
}