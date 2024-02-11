class HUD_DrawIcon extends HUDElementBase;

var() Texture IconTexture;
var() color IconColor;
var() float XPosition,YPosition; // Position relative to screen size.
var() float UVStart[2],UVEnd[2]; // Draw which pixels of the texture.
var() float XSize,YSize; // If size is less then 1, it will be relative to screen resolution, otherwise it will be this many pixels.
var() byte AlignmentX,AlignmentY; // Alignment is: 0=left, 1=center, 2=right
var() Actor.ERenderStyle IconStyle;
var() float DrawTime; // 0 = inifinite.
var() bool bFadeOut;
var() bool bUniformSize; // If true, both X and Y size will be scaled by XSize.

var SVariableBase InTexture;

function ReceiveEvent( byte Index )
{
	if( InTexture!=None )
		IconTexture = Texture(InTexture.GetObject());
	Super.ReceiveEvent(Index);
}

function InitReplication( ClientDrawHUD Other )
{
	Other.LifeSpan = DrawTime;
	Other.Texture = IconTexture;
}

simulated function DrawHUDFX( Canvas C, ClientDrawHUD Other )
{
	local float A,XS,YS;
	local Texture Tex;

	if( !Other.bHasInit )
		Other.LifeSpan = DrawTime;
	Tex = Other.Texture;
	if( Tex==None ) return;

	// Setup draw color.
	if( bFadeOut && DrawTime>0 )
	{
		A = FClamp((Other.LifeSpan / DrawTime),0.f,1.f);
		if( IconStyle==STY_AlphaBlend )
		{
			C.DrawColor = IconColor;
			C.DrawColor.A = IconColor.A * A;
		}
		else
		{
			C.DrawColor.R = IconColor.R * A;
			C.DrawColor.G = IconColor.G * A;
			C.DrawColor.B = IconColor.B * A;
		}
	}
	else C.DrawColor = IconColor;
	C.Style = IconStyle;

	// Get draw size.
	if( bUniformSize )
	{
		if( XSize<=1.f )
			XS = C.ClipX*XSize;
		else XS = XSize;
		YS = XS * Abs((UVEnd[1]*Tex.VSize)/(UVEnd[0]*Tex.USize));
	}
	else
	{
		if( XSize<=1.f )
			XS = C.ClipX*XSize;
		else XS = XSize;

		if( YSize<=1.f )
			YS = C.ClipY*YSize;
		else YS = YSize;
	}
	
	// Setup position.
	switch( AlignmentX )
	{
	case 0:
		C.CurX = XPosition*C.ClipX;
		break;
	case 1:
		C.CurX = XPosition*C.ClipX-(XS/2.f);
		break;
	default:
		C.CurX = XPosition*C.ClipX-XS;
	}
	switch( AlignmentY )
	{
	case 0:
		C.CurY = YPosition*C.ClipY;
		break;
	case 1:
		C.CurY = YPosition*C.ClipY-(YS/2.f);
		break;
	default:
		C.CurY = YPosition*C.ClipY-YS;
	}
	C.DrawTile(Tex,XS,YS,UVStart[0]*Tex.USize,UVStart[1]*Tex.VSize,UVEnd[0]*Tex.USize,UVEnd[1]*Tex.VSize);
}

defaultproperties
{
	MenuName="Draw Icon"
	Description="Draw an icon on HUD."
	
	IconTexture=Texture'DefaultTexture'
	IconColor=(R=255,G=255,B=255,A=255)
	IconStyle=STY_Normal
	XPosition=0.5
	YPosition=0.25
	AlignmentX=1
	AlignmentY=1
	DrawTime=6
	XSize=0.25
	YSize=0.25
	UVEnd(0)=1
	UVEnd(1)=1
	bUniformSize=true

	VarLinks.Add((Name="Texture",PropName="InTexture",bInput=true))
}