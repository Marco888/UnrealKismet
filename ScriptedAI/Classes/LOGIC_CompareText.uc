Class LOGIC_CompareText extends LOGICBASE;

var() string ValueA,ValueB;
var() bool bCaseInsensitive;
var SVariableBase InValueA,InValueB;

function ReceiveEvent( byte Index )
{
	if( InValueA!=None )
		ValueA = InValueA.GetValue();
	if( InValueB!=None )
		ValueB = InValueB.GetValue();

	if( bCaseInsensitive )
	{
		if( ValueA~=ValueB )
			SendEvent(0);
		else SendEvent(1);
	}
	else if( ValueA==ValueB )
		SendEvent(0);
	else SendEvent(1);
}

defaultproperties
{
	MenuName="Compare Text"
	Description="Compare 2 string text lines"
	bClientAction=true
	DrawColor=(R=142,G=25,B=88)

	OutputLinks(0)="A==B"
	OutputLinks(1)="A!=B"

	VarLinks.Add((Name="A",PropName="InValueA",bInput=true))
	VarLinks.Add((Name="B",PropName="InValueB",bInput=true))
}