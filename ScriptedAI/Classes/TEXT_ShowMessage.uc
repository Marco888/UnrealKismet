Class TEXT_ShowMessage extends TEXTBASE;

var() enum EMsgType
{
	MSG_Event,
	MSG_EventRed,
	MSG_Say,
	MSG_TeamSay,
	MSG_Console,
	MSG_CriticalEvent,
	MSG_LowCriticalEvent,
	MSG_RedCriticalEvent,
	MSG_Pickup,
} MessageType;
var() string TextLine;
var() bool bBeep; // Play a message beep? (this flag is skipped with Say/TeamSay)
var() bool bRequireSender; // Don't send message if no sender was acquired

var SVariableBase InLine,InSender;
var VAR_OBJECT_BASE InReceiver;

function ReceiveEvent( byte Index )
{
	local string S;
	local name N;
	local Pawn P;
	local PlayerReplicationInfo PRI;
	local Actor A;
	local int i,l;
	
	if( InSender!=None )
	{
		A = Actor(InSender.GetObject());
		if( A!=None )
		{
			if( A.bIsPawn )
				PRI = Pawn(A).PlayerReplicationInfo;
			else if( A.Instigator!=None )
				PRI = A.Instigator.PlayerReplicationInfo;
			else PRI = PlayerReplicationInfo(A);
		}
	}
	if( bRequireSender && PRI==None )
	{
		SendEvent(0);
		return;
	}

	if( InLine!=None )
		S = InLine.GetValue();
	else S = TextLine;
	
	switch( MessageType )
	{
	case MSG_Event:
		N = 'Event';
		break;
	case MSG_EventRed:
		N = 'DeathMessage';
		break;
	case MSG_Say:
		N = 'Say';
		break;
	case MSG_TeamSay:
		N = 'TeamSay';
		break;
	case MSG_Console:
		N = 'Log';
		break;
	case MSG_CriticalEvent:
		N = 'CriticalEvent';
		break;
	case MSG_LowCriticalEvent:
		N = 'LowCriticalEvent';
		break;
	case MSG_RedCriticalEvent:
		N = 'RedCriticalEvent';
		break;
	default:
		N = 'Pickup';
	}
	
	if( InReceiver==None )
	{
		for( P=Level.PawnList; P!=None; P=P.NextPawn )
		{
			if( P.bIsPlayer )
			{
				if( N=='Say' || N=='TeamSay' )
					P.TeamMessage(PRI,S,N);
				else P.ClientMessage(S,N,bBeep);
			}
		}
	}
	else if( InReceiver.bIsArray )
	{
		l = InReceiver.GetArraySize();
		for( i=0; i<l; ++i )
		{
			P = Pawn(InReceiver.GetObjectAt(i));
			if( P!=None && P.bIsPlayer )
			{
				if( N=='Say' || N=='TeamSay' )
					P.TeamMessage(PRI,S,N);
				else P.ClientMessage(S,N,bBeep);
			}
		}
	}
	else
	{
		P = Pawn(InReceiver.GetObject());
		if( P!=None && P.bIsPlayer )
		{
			if( N=='Say' || N=='TeamSay' )
				P.TeamMessage(PRI,S,N);
			else P.ClientMessage(S,N,bBeep);
		}
	}
	
	SendEvent(0);
}

defaultproperties
{
	MenuName="Show Message"
	Description="Show a client message on screen.|If no receiver is specified, everyone will receive the message."
	DrawColor=(R=225,G=100,B=138)
	
	VarLinks.Add((Name="TextLine",PropName="InLine",bInput=true))
	VarLinks.Add((Name="Receiver",PropName="InReceiver",bInput=true))
	VarLinks.Add((Name="Sender",PropName="InSender",bInput=true))
}