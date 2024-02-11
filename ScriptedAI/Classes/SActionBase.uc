Class SActionBase extends SObjectBase
	abstract;

struct export FEventLink
{
	var SActionBase Link;
	var byte OutIndex;
	
	var transient int X,Y; // Editor
};

struct export FVariableLink
{
	var() string Name;
	var() name PropName;
	var class<SVariableBase> ExpectedType;
	var SVariableBase Link;
	var bool bOutput,bInput;
	
	// Editor
	var const transient Property LinkedProp;
	var transient int X,Y,Color;
};

var string PostInfoText; // Optional addition info to display in editor.

var(Object) array<string> OutputLinks,InputLinks;
var array<FEventLink> LinkedOutput;

var(Object) array<FVariableLink> VarLinks;

var SActionBase NextTimed;

var const bool bRequestTick; // Controls whetever if trigger actor should be Static or not.
var bool bTickEnabled; // Must default to false!
var bool bClientAction; // Allow to receive events client side.

// Called if bRequestTick is True and SetEnableTick(true) has been called.
function Tick( float Delta );

function ReceiveEvent( byte Index );

// Requires to have bRequestTick true.
final function SetEnableTick( bool bEnable )
{
	local SActionBase S;

	if( bTickEnabled!=bEnable )
	{
		bTickEnabled = bEnable;
		
		if( bEnable )
		{
			NextTimed = Trigger.TickList;
			Trigger.TickList = Self;
			Trigger.Enable('Tick');
		}
		else 
		{
			if( Trigger.TickList==Self )
				Trigger.TickList = NextTimed;
			else
			{
				for( S=Trigger.TickList; S!=None; S=S.NextTimed )
					if( S.NextTimed==Self )
					{
						S.NextTimed = NextTimed;
						break;
					}
			}
			if( Trigger.TickList==None )
				Trigger.Disable('Tick');
			NextTimed = None;
		}
	}
}

final function SendEvent( byte Index )
{
	local SActionBase S;

	if( Trigger.bLogMessages )
		Log("SendEvent "$GetMenuName()$" #"$Index,'ScriptedAI');
	if( (Level.NetMode!=NM_Client || bClientAction) && Index<LinkedOutput.Size() )
	{
		S = LinkedOutput[Index].Link;
		if( S!=None && (Level.NetMode!=NM_Client || S.bClientAction) )
		{
			if( Trigger.bLogMessages )
				Log("ReceiveEvent "$S.GetMenuName(),'ScriptedAI');
			S.ReceiveEvent(LinkedOutput[Index].OutIndex);
		}
	}
}

final function LogEvent( string S )
{
	if( Trigger.bLogMessages )
		Log("Event "$GetMenuName()$": "$S,'ScriptedAI');
}

defaultproperties
{
	ObjType=1
	OutputLinks.Add("Out")
}