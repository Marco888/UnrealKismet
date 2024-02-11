Class LOGIC_CompareFloat extends LOGICBASE;

var() float ValueA,ValueB;
var SVariableBase InValueA,InValueB;

function ReceiveEvent( byte Index )
{
	if( InValueA!=None )
		ValueA = InValueA.GetFloat();
	if( InValueB!=None )
		ValueB = InValueB.GetFloat();

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
	MenuName="Compare Float"
	Description="Compare 2 floating points"
	bClientAction=true
	DrawColor=(R=88,G=25,B=142)

	OutputLinks(0)="A==B"
	OutputLinks(1)="A!=B"
	OutputLinks(2)="A>B"
	OutputLinks(3)="A<B"

	VarLinks.Add((Name="A",PropName="InValueA",bInput=true))
	VarLinks.Add((Name="B",PropName="InValueB",bInput=true))
}