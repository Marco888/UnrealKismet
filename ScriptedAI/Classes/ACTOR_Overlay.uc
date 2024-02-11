Class ACTOR_Overlay extends ACTORBASE;

var() float Duration; // 0 = infinite
var() nowarn color Color;
var() Texture Texture;
var() float FadeInTime,FadeOutTime; // Time relative to duration.
var() Actor.ERenderStyle Style;
var() int Fatness; // Added fatness
var() float Opacity;
var() bool bMeshEnviroMap,bUnlit;
var() bool bRemoveAllOld; // Remove any underlaying overlay.

var VAR_OBJECT_BASE InActor;

function ReceiveEvent( byte Index )
{
	local int i,l;
	local Actor A;
	local Actor_FX X;
	local bool bFound;

	if( InActor==None )
		Warn("No input actor?");
	else
	{
		l = InActor.GetArraySize();
		for( i=0; i<l; ++i )
		{
			A = Actor(InActor.GetObjectAt(i));
			if( A!=None && A.Mesh!=None && A.DrawType==DT_Mesh )
			{
				if( Index==0 )
				{
					// Check for excisting.
					bFound = false;
					foreach A.ChildActors(class'Actor_FX',X)
					{
						if( X.Handle==Self )
						{
							if( Duration<=0 )
								bFound = true;
							else X.Destroy();
						}
						else if( bRemoveAllOld )
							X.Destroy();
					}
					
					if( Duration<=0 )
					{
						if( bFound )
							continue;
						X = A.Spawn(class'Actor_FX',A);
					}
					else X = A.Spawn(class'Actor_FXTMP',A);
					X.Handle = Self;
					X.OwnerActor = A;
					if( Level.NetMode!=NM_DedicatedServer )
						X.InitFX();
				}
				else
				{
					foreach A.ChildActors(class'Actor_FX',X)
					{
						if( bRemoveAllOld || X.Handle==Self )
							X.Destroy();
					}
				}
			}
		}
	}
	SendEvent(0);
}

defaultproperties
{
	MenuName="Mesh Overlay"
	Description="Add a temporary mesh overlay to an actor"
	DrawColor=(R=200,G=8,B=128)

	Color=(R=255,G=255,B=255,A=255)
	Texture=Texture'DefaultTexture'
	Style=STY_Translucent
	Fatness=1
	bMeshEnviroMap=true
	bUnlit=true
	FadeOutTime=0.5
	Opacity=1
	bRemoveAllOld=true

	InputLinks(0)="Set"
	InputLinks(1)="Remove"
	VarLinks.Add((Name="Actor",PropName="InActor",bInput=true))
}