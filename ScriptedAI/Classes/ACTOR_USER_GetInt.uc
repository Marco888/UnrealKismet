Class ACTOR_USER_GetInt extends ACTOR_USERDATA;

var() int DefValue; // If value not found, use this instead.
var SVariableBase OutValue;

function Process( Actor Other )
{
	local any A;
	
	if( OutValue==None )
		return;

	if( Other.UserData.Has(DataID,A) && A.IsType(Int) )
		OutValue.SetInt(A.GetInt());
	else OutValue.SetInt(DefValue);
}

defaultproperties
{
	MenuName="Get Int"
	VarLinks.Add((Name="Value",PropName="OutValue",bOutput=true))
}