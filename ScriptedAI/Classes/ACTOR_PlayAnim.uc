Class ACTOR_PlayAnim extends ACTORBASE;

var() name AnimName;
var() float AnimRate,TweenTime;
var() bool bLoopAnim;

var VAR_OBJECT_BASE InActor;
var SVariableBase InName,InRate;

function ReceiveEvent( byte Index )
{
	local int i,l;

	if( InActor==None )
		Warn("No input actor?");
	else
	{
		if( InName!=None )
			AnimName = StringToName(InName.GetValue());
		if( InRate!=None )
			AnimRate = InRate.GetFloat();

		if( InActor.bIsArray )
		{
			l = InActor.GetArraySize();
			for( i=0; i<l; ++i )
				PlayAnim(Actor(InActor.GetObjectAt(i)));
		}
		else PlayAnim(Actor(InActor.GetObject()));
	}
	SendEvent(0);
}

final function PlayAnim( Actor A )
{
	if( A!=None && A.HasAnim(AnimName) )
	{
		if( bLoopAnim )
			A.LoopAnim(AnimName,AnimRate,TweenTime);
		else A.PlayAnim(AnimName,AnimRate,TweenTime);
	}
}

defaultproperties
{
	MenuName="Play Anim"
	Description="Play an animation on actors.|Note: Pawn code may override the animation!"
	DrawColor=(R=88,G=245,B=5)
	
	AnimRate=1

	VarLinks.Add((Name="Actor",PropName="InActor",bInput=true))
	VarLinks.Add((Name="AnimName",PropName="InName",bInput=true))
	VarLinks.Add((Name="AnimRate",PropName="InRate",bInput=true))
}