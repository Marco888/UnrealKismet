Class VAR_Vector extends VAR_STRUCT_BASE;

var() vector Value;
var vector BACKUP_Value;

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
	Value = vector(S);
}

function int GetInt()
{
	return VSize(Value);
}
function SetInt( int i )
{
	Value *= i;
}

function float GetFloat()
{
	return VSize(Value);
}
function SetFloat( float f )
{
	Value *= f;
}

function vector GetVector()
{
	return Value;
}

defaultproperties
{
	MenuName="Vector"
	Description="Vector variable"
	DrawColor=(R=0,G=88,B=255)
}