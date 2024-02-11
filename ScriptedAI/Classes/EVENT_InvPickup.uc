Class EVENT_InvPickup extends EVENTBASE;

var EVENT_InvPickup NextCallback;

var() class<Inventory> ItemClass;
var() export editinline FILTER_BASE PawnFilter,InventoryFilter; // Must pass both filters to trigger output.
var VAR_OBJECT_BASE OutPawn,OutInventory;

var Actor_GameRules Listen;

function BeginPlay()
{
	Listen = class'Actor_GameRules'.Static.GetRules(Level);
	if( Listen!=None )
	{
		NextCallback = Listen.InvCallback;
		Listen.InvCallback = Self;
		Listen.bHandleInventory = true;
	}
}

function NotifyInventory( Pawn Other, Inventory Inv )
{
	if( (ItemClass==None || ClassIsChildOf(Inv.Class,ItemClass)) && (PawnFilter==None || !PawnFilter.ShouldFilter(Other)) && (InventoryFilter==None || !InventoryFilter.ShouldFilter(Inv)) )
	{
		if( OutPawn!=None )
			OutPawn.SetObject(Other);
		if( OutInventory!=None )
			OutInventory.SetObject(Inv);
		SendEvent(0);
	}
}

event OnPropertyChange( name Property, name ParentProperty )
{
	if( Property=='ItemClass' )
	{
		if( ItemClass!=None )
			PostInfoText = string(ItemClass.Name);
		else PostInfoText = "";
	}
}

defaultproperties
{
	MenuName="Get Inventory"
	Description="Triggered when a pawn picks up an inventory item."
	DrawColor=(R=168,G=45,B=4)
	bRequestBeginPlay=true
	
	VarLinks.Add((Name="Pawn",PropName="OutPawn",bOutput=true))
	VarLinks.Add((Name="Inventory",PropName="OutInventory",bOutput=true))
}