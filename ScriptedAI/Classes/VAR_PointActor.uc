Class VAR_PointActor extends VAR_OBJECT_BASE;

var() button<"Move point to viewport"> MoveCamButton; // Move to current 3D viewport location.
var() button<"Go to point"> MovePointButton; // Move 3D viewport to this point.
var() editconst Actor_PointActor PointActor;

event string GetInfo() // Editor info.
{
	return "";
}
event GetToolbar( out array<string> Entries )
{
	Entries[0] = "Move point to viewport";
	Entries[1] = "Go to point";
}

event OnSelectToolbar( int Index )
{
	local PlayerPawn P;
	
	if( !PointActor )
		OnInitialize();
	P = Get3DViewport();
	if( Index==0 )
		PointActor.SetLocation(P.Location,Normalize(P.ViewRotation));
	else
	{
		P.SetLocation(PointActor.Location,PointActor.Rotation);
		P.ViewRotation = PointActor.Rotation;
	}
}

event OnPropertyChange( name Property, name ParentProperty )
{
	if( Property=='MoveCamButton' )
		OnSelectToolbar(0);
	else if( Property=='MovePointButton' )
		OnSelectToolbar(1);
}

event OnInitialize()
{
	local PlayerPawn P;
	
	if( !PointActor )
	{
		P = Get3DViewport();
		PointActor = Level.Spawn(Class'Actor_PointActor',,,P.Location,Normalize(P.ViewRotation));
	}
}
event OnRemoved()
{
	if( PointActor )
	{
		PointActor.Destroy();
		PointActor = None;
	}
}

function string GetValue()
{
	return bool(PointActor) ? PointActor.GetPointerName() : "None";
}

function Object GetObject()
{
	return PointActor;
}

defaultproperties
{
	MenuName="Point Actor"
	DrawColor=(R=32,G=64,B=200)
	Description="Point in level"
	bRequestBeginPlay=false
	bConstant=true
}