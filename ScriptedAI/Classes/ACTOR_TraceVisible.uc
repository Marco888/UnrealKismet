Class ACTOR_TraceVisible extends ACTORBASE;

var() vector Start; // Start of trace
var() vector End; // End of trace

var SVariableBase InStart,InEnd;

function ReceiveEvent( byte Index )
{
	if( InStart!=None )
		Start = InStart.GetVector();
	if( InEnd!=None )
		End = InEnd.GetVector();
	
	if( Level.FastTrace(End,Start) )
		SendEvent(0);
	else SendEvent(1);
}

static event string GetUIName( bool bGroupName )
{
	if( bGroupName )
		return "Trace";
	return Super.GetUIName(bGroupName);
}

defaultproperties
{
	MenuName="Trace Visible"
	Description="Do a simple visibility trace from Start to End."
	DrawColor=(R=128,G=255,B=88)
	bClientAction=true
	
	OutputLinks(0)="Visibile"
	OutputLinks(1)="Not Visible"

	VarLinks.Add((Name="Start",PropName="InStart",bInput=true))
	VarLinks.Add((Name="End",PropName="InEnd",bInput=true))
}