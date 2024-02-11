Class VARIABLE_SetFloat extends VARIABLEBASE;

var() float NewValue;
var SVariableBase InValue,OutValue;

function ReceiveEvent( byte Index )
{
	if( OutValue==None )
		Warn("No output?");
	else
	{
		if( InValue!=None )
			NewValue = InValue.GetFloat();
		OutValue.SetFloat(NewValue);
	}
	SendEvent(0);
}

defaultproperties
{
	MenuName="Set Float"
	Description="Set float value"
	bClientAction=true
	DrawColor=(R=0,G=0,B=255)

	VarLinks.Add((Name="Input",PropName="InValue",bInput=true))
	VarLinks.Add((Name="Output",PropName="OutValue",bOutput=true))
}