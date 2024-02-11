Class VAR_Int extends SVariableBase;

var() int Value;
var int BACKUP_Value;

function BeginPlay()
{
	BACKUP_Value = Value;
}
function Reset()
{
	if( !bNoReset )
		Value = BACKUP_Value;
}

function string GetValue()
{
	return string(Value);
}
function SetValue( string S )
{
	Value = int(S);
}

function int GetInt()
{
	return Value;
}
function SetInt( int i )
{
	Value = i;
}

function float GetFloat()
{
	return Value;
}
function SetFloat( float f )
{
	Value = f;
}

function Object GetObject()
{
	return (Value>=0) ? FindObjectIndex(Value) : None;
}
function SetObject( Object o )
{
	Value = bool(o) ? o.ObjectIndex : -1;
}

defaultproperties
{
	MenuName="Int"
	Description="32-bit integer variable"
	DrawColor=(R=0,G=255,B=255)
}