Class FILTER_MultiFilter extends FILTER_BASE;

var() export editinline array<FILTER_BASE> Filters;

function bool ShouldFilter( Object Obj )
{
	local int i;
	
	for( i=(Array_Size(Filters)-1); i>=0; --i )
		if( Filters[i].ShouldFilter(Obj) )
			return true;
	return false;
}
