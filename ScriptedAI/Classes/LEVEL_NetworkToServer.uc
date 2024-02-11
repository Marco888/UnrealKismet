Class LEVEL_NetworkToServer extends LEVEL_Network;

var transient Actor_NetworkerServer Networker;
var SVariableBase OutPlayer;

function BeginPlay()
{
	if( Level.NetMode!=NM_StandAlone )
		class'Actor_Mutator'.Static.FindMutator(Level);
}

function Reset();

function ReceiveEvent( byte Index )
{
	if( OutPlayer!=None )
		OutPlayer.SetObject(Level.GetLocalPlayerPawn());
	if( Level.NetMode!=NM_Client ) // Ignore this serverside.
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
		
	if( Networker==None )
	{
		foreach Level.AllActors(class'Actor_NetworkerServer',Networker)
			if( Networker.Owner==Level.GetLocalPlayerPawn() )
				break;
		if( Networker==None )
		{
			Warn("No server networker object found!");
			SendEvent(0);
			NetObject = None;
			return;
		}
	}
	
	Networker.ServerEvent(Self,NetString,NetInt,NetFloat,NetVector,NetObject);
	SendEvent(0);
	NetObject = None; // Avoid dangling actors references.
}

defaultproperties
{
	MenuName="Network to Server"
	Description="Transmit data from client to server.|All inputs you set will also output on server side and fire output event server side everytime you fire input serverside.|Sender will be the local player who sent this message."
	DrawColor=(R=0,G=12,B=120)
	bRequestBeginPlay=true
	
	OutputLinks(1)="Server"

	VarLinks.Remove((Name="Receiver",PropName="InReceiver",bInput=true))
	VarLinks.Add((Name="Sender",PropName="OutPlayer",bOutput=true))
}