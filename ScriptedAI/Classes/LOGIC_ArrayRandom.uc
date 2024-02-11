Class LOGIC_ArrayRandom extends LOGICBASE;

var VAR_OBJECTARRAY_BASE InList;
var SVariableBase OutObject;

var() bool bPopItem; // Remove the item after it has been picked from the list.

function ReceiveEvent( byte Index )
{
	local int i;
	local Object O;

	if( InList!=None )
		i = InList.GetArraySize();
	if( i>0 )
	{
		i = Rand(i);
		O = InList.GetObjectAt(i);
		if( bPopItem )
			InList.RemoveObjectAt(i);
		if( OutObject!=None )
			OutObject.SetObject(O);
		SendEvent(0);
	}
	else SendEvent(1);
}

defaultproperties
{
	MenuName="Array Random"
	Description="Pick a random item from a list"
	bClientAction=true
	DrawColor=(R=100,G=125,B=138)
	
	OutputLinks(0)="Out"
	OutputLinks(1)="Empty"

	VarLinks.Add((Name="InList",PropName="InList",bInput=true,bOutput=true))
	VarLinks.Add((Name="Object",PropName="OutObject",bOutput=true))
}