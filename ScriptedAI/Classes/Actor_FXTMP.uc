Class Actor_FXTMP extends Actor_FX
	NoUserCreate
	transient;

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
	
	Delta = 1.f - (LifeSpan / Handle.Duration);
	if( Delta<Handle.FadeInTime )
		ScaleGlow = (Delta/Handle.FadeInTime) * Handle.Opacity;
	else if( Delta>Handle.FadeOutTime )
		ScaleGlow = (1.f - ((Delta-Handle.FadeOutTime)/(1.f-Handle.FadeInTime))) * Handle.Opacity;
	else ScaleGlow = Handle.Opacity;
}

defaultproperties
{
	bNetTemporary=true
}