Class PAWN_GiveItem extends PAWNBASE;

var() class<Inventory> ItemClass;
var VAR_OBJECT_BASE InActor;

function ReceiveEvent( byte Index )
{
	local int i,l;

	if( InActor==None )
		Warn("Give weapon to pawn, but no input actor?");
	else if( InActor.bIsArray )
	{
		l = InActor.GetArraySize();
		for( i=0; i<l; ++i )
			GiveItem(Pawn(InActor.GetObjectAt(i)));
	}
	else GiveItem(Pawn(InActor.GetObject()));
	SendEvent(0);
}

final function GiveItem( Pawn P )
{
	local Inventory I;
	local bool bIsPlayer;

	if( P==None || P.Health<=0 || Spectator(P)!=None )
		return;
	
	I = Level.Spawn(ItemClass);
	if( I==None )
		return;
	
	if( Weapon(I)!=None )
		Weapon(I).bWeaponStay = false;
	I.RespawnTime = 0;

	bIsPlayer = P.bIsPlayer;
	P.bIsPlayer = true;
	I.Touch(P);
	P.bIsPlayer = bIsPlayer;
	
	if( I.Owner!=P )
		I.Destroy();
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
	MenuName="Give Item"
	Description="Give an inventory item to a player"
	DrawColor=(R=220,G=240,B=25)

	VarLinks.Add((Name="Pawn",PropName="InActor",bInput=true))
}