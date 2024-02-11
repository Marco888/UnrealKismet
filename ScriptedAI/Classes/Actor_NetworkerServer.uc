Class Actor_NetworkerServer extends ReplicationInfo
	transient;

var PlayerPawn PlayerOwner;

function PostBeginPlay()
{
	PlayerOwner = PlayerPawn(Owner);
	if( !PlayerOwner )
		Destroy();
	else SetTimer(0.25+(FRand()*0.25),true);
}

function Timer()
{
	if( !PlayerOwner || PlayerOwner.bDeleteMe || !PlayerOwner.Player )
		Destroy();
}

reliable server final function ServerEvent( LEVEL_NetworkToServer Callback, optional string s, optional int i, optional float f, optional vector v, optional Object obj )
{
	if( !Callback )
		return;
	if( Callback.InString )
		Callback.InString.SetValue(s);
	if( Callback.InInt )
		Callback.InInt.SetInt(i);
	if( Callback.InFloat )
		Callback.InFloat.SetFloat(f);
	if( Callback.InVector )
		Callback.InVector.Value = v;
	if( Callback.InObject )
		Callback.InObject.SetObject(obj);
	if( Callback.OutPlayer )
		Callback.OutPlayer.SetObject(PlayerOwner);
	Callback.SendEvent(1);
}

defaultproperties
{
	RemoteRole=ROLE_SimulatedProxy
	bSkipActorReplication=true
	bAlwaysRelevant=false
	bOnlyOwnerRelevant=true
}