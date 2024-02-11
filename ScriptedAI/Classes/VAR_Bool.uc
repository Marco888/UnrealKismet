Class VAR_Bool extends SVariableBase;

var() bool Value;
var bool BACKUP_Value;

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
	Value = bool(S);
}

function bool GetBool()
{
	return Value;
}
function SetBool( bool b )
{
	Value = b;
}

function int GetInt()
{
	return int(Value);
}
function SetInt( int i )
{
	Value = bool(i);
}

function float GetFloat()
{
	return float(Value);
}
function SetFloat( float f )
{
	Value = bool(f);
}

defaultproperties
{
	MenuName="Boolean"
	Description="Boolean variable"
	DrawColor=(R=255,G=0,B=0)
}