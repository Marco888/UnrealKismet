Class LOGIC_ListIterator extends LOGICBASE;

var VAR_OBJECTARRAY_BASE InList;
var SVariableBase OutObject;

var() export editinline FILTER_BASE ObjectFilter;

function ReceiveEvent( byte Index )
{
	local int i,l;
	local Object O;

	if( InList!=None )
		l = InList.GetArraySize();
	for( i=0; i<l; ++i )
	{
		O = InList.GetObjectAt(i);
		if( O!=None && (Actor(O)==None || !Actor(O).bDeleteMe) && (ObjectFilter==None || !ObjectFilter.ShouldFilter(O)) )
		{
			OutObject.SetObject(O);
			SendEvent(0);
		}
	}
	OutObject.SetObject(None);
	SendEvent(1);
}

defaultproperties
{
	MenuName="ObjList Iterator"
	Description="Iterate through object list"
	bClientAction=true
	DrawColor=(R=138,G=75,B=138)

	VarLinks.Add((Name="InList",PropName="InList",bInput=true))
	VarLinks.Add((Name="Object",PropName="OutObject",bOutput=true))

	OutputLinks(0)="Loop"
	OutputLinks(1)="Finished"
}