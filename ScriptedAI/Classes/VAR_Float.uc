Class VAR_Float extends SVariableBase;

var() float Value;
var float BACKUP_Value;

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
	Value = float(S);
}

function bool GetBool()
{
	return (Value!=0);
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

defaultproperties
{
	MenuName="Float"
	Description="Floating point variable"
	DrawColor=(R=0,G=0,B=255)
}