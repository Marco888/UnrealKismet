Class FILTER_Invert extends FILTER_BASE;

var() export editinline FILTER_BASE Filter;

function bool ShouldFilter( Object Obj )
{
	return !Filter.ShouldFilter(Obj);
}
