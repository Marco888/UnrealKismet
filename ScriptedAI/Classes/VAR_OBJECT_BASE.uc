Class VAR_OBJECT_BASE extends SVariableBase
	abstract;

var const bool bIsArray;

event string GetInfo() // Editor info.
{
	local Object O;
	
	O = GetObject();
	if( O!=None )
		return string(O.Name);
	return "";
}
event GetToolbar( out array<string> Entries )
{
	Entries[0] = "Assign to selected actors";
}

function bool GetBool()
{
	return (GetObject()!=None);
}
function SetBool( bool b );

function vector GetVector()
{
	local Actor A;
	
	A = Actor(GetObject());
	if( A!=None )
		return A.Location;
	return vect(0,0,0);
}

defaultproperties
{
	MenuName="Object ref"
	DrawColor=(R=128,G=0,B=128)
	bContainsActorRef=true
}