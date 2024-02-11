Class ACTOR_TraceHit extends ACTOR_TraceVisible;

var() export editinline FILTER_BASE TraceFilter; // Skipped hits (if used, bTraceWorld flag will not work properly).
var() vector TraceExtent; // Box size of the trace.
var VAR_Vector OutLocation,OutNormal;
var VAR_OBJECT_BASE InSource,OutActor;

var() bool bTraceActors; // Should trace actors.
var() bool bTraceWorld; // Should trace level geometry.

function ReceiveEvent( byte Index )
{
	local Actor A,Src;
	local vector HL,HN;

	if( InStart!=None )
		Start = InStart.GetVector();
	if( InEnd!=None )
		End = InEnd.GetVector();
	if( InSource!=None )
		Src = Actor(InSource.GetObject());
	if( Src==None )
		Src = Level;
	
	if( TraceFilter!=None )
	{
		foreach Src.TraceActors(class'Actor',A,HL,HN,End,Start,TraceExtent)
		{
			if( (!bTraceActors || A.bBlockActors || A.bProjTarget) && (bTraceActors || A.bWorldGeometry || A==Level || A.bIsMover) && (bTraceWorld || A!=Level) && !TraceFilter.ShouldFilter(A) )
				break;
		}
	}
	else A = Src.Trace(HL,HN,End,Start,bTraceActors,TraceExtent,bTraceWorld);

	if( A==None )
		SendEvent(0);
	else
	{
		if( OutLocation!=None )
			OutLocation.Value = HL;
		if( OutNormal!=None )
			OutNormal.Value = HN;
		if( OutActor!=None )
			OutActor.SetObject(A);
		SendEvent(1);
	}
}

defaultproperties
{
	MenuName="Trace Hit Info"
	Description="Do a trace from Start to End.|Source: The actor that performed the trace (ignore hit with this).|Location/Normal: Hit location and direction.|Actor: Trace hit actor."
	DrawColor=(R=150,G=8,B=128)

	bTraceActors=true
	bTraceWorld=true
	
	OutputLinks(0)="Not Hit"
	OutputLinks(1)="Hit"

	VarLinks.Add((Name="Source",PropName="InSource",bInput=true))
	VarLinks.Add((Name="Location",PropName="OutLocation",bOutput=true))
	VarLinks.Add((Name="Normal",PropName="OutNormal",bOutput=true))
	VarLinks.Add((Name="Actor",PropName="OutActor",bOutput=true))
}