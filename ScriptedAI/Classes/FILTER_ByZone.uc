Class FILTER_ByZone extends FILTER_BASE;

var() name ZoneTag;

function bool ShouldFilter( Object Obj )
{
	local Actor A;
	
	A = Actor(Obj);
	return (A==None || A.Region.Zone==None || A.Region.Zone.Tag!=ZoneTag);
}
