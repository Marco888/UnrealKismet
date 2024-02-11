Class TEXT_AddText extends TEXTBASE;

var() string TextLine,AddedText;
var SVariableBase InLine,InAdd,OutLine;

function ReceiveEvent( byte Index )
{
	local string S;
	
	if( OutLine==None )
	{
		Warn("Tried to add text with no output?");
		SendEvent(0);
		return;
	}
	if( InLine!=None )
		S = InLine.GetValue();
	else S = TextLine;
	
	if( InAdd!=None )
		S = S$InAdd.GetValue();
	else S = S$AddedText;

	OutLine.SetValue(S);
	SendEvent(0);
}

defaultproperties
{
	MenuName="Append Text"
	Description="Add text to the end of current textline"
	DrawColor=(R=225,G=100,B=138)
	
	VarLinks.Add((Name="TextLine",PropName="InLine",bInput=true))
	VarLinks.Add((Name="AddedText",PropName="InAdd",bInput=true))
	VarLinks.Add((Name="Output",PropName="OutLine",bOutput=true))
}