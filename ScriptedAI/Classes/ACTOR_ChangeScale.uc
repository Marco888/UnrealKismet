Class ACTOR_ChangeScale extends ACTORBASE;

var() float NewScale;
var() float ChangeTime; // Time in seconds it takes to resize.
var() bool bRelative; // Relative to previous scale, or absolute scale?
var() bool bChangeCollision; // Also change collision size?

var SVariableBase InScale;
var VAR_OBJECT_BASE InActor;

function ReceiveEvent( byte Index )
{
	local int i,l;

	if( InActor==None )
		Warn("No input actor?");
	else
	{
		if( InScale!=None )
			NewScale = InScale.GetFloat();

		if( InActor.bIsArray )
		{
			l = InActor.GetArraySize();
			for( i=0; i<l; ++i )
				Resize(Actor(InActor.GetObjectAt(i)));
		}
		else Resize(Actor(InActor.GetObject()));
	}
	SendEvent(0);
}

final function Resize( Actor A )
{
	local float f,Cur;
	local Actor_Rescale R;
	
	Cur = A.DrawScale;

	// Cancel out any other scalers in progress.
	foreach A.ChildActors(class'Actor_Rescale',R)
	{
		Cur = R.DestScale;
		R.Destroy();
		break;
	}
	
	if( bRelative )
		f = Cur*NewScale;
	else f = NewScale;
	
	if( Abs(Cur-f)<0.001 )
		return;
	
	if( ChangeTime>0.f )
	{
		R = A.Spawn(class'Actor_Rescale',A);
		if( R!=None )
		{
			R.Scaler = self;
			R.DestScale = f;
			R.StartScale = A.DrawScale;
			R.TotalTime = ChangeTime;
		}
	}
	else SetActorSize(A,f);
}

final function SetActorSize( Actor A, float Scale )
{
	local float NSize,OldHeight;

	A.DrawScale = Scale;
	if( bChangeCollision )
	{
		NSize = (A.DrawScale/A.Default.DrawScale);
		OldHeight = A.CollisionHeight;
		A.SetCollisionSize(A.Default.CollisionRadius*NSize,A.Default.CollisionHeight*NSize);
		if( A.bIsPawn && OldHeight<A.CollisionHeight ) // Move pawn up from the ground if possible.
			A.MoveSmooth(vect(0,0,1)*(A.CollisionHeight-OldHeight));
	}
}

defaultproperties
{
	MenuName="Change scale"
	Description="Resize an actor with optional blend time."
	DrawColor=(R=128,G=48,B=68)

	VarLinks.Add((Name="NewScale",PropName="InScale",bInput=true))
	VarLinks.Add((Name="Actor",PropName="InActor",bInput=true))
}