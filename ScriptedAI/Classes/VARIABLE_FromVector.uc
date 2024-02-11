Class VARIABLE_FromVector extends VARIABLEBASE;

var() vector Value;
var SVariableBase OutX,OutY,OutZ;
var VAR_Vector InValue;

function ReceiveEvent( byte Index )
{
	if( InValue!=None )
		Value = InValue.Value;
	if( OutX!=None )
		OutX.SetFloat(Value.X);
	if( OutY!=None )
		OutY.SetFloat(Value.Y);
	if( OutZ!=None )
		OutZ.SetFloat(Value.Z);
	SendEvent(0);
}

defaultproperties
{
	MenuName="From Vector"
	Description="Grab each vector component"
	bClientAction=true
	DrawColor=(R=0,G=88,B=255)
	
	VarLinks.Add((Name="Input",PropName="InValue",bInput=true))
	VarLinks.Add((Name="X",PropName="OutX",bOutput=true))
	VarLinks.Add((Name="Y",PropName="OutY",bOutput=true))
	VarLinks.Add((Name="Z",PropName="OutZ",bOutput=true))
}