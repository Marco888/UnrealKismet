Class FILTER_ByPawn extends FILTER_BASE;

var() bool bOnlyPlayers,bOnlyAlive,bByTeam;
var() class<Pawn> MetaClass;
var() byte TeamNum;

function bool ShouldFilter( Object Obj )
{
	local Pawn P;
	
	P = Pawn(Obj);
	return (P==None || (bOnlyPlayers && !P.bIsPlayer) || (bOnlyAlive && P.Health<=0) || (bByTeam && P.GetTeamNum()!=TeamNum) || (MetaClass!=None && !ClassIsChildOf(P.Class, MetaClass)));
}
