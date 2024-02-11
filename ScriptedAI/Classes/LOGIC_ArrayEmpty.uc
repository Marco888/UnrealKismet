Class LOGIC_ArrayEmpty extends LOGICBASE;

var VAR_OBJECTARRAY_BASE InArray;

function ReceiveEvent( byte Index )
{
	if( InArray==None )
		Warn("No input array or object?");
	else InArray.SetArraySize(0);
	SendEvent(0);
}

defaultproperties
{
	MenuName="Array Empty"
	Description="Simply blank out an array."
	bClientAction=true
	DrawColor=(R=128,G=22,B=16)
	
	VarLinks.Add((Name="Array",PropName="InArray",bInput=true,bOutput=true))
}