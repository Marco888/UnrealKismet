Class ACTOR_Explosion extends ACTORBASE;

var() float Damage; // Explosion damage nearest to the point.
var() float Radius; // Radius in UU for explosion.
var() float MomentumTransfer; // How much momentum should be passed on to victim?
var() name DamageType; // Type of damage type for the explosion.
var() export editinline FILTER_BASE Filter;
var() class<Effects> ExplosionFX; // Explosion FX to spawn at the point.

var VAR_OBJECT_BASE InInstigator;
var SVariableBase InSource,InDamage,InRadius;
var bool bHurtEntry;

function ReceiveEvent( byte Index )
{
	local int i,l;
	local Actor A;

	if( bHurtEntry )
		return;
	if( InSource==None )
		Warn("No source?");
	else if( VAR_OBJECT_BASE(InSource)!=None )
	{
		l = InSource.GetArraySize();
		for( i=0; i<l; ++i )
		{
			A = Actor(InSource.GetObjectAt(i));
			if( A!=None && !A.bDeleteMe )
				SpawnExplosion(A.Location,A.Rotation);
		}
	}
	else if( VAR_Vector(InSource)!=None )
		SpawnExplosion(VAR_Vector(InSource).Value,RotRand(true));
	else Warn("Invalid source, MUST be Object or Vector, was: "@InSource);
	SendEvent(0);
}

final function SpawnExplosion( vector pos, rotator Rotation )
{
	local Pawn P;
	local Actor A;
	local float damageScale, dist;
	local vector dir;

	if( InDamage!=None )
		Damage = InDamage.GetFloat();
	if( InRadius!=None )
		Radius = InRadius.GetFloat();
	if( InInstigator!=None )
		P = Pawn(InInstigator.GetObject());

	bHurtEntry = true;
	if( Radius>0 )
	{
		foreach Level.VisibleCollidingActors(class'Actor',A,Radius,pos)
		{
			if ( Filter==None || !Filter.ShouldFilter(A) )
			{
				dir = A.Location - pos;
				dist = FMax(1,VSize(dir));
				dir = dir/dist;
				damageScale = 1 - FMax(0,(dist - A.CollisionRadius)/Radius);
				A.TakeDamage(damageScale * Damage,P,A.Location - 0.5 * (A.CollisionHeight + A.CollisionRadius) * dir,(damageScale * MomentumTransfer * dir),DamageType);
			}
		}
	}
	bHurtEntry = false;

	if( ExplosionFX!=None )
	{
		A = Level.Spawn(ExplosionFX,,,pos,Rotation);
		if( A!=None && bClientAction )
			A.RemoteRole = ROLE_None;
	}
}

defaultproperties
{
	MenuName="Explosion"
	Description="Spawn an explosion at a point in level.|Note: Source may be a vector or actor (if a list of actors it will spawn on all of them).|Instigator is the pawn dealing the damage."
	DrawColor=(R=148,G=5,B=5)
	
	Damage=64
	Radius=200
	MomentumTransfer=80000
	DamageType="explosion"
	ExplosionFX=Class'SpriteBallExplosion'

	VarLinks.Add((Name="Source",PropName="InSource",bInput=true))
	VarLinks.Add((Name="Instigator",PropName="InInstigator",bInput=true))
	VarLinks.Add((Name="Damage",PropName="InDamage",bInput=true))
	VarLinks.Add((Name="Radius",PropName="InRadius",bInput=true))
}