Class PAWN_DeleteItem extends PAWNBASE;

var() class<Inventory> ItemClass;
var VAR_OBJECT_BASE InActor;

function ReceiveEvent( byte Index )
{
	local Pawn P;
	local Inventory Inv;
	local int i,l;
	local bool bFound;

	if( InActor==None )
		Warn("No input actor?");
	else
	{
		l = InActor.GetArraySize();
		for( i=0; i<l; ++i )
		{
			P = Pawn(InActor.GetObjectAt(i));
			if( P!=None )
			{
				Inv = P.FindInventoryType(ItemClass);
				if( Inv!=None )
				{
					Inv.Destroy();
					bFound = true;
				}
			}
		}
	}
	if( bFound )
		SendEvent(0);
	else SendEvent(1);
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
	MenuName="Delete Item"
	Description="Find and delete an inventory item from a player"
	DrawColor=(R=255,G=0,B=0)
	
	OutputLinks(0)="Found"
	OutputLinks(1)="Not Found"

	VarLinks.Add((Name="Pawn",PropName="InActor",bInput=true))
}