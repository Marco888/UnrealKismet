Class VAR_Actor extends VAR_OBJECT_BASE;

var() name ActorTag;
var Actor RefActor;
var bool bHasInit;

function Reset()
{
	if( bNoReset ) return;
	bHasInit = false;
	RefActor = None;
}

event string GetInfo() // Editor info.
{
	return string(ActorTag);
}

final function InitReference()
{
	bHasInit = true;
	if( ActorTag!='' )
	{
		foreach Level.AllActors(class'Actor',RefActor,ActorTag)
			break;
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
	if( RefActor!=None && RefActor.bDeleteMe )
		RefActor = None;
	return (RefActor!=None) ? RefActor.GetPointerName() : "None";
}
function SetValue( string S )
{
	if( !bHasInit )
		InitReference();
	RefActor = FindObject(class'Actor',S);
}

function Object GetObject()
{
	if( !bHasInit )
		InitReference();
	if( RefActor!=None && RefActor.bDeleteMe )
		RefActor = None;
	return RefActor;
}
function SetObject( Object o )
{
	if( !bHasInit )
		InitReference();
	RefActor = Actor(o);
}

defaultproperties
{
	MenuName="Actor"
	DrawColor=(R=168,G=32,B=32)
	Description="Dynamic actor reference variable"
	bRequestBeginPlay=false
}