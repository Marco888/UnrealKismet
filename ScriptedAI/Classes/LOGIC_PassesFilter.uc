Class LOGIC_PassesFilter extends LOGICBASE;

var() export editinline FILTER_BASE Filter;
var VAR_OBJECT_BASE InValue;

function ReceiveEvent( byte Index )
{
	local Object O;
	
	if( InValue==None )
	{
		Warn("No Input?");
		SendEvent(1);
	}
	else if( Filter==None )
	{
		Warn("No Filter?");
		SendEvent(0);
	}
	else
	{
		O = InValue.GetObject();
		if( Filter.ShouldFilter(O) )
			SendEvent(1);
		else SendEvent(0);
	}
}

defaultproperties
{
	MenuName="Passes Filter"
	Description="Check if a single object passes a filter test"
	bClientAction=true
	DrawColor=(R=125,G=65,B=5)

	OutputLinks(0)="Pass"
	OutputLinks(1)="Fail"
	VarLinks.Add((Name="Object",PropName="InValue",bInput=true))
}