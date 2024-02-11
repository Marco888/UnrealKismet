Class EVENT_PawnPrevDeath extends EVENTBASE;

var EVENT_PawnPrevDeath NextCallback;

var() export editinline FILTER_BASE VictimFilter;
var SVariableBase OutKilled,OutKiller,OutDamageType,InPrevent;

var Actor_GameRules Listen;

function BeginPlay()
{
	Listen = class'Actor_GameRules'.Static.GetRules(Level);
	if( Listen!=None )
	{
		NextCallback = Listen.PreventCallback;
		Listen.PreventCallback = Self;
		Listen.bHandleDeaths = true;
	}
}

function bool PreventDeath( Pawn Dying, Pawn Killer, name DamageType )
{
	if( VictimFilter==None || !VictimFilter.ShouldFilter(Dying) )
	{
		if( OutKilled!=None )
			OutKilled.SetObject(Dying);
		if( OutKiller!=None )
			OutKiller.SetObject(Killer);
		if( OutDamageType!=None )
			OutDamageType.SetValue(string(DamageType));
		SendEvent(0);
		if( InPrevent!=None && InPrevent.GetBool() )
			return true;
	}
	return false;
}

defaultproperties
{
	MenuName="Prevent Death"
	Description="Prevent a pawn from dying.|NOTE: Output link is fired, AFTER that it checks Input flag if true, then prevents pawn from dying."
	DrawColor=(R=128,G=0,B=24)
	bRequestBeginPlay=true
	
	VarLinks.Add((Name="Killed",PropName="OutKilled",bOutput=true))
	VarLinks.Add((Name="Killer",PropName="OutKiller",bOutput=true))
	VarLinks.Add((Name="DamageType",PropName="OutDamageType",bOutput=true))
	VarLinks.Add((Name="Input",PropName="InPrevent",bInput=true))
}