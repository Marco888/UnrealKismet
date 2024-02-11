Class Actor_Networker extends KismetInfoBase
	transient;

var LEVEL_Network Handler;
var string NetStr;
var int NetInt;
var float NetFloat;
var vector NetVector;
var Object NetObject;
var bool bImpulse,bClientImpulse;

replication
{
	unreliable if ( Role==ROLE_Authority )
		Handler,NetStr,NetInt,NetFloat,NetVector,NetObject,bImpulse;
}

simulated function PostNetBeginPlay()
{
	if( Handler!=None )
		Handler.Impulse(Self);
	bClientImpulse = bImpulse;
	bNetNotify = true;
}

simulated function PostNetReceive()
{
	if( bClientImpulse!=bImpulse )
	{
		bClientImpulse = bImpulse;
		if( Handler!=None )
			Handler.Impulse(Self);
	}
}

defaultproperties
{
	RemoteRole=ROLE_SimulatedProxy
	bSkipActorReplication=true
}