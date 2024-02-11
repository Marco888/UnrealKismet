Class MATH_VectorFloatOp extends MATH_VECTORBASE;

var() enum VFOperator
{
	VF_Multiply,
	VF_Division,
} VOperator;
var() vector ValueA;
var() float ValueB;
var VAR_Vector InValueA,OutValue;
var SVariableBase InValueB;

function ReceiveEvent( byte Index )
{
	if( OutValue==None )
		Warn("No output?");
	else
	{
		if( InValueA!=None )
			ValueA = InValueA.Value;
		if( InValueB!=None )
			ValueB = InValueB.GetFloat();
		
		switch( VOperator )
		{
		case VF_Multiply:
			OutValue.Value = ValueA*ValueB;
			break;
		case VF_Division:
			OutValue.Value = ValueA/ValueB;
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
		case VF_Multiply:
			PostInfoText = "A*B";
			break;
		case VF_Division:
			PostInfoText = "A/B";
			break;
		}
	}
}

defaultproperties
{
	MenuName="Vector Float op"
	Description="Do a math operation with vector and floating point"
	DrawColor=(R=200,G=68,B=68)
	PostInfoText="A*B"
	
	VarLinks.Add((Name="A",PropName="InValueA",bInput=true))
	VarLinks.Add((Name="B",PropName="InValueB",bInput=true))
	VarLinks.Add((Name="Output",PropName="OutValue",bOutput=true))
}