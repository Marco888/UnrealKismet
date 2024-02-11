Class Actor_Mutator extends Mutator;

static final function Actor_Mutator FindMutator( LevelInfo L )
{
	local Mutator M;

	if( L.Game==None )
		return None;
	
	for( M=L.Game.BaseMutator; M!=None; M=M.NextMutator )
		if( M.Class==Class'Actor_Mutator' )
			break;
	
	if( M==None )
	{
		M = L.Spawn(class'Actor_Mutator');
		if( L.Game.BaseMutator==None )
			L.Game.BaseMutator = M;
		else L.Game.BaseMutator.AddMutator(M);
	}
	return Actor_Mutator(M);
}
function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
	if( Other.bIsPawn && PlayerPawn(Other)!=None )
		Spawn(class'Actor_NetworkerServer',Other);
	return true;
}
