Class FILTER_ByPlayer extends FILTER_BASE;

var() bool bIsPlayer; // If false, only let monsters pass.

function bool ShouldFilter( Object Obj )
{
	return (Pawn(Obj)==None || Pawn(Obj).bIsPlayer!=bIsPlayer);
}

defaultproperties
{
	bIsPlayer=true
}