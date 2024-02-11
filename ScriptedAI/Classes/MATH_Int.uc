Class MATH_Int extends MATHBASE;

var() enum EIOperator
{
	II_Add,
	II_Subtract,
	II_Multiply,
	II_Division,
	II_LShift,
	II_RShift,
	II_And,
	II_Or,
	II_XOr,
	II_Not,
	II_Min,
	II_Max,
} IOperator;
var() int ValueA,ValueB;
var SVariableBase InValueA,InValueB,OutValue;

function ReceiveEvent( byte Index )
{
	local int i;

	if( OutValue==None )
		Warn("No output?");
	else
	{
		if( InValueA!=None )
			ValueA = InValueA.GetInt();
		if( InValueB!=None )
			ValueB = InValueB.GetInt();
		
		switch( IOperator )
		{
		case II_Add:
			i = ValueA+ValueB;
			break;
		case II_Subtract:
			i = ValueA-ValueB;
			break;
		case II_Multiply:
			i = ValueA*ValueB;
			break;
		case II_Division:
			i = ValueA/ValueB;
			break;
		case II_LShift:
			i = ValueA<<ValueB;
			break;
		case II_RShift:
			i = ValueA>>ValueB;
			break;
		case II_And:
			i = ValueA & ValueB;
			break;
		case II_Or:
			i = ValueA | ValueB;
			break;
		case II_XOr:
			i = ValueA ^ ValueB;
			break;
		case II_Not:
			i = ~ValueA;
			break;
		case II_Min:
			i = Min(ValueA,ValueB);
			break;
		case II_Max:
			i = Max(ValueA,ValueB);
			break;
		}
		OutValue.SetInt(i);
	}
	SendEvent(0);
}

event OnPropertyChange( name Property, name ParentProperty )
{
	if( Property=='IOperator' )
	{
		switch( IOperator )
		{
		case II_Add:
			PostInfoText = "A+B";
			break;
		case II_Subtract:
			PostInfoText = "A-B";
			break;
		case II_Multiply:
			PostInfoText = "A*B";
			break;
		case II_Division:
			PostInfoText = "A/B";
			break;
		case II_LShift:
			PostInfoText = "A<<B";
			break;
		case II_RShift:
			PostInfoText = "A>>B";
			break;
		case II_And:
			PostInfoText = "A&B";
			break;
		case II_Or:
			PostInfoText = "A|B";
			break;
		case II_XOr:
			PostInfoText = "A^B";
			break;
		case II_Not:
			PostInfoText = "~A";
			break;
		case II_Min:
			PostInfoText = "Min(A,B)";
			break;
		case II_Max:
			PostInfoText = "Max(A,B)";
			break;
		}
	}
}

defaultproperties
{
	MenuName="Int op"
	Description="Do a math operation with integers"
	DrawColor=(R=68,G=220,B=55)
	PostInfoText="A+B"
	
	VarLinks.Add((Name="A",PropName="InValueA",bInput=true))
	VarLinks.Add((Name="B",PropName="InValueB",bInput=true))
	VarLinks.Add((Name="Output",PropName="OutValue",bOutput=true))
}