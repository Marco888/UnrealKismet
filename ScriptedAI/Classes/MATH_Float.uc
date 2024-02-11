Class MATH_Float extends MATHBASE;

var() enum EFOperator
{
	FF_Add,
	FF_Subtract,
	FF_Multiply,
	FF_Division,
	FF_Modulo,
	FF_Sin,
	FF_Cos,
	FF_Min,
	FF_Max,
} FOperator;
var() float ValueA,ValueB;
var SVariableBase InValueA,InValueB,OutValue;

function ReceiveEvent( byte Index )
{
	local float F;

	if( OutValue==None )
		Warn("No output?");
	else
	{
		if( InValueA!=None )
			ValueA = InValueA.GetFloat();
		if( InValueB!=None )
			ValueB = InValueB.GetFloat();
		
		switch( FOperator )
		{
		case FF_Add:
			F = ValueA+ValueB;
			break;
		case FF_Subtract:
			F = ValueA-ValueB;
			break;
		case FF_Multiply:
			F = ValueA*ValueB;
			break;
		case FF_Division:
			F = ValueA/ValueB;
			break;
		case FF_Modulo:
			F = ValueA%ValueB;
			break;
		case FF_Sin:
			F = Sin(ValueA);
			break;
		case FF_Cos:
			F = Cos(ValueA);
			break;
		case FF_Min:
			F = FMin(ValueA,ValueB);
			break;
		case FF_Max:
			F = FMax(ValueA,ValueB);
			break;
		}
		OutValue.SetFloat(F);
	}
	SendEvent(0);
}

event OnPropertyChange( name Property, name ParentProperty )
{
	if( Property=='FOperator' )
	{
		switch( FOperator )
		{
		case FF_Add:
			PostInfoText = "A+B";
			break;
		case FF_Subtract:
			PostInfoText = "A-B";
			break;
		case FF_Multiply:
			PostInfoText = "A*B";
			break;
		case FF_Division:
			PostInfoText = "A/B";
			break;
		case FF_Modulo:
			PostInfoText = "A%B";
			break;
		case FF_Sin:
			PostInfoText = "Sin(A)";
			break;
		case FF_Cos:
			PostInfoText = "Cos(A)";
			break;
		case FF_Min:
			PostInfoText = "Min(A,B)";
			break;
		case FF_Max:
			PostInfoText = "Max(A,B)";
			break;
		}
	}
}

defaultproperties
{
	MenuName="Float op"
	Description="Do a math operation with floating point"
	DrawColor=(R=68,G=200,B=68)
	PostInfoText="A+B"
	
	VarLinks.Add((Name="A",PropName="InValueA",bInput=true))
	VarLinks.Add((Name="B",PropName="InValueB",bInput=true))
	VarLinks.Add((Name="Output",PropName="OutValue",bOutput=true))
}