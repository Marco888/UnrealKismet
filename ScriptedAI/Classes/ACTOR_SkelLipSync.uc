Class ACTOR_SkelLipSync extends SKELBASE;

var() Sound Sound;
var() float SoundPitch,SoundVolume,SoundRadius;
var() bool bNetworkToClient; // Should play this voiceline locally only, or if true, network to all players.

var VAR_OBJECT_BASE InActor,InSound;

function ReceiveEvent( byte Index )
{
	local int i,l;

	if( !InActor )
		Warn("No input actor?");
	else
	{
		if( InSound )
			Sound = Sound(InSound.GetObject());

		l = InActor.GetArraySize();
		for( i=0; i<l; ++i )
			StartLipSync(Sound, Actor(InActor.GetObjectAt(i)));
	}
	SendEvent(0);
}

simulated function StartLipSync( Sound Snd, Actor A )
{
	local IK_LipSync S;
	local Actor_SkeletalLipSync Sk;
	
	if( !Snd || !A || A.bDeleteMe || (A.bIsPawn && Pawn(A).Health<=0) )
		return;
	
	if( Level.NetMode!=NM_DedicatedServer )
	{
		S = IK_LipSync(A.GetIKSolver(Class'IK_LipSync'));
		if( S )
			S.StartLIPSyncTrack(Snd,SoundPitch);
		A.PlaySound(Snd,SLOT_Talk,SoundVolume,,SoundRadius,SoundPitch);
	}
	if( bNetworkToClient && Level.NetMode!=NM_Client && (Level.NetMode!=NM_StandAlone || Level.bIsDemoRecording) )
	{
		// Make sure they don't overlap if many start rapidly.
		foreach A.ChildActors(Class'Actor_SkeletalLipSync',Sk)
			Sk.Destroy();
		
		Sk = A.Spawn(class'Actor_SkeletalLipSync',A);
		Sk.Handle = Self;
		Sk.SoundFX = Snd;
	}
}

defaultproperties
{
	MenuName="Play LipSync"
	Description="Play a lipsync animation on an actor."
	DrawColor=(R=128,G=200,B=68)
	
	SoundPitch=1
	SoundVolume=1
	SoundRadius=1000
	bNetworkToClient=true

	VarLinks.Add((Name="Actor",PropName="InActor",bInput=true))
	VarLinks.Add((Name="Sound",PropName="InSound",bInput=true))
}