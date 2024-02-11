Class ACTOR_USER_GetObj extends ACTOR_USERDATA;

var() Object DefValue; // If value not found, use this instead.
var SVariableBase OutValue;

function Process( Actor Other )
{
	local any A;
	
	if( OutValue==None )
		return;

	if( Other.UserData.Has(DataID,A) && A.IsType(Object) )
		OutValue.SetObject(A.GetObject());
	else OutValue.SetObject(DefValue);
}

defaultproperties
{
	MenuName="Get Object"
	VarLinks.Add((Name="Value",PropName="OutValue",bOutput=true))
	bContainsActorRef=true
}