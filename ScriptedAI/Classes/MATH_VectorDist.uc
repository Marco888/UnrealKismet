Class MATH_VectorDist extends MATH_VECTORBASE;

var() vector ValueA,ValueB;
var VAR_Vector InValueA,InValueB;
var SVariableBase OutValue;
var transient vector TempV;

var() bool bDistance2D; // Skip Z axis?

function ReceiveEvent( byte Index )
{
	if( InValueA!=None )
		ValueA = InValueA.Value;
	if( InValueB!=None )
		ValueB = InValueB.Value;
	if( OutValue!=None )
	{
		if( bDistance2D )
		{
			TempV = ValueA-ValueB;
			TempV.Z = 0;
			OutValue.SetFloat(VSize(TempV));
		}
		else OutValue.SetFloat(VSize(ValueA-ValueB));
	}
	SendEvent(0);
}

defaultproperties
{
	MenuName="Distance"
	Description="Get distance of 2 vectors"
	DrawColor=(R=86,G=32,B=210)
	
	VarLinks.Add((Name="A",PropName="InValueA",bInput=true))
	VarLinks.Add((Name="B",PropName="InValueB",bInput=true))
	VarLinks.Add((Name="Output",PropName="OutValue",bOutput=true))
}