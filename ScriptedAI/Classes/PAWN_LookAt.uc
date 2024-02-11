Class PAWN_LookAt extends PAWNBASE;

var() bool bReturnRotation; // For PLAYER only, return to original rotation after?
var() float LookDuration; // Time duration pawn should be stuck looking at the actor (0 = finish once done rotating)

var VAR_OBJECT_BASE InActor;
var SVariableBase InTarget;

function ReceiveEvent( byte Index )
{
	local int i,l;
	local Pawn P;
	local Actor A;
	local Actor_AILookAt H;
	local rotator R;

	if( InActor==None || InTarget==None )
		Warn("No input actor/target?");
	else
	{
		l = InActor.GetArraySize();
		for( i=0; i<l; ++i )
		{
			P = Pawn(InActor.GetObjectAt(i));
			if( P!=None && P.Health>0 )
			{
				R = P.ViewRotation;
				foreach P.ChildActors(class'Actor_AILookAt',H)
				{
					R = H.OriginalRotation;
					H.Destroy();
					break;
				}
				H = Level.Spawn(class'Actor_AILookAt',P);
				H.Handle = Self;
				H.OriginalRotation = R;
				if( VAR_Rotator(InTarget)!=None )
				{
					H.bLookDirection = true;
					H.LookRotation = VAR_Rotator(InTarget).Value;
				}
				else
				{
					A = Actor(InTarget.GetObject());
					if( A!=None )
					{
						H.LookActor = A;
						H.LookPos = A.Location;
					}
					else H.LookPos = InTarget.GetVector();
				}
			}
		}
	}
	SendEvent(0);
}

defaultproperties
{
	MenuName="Look At"
	Description="Make player/AI look towards a direction/actor/location."
	DrawColor=(R=125,G=200,B=25)

	VarLinks.Add((Name="Pawn",PropName="InActor",bInput=true))
	VarLinks.Add((Name="Target",PropName="InTarget",bInput=true))
}