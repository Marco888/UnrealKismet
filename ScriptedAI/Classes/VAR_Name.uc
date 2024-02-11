Class VAR_Name extends SVariableBase;

var() name Value;
var name BACKUP_Value;

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
	Value = StringToName(S);
}

function bool GetBool()
{
	return (Value=='True');
}
function SetBool( bool b )
{
	if( b )
		Value = 'True';
	else Value = 'False';
}

function Object GetObject()
{
	return FindObject(class'Object',string(Value));
}
function SetObject( Object o )
{
	if( o!=None )
		Value = o.Name;
	else Value = '';
}

defaultproperties
{
	MenuName="Name"
	DrawColor=(R=128,G=255,B=255)
	Description="Name variable"
}