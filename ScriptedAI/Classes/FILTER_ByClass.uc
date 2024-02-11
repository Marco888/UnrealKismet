Class FILTER_ByClass extends FILTER_BASE;

var() class MetaClass;

function bool ShouldFilter( Object Obj )
{
	return (MetaClass!=None && !ClassIsChildOf(Obj.Class, MetaClass));
}
