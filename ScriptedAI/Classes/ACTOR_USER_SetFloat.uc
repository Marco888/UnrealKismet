Class ACTOR_USER_SetFloat extends ACTOR_USERDATA;

var() float Value;
var SVariableBase InValue;

function Process( Actor Other )
{
	if( InValue!=None )
		Value = InValue.GetFloat();
	Other.UserData[DataID].SetFloat(Value);
}

defaultproperties
{
	MenuName="Set Float"
	VarLinks.Add((Name="Value",PropName="InValue",bInput=true))
}