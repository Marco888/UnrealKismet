Class LOGIC_CompareBool extends LOGICBASE;

var() bool ValueA,ValueB;
var SVariableBase InValueA,InValueB;

function ReceiveEvent( byte Index )
{
	if( InValueA!=None )
		ValueA = InValueA.GetBool();
	if( InValueB!=None )
		ValueB = InValueB.GetBool();

	if( ValueA==ValueB )
		SendEvent(0);
	else SendEvent(1);
}

defaultproperties
{
	MenuName="Compare Bool"
	Description="Compare a boolean"
	bClientAction=true
	DrawColor=(R=156,G=32,B=32)

	OutputLinks(0)="A==B"
	OutputLinks(1)="A!=B"

	VarLinks.Add((Name="A",PropName="InValueA",bInput=true))
	VarLinks.Add((Name="B",PropName="InValueB",bInput=true))
}