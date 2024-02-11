Class ACTOR_USER_GetFloat extends ACTOR_USERDATA;

var() float DefValue; // If value not found, use this instead.
var SVariableBase OutValue;

function Process( Actor Other )
{
	local any A;
	
	if( OutValue==None )
		return;

	if( Other.UserData.Has(DataID,A) && A.IsType(Float) )
		OutValue.SetFloat(A.GetFloat());
	else OutValue.SetFloat(DefValue);
}

defaultproperties
{
	MenuName="Get Float"
	VarLinks.Add((Name="Value",PropName="OutValue",bOutput=true))
}