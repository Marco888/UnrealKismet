Class Actor_Interaction extends UWinInteraction;

var EVENT_INPUTBASE KeyCallbacks;

final function EnableKey( EVENT_INPUTBASE e )
{
	bRequestInput = true;
	E.NextCallback = KeyCallbacks;
	KeyCallbacks = E;
}
final function DisableKey( EVENT_INPUTBASE e )
{
	local EVENT_INPUTBASE k;
	
	if( KeyCallbacks==e )
		KeyCallbacks = e.NextCallback;
	else
	{
		for( k=KeyCallbacks; k!=None; k=k.NextCallback )
			if( k.NextCallback==e )
			{
				k.NextCallback = e.NextCallback;
				break;
			}
	}
	e.NextCallback = None;
	if( KeyCallbacks==None )
		bRequestInput = false;
}

function bool KeyEvent( byte Key, byte Action, FLOAT Delta )
{
	local EVENT_INPUTBASE k;
	
	// Do not allow to override menu/typing states input.
	if( !Console.IsInState('Typing') && !Console.IsInState('Menuing') && !Console.IsInState('MenuTyping') && !Console.IsInState('KeyMenuing') )
	{
		for( k=KeyCallbacks; k!=None; k=k.NextCallback )
			if( k.OnProcessInput(Key,Action,Delta) )
				return true;
	}
	return false;
}

defaultproperties
{
}