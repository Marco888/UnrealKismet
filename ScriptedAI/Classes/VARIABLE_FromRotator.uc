Class VARIABLE_FromRotator extends VARIABLEBASE;

var() rotator Value;
var SVariableBase OutY,OutP,OutR;
var VAR_Rotator InValue;

function ReceiveEvent( byte Index )
{
	if( InValue!=None )
		Value = InValue.Value;
	if( OutY!=None )
		OutY.SetInt(Value.Yaw);
	if( OutP!=None )
		OutP.SetInt(Value.Pitch);
	if( OutR!=None )
		OutR.SetInt(Value.Roll);
	SendEvent(0);
}

defaultproperties
{
	MenuName="From Rotator"
	Description="Grab each rotator component"
	bClientAction=true
	DrawColor=(R=0,G=255,B=88)
	
	VarLinks.Add((Name="Input",PropName="InValue",bInput=true))
	VarLinks.Add((Name="Yaw",PropName="OutY",bOutput=true))
	VarLinks.Add((Name="Pitch",PropName="OutP",bOutput=true))
	VarLinks.Add((Name="Roll",PropName="OutR",bOutput=true))
}