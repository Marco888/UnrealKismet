Class LEVEL_PlayMusic extends LEVELSBASE;

var() Music Song;
var() byte SongSection;
var() Actor.EMusicTransition SongTransition;
var() bool bNoRestart; // Don't restart the music if its already playing.
var() bool bChangeDefaultSong; // Change the music that starts for newly connected clients.

var VAR_OBJECT_BASE InActor;

function ReceiveEvent( byte Index )
{
	local Pawn P;
	local PlayerPawn PP;
	local int l,i;
	
	if( InActor==None )
	{
		if( Level.NetMode==NM_Client || Level.NetMode==NM_StandAlone )
			StartMusic(Level.GetLocalPlayerPawn());
		else
		{
			for( P=Level.PawnList; P!=None; P=P.NextPawn )
			{
				if( P.bIsPlayer )
				{
					PP = PlayerPawn(P);
					if( PP!=None )
						StartMusic(PP);
				}
			}
		}
		
		if( bChangeDefaultSong )
		{
			Level.Song = Song;
			Level.SongSection = SongSection;
		}
	}
	else
	{
		l = InActor.GetArraySize();
		for( i=0; i<l; ++i )
		{
			PP = PlayerPawn(InActor.GetObjectAt(i));
			if( PP!=None )
				StartMusic(PP);
		}
	}
	SendEvent(0);
}

final function StartMusic( PlayerPawn P )
{
	if( P==None || P.Player==None || (bNoRestart && P.Song==Song && P.SongSection==SongSection) )
		return;
	P.ClientSetMusic(Song,SongSection,255,SongTransition);
	P.Song = Song;
	P.SongSection = SongSection;
}

event OnPropertyChange( name Property, name ParentProperty )
{
	if( Property=='Song' )
	{
		if( Song!=None )
			PostInfoText = string(Song.Name);
		else PostInfoText = "";
	}
}

defaultproperties
{
	MenuName="Play Music"
	Description="Change currently played music.|If no player specified, everyone will change music."
	DrawColor=(R=128,G=48,B=200)
	bClientAction=true
	
	bNoRestart=true
	SongTransition=MTRAN_Segue

	VarLinks.Add((Name="Player",PropName="InActor",bInput=true))
}