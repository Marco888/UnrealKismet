Class LATENT_AIAnimation extends LATENTBASE;

var() name Animation;
var() float AnimRate;
var() byte NumRepeats; // Number of animation loops to play.

var VAR_OBJECT_BASE InActor,OutActor;

function ReceiveEvent( byte Index )
{
	local ScriptedPawn P;
	local int i,l;
	local Actor_AIController A;

	if( InActor==None )
		Warn("No input actor?");
	else
	{
		l = InActor.GetArraySize();
		for( i=0; i<l; ++i )
		{
			P = ScriptedPawn(InActor.GetObjectAt(i));
			if( P!=None && P.Health>0 )
			{
				foreach P.ChildActors(class'Actor_AIController',A)
				{
					A.Destroy();
					break;
				}

				A = Level.Spawn(class'Actor_AIController',P);
				A.AI = P;
				A.NumReps = NumRepeats;
				A.AnimCallback = Self;
				P.GoToState('');
				P.Acceleration = vect(0,0,0);
				P.MoveTimer = -1;
				if( NumRepeats>0 )
					P.LoopAnim(Animation,AnimRate);
				else P.PlayAnim(Animation,AnimRate);
				A.OldFrame = P.AnimFrame;
			}
		}
	}
}

event OnPropertyChange( name Property, name ParentProperty )
{
	if( Property=='Animation' )
		PostInfoText = string(Animation);
}

defaultproperties
{
	MenuName="AI Play Animation"
	Description="Make a ScriptedPawn play an animation and wait for the animation to finish, with Animator set to the pawn that finished the animation."
	DrawColor=(R=148,G=148,B=54)
	
	Animation="All"
	AnimRate=1

	VarLinks.Add((Name="Pawn",PropName="InActor",bInput=true))
	VarLinks.Add((Name="Animator",PropName="OutActor",bOutput=true))
}