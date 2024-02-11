Class VARIABLE_SetString extends VARIABLEBASE;

var() string NewValue;
var SVariableBase InValue,OutValue;

function ReceiveEvent( byte Index )
{
	if( OutValue==None )
		Warn("No output?");
	else
	{
		if( InValue!=None )
			NewValue = InValue.GetValue();
		OutValue.SetValue(NewValue);
	}
	SendEvent(0);
}

defaultproperties
{
	MenuName="Set Text"
	Description="Set string value"
	bClientAction=true
	DrawColor=(R=0,G=255,B=0,A=255)

	VarLinks.Add((Name="Input",PropName="InValue",bInput=true))
	VarLinks.Add((Name="Output",PropName="OutValue",bOutput=true))
}