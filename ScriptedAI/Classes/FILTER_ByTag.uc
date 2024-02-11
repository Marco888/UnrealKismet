Class FILTER_ByTag extends FILTER_BASE;

var() name Tag,Event;

function bool ShouldFilter( Object Obj )
{
	local Actor A;
	
	A = Actor(Obj);
	return (A==None || (Tag!='' && A.Tag!=Tag) || (Event!='' && A.Event!=Event));
}
