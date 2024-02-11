Class LEVEL_Network extends LEVELSBASE;

var string NetString;
var int NetInt;
var float NetFloat;
var vector NetVector;
var Object NetObject;
var() bool bPersistent; // Keep networking the data to all new players who join in aswell.

var VAR_OBJECT_BASE InReceiver,InObject;
var SVariableBase InString,InInt,InFloat;
var VAR_Vector InVector;

var Actor_Networker ActiveNetwork;

function Reset()
{
	if( ActiveNetwork!=None )
	{
		ActiveNetwork.Destroy();
		ActiveNetwork = None;
	}
}
function ReceiveEvent( byte Index )
{
	local PlayerPawn P;
	local int i,l;

	if( Level.NetMode==NM_StandAlone || Level.NetMode==NM_Client ) // Ignore if this is fired clientside or lone player game.
	{
		SendEvent(0);
		return;
	}
	if( InString!=None )
		NetString = InString.GetValue();
	if( InInt!=None )
		NetInt = InInt.GetInt();
	if( InFloat!=None )
		NetFloat = InFloat.GetFloat();
	if( InVector!=None )
		NetVector = InVector.Value;
	if( InObject!=None )
		NetObject = InObject.GetObject();
	
	if( InReceiver==None )
		SetupNetwork(None);
	else if( InReceiver.bIsArray )
	{
		l = InReceiver.GetArraySize();
		
		for( i=0; i<l; ++i )
		{
			P = PlayerPawn(InReceiver.GetObjectAt(i));
			if( P!=None && NetConnection(P.Player)!=None )
				SetupNetwork(P);
		}
	}
	else
	{
		P = PlayerPawn(InReceiver.GetObject());
		if( P!=None && NetConnection(P.Player)!=None )
			SetupNetwork(P);
	}

	SendEvent(0);
	NetObject = None; // Avoid dangling actors references.
}
final function SetupNetwork( PlayerPawn Rec )
{
	local Actor_Networker N;
	
	if( Rec==None )
	{
		if( ActiveNetwork!=None )
		{
			ActiveNetwork.bImpulse = !ActiveNetwork.bImpulse;
			N = ActiveNetwork;
		}
		else
		{
			N = Level.Spawn(class'Actor_Networker');
			N.bAlwaysRelevant = true;
			N.Handler = Self;
			
			if( bPersistent )
				ActiveNetwork = N;
			else N.LifeSpan = 0.5;
		}
	}
	else
	{
		N = Level.Spawn(class'Actor_Networker',Rec);
		N.Handler = Self;
		N.LifeSpan = 0.5;
	}
	
	if( InString!=None )
		N.NetStr = NetString;
	if( InInt!=None )
		N.NetInt = NetInt;
	if( InFloat!=None )
		N.NetFloat = NetFloat;
	if( InVector!=None )
		N.NetVector = NetVector;
	if( InObject!=None )
		N.NetObject = NetObject;
}

function Impulse( Actor_Networker N )
{
	if( InString!=None )
		InString.SetValue(N.NetStr);
	if( InInt!=None )
		InInt.SetInt(N.NetInt);
	if( InFloat!=None )
		InFloat.SetFloat(N.NetFloat);
	if( InVector!=None )
		InVector.Value = N.NetVector;
	if( InObject!=None )
		InObject.SetObject(N.NetObject);
	SendEvent(1);
}

static event string GetUIName( bool bGroupName )
{
	if( bGroupName )
		return "Network";
	return Super.GetUIName(bGroupName);
}

defaultproperties
{
	MenuName="Network to Client"
	Description="Transmit data from server to client.|All inputs you set will also output on client side and fire output event client side everytime you fire input serverside.|If no receiver is specified, the networked event will be broadcasted to all clients."
	bClientAction=true
	DrawColor=(R=0,G=120,B=12)
	
	OutputLinks(1)="Client"

	VarLinks.Add((Name="Receiver",PropName="InReceiver",bInput=true))
	VarLinks.Add((Name="NetString",PropName="InString",bInput=true,bOutput=true))
	VarLinks.Add((Name="NetInt",PropName="InInt",bInput=true,bOutput=true))
	VarLinks.Add((Name="NetFloat",PropName="InFloat",bInput=true,bOutput=true))
	VarLinks.Add((Name="NetVector",PropName="InVector",bInput=true,bOutput=true))
	VarLinks.Add((Name="NetObject",PropName="InObject",bInput=true,bOutput=true))
}