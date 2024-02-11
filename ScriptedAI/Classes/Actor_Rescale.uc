Class Actor_Rescale extends KismetInfoBase
	NoUserCreate;

var ACTOR_ChangeScale Scaler;
var float DestScale,StartScale,ScaleTime,TotalTime;

function Tick( float Delta )
{
	if( Owner==None || Owner.bDeleteMe || (Owner.bIsPawn && Pawn(Owner).Health<=0) )
	{
		Destroy();
		return;
	}
	ScaleTime+=Delta;
	Delta = FMin(ScaleTime/TotalTime,1.f);
	Scaler.SetActorSize(Owner,StartScale*(1.f-Delta) + DestScale*Delta);

	if( ScaleTime>=TotalTime )
		Destroy();
}

defaultproperties
{
	RemoteRole=ROLE_None
}