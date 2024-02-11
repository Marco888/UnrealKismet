Class ACTOR_USER_GetStr extends ACTOR_USERDATA;

var() string DefValue; // If value not found, use this instead.
var SVariableBase OutValue;

function Process( Actor Other )
{
	local any A;
	
	if( OutValue==None )
		return;

	if( Other.UserData.Has(DataID,A) && A.IsType(String) )
		OutValue.SetValue(A.GetString());
	else OutValue.SetValue(DefValue);
}

defaultproperties
{
	MenuName="Get String"
	VarLinks.Add((Name="Value",PropName="OutValue",bOutput=true))
}