Class Actor_FX extends Effects
	NoUserCreate;

var ACTOR_Overlay Handle;
var Actor OwnerActor,OldActor;

replication
{
	reliable if ( Role==ROLE_Authority )
		Handle,OwnerActor;
}

simulated function PostNetReceive()
{
	if( OldActor!=OwnerActor && Handle!=None )
	{
		OldActor = OwnerActor;
		if( OwnerActor!=None )
		{
			SetOwner(OwnerActor);
			InitFX();
		}
	}
}
simulated final function InitFX()
{
	local Actor_FX X;

	DrawScale = OwnerActor.DrawScale+0.01;
	Mesh = OwnerActor.Mesh;
	Fatness = Clamp(OwnerActor.Fatness + Handle.Fatness,0,255);
	Texture = Handle.Texture;
	LifeSpan = Handle.Duration;
	ActorRenderColor = Handle.Color;
	ActorGUnlitColor = Handle.Color;
	Style = Handle.Style;
	bMeshEnviroMap = Handle.bMeshEnviroMap;
	bUnlit = Handle.bUnlit;
	
	if( Handle.FadeInTime>0 && LifeSpan>0 )
		ScaleGlow = 0;
	else ScaleGlow = Handle.Opacity;
	
	if( LifeSpan>0 || Handle.bRemoveAllOld ) // Make sure net temporary ones gets removed too...
	{
		foreach OwnerActor.ChildActors(class'Actor_FX',X)
		{
			if( X==Self )
				continue;
			if( Handle.bRemoveAllOld || X.Handle==Handle )
				X.Destroy();
		}
	}
}

simulated function Tick( float Delta )
{
	if( OwnerActor==None || (OwnerActor.bIsPawn && Pawn(OwnerActor).Health<=0) )
	{
		Destroy();
		return;
	}
	DrawScale = OwnerActor.DrawScale+0.01;
	Mesh = OwnerActor.Mesh;
	Fatness = Clamp(OwnerActor.Fatness + Handle.Fatness,0,255);
}

defaultproperties
{
	bNetTemporary=False
	DrawType=DT_Mesh
	RemoteRole=ROLE_SimulatedProxy
	Physics=PHYS_Trailer
	bOwnerNoSee=True
	bTrailerSameRotation=True
	bAnimByOwner=True

	bSkipActorReplication=true
	bRepAnimations=false
	bRepMesh=false
	bCarriedItem=true
	bNetNotify=true
}