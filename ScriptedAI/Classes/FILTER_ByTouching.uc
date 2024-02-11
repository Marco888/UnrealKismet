Class FILTER_ByTouching extends FILTER_BASE;

var() class<Actor> TouchClass; // Actor to touch (i.e: Trigger)
var() name TouchTag; // Tag of the actor to touch.

function bool ShouldFilter( Object Obj )
{
	local Actor A,T;
	
	A = Actor(Obj);
	if( A!=None )
	{
		foreach A.TouchingActors(TouchClass,T)
			if( TouchTag=='' || TouchTag==T.Tag )
				return false;
	}
	return true;
}

defaultproperties
{
	TouchClass=class'Actor'
}