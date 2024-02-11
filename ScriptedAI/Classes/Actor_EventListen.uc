Class Actor_EventListen extends KismetInfoBase
	NoUserCreate;

var EVENT_Triggered Callback;

event Trigger( Actor Other, Pawn EventInstigator )
{
	if( Callback.OutActor!=None )
		Callback.OutActor.SetObject(Other);
	if( Callback.OutInstigator!=None )
		Callback.OutInstigator.SetObject(Other);
	Callback.SendEvent(0);
}
event UnTrigger( Actor Other, Pawn EventInstigator )
{
	if( Callback.OutActor!=None )
		Callback.OutActor.SetObject(Other);
	if( Callback.OutInstigator!=None )
		Callback.OutInstigator.SetObject(Other);
	Callback.SendEvent(1);
}

defaultproperties
{
	RemoteRole=ROLE_None
}