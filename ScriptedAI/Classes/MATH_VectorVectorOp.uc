Class MATH_VectorVectorOp extends MATH_VECTORBASE;

var() enum VVOperator
{
	VV_Add,
	VV_Subtract,
	VV_Multiply,
} VOperator;
var() vector ValueA,ValueB;
var VAR_Vector InValueA,InValueB,OutValue;

function ReceiveEvent( byte Index )
{
	if( OutValue==None )
		Warn("No output?");
	else
	{
		if( InValueA!=None )
			ValueA = InValueA.Value;
		if( InValueB!=None )
			ValueB = InValueB.Value;
		
		switch( VOperator )
		{
		case VV_Add:
			OutValue.Value = ValueA+ValueB;
			break;
		case VV_Subtract:
			OutValue.Value = ValueA-ValueB;
			break;
		case VV_Multiply:
			OutValue.Value = ValueA*ValueB;
			break;
		}
	}
	SendEvent(0);
}

event OnPropertyChange( name Property, name ParentProperty )
{
	if( Property=='VOperator' )
	{
		switch( VOperator )
		{
		case VV_Add:
			PostInfoText = "A+B";
			break;
		case VV_Subtract:
			PostInfoText = "A-B";
			break;
		case VV_Multiply:
			PostInfoText = "A*B";
			break;
		}
	}
}

defaultproperties
{
	MenuName="Vector Vector op"
	Description="Do a math operation with vector and vector"
	DrawColor=(R=200,G=68,B=68)
	PostInfoText="A+B"
	
	VarLinks.Add((Name="A",PropName="InValueA",bInput=true))
	VarLinks.Add((Name="B",PropName="InValueB",bInput=true))
	VarLinks.Add((Name="Output",PropName="OutValue",bOutput=true))
}