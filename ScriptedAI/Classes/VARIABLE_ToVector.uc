Class VARIABLE_ToVector extends VARIABLEBASE;

var() float X,Y,Z;
var SVariableBase InX,InY,InZ;
var VAR_Vector OutValue;

function ReceiveEvent( byte Index )
{
	if( OutValue==None )
		Warn("No output?");
	else
	{
		if( InX!=None )
			X = InX.GetFloat();
		if( InY!=None )
			Y = InY.GetFloat();
		if( InZ!=None )
			Z = InZ.GetFloat();
		OutValue.Value.X = X;
		OutValue.Value.Y = Y;
		OutValue.Value.Z = Z;
	}
	SendEvent(0);
}

defaultproperties
{
	MenuName="To Vector"
	Description="Construct a vector from individual components"
	bClientAction=true
	DrawColor=(R=0,G=88,B=255)
	
	VarLinks.Add((Name="X",PropName="InX",bInput=true))
	VarLinks.Add((Name="Y",PropName="InY",bInput=true))
	VarLinks.Add((Name="Z",PropName="InZ",bInput=true))
	VarLinks.Add((Name="Output",PropName="OutValue",bOutput=true))
}