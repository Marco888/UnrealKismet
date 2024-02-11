Class OBJECT_ChangeState extends OBJECTBASE;

var() name NewState,NewLabel;
var SVariableBase InActor,InState;

function ReceiveEvent( byte Index )
{
	local Object O;

	if( InActor==None )
		Warn("Set state of none input actor?");
	else
	{
		if( InState!=None )
			NewState = StringToName(InState.GetValue());

		O = InActor.GetObject();
		if( O!=None )
			O.GoToState(NewState,NewLabel);
	}
	SendEvent(0);
}

defaultproperties
{
	MenuName="Change State"
	Description="Change actor script state"
	bClientAction=true
	DrawColor=(R=68,G=55,B=160)

	VarLinks.Add((Name="Actor",PropName="InActor",bInput=true))
	VarLinks.Add((Name="State",PropName="InState",bInput=true))
}