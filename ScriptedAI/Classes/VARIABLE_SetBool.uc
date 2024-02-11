Class VARIABLE_SetBool extends VARIABLEBASE;

var() bool NewValue;
var SVariableBase InValue,OutValue;

function ReceiveEvent( byte Index )
{
	if( OutValue==None )
		Warn("No output?");
	else
	{
		if( InValue!=None )
			NewValue = InValue.GetBool();
		OutValue.SetBool(NewValue);
	}
	SendEvent(0);
}

defaultproperties
{
	MenuName="Set Bool"
	Description="Set boolean value"
	bClientAction=true
	DrawColor=(R=255,G=0,B=0)

	VarLinks.Add((Name="Input",PropName="InValue",bInput=true))
	VarLinks.Add((Name="Output",PropName="OutValue",bOutput=true))
}