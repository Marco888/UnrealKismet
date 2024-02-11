Class EVENT_ActorSpawned extends EVENTBASE;

var() class<Actor> MetaClass;
var() export editinline FILTER_BASE Filter;

var Actor_ActorNotify Listen;
var SVariableBase OutActor;

var() bool bStartupEnabled; // Start event as enabled, otherwise must fire Enable input.
var() bool bExactClass; // Only call output if the actor class is exact.

function BeginPlay()
{
	Listen = Level.Spawn(class'Actor_ActorNotify');
	if( Listen )
	{
		Listen.SpawnCallback = Self;
		if( !MetaClass )
			MetaClass = class'Actor';
		Listen.ActorClass = MetaClass;
		if( bStartupEnabled )
			Listen.Linkup();
	}
}

function ReceiveEvent( byte Index )
{
	if( Listen )
	{
		if( Index==0 )
			Listen.Linkup();
		else Listen.Unlink();
	}
}

final function NotifySpawned( Actor Other )
{
	if( (bExactClass && Other.Class!=MetaClass) || (Filter && Filter.ShouldFilter(Other)) )
		return;
	if( OutActor )
		OutActor.SetObject(Other);
	SendEvent(0);
}

event OnPropertyChange( name Property, name ParentProperty )
{
	if( Property=='MetaClass' )
	{
		if( MetaClass )
			PostInfoText = string(MetaClass.Name);
		else PostInfoText = "";
	}
}

defaultproperties
{
	MenuName="Actor spawned"
	Description="Triggered when an actor spawns.|Caution: A lot of these events could effect performance|(keep them disabled when not actively in use)."
	DrawColor=(R=125,G=211,B=25)
	bRequestBeginPlay=true
	
	InputLinks.Add("Enable")
	InputLinks.Add("Disable")

	VarLinks.Add((Name="Actor",PropName="OutActor",bOutput=true))
}