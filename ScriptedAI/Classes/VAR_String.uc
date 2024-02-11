Class VAR_String extends SVariableBase;

var() string Value;
var string BACKUP_Value;

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
	return Value;
}
function SetValue( string S )
{
	Value = S;
}

function bool GetBool()
{
	return bool(Value);
}
function SetBool( bool b )
{
	Value = string(b);
}

function int GetInt()
{
	return int(Value);
}
function SetInt( int i )
{
	Value = string(i);
}

function float GetFloat()
{
	return float(Value);
}
function SetFloat( float f )
{
	Value = string(f);
}

function Object GetObject()
{
	return FindObject(class'Object',Value);
}
function SetObject( Object o )
{
	Value = string(o);
}

function vector GetVector()
{
	return vector(Value);
}

defaultproperties
{
	MenuName="String"
	DrawColor=(R=0,G=255,B=0,A=255)
	Description="Text line variable"
}