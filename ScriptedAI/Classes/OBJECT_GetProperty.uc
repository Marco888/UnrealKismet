Class OBJECT_GetProperty extends OBJECTBASE;

var() string PropertyName; // Name of the property to obtain.
var SVariableBase InActor,OutValue;

function ReceiveEvent( byte Index )
{
	local Object O;

	if( InActor==None )
		Warn("Grab property of none input Object?");
	else if( OutValue==None )
		Warn("Grab property of Object but output it to nowhere?");
	else
	{
		O = InActor.GetObject();
		if( O!=None )
			OutValue.SetValue(O.GetPropertyText(PropertyName));
		else OutValue.SetValue("");
	}
	SendEvent(0);
}

event OnPropertyChange( name Property, name ParentProperty )
{
	if( Property=='PropertyName' )
		PostInfoText = PropertyName;
}

defaultproperties
{
	MenuName="Get Property"
	Description="Grab Object property value"
	bClientAction=true
	DrawColor=(R=128,G=58,B=200)

	VarLinks.Add((Name="Object",PropName="InActor",bInput=true))
	VarLinks.Add((Name="Output",PropName="OutValue",bOutput=true))
}