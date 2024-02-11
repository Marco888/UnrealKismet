Class PAWN_Kill extends PAWNBASE;

var() name DamageType;
var() vector HitOffset; // Instead of HitLocation, this offset is relative to actor location.

var VAR_OBJECT_BASE InActor,InInstigator;
var VAR_Vector InHitLocation;

function ReceiveEvent( byte Index )
{
	local int i,l;
	local Pawn A,P;

	if( InActor==None )
		Warn("No input actor?");
	else
	{
		if( InInstigator!=None )
			P = Pawn(InInstigator.GetObject());
		if( InHitLocation!=None )
			HitOffset = InHitLocation.Value;

		l = InActor.GetArraySize();
		for( i=0; i<l; ++i )
		{
			A = Pawn(InActor.GetObjectAt(i));
			if( A!=None && A.Health>0 )
			{
				if( InHitLocation!=None )
					A.Died(P,DamageType,HitOffset);
				else A.Died(P,DamageType,A.Location+HitOffset);
			}
		}
	}
	SendEvent(0);
}

defaultproperties
{
	MenuName="Kill Pawn"
	Description="Instantly kill a pawn"
	DrawColor=(R=156,G=8,B=32)

	VarLinks.Add((Name="Actor",PropName="InActor",bInput=true))
	VarLinks.Add((Name="Instigator",PropName="InInstigator",bInput=true))
	VarLinks.Add((Name="HitLocation",PropName="InHitLocation",bInput=true))
}