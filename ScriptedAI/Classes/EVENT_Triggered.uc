Class EVENT_Triggered extends EVENTBASE;

var() name ExpectedTag;
var SVariableBase NewTag,OutActor,OutInstigator;

var Actor_EventListen Listen;

function BeginPlay()
{
	Listen = Level.Spawn(class'Actor_EventListen',,ExpectedTag);
	Listen.Callback = Self;
}
function ReceiveEvent( byte Index )
{
	Listen.Tag = StringToName(NewTag.GetValue());
}

event OnPropertyChange( name Property, name ParentProperty )
{
	if( Property=='ExpectedTag' )
	{
		if( ExpectedTag!='' )
			PostInfoText = string(ExpectedTag);
		else PostInfoText = "";
	}
}

defaultproperties
{
	MenuName="Triggered"
	Description="Triggered by a regular in level event.|Tag can be changed by firing Set Tag event and binding NewTag value."
	DrawColor=(R=140,G=48,B=100)
	bRequestBeginPlay=true
	
	VarLinks.Add((Name="NewTag",PropName="NewTag",bInput=true))
	VarLinks.Add((Name="Actor",PropName="OutActor",bOutput=true))
	VarLinks.Add((Name="Instigator",PropName="OutInstigator",bOutput=true))

	InputLinks.Add("Set Tag")
	OutputLinks(0)="Trigger"
	OutputLinks(1)="UnTrigger"
}