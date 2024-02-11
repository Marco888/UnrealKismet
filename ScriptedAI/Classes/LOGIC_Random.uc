Class LOGIC_Random extends LOGIC_Dispatch;

function ReceiveEvent( byte Index )
{
	SendEvent(Rand(NumBranches));
}

defaultproperties
{
	MenuName="Random gate"
	Description="Fire an output at random gate"
}