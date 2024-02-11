Class LEVEL_AllPawns extends LEVELSBASE;

var VAR_OBJECTARRAY_BASE OutList;

var() export editinline FILTER_BASE PawnFilter;

function ReceiveEvent( byte Index )
{
	local Pawn P;
	local int i;

	if( OutList!=None )
	{
		OutList.SetArraySize(0);
		if( Level.NetMode==NM_Client )
		{
			foreach Level.AllActors(class'Pawn',P)
			{
				if( PawnFilter==None || !PawnFilter.ShouldFilter(P) )
					OutList.SetObjectAt(P,i++);
			}
		}
		else
		{
			for( P=Level.PawnList; P!=None; P=P.NextPawn )
			{
				if( PawnFilter==None || !PawnFilter.ShouldFilter(P) )
					OutList.SetObjectAt(P,i++);
			}
		}
	}
	SendEvent(0);
}

defaultproperties
{
	MenuName="All Pawns"
	Description="Grab all pawns from level"
	bClientAction=true
	DrawColor=(R=200,G=88,B=100)

	VarLinks.Add((Name="List",PropName="OutList",bOutput=true))
}