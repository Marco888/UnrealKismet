Class PAWN_GodMode extends PAWNBASE;

var() float Duration; // How long god mode should be enabled until auto-disabled (0 = unlimited until "off" input is fired).

var VAR_OBJECT_BASE InActor;
var Actor_GameRules Listen;

function BeginPlay()
{
	Listen = class'Actor_GameRules'.Static.GetRules(Level);
}

function ReceiveEvent( byte Index )
{
	local int i,l;
	local Pawn P;

	if( InActor==None )
		Warn("Give weapon to pawn, but no input actor?");
	else
	{
		l = InActor.GetArraySize();
		for( i=0; i<l; ++i )
		{
			P = Pawn(InActor.GetObjectAt(i));
			if( P==None || P.bDeleteMe || P.Health<=0 )
				continue;
			Listen.SetGodMode(P,(Index==0),Duration);
		}
	}
	SendEvent(0);
}

defaultproperties
{
	MenuName="God Mode"
	Description="Give a pawn degreelessness mode"
	DrawColor=(R=240,G=240,B=75)
	bRequestBeginPlay=true
	
	InputLinks(0)="On"
	InputLinks(1)="Off"

	VarLinks.Add((Name="Pawn",PropName="InActor",bInput=true))
}