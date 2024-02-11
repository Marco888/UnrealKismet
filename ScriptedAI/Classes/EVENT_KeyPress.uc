Class EVENT_KeyPress extends EVENT_INPUTBASE;

var() Actor.EInputKey ListenKey;

var SVariableBase OutAxis;

function bool OnProcessInput( byte Key, byte Action, float Delta )
{
	if( Key==ListenKey )
	{
		switch( Action )
		{
		case 1: // EInputAction.IST_Press
			SendEvent(0);
			break;
		case 2: // EInputAction.IST_Hold
			SendEvent(1);
			break;
		case 3: // EInputAction.IST_Release
			SendEvent(2);
			break;
		case 4: // EInputAction.IST_Axis
			if( OutAxis!=None )
				OutAxis.SetFloat(Delta);
			SendEvent(3);
			break;
		default:
			return false;
		}
		if( InBlockKey!=None )
			return InBlockKey.GetBool();
		return bBlockKey;
	}
	return false;
}

event OnPropertyChange( name Property, name ParentProperty )
{
	if( Property=='ListenKey' )
		PostInfoText = string(GetEnum(enum'EInputKey',ListenKey));
}

defaultproperties
{
	MenuName="Key Press"
	Description="Called on CLIENT side when local user presses a keystroke.|Axis is when user presses joystick or moves mouse."
	DrawColor=(R=128,G=128,B=128)

	bClientAction=true

	OutputLinks(0)="Press"
	OutputLinks(1)="Hold"
	OutputLinks(2)="Release"
	OutputLinks(3)="Axis"

	VarLinks.Add((Name="AxisDelta",PropName="OutAxis",bOutput=true))
}