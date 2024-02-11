class HUD_DrawText extends HUDElementBase;

var() string Message;
var() color TextColor;
var() font FontType;
var() float XPosition,YPosition; // Position relative to screen size.
var() byte TextAlignmentX,TextAlignmentY; // Alignment is: 0=left, 1=center, 2=right
var() Actor.ERenderStyle TextStyle;
var() float DrawTime; // 0 = inifinite.
var() bool bFadeOut;

var SVariableBase InMessage;

function ReceiveEvent( byte Index )
{
	if( InMessage!=None )
		Message = InMessage.GetValue();
	Super.ReceiveEvent(Index);
}

function InitReplication( ClientDrawHUD Other )
{
	Other.LifeSpan = DrawTime;
	Other.RepText = Message;
}

simulated function DrawHUDFX( Canvas C, ClientDrawHUD Other )
{
	local float A,XS,YS;

	if( !Other.bHasInit )
		Other.LifeSpan = DrawTime;
	C.Font = FontType;
	if( bFadeOut && DrawTime>0 )
	{
		A = FClamp((Other.LifeSpan / DrawTime),0.f,1.f);
		if( TextStyle==STY_AlphaBlend )
		{
			C.DrawColor = TextColor;
			C.DrawColor.A = TextColor.A * A;
		}
		else
		{
			C.DrawColor.R = TextColor.R * A;
			C.DrawColor.G = TextColor.G * A;
			C.DrawColor.B = TextColor.B * A;
		}
	}
	else C.DrawColor = TextColor;
	C.Style = TextStyle;

	C.TextSize(Other.RepText,XS,YS);
	switch( TextAlignmentX )
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
	switch( TextAlignmentY )
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
	C.DrawText(Other.RepText);
}

defaultproperties
{
	MenuName="Draw Text"
	Description="Draw a message on HUD."
	
	TextColor=(R=80,G=255,B=80,A=255)
	TextStyle=STY_Translucent
	FontType=Font'WhiteFont'
	XPosition=0.5
	YPosition=0.25
	TextAlignmentX=1
	TextAlignmentY=1
	DrawTime=6
	bFadeOut=true

	VarLinks.Add((Name="Text",PropName="InMessage",bInput=true))
}