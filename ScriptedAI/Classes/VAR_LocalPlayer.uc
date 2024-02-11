Class VAR_LocalPlayer extends VAR_OBJECT_BASE;

event GetToolbar( out array<string> Entries );

event string GetInfo()
{
	return "";
}

function string GetValue()
{
	local PlayerPawn P;
	
	P = Level.GetLocalPlayerPawn();
	return (P!=None) ? P.GetPointerName() : "None";
}
function Object GetObject()
{
	return Level.GetLocalPlayerPawn();
}

defaultproperties
{
	MenuName="Local Player"
	bConstant=true
	DrawColor=(R=200,G=0,B=200)
	Description="Local player variable function"
	bRequestBeginPlay=false
}