Class LOGIC_CompareObject extends LOGICBASE;

var() Object ValueA,ValueB;
var SVariableBase InValueA,InValueB;

function ReceiveEvent( byte Index )
{
	local Object A,B;

	if( InValueA!=None )
		A = InValueA.GetObject();
	else A = ValueA;

	if( InValueB!=None )
		B = InValueB.GetObject();
	else B = ValueB;

	if( A==B )
		SendEvent(0);
	else SendEvent(1);
}

defaultproperties
{
	MenuName="Compare Object"
	Description="Compare 2 objects"
	bClientAction=true
	DrawColor=(R=128,G=32,B=156)

	OutputLinks(0)="A==B"
	OutputLinks(1)="A!=B"

	VarLinks.Add((Name="A",PropName="InValueA",bInput=true))
	VarLinks.Add((Name="B",PropName="InValueB",bInput=true))
}