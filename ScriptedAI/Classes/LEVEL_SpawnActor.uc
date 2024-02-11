Class LEVEL_SpawnActor extends LEVELSBASE;

var() class<Actor> ActorClass;
var() name Tag,Event;
var() editconst editinline export Actor SpawnTemplate;
var() bool bNoFail; // If true, spawn actor even if it does not fit in that location.
var() bool bRandomSpawnpoint; // If Position is an array of actors, pick actor in random order from list or in linear order?
var() bool bSpawnWithTemplate; // Should spawn with a specific actor template.

var SVariableBase InLocation,InOwner,InInstigator,OutActor;
var VAR_Rotator InRotation;
var int PosIndex;

function ReceiveEvent( byte Index )
{
	local vector V;
	local rotator R;
	local Actor A,O;
	local Pawn I;
	local int l;
	
	if( ActorClass==None )
		Warn("No spawnclass defined!");
	else
	{
		if( InLocation )
		{
			if( VAR_Vector(InLocation) )
				V = VAR_Vector(InLocation).Value;
			else
			{
				l = InLocation.GetArraySize();
				if( l>1 )
				{
					if( bRandomSpawnpoint )
						A = Actor(InLocation.GetObjectAt(Rand(l)));
					else
					{
						A = Actor(InLocation.GetObjectAt(PosIndex++));
						if( PosIndex>=l )
							PosIndex = 0;
					}
				}
				else A = Actor(InLocation.GetObject());
				if( A!=None )
				{
					V = A.Location;
					R = A.Rotation;
				}
			}
		}
		if( InRotation )
			R = InRotation.Value;
		if( InOwner )
			O = Actor(InOwner.GetObject());
		if( InInstigator )
			I = Pawn(InInstigator.GetObject());

		A = Level.Spawn(ActorClass,O,Tag,V,R,I,SpawnTemplate,bNoFail);
		if( A )
		{
			A.Event = Event;
			if( OutActor!=None )
				OutActor.SetObject(A);
			SendEvent(0);
			return;
		}
	}
	SendEvent(1);
}

event OnPropertyChange( name Property, name ParentProperty )
{
	if( Property=='ActorClass' || Property=='bSpawnWithTemplate' )
	{
		if( ActorClass )
		{
			PostInfoText = string(ActorClass.Name);
			if( bSpawnWithTemplate )
			{
				if( !SpawnTemplate || SpawnTemplate.Class!=ActorClass )
					SpawnTemplate = new (Outer) ActorClass;
			}
			else SpawnTemplate = None;
		}
		else
		{
			SpawnTemplate = None;
			PostInfoText = "";
		}
	}
}

defaultproperties
{
	MenuName="Spawn Actor"
	Description="Spawn a new actor.|If you input Position as actor variable, it will use that actor rotation. Otherwise you can input vector and rotation."
	DrawColor=(R=255,G=48,B=58)

	OutputLinks(0)="Spawned"
	OutputLinks(1)="Failed"

	VarLinks.Add((Name="Position",PropName="InLocation",bInput=true))
	VarLinks.Add((Name="Rotation",PropName="InRotation",bInput=true))
	VarLinks.Add((Name="Owner",PropName="InOwner",bInput=true))
	VarLinks.Add((Name="Instigator",PropName="InInstigator",bInput=true))
	VarLinks.Add((Name="OutActor",PropName="OutActor",bOutput=true))
}