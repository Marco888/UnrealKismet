Class LOGIC_GetArraySize extends LOGICBASE;

var() int CompareSize; // Compare value for size comparsion outputs.
var VAR_OBJECTARRAY_BASE InArray;
var SVariableBase OutSize;

function ReceiveEvent( byte Index )
{
	local int i;
	
	if( InArray==None )
		Warn("No input array?");
	else
	{
		i = InArray.GetArraySize();
		if( OutSize!=None )
			OutSize.SetInt(i);

		if( i>CompareSize )
			SendEvent(1);
		else SendEvent(2);
	}
	SendEvent(0);
}

defaultproperties
{
	MenuName="Get Array Size"
	Description="Check the size of an object array"
	bClientAction=true
	DrawColor=(R=168,G=122,B=168)

	OutputLinks(0)="Out"
	OutputLinks(1)="Ar>Comp"
	OutputLinks(2)="Ar<=Comp"
	
	VarLinks.Add((Name="Array",PropName="InArray",bInput=true))
	VarLinks.Add((Name="OutSize",PropName="OutSize",bOutput=true))
}