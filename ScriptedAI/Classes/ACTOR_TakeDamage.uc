Class ACTOR_TakeDamage extends ACTORBASE;

var() int Damage;
var() name DamageType;
var() vector Momentum;
var() vector HitOffset; // Instead of HitLocation, this offset is relative to actor location.

var VAR_OBJECT_BASE InActor,InInstigator;
var SVariableBase InDamage;
var VAR_Vector InMomentum,InHitLocation;

function ReceiveEvent( byte Index )
{
	local int i,l;
	local Actor A;
	local Pawn P;

	if( InActor==None )
		Warn("No input actor?");
	else
	{
		if( InInstigator!=None )
			P = Pawn(InInstigator.GetObject());
		if( InDamage!=None )
			Damage = InDamage.GetInt();
		if( InMomentum!=None )
			Momentum = InMomentum.Value;
		if( InHitLocation!=None )
			HitOffset = InHitLocation.Value;

		l = InActor.GetArraySize();
		for( i=0; i<l; ++i )
		{
			A = Actor(InActor.GetObjectAt(i));
			if( A!=None )
			{
				if( InHitLocation!=None )
					A.TakeDamage(Damage,P,HitOffset,Momentum,DamageType);
				else A.TakeDamage(Damage,P,A.Location+HitOffset,Momentum,DamageType);
			}
		}
	}
	SendEvent(0);
}

defaultproperties
{
	MenuName="Take Damage"
	Description="Make an actor take damage"
	DrawColor=(R=200,G=8,B=128)

	VarLinks.Add((Name="Actor",PropName="InActor",bInput=true))
	VarLinks.Add((Name="Instigator",PropName="InInstigator",bInput=true))
	VarLinks.Add((Name="Damage",PropName="InDamage",bInput=true))
	VarLinks.Add((Name="Momentum",PropName="InMomentum",bInput=true))
	VarLinks.Add((Name="HitLocation",PropName="InHitLocation",bInput=true))
}