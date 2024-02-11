Class LOGIC_ServerType extends LOGICBASE;

function ReceiveEvent( byte Index )
{
	SendEvent(Level.NetMode);
}

defaultproperties
{
	MenuName="Server Type"
	Description="Check in which enviroment this action is executed on"
	bClientAction=true
	DrawColor=(R=168,G=168,B=168)

	OutputLinks(0)="Stand Alone"
	OutputLinks(1)="Dedicated Server"
	OutputLinks(2)="Listen Server"
	OutputLinks(3)="Client"
}