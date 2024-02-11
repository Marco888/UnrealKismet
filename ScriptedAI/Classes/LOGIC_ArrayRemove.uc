Class LOGIC_ArrayRemove extends LOGICBASE;

var VAR_OBJECTARRAY_BASE InArray;
var VAR_OBJECT_BASE InObject;
var SVariableBase OutSize;

function ReceiveEvent( byte Index )
{
	local int i,l;
	local Object O,B;
	
	if( InArray==None || InObject==None )
		Warn("No input array or object?");
	else
	{
		O = InObject.GetObject();
		l = InArray.GetArraySize();
		for( i=0; i<l; ++i )
		{
			B = InArray.GetObjectAt(i);
			if( B==None || B==O || (Actor(B)!=None && Actor(B).bDeleteMe) )
			{
				InArray.RemoveObjectAt(i--);
				--l;
			}
		}
	}
	if( OutSize!=None )
		OutSize.SetInt(l);
	SendEvent(0);
	if( l==0 )
		SendEvent(1);
}

defaultproperties
{
	MenuName="Array Remove"
	Description="Remove a single item from array and return size.|Empty event is fired once final array entry has been removed."
	bClientAction=true
	DrawColor=(R=68,G=128,B=168)

	OutputLinks(0)="Out"
	OutputLinks(1)="Empty"
	
	VarLinks.Add((Name="Object",PropName="InObject",bInput=true))
	VarLinks.Add((Name="Array",PropName="InArray",bInput=true,bOutput=true))
	VarLinks.Add((Name="OutSize",PropName="OutSize",bOutput=true))
}