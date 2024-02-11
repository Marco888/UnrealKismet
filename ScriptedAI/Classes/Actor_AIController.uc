Class Actor_AIController extends KismetInfoBase
	NoUserCreate;

var ScriptedPawn AI;
var Actor Goal;
var LATENT_MoveToActor Callback;
var LATENT_AIAnimation AnimCallback;
var byte NumReps;
var float OldFrame;
var int NumTries;
var bool bWalk;

function Tick( float Delta )
{
	if( AI==None || AI.bDeleteMe || AI.Health<=0 )
	{
		Destroy();
		return;
	}

	if( Callback!=None )
	{
		if( bWalk )
		{
			if( (AI.OrderObject!=Goal && AI.MoveTarget!=Goal) || (AI.MoveTarget==Goal && AI.Acceleration==vect(0,0,0) && VSize2DSq(AI.Location-Goal.Location)<Square(50.f)) || !AI.IsInState('Roaming') )
			{
				if( AI.Enemy==None )
					AI.GotoState('Waiting');
				else AI.GotoState('Attacking');
				if( VSize2DSq(AI.Location-Goal.Location)<Square(50.f) )
					FinishedMove(0);
				else if( --NumTries>=0 )
				{
					AI.OrderObject = Goal;
					AI.numHuntPaths = 0;
					AI.GoToState('Roaming','Roam');
				}
				else
				{
					FinishedMove(1);
				}
			}
			else AI.bSpecialGoal = true; // Keep moving.
		}
		else if( AI.AlarmTag=='' || AI.OrderObject!=Goal )
		{
			if( VSize2DSq(AI.Location-Goal.Location)<Square(50.f) )
				FinishedMove(0);
			else if( --NumTries>=0 )
			{
				AI.OrderObject = Goal;
				AI.AlarmTag = Goal.Tag;
				AI.bNoWait = true;
				AI.GoToState('TriggerAlarm');
			}
			else FinishedMove(1);
		}
		else if( AI.IsInState('AlarmPaused') )
			AI.GoToState('TriggerAlarm');
	}
	else
	{
		if( AI.AnimSequence!=AnimCallback.Animation || !AI.IsAnimating() )
			FinishedAnim();
		else if( AI.AnimFrame<OldFrame )
		{
			if( NumReps==0 )
				FinishedAnim();
			else --NumReps;
		}
		OldFrame = AI.AnimFrame;
	}
}

final function FinishedMove( byte Result )
{
	Destroy();
	if( Callback.OutActor!=None )
		Callback.OutActor.SetObject(AI);
	Callback.SendEvent(Result);
}
final function FinishedAnim()
{
	Destroy();
	if( AnimCallback.OutActor!=None )
		AnimCallback.OutActor.SetObject(AI);
	AnimCallback.SendEvent(0);
}

defaultproperties
{
	RemoteRole=ROLE_None
}