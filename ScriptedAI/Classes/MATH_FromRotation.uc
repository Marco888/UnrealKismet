Class MATH_FromRotation extends MATH_ROTATORBASE;

var() rotator Value;
var VAR_Rotator InValue;
var VAR_Vector OutX,OutY,OutZ;
var transient vector X,Y,Z;

var() bool bUnAxis; // Get inverted axis.

function ReceiveEvent( byte Index )
{
	if( InValue!=None )
		Value = InValue.Value;
	if( bUnAxis )
		GetUnAxes(Value,X,Y,Z);
	else GetAxes(Value,X,Y,Z);
	if( OutX!=None )
		OutX.Value = X;
	if( OutY!=None )
		OutY.Value = Y;
	if( OutZ!=None )
		OutZ.Value = Z;
	SendEvent(0);
}

defaultproperties
{
	MenuName="From rotation"
	Description="Get vector from rotation"
	DrawColor=(R=128,G=32,B=210)
	
	VarLinks.Add((Name="Direction",PropName="InValue",bInput=true))
	VarLinks.Add((Name="Forward",PropName="OutX",bOutput=true))
	VarLinks.Add((Name="Side",PropName="OutY",bOutput=true))
	VarLinks.Add((Name="Up",PropName="OutZ",bOutput=true))
}