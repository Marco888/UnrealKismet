Class LOGIC_ArrayAdd extends LOGICBASE;

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
		if( O!=None )
		{
			l = InArray.GetArraySize();
			for( i=0; i<l; ++i )
			{
				B = InArray.GetObjectAt(i);
				if( B==None || (Actor(B)!=None && Actor(B).bDeleteMe) )
				{
					InArray.RemoveObjectAt(i--);
					--l;
				}
				else if( O==B )
					break;
			}
			if( i==l )
			{
				InArray.SetArraySize(++l);
				InArray.SetObjectAt(O,i++);
			}
		}
	}
	if( OutSize!=None )
		OutSize.SetInt(l);
	SendEvent(int(i==l));
}

defaultproperties
{
	MenuName="Array Add"
	Description="Add an unique item to array.|Fires event Found or Not Found depending on the result."
	bClientAction=true
	DrawColor=(R=68,G=128,B=168)

	OutputLinks(0)="Found"
	OutputLinks(1)="Not Found"
	
	VarLinks.Add((Name="Object",PropName="InObject",bInput=true))
	VarLinks.Add((Name="Array",PropName="InArray",bInput=true,bOutput=true))
	VarLinks.Add((Name="OutSize",PropName="OutSize",bOutput=true))
}