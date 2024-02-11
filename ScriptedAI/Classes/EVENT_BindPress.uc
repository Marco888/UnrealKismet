Class EVENT_BindPress extends EVENT_INPUTBASE;

var() string KeyBind; // Keybinding to look for (check User.ini, ie: Fire,AltFire,MoveForward etc)
var transient byte InputKeys[255];

var SVariableBase OutAxis;

var transient bool bHasInit;

final function InitBindings()
{
	local int i;
	local string key;
	local PlayerPawn P;

	P = Level.GetLocalPlayerPawn();
	if( P==None )
		return;
	bHasInit = true;
	if( KeyBind=="" ) return;

	key = P.ConsoleCommand("KEYBINDING FIND "$KeyBind);
	while( Len(key) )
	{
		i = InStr(key,",");
		if( i==-1 )
		{
			InputKeys[int(key)] = 1;
			break;
		}
		InputKeys[int(Left(key,i))] = 1;
		key = Mid(key,i+1);
	}
}

final function bool VerifyInput( string bind ) // Slow verification of input, i.e: not Fire in AltFire or so.
{
	local int i;
	local string t;
	
	while( bind!="" )
	{
		i = InStr(bind,"|");
		if( i>=0 )
		{
			t = Left(bind,i);
			bind = Mid(bind,i+1);
		}
		else
		{
			t = bind;
			bind = "";
		}
		
		// Strip whitespaces from start.
		while( Left(t,1)==" " )
			t = Mid(t,1);
		// Strip whitespaces from end.
		while( Right(t,1)==" " )
			t = Left(t,Len(t)-1);

		if( t~=KeyBind )
			return true;
	}
	return false;
}

function bool OnProcessInput( byte Key, byte Action, float Delta )
{
	if( !bHasInit )
		InitBindings();
	if( InputKeys[Key]==1 )
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
	if( Property=='KeyBind' )
		PostInfoText = KeyBind;
}

defaultproperties
{
	MenuName="Bind Press"
	Description="Called on CLIENT side when local user presses a keybinding.|Axis is when user presses joystick or moves mouse."
	DrawColor=(R=64,G=128,B=128)

	bClientAction=true

	OutputLinks(0)="Press"
	OutputLinks(1)="Hold"
	OutputLinks(2)="Release"
	OutputLinks(3)="Axis"

	VarLinks.Add((Name="AxisDelta",PropName="OutAxis",bOutput=true))
}