class SObjectBase extends Object
	abstract;

var(Object) localized string MenuName,Description;

var ScriptedAI Trigger;
var LevelInfo Level;

var SObjectBase NextBeginPlay;

// Editor variables:
var pointer EditData;
var color DrawColor; // Render color of this sequence in browser window.
var int Location[2]; // Position of this property in browser.
var private byte ObjType; // Don't modify!

var const bool bRequestBeginPlay; // Controls wherever if object should receive BeginPlay/PostBeginPlay events.
var bool bReqPostBeginPlay; // Requires to have bRequestBeginPlay aswell.
var transient bool bEditorInit,bEditDirty; // Note, set bEditDirty=true if you change position of this object.
var const bool bContainsActorRef; // This object needs CleanupDestroyed.

function BeginPlay(); // Called if bRequestBeginPlay
function PostBeginPlay(); // Called if bRequestBeginPlay and bReqPostBeginPlay
function PostLoadGame(); // Called if bRequestBeginPlay

function Reset();

final function string GetMenuName()
{
	return "'"$MenuName$" ("$Name$")'";
}

// Editor events:
event OnInitialize(); // Called when first loaded/created in editor.
event OnRemoved(); // Called when this action was removed from the kismet.
static event string GetUIName( bool bGroupName ) // For right-click menu.
{
	return Default.MenuName;
}

final function PlayerPawn Get3DViewport()
{
	local PlayerPawn P,Best;
	
	foreach Level.AllActors(class'PlayerPawn',P)
		if( P.Player )
		{
			if( (P.RendMap>=1 && P.RendMap<=6) || (P.RendMap>=19 && P.RendMap<=20) )
				return P;
			if( P.RendMap>=13 && P.RendMap<=15 )
				Best = P;
		}
	return Best;
}

defaultproperties
{
	DrawColor=(R=255,G=255,B=255,A=255)
}