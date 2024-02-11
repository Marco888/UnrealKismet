Class LATENT_MoveToActor extends LATENTBASE;

var VAR_OBJECT_BASE InActor,InGoal,OutActor;
var() int NumTries; // Number of times AI should try to reach the goal before giving up.
var() bool bWalk; // AI will wander to the goal actor (however spotting an enemy will interrupt this)

function ReceiveEvent( byte Index )
{
	local ScriptedPawn P;
	local PlayerPawn PP;
	local int i,l;
	local KismetInfoBase A;
	local Actor Goal;
	local Actor_AIController C;
	local Actor_PlayerController PC;

	if( !InActor )
		Warn("No input actor?");
	else if( !InGoal )
		Warn("No input goal actor?");
	else
	{
		Goal = Actor(InGoal.GetObject());
		if( !Goal )
			return;

		l = InActor.GetArraySize();
		for( i=0; i<l; ++i )
		{
			P = ScriptedPawn(InActor.GetObjectAt(i));
			if( P && P.Health>0 )
			{
				foreach P.ChildActors(class'KismetInfoBase',A)
				{
					if( A.Class==class'Actor_AIController' || A.Class==class'Actor_AILookAt' )
						A.Destroy();
				}

				C = Level.Spawn(class'Actor_AIController',P);
				C.NumTries = NumTries;
				C.AI = P;
				C.Goal = Goal;
				C.Callback = Self;
				C.bWalk = bWalk;
				P.OrderObject = Goal;
				if( Goal.Tag=='' )
					Goal.Tag = Name;
				if( bWalk )
				{
					P.numHuntPaths = 0;
					P.GoToState('Roaming','Roam');
				}
				else
				{
					P.AlarmTag = Goal.Tag;
					P.bNoWait = true;
					P.GoToState('TriggerAlarm');
				}
			}
			else
			{
				PP = PlayerPawn(InActor.GetObjectAt(i));
				if( PP && PP.Health>0 )
				{
					foreach PP.ChildActors(class'KismetInfoBase',A)
					{
						if( A.Class==class'Actor_PlayerController' || A.Class==class'Actor_AILookAt' )
							A.Destroy();
					}
					
					PC = Level.Spawn(class'Actor_PlayerController',PP);
					PC.Callback = Self;
					PC.Goal = Goal;
					PC.bWalk = bWalk;
					PC.NumTries = NumTries;
				}
			}
		}
	}
}

defaultproperties
{
	MenuName="AI Move to actor"
	Description="Make a ScriptedPawn/PlayerPawn move to a goal actor.|Output is fired when a pawn has reached or not the goal actor, with Reached output set to just finished pawn."
	DrawColor=(R=128,G=68,B=165)
	NumTries=3
	
	OutputLinks(0)="Reached"
	OutputLinks(1)="Unreached"

	VarLinks.Add((Name="Pawn",PropName="InActor",bInput=true))
	VarLinks.Add((Name="Goal",PropName="InGoal",bInput=true))
	VarLinks.Add((Name="Reached",PropName="OutActor",bOutput=true))
}