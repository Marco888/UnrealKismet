Class ACTOR_PlaySound extends ACTORBASE;

var() Actor.ESoundSlot SoundSlot;
var() Sound Sound;
var() float Radius,Volume,Pitch;
var() bool bNoNetwork; // Do not network this sound effect to clients if played on server.

var VAR_OBJECT_BASE InSound;
var SVariableBase InSource,InRadius,InVolume,InPitch;

function ReceiveEvent( byte Index )
{
	local Actor A;
	local int l,i;
	
	// Quick sanity check.
	if( bNoNetwork && Level.NetMode==NM_DedicatedServer )
	{
		SendEvent(0);
		return;
	}
	
	if( InSource==None )
		Warn("No sound source!");
	else
	{
		if( InSound!=None )
		{
			if( InSound.bIsArray )
			{
				l = InSound.GetArraySize();
				Sound = Sound(InSound.GetObjectAt(Rand(l)));
			}
			else Sound = Sound(InSound.GetObject());
		}
		if( InRadius!=None )
			Radius = InRadius.GetFloat();
		if( InVolume!=None )
			Volume = InVolume.GetFloat();
		if( InPitch!=None )
			Pitch = InPitch.GetFloat();
		if( Sound!=None && Radius>10 )
		{
			if( VAR_Vector(InSource)!=None )
				PlaySoundVect(VAR_Vector(InSource).Value);
			else
			{
				l = InSource.GetArraySize();
				if( l>1 )
				{
					for( i=0; i<l; ++i )
					{
						A = Actor(InSource.GetObjectAt(i));
						if( A!=None )
							PlaySound(A);
					}
				}
				else
				{
					A = Actor(InSource.GetObject());
					if( A!=None )
						PlaySound(A);
				}
			}
		}
	}
	SendEvent(0);
}

simulated final function SimPlaySound( Actor A )
{
	A.PlaySound(Sound,SoundSlot,Volume,,Radius,Pitch);
}
final function PlaySound( Actor A )
{
	if( bNoNetwork )
		SimPlaySound(A);
	else A.PlaySound(Sound,SoundSlot,Volume,,Radius,Pitch);
}
final function PlaySoundVect( vector V )
{
	local int i;
	local vector Parameters;
	local Pawn P;
	local PlayerPawn PP;

	i = Rand(10000)*16 + SoundSlot*2;
	Parameters.X = 100 * Volume;
	Parameters.Y = Radius;
	Parameters.Z = 100 * Pitch;

	if( Level.NetMode==NM_Client || Level.NetMode==NM_StandAlone || bNoNetwork )
	{
		// Called from a simulated function, so propagate locally only.
		PP = Level.GetLocalPlayerPawn();
		if( VSize(PP.CalcCameraLocation-V)<Radius )
			PP.ClientHearSound(None, i, Sound, V, Parameters);
	}
	else
	{
		// Propagate to all player actors.
		for( P=Level.PawnList; P!=None; P=P.NextPawn )
		{
			if( P.bIsPlayer )
			{
				PP = PlayerPawn(P);
				if( PP!=None && PP.Player!=None && VSize(PP.CalcCameraLocation-V)<Radius )
					PP.ClientHearSound(None, i, Sound, V, Parameters);
			}
		}
	}
}

event OnPropertyChange( name Property, name ParentProperty )
{
	if( Property=='Sound' )
	{
		if( Sound!=None )
			PostInfoText = string(Sound.Name);
		else PostInfoText = "";
	}
}

defaultproperties
{
	MenuName="Play Sound"
	Description="Play sound effect.|Sound source can be an actor or a vector. If actor array, it will play the sound on all actors in that array."
	DrawColor=(R=255,G=48,B=58)
	bClientAction=true
	
	Radius=1600
	Volume=1
	Pitch=1

	OutputLinks(0)="Out"

	VarLinks.Add((Name="Sound",PropName="InSound",bInput=true))
	VarLinks.Add((Name="Source",PropName="InSource",bInput=true))
	VarLinks.Add((Name="Radius",PropName="InRadius",bInput=true))
	VarLinks.Add((Name="Volume",PropName="InVolume",bOutput=true))
	VarLinks.Add((Name="Pitch",PropName="InPitch",bOutput=true))
}