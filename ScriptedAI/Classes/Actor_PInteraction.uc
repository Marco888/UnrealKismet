Class Actor_PInteraction extends PlayerInteraction;

var bool bRequestForward,bWalkMove;

event bool PlayerTick( float DeltaTime )
{
	PlayerOwner.aMouseX = 0;
	PlayerOwner.aMouseY = 0;
	PlayerOwner.aStrafe = 0;
	PlayerOwner.aTurn = 0;
	PlayerOwner.aForward = 0;
	PlayerOwner.aLookUp = 0;
	PlayerOwner.aBaseX = 0;
	PlayerOwner.bZoom = 0;
	PlayerOwner.bRun = byte(bWalkMove);
	PlayerOwner.bLook = 0;
	PlayerOwner.bDuck = 0;
	PlayerOwner.bStrafe = 0;
	PlayerOwner.bPressedJump = false;
	PlayerOwner.bFire = 0;
	PlayerOwner.bAltFire = 0;
	PlayerOwner.bJustFired = false;
	PlayerOwner.bJustAltFired = false;
	
	if( bRequestForward )
		PlayerOwner.aBaseY = 1000;
	else PlayerOwner.aBaseY = 0;
	return false;
}

defaultproperties
{
	bPlayerTick=true
	Priority=10
}