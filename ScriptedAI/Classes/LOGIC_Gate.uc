Class LOGIC_Gate extends LOGICBASE;

var() enum EGateType
{
	GATE_And,
	GATE_Or,
	GATE_XOr,
} GateType;
var() bool ValueA,ValueB;
var SVariableBase InValueA,InValueB;

function ReceiveEvent( byte Index )
{
	if( InValueA!=None )
		ValueA = InValueA.GetBool();
	if( InValueB!=None )
		ValueB = InValueB.GetBool();

	switch( GateType )
	{
	case GATE_And:
		Index = (int(ValueA) & int(ValueB));
		break;
	case GATE_Or:
		Index = (int(ValueA) | int(ValueB));
		break;
	case GATE_XOr:
		Index = (int(ValueA) ^ int(ValueB));
		break;
	}
	SendEvent(1-Index);
}

event OnPropertyChange( name Property, name ParentProperty )
{
	if( Property=='GateType' )
	{
		switch( GateType )
		{
		case GATE_And:
			PostInfoText = "AND";
			break;
		case GATE_Or:
			PostInfoText = "OR";
			break;
		case GATE_XOr:
			PostInfoText = "XOR";
			break;
		}
	}
}

defaultproperties
{
	MenuName="Logic Gate"
	Description="A logic gate"
	bClientAction=true
	DrawColor=(R=66,G=165,B=5)
	PostInfoText="AND"

	OutputLinks(0)="True"
	OutputLinks(1)="False"
	VarLinks.Add((Name="A",PropName="InValueA",bInput=true))
	VarLinks.Add((Name="B",PropName="InValueB",bInput=true))
}