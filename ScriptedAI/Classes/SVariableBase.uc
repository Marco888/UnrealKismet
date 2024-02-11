Class SVariableBase extends SObjectBase
	abstract;

var() bool bNoReset; // Don't reset this variable on level soft reset.
var const bool bConstant;

event string GetInfo() // Editor info.
{
	return GetValue();
}
event GetToolbar( out array<string> Entries );
event OnSelectToolbar( int Index );

function string GetValue();
function SetValue( string S );

function bool GetBool()
{
	return bool(GetInt());
}
function SetBool( bool b )
{
	SetInt(int(b));
}

function int GetInt();
function SetInt( int i );

function float GetFloat();
function SetFloat( float f );

function Object GetObject();
function SetObject( Object o );

// Object array
function int GetArraySize()
{
	return 1;
}
function Object GetObjectAt( int Index )
{
	return GetObject();
}
function SetArraySize( int NewSize );
function SetObjectAt( Object o, int Index )
{
	SetObject(o);
}
function RemoveObjectAt( int Index );

// Get location
function vector GetVector()
{
	return vect(0,0,0);
}

defaultproperties
{
	ObjType=2
	MenuName="Variables"
	bRequestBeginPlay=true
}