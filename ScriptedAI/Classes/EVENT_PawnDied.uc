Class EVENT_PawnDied extends EVENTBASE;

var EVENT_PawnDied NextCallback;

var() export editinline FILTER_BASE VictimFilter;
var SVariableBase OutKilled,OutKiller,OutDamageType;

var Actor_GameRules Listen;

function BeginPlay()
{
	Listen = class'Actor_GameRules'.Static.GetRules(Level);
	if( Listen!=None )
	{
		NextCallback = Listen.DieCallback;
		Listen.DieCallback = Self;
		Listen.bHandleDeaths = true;
	}
}

function NotifyKilled( Pawn Killed, Pawn Killer, name DamageType )
{
	if( VictimFilter==None || !VictimFilter.ShouldFilter(Killed) )
	{
		if( OutKilled!=None )
			OutKilled.SetObject(Killed);
		if( OutKiller!=None )
			OutKiller.SetObject(Killer);
		if( OutDamageType!=None )
			OutDamageType.SetValue(string(DamageType));
		SendEvent(0);
	}
}

defaultproperties
{
	MenuName="Pawn Died"
	Description="Triggered when a pawn dies."
	DrawColor=(R=200,G=12,B=12)
	bRequestBeginPlay=true
	
	VarLinks.Add((Name="Killed",PropName="OutKilled",bOutput=true))
	VarLinks.Add((Name="Killer",PropName="OutKiller",bOutput=true))
	VarLinks.Add((Name="DamageType",PropName="OutDamageType",bOutput=true))
}