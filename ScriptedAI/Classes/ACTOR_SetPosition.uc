Class ACTOR_SetPosition extends ACTORBASE;

var VAR_OBJECT_BASE InActor;
var VAR_Vector InLocation,InVelocity;
var VAR_Rotator InRotation;

var() bool bNoTelefrag; // Don't allow players to telefrag other players with this.
var() bool bAddVelocity; // Add the velocity onto the actor.

function ReceiveEvent( byte Index )
{
	local int i,l;

	if( InActor==None )
		Warn("No input actor?");
	else if( InActor.bIsArray )
	{
		l = InActor.GetArraySize();
		for( i=0; i<l; ++i )
			SetPosition(Actor(InActor.GetObjectAt(i)));
	}
	else SetPosition(Actor(InActor.GetObject()));
	SendEvent(0);
}

final function SetPosition( Actor A )
{
	local bool bA,bB;

	if( A!=None )
	{
		if( InLocation!=None )
		{
			if( bNoTelefrag && A.bIsPawn )
			{
				bA = A.bBlockActors;
				bB = A.bBlockPlayers;
				A.bBlockActors = false;
				A.bBlockPlayers = false;
				A.SetLocation(InLocation.Value);
				A.bBlockActors = bA;
				A.bBlockPlayers = bB;
			}
			else A.SetLocation(InLocation.Value);
		}
		if( InRotation!=None )
		{
			if( A.bIsPawn )
				Pawn(A).ClientSetRotation(InRotation.Value);
			else A.SetRotation(InRotation.Value);
		}
		if( InVelocity!=None )
		{
			if( bAddVelocity )
			{
				if( A.bIsPawn )
					Pawn(A).AddVelocity(InVelocity.Value);
				else A.Velocity += InVelocity.Value;
			}
			else A.Velocity = InVelocity.Value;
		}
	}
}

defaultproperties
{
	MenuName="Set Location"
	Description="Change Actor location and/or rotation"
	DrawColor=(R=180,G=200,B=85)
	bNoTelefrag=true

	VarLinks.Add((Name="Actor",PropName="InActor",bInput=true))
	VarLinks.Add((Name="Location",PropName="InLocation",bInput=true))
	VarLinks.Add((Name="Rotation",PropName="InRotation",bInput=true))
	VarLinks.Add((Name="Velocity",PropName="InVelocity",bInput=true))
}