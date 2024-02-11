Class EVENT_INPUTBASE extends EVENTBASE
	abstract;

var transient Actor_Interaction Interaction;
var transient EVENT_INPUTBASE NextCallback;

var SVariableBase InBlockKey;

var() bool bEnabled; // Start enabled.
var() bool bBlockKey; // Block the key from sending engine command (you can change the bool input before end of tick to override this)?

function BeginPlay()
{
	InitInput();
}
function PostLoadGame()
{
	InitInput();
}

function ReceiveEvent( byte Index )
{
	if( bEnabled==(Index==0) ) return;

	bEnabled = !bEnabled;
	if( bEnabled )
		Interaction.EnableKey(Self);
	else Interaction.DisableKey(Self);
}

final function InitInput()
{
	local Viewport V;
	local WindowConsole W;
	
	if( Level.NetMode==NM_DedicatedServer ) return;

	foreach AllObjects(class'Viewport',V)
	{
		W = WindowConsole(V.Console);
		if( W!=None )
		{
			Interaction = Actor_Interaction(W.FindInteraction(class'Actor_Interaction',true));
			break;
		}
	}
	if( Interaction==None )
		Warn("Interaction couldn't be created, event is broken!");
	else if( bEnabled )
		Interaction.EnableKey(Self);
}

function bool OnProcessInput( byte Key, byte Action, float Delta )
{
	return false;
}

defaultproperties
{
	MenuName="Input"
	bRequestBeginPlay=true
	bEnabled=true
	
	InputLinks(0)="Enable"
	InputLinks(1)="Disable"
	
	VarLinks.Add((Name="BlockKey",PropName="InBlockKey",bInput=true))
}