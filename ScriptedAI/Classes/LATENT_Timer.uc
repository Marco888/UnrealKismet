Class LATENT_Timer extends LATENTBASE;

var() int Repeats; // 0 = infinite
var() float SleepTime; // Wait for X seconds
var SVariableBase SleepTimeRef,RepeatsRef,TimeRemainRef;

var int Count;
var float CountTime;

function ReceiveEvent( byte Index )
{
	switch( Index )
	{
	case 0:
		if( SleepTimeRef!=None )
			SleepTime = SleepTimeRef.GetFloat();
		if( RepeatsRef!=None )
			Repeats = RepeatsRef.GetInt();
		CountTime = SleepTime;
		if( TimeRemainRef!=None )
			TimeRemainRef.SetFloat(CountTime);
		Count = Repeats;
		SetEnableTick(true);
		break;
	case 1:
		SetEnableTick(false);
		break;
	default:
		if( CountTime>0 )
			SetEnableTick(true);
	}
}

function Tick( float Delta )
{
	if( (CountTime-=Delta)<=0 )
	{
		if( TimeRemainRef!=None )
			TimeRemainRef.SetFloat(CountTime);
		if( Count>0 && --Count==0 )
			SetEnableTick(false);
		else CountTime = SleepTime;
		SendEvent(0);
	}
}

function Reset()
{
	CountTime = 0;
}

defaultproperties
{
	MenuName="Timer"
	Description="Wait for specific time"
	bRequestTick=true
	bClientAction=true
	Repeats=1
	DrawColor=(R=0,G=0,B=140)
	
	VarLinks.Add((Name="Time",PropName="SleepTimeRef",bInput=true))
	VarLinks.Add((Name="Repeats",PropName="RepeatsRef",bInput=true))
	VarLinks.Add((Name="Remain",PropName="TimeRemainRef",bOutput=true))
	
	InputLinks(0)="Restart"
	InputLinks(1)="Pause"
	InputLinks(2)="Continue"
}