Class LOGIC_LockGate extends LOGICBASE;

var bool bLocked;

function Reset()
{
	bLocked = false;
}

function ReceiveEvent( byte Index )
{
	if( Index==0 )
	{
		if( !bLocked )
		{
			bLocked = true;
			SendEvent(0);
		}
	}
	else bLocked = false;
}

defaultproperties
{
	MenuName="Lock Gate"
	Description="To control execution flow to only once per sequence of actions.|Fire Lock to output once only until you fire Unlock."
	bClientAction=true
	DrawColor=(R=96,G=38,B=120)

	InputLinks(0)="Lock"
	InputLinks(1)="Unlock"
}