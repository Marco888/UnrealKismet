Class FILTER_ByTeam extends FILTER_BASE;

var() byte TeamNum;

function bool ShouldFilter( Object Obj )
{
	return (Pawn(Obj)==None || Pawn(Obj).GetTeamNum()!=TeamNum);
}
