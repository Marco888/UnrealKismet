Class LATENT_Dispatch extends LATENTBASE;

var() array<float> OutDelays;
var int Offset,Count;
var float Time;

function ReceiveEvent( byte Index )
{
	switch( Index )
	{
	case 0:
		if( Count>0 )
		{
			Offset = 0;
			Time = 0.f;
			SetEnableTick(true);
		}
		break;
	case 1:
		SetEnableTick(false);
		break;
	default:
		if( Offset<Count )
			SetEnableTick(true);
	}
}

function Tick( float Delta )
{
	Time+=Delta;
	while( Time>=OutDelays[Offset] )
	{
		Time-=OutDelays[Offset];
		if( ++Offset>=Count )
		{
			SetEnableTick(false);
			SendEvent(Offset-1);
			break;
		}
		else SendEvent(Offset-1);
	}
}

function Reset()
{
	Offset = 0;
	Time = 0.f;
}

event OnPropertyChange( name Property, name ParentProperty )
{
	local byte i;
	local float t;
	local string S;

	if( Property=='OutDelays' )
	{
		Count = OutDelays.Size();
		OutputLinks.SetSize(Count);
		for( i=0; i<Count; ++i )
		{
			t+=OutDelays[i];
			S = string(t);
			OutputLinks[i] = Left(S,Len(S)-4);
		}
	}
}

defaultproperties
{
	MenuName="Dispatch Timed"
	Description="Send out multiple outputs with a delay timer"
	bRequestTick=true
	bClientAction=true
	DrawColor=(R=12,G=140,B=5)

	OutputLinks.Empty()
	InputLinks(0)="Restart"
	InputLinks(1)="Pause"
	InputLinks(2)="Continue"
}