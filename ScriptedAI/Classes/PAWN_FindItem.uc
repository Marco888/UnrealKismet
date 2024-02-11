Class PAWN_FindItem extends PAWNBASE;

var() class<Inventory> ItemClass;
var VAR_OBJECT_BASE InActor,OutInventory;

function ReceiveEvent( byte Index )
{
	local Pawn P;
	local Inventory I;

	if( InActor==None )
		Warn("No input actor?");
	else
	{
		P = Pawn(InActor.GetObject());
		if( P!=None )
		{
			I = P.FindInventoryType(ItemClass);
			if( I!=None )
			{
				if( OutInventory!=None )
					OutInventory.SetObject(I);
				SendEvent(0);
				return;
			}
		}
	}
	if( OutInventory!=None )
		OutInventory.SetObject(None);
	SendEvent(1);
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
	MenuName="Find Item"
	Description="Find an inventory item from a player"
	DrawColor=(R=220,G=200,B=25)
	
	OutputLinks(0)="Found"
	OutputLinks(1)="Not Found"

	VarLinks.Add((Name="Pawn",PropName="InActor",bInput=true))
	VarLinks.Add((Name="Inv",PropName="OutInventory",bOutput=true))
}