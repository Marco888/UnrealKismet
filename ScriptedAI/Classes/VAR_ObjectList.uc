Class VAR_ObjectList extends VAR_OBJECTARRAY_BASE;

var() array<Object> Value;
var array<Object> BACKUP_Value;

function BeginPlay()
{
	BACKUP_Value = Value;
}
function Reset()
{
	if( !bNoReset )
		Value = BACKUP_Value;
}

event string GetInfo()
{
	return "["$string(Value.Size())$"]";
}

event OnSelectToolbar( int Index )
{
	local Actor A;

	Value.Empty();
	foreach Level.AllActors(class'Actor',A)
		if( A.bSelected && (A.bStatic || A.bDeleteMe) )
			Value.Add(A);
}

function string GetValue()
{
	if( Value.Size()>0 )
		return string(Value[0]);
	return "None";
}
function SetValue( string S )
{
	Value[0] = FindObject(class'Object',S);
}

function Object GetObject()
{
	if( Value.Size()>0 )
		return Value[0];
	return None;
}
function SetObject( Object o )
{
	Value[0] = o;
}

function int GetArraySize()
{
	return Value.Size();
}
function Object GetObjectAt( int Index )
{
	return Value[Index];
}
function SetArraySize( int NewSize )
{
	Value.SetSize(NewSize);
}
function SetObjectAt( Object o, int Index )
{
	Value[Index] = o;
}
function RemoveObjectAt( int Index )
{
	Value.Remove(Index);
}

defaultproperties
{
	MenuName="Object List"
	Description="Object list reference variable|WARNING: Don't use this to reference dynamic destroyable actors or game could crash!"
}