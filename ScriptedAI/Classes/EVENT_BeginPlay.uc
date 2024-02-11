Class EVENT_BeginPlay extends EVENTBASE;

var bool bPostReset;

function Reset()
{
	bPostReset = true;
}
function PostBeginPlay()
{
	if( bPostReset )
		SendEvent(1);
	else SendEvent(0);
}

defaultproperties
{
	MenuName="Begin Play"
	Description="Fires an event on start of map.|Reset event is fired instead when level was soft resetted."
	DrawColor=(R=140,G=140,B=140)
	bRequestBeginPlay=true
	bReqPostBeginPlay=true
	OutputLinks(1)="Reset"
}