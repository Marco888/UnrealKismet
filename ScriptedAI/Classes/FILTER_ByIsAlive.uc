Class FILTER_ByIsAlive extends FILTER_BASE;

function bool ShouldFilter( Object Obj )
{
	return (Pawn(Obj)==None || Pawn(Obj).Health<=0);
}
