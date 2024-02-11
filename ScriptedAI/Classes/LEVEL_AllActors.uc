Class LEVEL_AllActors extends LEVELSBASE;

var VAR_OBJECTARRAY_BASE OutList;

var() class<Actor> MetaClass;
var() name ActorTag,ActorEvent;
var() export editinline FILTER_BASE ActorFilter;

function ReceiveEvent( byte Index )
{
	local Actor A;
	local int i;

	if( OutList!=None )
	{
		OutList.SetArraySize(0);
		foreach Level.AllActors(MetaClass,A,ActorTag,ActorEvent)
		{
			if( ActorFilter==None || !ActorFilter.ShouldFilter(A) )
				OutList.SetObjectAt(A,i++);
		}
	}
	SendEvent(0);
}

defaultproperties
{
	MenuName="All Actors"
	Description="Grab all actors from level"
	bClientAction=true
	DrawColor=(R=200,G=175,B=100)
	MetaClass=class'Actor'

	VarLinks.Add((Name="List",PropName="OutList",bOutput=true))
}