Class VAR_ActorList extends VAR_OBJECTARRAY_BASE;

var() name ActorTag;
var array<Actor> RefActors;
var bool bHasInit;

function Reset()
{
	if( bNoReset ) return;
	bHasInit = false;
	RefActors.Empty();
}

event string GetInfo() // Editor info.
{
	return string(ActorTag);
}

final function InitReference()
{
	local Actor A;

	bHasInit = true;
	if( ActorTag!='' )
	{
		foreach Level.AllActors(class'Actor',A,ActorTag)
			RefActors.Add(A);
	}
}

event OnSelectToolbar( int Index )
{
	local Actor A;
	
	foreach Level.AllActors(class'Actor',A)
		if( A.bSelected )
		{
			ActorTag = A.Tag;
			break;
		}
}

function string GetValue()
{
	if( !bHasInit )
		InitReference();
	if( RefActors.Size()>0 )
		return (RefActors[0]!=None) ? RefActors[0].GetPointerName() : "None";
	return "None";
}
function SetValue( string S )
{
	if( !bHasInit )
		InitReference();
	RefActors.SetSize(1);
	RefActors[0] = FindObject(class'Actor',S);
}

function Object GetObject()
{
	if( !bHasInit )
		InitReference();
	if( RefActors.Size()>0 )
		return RefActors[0];
	return None;
}
function SetObject( Object o )
{
	if( !bHasInit )
		InitReference();
	RefActors.SetSize(1);
	RefActors[0] = Actor(o);
}

function int GetArraySize()
{
	if( !bHasInit )
		InitReference();
	return RefActors.Size();
}
function Object GetObjectAt( int Index )
{
	if( !bHasInit )
		InitReference();
	return RefActors[Index];
}
function SetArraySize( int NewSize )
{
	if( !bHasInit )
		InitReference();
	RefActors.SetSize(NewSize);
}
function SetObjectAt( Object o, int Index )
{
	if( !bHasInit )
		InitReference();
	RefActors[Index] = Actor(o);
}
function RemoveObjectAt( int Index )
{
	RefActors.Remove(Index);
}

defaultproperties
{
	MenuName="Actor List"
	DrawColor=(R=168,G=32,B=32)
	Description="Dynamic actorlist reference variable"
	bRequestBeginPlay=false
}