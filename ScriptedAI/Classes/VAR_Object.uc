Class VAR_Object extends VAR_OBJECT_BASE;

var() Object Value;
var Object BACKUP_Value;

function BeginPlay()
{
	BACKUP_Value = Value;
}
function Reset()
{
	if( !bNoReset )
		Value = BACKUP_Value;
}

event OnSelectToolbar( int Index )
{
	local Actor A;
	
	foreach Level.AllActors(class'Actor',A)
		if( A.bSelected && (A.bStatic || A.bDeleteMe) )
		{
			Value = A;
			break;
		}
}

function string GetValue()
{
	return string(Value);
}
function SetValue( string S )
{
	Value = FindObject(class'Object',S);
}

function Object GetObject()
{
	return Value;
}
function SetObject( Object o )
{
	Value = o;
}

defaultproperties
{
	MenuName="Object"
	Description="Object reference variable|WARNING: Don't use this to reference dynamic destroyable actors or game could crash!"
}