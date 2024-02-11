Class LATENT_PlayAnim extends LATENTBASE;

var() name Animation;
var() float AnimRate;

var VAR_OBJECT_BASE InActor,OutActor;

function ReceiveEvent( byte Index )
{
	local Actor A;
	local int i,l;

	if( !InActor )
		Warn("No input actor?");
	else
	{
		l = InActor.GetArraySize();
		for( i=0; i<l; ++i )
		{
			A = Actor(InActor.GetObjectAt(i));
			if( A && (!A.bIsPawn || Pawn(A).Health>0) )
			{
				if( A.Mesh && A.HasAnim(Animation) )
					A.PlayAnim(Animation,AnimRate);
				A.SetTimer(A.GetAnimRemainTime(),false,'OnActorTimer',Self);
			}
		}
	}
}

function OnActorTimer( Actor Other )
{
	if( !Other || Other.bDeleteMe )
		return;

	if( OutActor )
		OutActor.SetObject(Other);
	SendEvent(0);
}

event OnPropertyChange( name Property, name ParentProperty )
{
	if( Property=='Animation' )
		PostInfoText = string(Animation);
}

defaultproperties
{
	MenuName="Actor Play Animation"
	Description="Make any actor play an animation and wait for the animation to finish, with OutActor set to the actor that finished the animation. Note that this does not account for interrupted animations."
	DrawColor=(R=148,G=148,B=54)
	
	Animation="All"
	AnimRate=1

	VarLinks.Add((Name="InActor",PropName="InActor",bInput=true))
	VarLinks.Add((Name="OutActor",PropName="OutActor",bOutput=true))
}