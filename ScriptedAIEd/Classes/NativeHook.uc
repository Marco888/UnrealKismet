Class NativeHook extends Object
	native;

#exec Texture Import File=Textures\KismetBackground.pcx Name=KismetBackground Mips=Off UClampMode=UClamp VClampMode=VClamp
#exec Texture Import File=Textures\ArrowTex.bmp Name=K_ArrowTex Mips=Off Flags=2 UClampMode=UClamp VClampMode=VClamp
#exec Texture Import File=Textures\Sphere.bmp Name=K_Sphere Mips=Off Flags=2 UClampMode=UClamp VClampMode=VClamp

#exec obj load file="UWindowFonts"
#exec obj load file="GenFX"

var Font MainFont;
var Texture BgTexture,ArrowTexture,SphereTexture,GroupBGTexture,HaloTexture;
var plane BgColor;

static native final function ShowEdWindow();

defaultproperties
{
	MainFont=Font'Tahoma12'
	ArrowTexture=Texture'K_ArrowTex'
	SphereTexture=Texture'K_Sphere'
	HaloTexture=Texture'GenFX.LensFlar.Dot_B'
	BgTexture=Texture'KismetBackground'
	BgColor=(X=0.61569,Y=0.61569,Z=0.61569,W=1.0)
	
	Begin Object Class=ConstantColor Name=KismetGroupBg
		Color1=(R=60,G=85,B=106,A=255)
	End Object
	GroupBGTexture=KismetGroupBg
}