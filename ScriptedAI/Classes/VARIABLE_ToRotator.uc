Class VARIABLE_ToRotator extends VARIABLEBASE;

var() int Yaw,Pitch,Roll; // Angles in 0 - 65536
var SVariableBase InY,InP,InR;
var VAR_Rotator OutValue;

function ReceiveEvent( byte Index )
{
	if( OutValue==None )
		Warn("No output?");
	else
	{
		if( InY!=None )
			Yaw = InY.GetInt();
		if( InP!=None )
			Pitch = InP.GetInt();
		if( InR!=None )
			Roll = InR.GetInt();
		OutValue.Value.Yaw = Yaw;
		OutValue.Value.Pitch = Pitch;
		OutValue.Value.Roll = Roll;
	}
	SendEvent(0);
}

defaultproperties
{
	MenuName="To Rotator"
	Description="Construct a rotator from individual components"
	bClientAction=true
	DrawColor=(R=0,G=255,B=88)
	
	VarLinks.Add((Name="Yaw",PropName="InY",bInput=true))
	VarLinks.Add((Name="Pitch",PropName="InP",bInput=true))
	VarLinks.Add((Name="Roll",PropName="InR",bInput=true))
	VarLinks.Add((Name="Output",PropName="OutValue",bOutput=true))
}