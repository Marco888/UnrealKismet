Class EVENT_PawnHurt extends EVENTBASE;

var EVENT_PawnHurt NextCallback;

var() export editinline FILTER_BASE VictimFilter;
var SVariableBase OutInjured,OutInstigator,OutDamage,OutDamageType;
var VAR_Vector OutHitLocation;

var Actor_GameRules Listen;

function BeginPlay()
{
	Listen = class'Actor_GameRules'.Static.GetRules(Level);
	if( Listen!=None )
	{
		NextCallback = Listen.HurtCallback;
		Listen.HurtCallback = Self;
		Listen.bModifyDamage = true;
	}
}

function NotifyDamage( Pawn Injured, Pawn EventInstigator, int Damage, vector HitLocation, name DamageType )
{
	if( VictimFilter==None || !VictimFilter.ShouldFilter(Injured) )
	{
		if( OutInjured!=None )
			OutInjured.SetObject(Injured);
		if( OutInstigator!=None )
			OutInstigator.SetObject(EventInstigator);
		if( OutDamage!=None )
			OutDamage.SetInt(Damage);
		if( OutHitLocation!=None )
			OutHitLocation.Value = HitLocation;
		if( OutDamageType!=None )
			OutDamageType.SetValue(string(DamageType));
		SendEvent(0);
	}
}

defaultproperties
{
	MenuName="Pawn Hurt"
	Description="Triggered when a pawn takes damage."
	DrawColor=(R=128,G=32,B=12)
	bRequestBeginPlay=true
	
	VarLinks.Add((Name="Injured",PropName="OutInjured",bOutput=true))
	VarLinks.Add((Name="Attacker",PropName="OutInstigator",bOutput=true))
	VarLinks.Add((Name="Damage",PropName="OutDamage",bOutput=true))
	VarLinks.Add((Name="HitPos",PropName="OutHitLocation",bOutput=true))
	VarLinks.Add((Name="DamageType",PropName="OutDamageType",bOutput=true))
}