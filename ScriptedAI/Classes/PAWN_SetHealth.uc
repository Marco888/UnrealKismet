Class PAWN_SetHealth extends PAWNBASE;

var() int AddedHealth;
var() int CustomHealthMax; // Custom health max limit.
var() enum EHealthLimit
{
	HP_NoLimit,
	HP_CustomLimit,
	HP_HealthMax,
	HP_SuperHealthMax,
} HealthLimit;

var VAR_OBJECT_BASE InActor;
var SVariableBase InHealth,OutHealth;

function ReceiveEvent( byte Index )
{
	local int i,l,x;
	local Pawn P;

	if( InActor==None )
		Warn("No input actor?");
	else
	{
		if( InHealth!=None )
			AddedHealth = InHealth.GetInt();

		l = InActor.GetArraySize();
		for( i=0; i<l; ++i )
		{
			P = Pawn(InActor.GetObjectAt(i));
			if( P!=None && P.Health>0 )
			{
				if( AddedHealth>0 )
				{
					switch( HealthLimit )
					{
					case HP_NoLimit:
						x = 99999999;
						break;
					case HP_CustomLimit:
						x = CustomHealthMax;
						break;
					case HP_HealthMax:
						x = P.Default.Health;
						break;
					default:
						x = P.Default.Health*2;
					}
					if( P.Health<x )
						P.Health = Min(P.Health+AddedHealth,x);
				}
				else P.Health = Max(P.Health+AddedHealth,1);
				
				if( OutHealth!=None )
					OutHealth.SetInt(P.Health);
			}
		}
	}
	SendEvent(0);
}

defaultproperties
{
	MenuName="Give Health"
	Description="Give or remove health from pawn."
	DrawColor=(R=25,G=240,B=25)
	CustomHealthMax=100
	HealthLimit=HP_HealthMax

	VarLinks.Add((Name="Pawn",PropName="InActor",bInput=true))
	VarLinks.Add((Name="Health",PropName="InHealth",bInput=true))
	VarLinks.Add((Name="OutHealth",PropName="OutHealth",bOutput=true))
}