Class ACTOR_GetPosition extends ACTORBASE;

var VAR_OBJECT_BASE InActor;
var VAR_Vector OutLocation,OutVecRotation,OutVelocity;
var VAR_Rotator OutRotation;

var() bool bEyeLocation; // If Actor is a pawn, grab eye position rather then real location.
var() bool bViewRotation; // If Actor is a player, grab view rotation instead of real rotation.

function ReceiveEvent( byte Index )
{
	local Actor A;

	if( InActor==None )
		Warn("No input actor?");
	else
	{
		A = Actor(InActor.GetObject());
		if( A!=None )
		{
			if( OutLocation!=None )
			{
				if( bEyeLocation && A.bIsPawn )
				{
					if( PlayerPawn(A)!=None )
						OutLocation.Value = PlayerPawn(A).CalcCameraLocation;
					else OutLocation.Value = A.Location+vect(0,0,1)*Pawn(A).EyeHeight;
				}
				else OutLocation.Value = A.Location;
			}
			if( bViewRotation && PlayerPawn(A)!=None )
			{
				if( OutVecRotation!=None )
					OutVecRotation.Value = vector(PlayerPawn(A).ViewRotation);
				if( OutRotation!=None )
					OutRotation.Value = PlayerPawn(A).ViewRotation;
			}
			else
			{
				if( OutVecRotation!=None )
					OutVecRotation.Value = vector(A.Rotation);
				if( OutRotation!=None )
					OutRotation.Value = A.Rotation;
			}
			if( OutVelocity!=None )
				OutVelocity.Value = A.Velocity;
		}
	}
	SendEvent(0);
}

defaultproperties
{
	MenuName="Get Location"
	Description="Grab Actor location and rotation"
	bClientAction=true
	DrawColor=(R=180,G=200,B=85)

	VarLinks.Add((Name="Actor",PropName="InActor",bInput=true))
	VarLinks.Add((Name="Location",PropName="OutLocation",bOutput=true))
	VarLinks.Add((Name="VecRotation",PropName="OutVecRotation",bOutput=true))
	VarLinks.Add((Name="Rotation",PropName="OutRotation",bOutput=true))
	VarLinks.Add((Name="Velocity",PropName="OutVelocity",bOutput=true))
}