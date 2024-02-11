Class LOGIC_CompareInt extends LOGICBASE;

var() int ValueA,ValueB;
var SVariableBase InValueA,InValueB;

function ReceiveEvent( byte Index )
{
	if( InValueA!=None )
		ValueA = InValueA.GetInt();
	if( InValueB!=None )
		ValueB = InValueB.GetInt();

	if( ValueA==ValueB )
		SendEvent(0);
	else SendEvent(1);

	if( ValueA>ValueB )
		SendEvent(2);
	if( ValueA<ValueB )
		SendEvent(3);
}

defaultproperties
{
	MenuName="Compare Int"
	Description="Compare 2 integers"
	bClientAction=true
	DrawColor=(R=88,G=142,B=25)

	OutputLinks(0)="A==B"
	OutputLinks(1)="A!=B"
	OutputLinks(2)="A>B"
	OutputLinks(3)="A<B"

	VarLinks.Add((Name="A",PropName="InValueA",bInput=true))
	VarLinks.Add((Name="B",PropName="InValueB",bInput=true))
}