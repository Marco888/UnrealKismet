Class TEXT_Replace extends TEXTBASE;

var() string TextLine,ReplaceText,With;
var SVariableBase InLine,InWith,OutLine;
var() bool bCaseInsenstive;

function ReceiveEvent( byte Index )
{
	local string S;
	
	if( OutLine==None )
	{
		Warn("Tried to replace text with no output?");
		SendEvent(0);
		return;
	}
	if( InLine!=None )
		S = InLine.GetValue();
	else S = TextLine;
	
	if( InWith!=None )
		With = InWith.GetValue();

	S = ReplaceStr(S,ReplaceText,With,bCaseInsenstive);
	
	OutLine.SetValue(S);
	SendEvent(0);
}

defaultproperties
{
	MenuName="Replace Text"
	Description="Replace a part of text with text"
	DrawColor=(R=220,G=128,B=138)
	
	ReplaceText="%s"
	
	VarLinks.Add((Name="TextLine",PropName="InLine",bInput=true))
	VarLinks.Add((Name="With",PropName="InWith",bInput=true))
	VarLinks.Add((Name="Output",PropName="OutLine",bOutput=true))
}