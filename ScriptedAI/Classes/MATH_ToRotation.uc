Class MATH_ToRotation extends MATH_ROTATORBASE;

var VAR_Vector InValue,InUpAxis;
var VAR_Rotator OutValue;

function ReceiveEvent( byte Index )
{
	if( InValue!=None && OutValue!=None )
	{
		if( InUpAxis!=None )
			OutValue.Value = OrthoRotation(InValue.Value,(InValue.Value Cross InUpAxis.Value),InUpAxis.Value);
		else OutValue.Value = rotator(InValue.Value);
	}
	SendEvent(0);
}

defaultproperties
{
	MenuName="To rotation"
	Description="Convert a vector into rotation (* with optional up axis)"
	DrawColor=(R=128,G=32,B=210)
	
	VarLinks.Add((Name="InForward",PropName="InValue",bInput=true))
	VarLinks.Add((Name="InUp*",PropName="InUpAxis",bInput=true))
	VarLinks.Add((Name="Output",PropName="OutValue",bOutput=true))
}