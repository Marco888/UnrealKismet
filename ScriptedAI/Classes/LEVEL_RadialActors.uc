Class LEVEL_RadialActors extends LEVELSBASE;

var SVariableBase InPosition,InRadius;
var VAR_OBJECTARRAY_BASE OutList;

var() vector Position;
var() float Radius; // Radius of the sphere to grab the actors.
var() class<Actor> MetaClass;
var() export editinline FILTER_BASE ActorFilter;

var() bool bOnlyVisible; // Only grab actors visible to the point.
var() bool bColliding; // Only grab colliding actors.

function ReceiveEvent( byte Index )
{
	local Actor A;
	local int i;

	if( OutList!=None )
	{
		if( InPosition!=None )
		{
			if( VAR_Vector(InPosition)!=None )
				Position = VAR_Vector(InPosition).Value;
			else
			{
				A = Actor(InPosition.GetObject());
				if( A!=None )
					Position = A.Location;
			}
		}
		if( InRadius!=None )
			Radius = InRadius.GetFloat();

		OutList.SetArraySize(0);
		if( bOnlyVisible && bColliding ) // Fastest method.
		{
			foreach Level.VisibleCollidingActors(MetaClass,A,Radius,Position)
			{
				if( ActorFilter==None || !ActorFilter.ShouldFilter(A) )
					OutList.SetObjectAt(A,i++);
			}
		}
		else if( bOnlyVisible )
		{
			foreach Level.VisibleActors(MetaClass,A,Radius,Position)
			{
				if( ActorFilter==None || !ActorFilter.ShouldFilter(A) )
					OutList.SetObjectAt(A,i++);
			}
		}
		else
		{
			foreach Level.RadiusActors(MetaClass,A,Radius,Position)
			{
				if( (!bColliding || !A.bCollideActors) && (ActorFilter==None || !ActorFilter.ShouldFilter(A)) )
					OutList.SetObjectAt(A,i++);
			}
		}
	}
	SendEvent(0);
}

defaultproperties
{
	MenuName="Radius Actors"
	Description="Grab all actors within a point in level.|Position input can be an actor or a vector."
	bClientAction=true
	DrawColor=(R=175,G=200,B=100)
	MetaClass=class'Actor'
	Radius=1000

	VarLinks.Add((Name="Position",PropName="InPosition",bInput=true))
	VarLinks.Add((Name="Radius",PropName="InRadius",bInput=true))
	VarLinks.Add((Name="List",PropName="OutList",bOutput=true))
}