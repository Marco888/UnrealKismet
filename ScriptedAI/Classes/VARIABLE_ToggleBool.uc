Class VARIABLE_ToggleBool extends VARIABLEBASE;

var SVariableBase InValue;

function ReceiveEvent( byte Index )
{
	if( InValue==None )
		Warn("No input/output");
	else
	{
		switch( Index )
		{
		case 0:
			InValue.SetBool(true);
			break;
		case 1:
			InValue.SetBool(false);
			break;
		default:
			InValue.SetBool(!InValue.GetBool());
		}
	}
	SendEvent(0);
}

defaultproperties
{
	MenuName="Toggle Bool"
	Description="Toggle boolean value"
	bClientAction=true
	DrawColor=(R=255,G=32,B=32)
	
	InputLinks(0)="Turn On"
	InputLinks(1)="Turn Off"
	InputLinks(2)="Toggle"

	VarLinks.Add((Name="Bool",PropName="InValue",bInput=true,bOutput=true))
}