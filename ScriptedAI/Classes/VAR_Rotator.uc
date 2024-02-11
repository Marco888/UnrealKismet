Class VAR_Rotator extends VAR_STRUCT_BASE;

var() rotator Value;
var rotator BACKUP_Value;

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
	Value = rotator(S);
}

defaultproperties
{
	MenuName="Rotator"
	Description="Rotator variable"
	DrawColor=(R=0,G=255,B=88)
}