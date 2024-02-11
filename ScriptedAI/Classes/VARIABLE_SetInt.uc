Class VARIABLE_SetInt extends VARIABLEBASE;

var() int NewValue;
var SVariableBase InValue,OutValue;

function ReceiveEvent( byte Index )
{
	if( OutValue==None )
		Warn("No output?");
	else
	{
		if( InValue!=None )
			NewValue = InValue.GetInt();
		OutValue.SetInt(NewValue);
	}
	SendEvent(0);
}

defaultproperties
{
	MenuName="Set Int"
	Description="Set integer value"
	bClientAction=true
	DrawColor=(R=0,G=255,B=255)

	VarLinks.Add((Name="Input",PropName="InValue",bInput=true))
	VarLinks.Add((Name="Output",PropName="OutValue",bOutput=true))
}