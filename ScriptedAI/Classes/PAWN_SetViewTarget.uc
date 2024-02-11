Class PAWN_SetViewTarget extends PAWNBASE;

var() bool bScreenFlash; // Flash to black when switching view.
var() bool bInterpolateIn; // Should interpolate into the new viewtarget.
var() bool bInterpolateOut; // Should interpolate out of the viewtarget when ViewDuration expires.
var() bool bSplineInterpolation; // Interpolation should be spline curved.
var() bool bNoInterpolateWall; // Don't interpolate if a wall is blocking between viewtarget and view source.
var() float ViewDuration; // How long should player be looking at the new view target (0 = as long until another action switches it).
var() float InterpolationTime; // If view should interpolate to the desired view target.

var VAR_OBJECT_BASE InPlayer,InTarget;

function ReceiveEvent( byte Index )
{
	local int i,l;
	local PlayerPawn P;
	local Actor A;
	local Actor_ViewInterpolate V;

	if( !InPlayer )
		Warn("No input player?");
	else
	{
		if( InTarget )
			A = Actor(InTarget.GetObject());
		l = InPlayer.GetArraySize();
		for( i=0; i<l; ++i )
		{
			P = PlayerPawn(InPlayer.GetObjectAt(i));
			if( P && P.Health>0 )
			{
				if( bInterpolateIn && P.ViewTarget!=A && InterpolationTime>0.f && (!bNoInterpolateWall || P.FastTrace(P.CalcCameraLocation,(bool(A) ? A.Location : P.Location))) )
				{
					foreach P.ChildActors(Class'Actor_ViewInterpolate',V)
						V.Destroy();
					V = P.Spawn(class'Actor_ViewInterpolate',P);
					if( V )
						V.SetViewTarget(Self,A);
					else P.ViewTarget = A;
				}
				else
				{
					foreach P.ChildActors(Class'Actor_ViewInterpolate',V)
						V.Destroy();
					P.ViewTarget = A;
				}
				
				P.bBehindView = false;
				if( bScreenFlash )
					P.ClientFlash(-1.5f,vect(0,0,0));
				
				if( ViewDuration>0.f && A )
					P.SetTimer(ViewDuration,false,'OnRestoreView',Self);
				else ClearTimers(P); // Prevent other viewtarget actions from messing with this.
			}
		}
	}
	SendEvent(0);
}
function OnRestoreView( Actor Other )
{
	local Actor_ViewInterpolate V;
	
	if( Other && !Other.bDeleteMe && Other.bIsPlayerPawn && Pawn(Other).Health>0 )
	{
		if( bScreenFlash )
			PlayerPawn(Other).ClientFlash(-1.5f,vect(0,0,0));
		
		if( bInterpolateOut && InterpolationTime>0.f && (!bNoInterpolateWall || Other.FastTrace(PlayerPawn(Other).CalcCameraLocation,Other.Location)) )
		{
			V = Other.Spawn(class'Actor_ViewInterpolate',Other);
			if( V )
				V.SetViewTarget(Self,None);
			else PlayerPawn(Other).ViewTarget = None;
		}
		else PlayerPawn(Other).ViewTarget = None;
	}
}
final function ClearTimers( PlayerPawn Other )
{
	local int i;
	
	i = Other.MultiTimers.Find(Func,'OnRestoreView');
	if( i>=0 )
		Other.SetTimer(0.f,false,'OnRestoreView',Other.MultiTimers[i].Object);
}

defaultproperties
{
	MenuName="Set ViewTarget"
	Description="Change player viewtarget.|Empty viewtarget = switch to first person view."
	DrawColor=(R=232,G=238,B=55)
	
	bSplineInterpolation=true

	VarLinks.Add((Name="Player",PropName="InPlayer",bInput=true))
	VarLinks.Add((Name="ViewTarget",PropName="InTarget",bInput=true))
}