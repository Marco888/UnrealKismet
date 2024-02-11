Class LATENT_TimerActor extends LATENT_Timer;

var VAR_OBJECT_BASE ObjectInRef,ObjectOutRef;

function ReceiveEvent( byte Index )
{
	local Actor A;
	
	if( !ObjectInRef )
		return;
	A = Actor(ObjectInRef.GetObject());
	if( !A || A.bDeleteMe )
		return;

	switch( Index )
	{
	case 0:
		if( SleepTimeRef )
			SleepTime = SleepTimeRef.GetFloat();
		A.SetTimer(SleepTime,(Repeats==0),'OnActorTimer',Self);
		break;
	default:
		A.SetTimer(0.f,false,'OnActorTimer',Self);
	}
}

function Tick( float Delta );

function OnActorTimer( Actor Other )
{
	if( !Other || Other.bDeleteMe )
		return;

	if( ObjectOutRef )
		ObjectOutRef.SetObject(Other);
	SendEvent(0);
}

defaultproperties
{
	MenuName="Timer Actor"
	Description="Wait for specific time for each actor"
	bRequestTick=false
	DrawColor=(R=0,G=0,B=110)
	
	VarLinks.Empty()
	VarLinks.Add((Name="InActor",PropName="ObjectInRef",bInput=true))
	VarLinks.Add((Name="Time",PropName="SleepTimeRef",bInput=true))
	VarLinks.Add((Name="OutActor",PropName="ObjectOutRef",bOutput=true))
	
	InputLinks.Empty()
	InputLinks.Add("Start")
	InputLinks.Add("Stop")
}