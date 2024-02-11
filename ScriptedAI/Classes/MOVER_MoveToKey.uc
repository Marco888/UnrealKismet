Class MOVER_MoveToKey extends MOVERBASE;

var() byte KeyNum;
var() float MoveTime;
var() bool bPlaySound,bStartAmbientSound; // Play opening/closing sounds and ambient sound.
var bool bDidOpen;

var VAR_OBJECT_BASE InMover;
var SVariableBase InKeyNum,InMoveTime;
var float MoveTimeRemain;

function ReceiveEvent( byte Index )
{
	local int i,l;
	local Mover M;

	if( InMover==None )
		Warn("No input mover?");
	else
	{
		if( InKeyNum!=None )
			KeyNum = InKeyNum.GetInt();
		if( InMoveTime!=None )
			MoveTime = InMoveTime.GetFloat();

		l = InMover.GetArraySize();
		for( i=0; i<l; ++i )
		{
			M = Mover(InMover.GetObjectAt(i));
			if( M!=None )
			{
				if( bPlaySound )
				{
					bDidOpen = (M.PrevKeyNum<KeyNum);
					if( bDidOpen )
						M.PlaySound( M.OpeningSound, SLOT_None );
					else M.PlaySound( M.ClosingSound, SLOT_None );
				}
				if( bStartAmbientSound )
					M.AmbientSound = M.MoveAmbientSound;
				M.InterpolateTo(KeyNum,MoveTime);
				M.PrevKeyNum = KeyNum; // Don't keep moving to next keyframe.
				MoveTimeRemain = MoveTime;
				SetEnableTick(true);
			}
		}
	}
	if( !bTickEnabled ) // Failsafe.
		SendEvent(0);
}

function Tick( float Delta )
{
	if( (MoveTimeRemain-=Delta)<=0 )
		MoveFinished();
}

function MoveFinished()
{
	local int i,l;
	local Mover M;

	l = InMover.GetArraySize();
	for( i=0; i<l; ++i )
	{
		M = Mover(InMover.GetObjectAt(i));
		if( M!=None )
		{
			if( bPlaySound )
			{
				if( bDidOpen )
					M.PlaySound( M.OpenedSound, SLOT_None );
				else M.PlaySound( M.ClosedSound, SLOT_None );
			}
			if( bStartAmbientSound )
				M.AmbientSound = None;
		}
	}

	SetEnableTick(false);
	SendEvent(0);
}

defaultproperties
{
	MenuName="Move to key"
	Description="Move a mover to a keyframe (output waits til the mover is finished)."
	DrawColor=(R=88,G=245,B=5)
	bRequestTick=true
	
	bPlaySound=true
	bStartAmbientSound=true
	MoveTime=1

	VarLinks.Add((Name="Mover",PropName="InMover",bInput=true))
	VarLinks.Add((Name="KeyNum",PropName="InKeyNum",bInput=true))
	VarLinks.Add((Name="MoveTime",PropName="InMoveTime",bInput=true))
}