Class LEVEL_SendEvent extends LEVELSBASE;

var() name Event;

var SVariableBase InEvent,InActor,InInstigator;

function ReceiveEvent( byte Index )
{
	local Actor A;
	local Pawn I;
	
	if( InEvent!=None )
		Event = StringToName(InEvent.GetValue());
	if( InActor!=None )
		A = Actor(InActor.GetObject());
	if( InInstigator!=None )
		I = Pawn(InInstigator.GetObject());
	if( A==None )
		A = Trigger;

	switch( Index )
	{
	case 0:
		Level.TriggerEvent(Event,A,I);
		break;
	default:
		Level.UnTriggerEvent(Event,A,I);
	}
	SendEvent(0);
}

event OnPropertyChange( name Property, name ParentProperty )
{
	if( Property=='Event' )
	{
		if( Event!='' )
			PostInfoText = string(Event);
		else PostInfoText = "";
	}
}

defaultproperties
{
	MenuName="Trigger Event"
	Description="Send a regular event to all actors in level"
	bClientAction=true
	DrawColor=(R=138,G=32,B=100)

	VarLinks.Add((Name="Event",PropName="InEvent",bInput=true))
	VarLinks.Add((Name="Actor",PropName="InActor",bInput=true))
	VarLinks.Add((Name="Instigator",PropName="InInstigator",bInput=true))

	InputLinks(0)="Trigger"
	InputLinks(1)="UnTrigger"
}