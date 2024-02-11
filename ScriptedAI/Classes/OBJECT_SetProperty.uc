Class OBJECT_SetProperty extends OBJECTBASE;

var() string PropertyName; // Name of the property to obtain.
var() string PropertyValue; // Property value to change to.
var SVariableBase InActor,InValue;

function ReceiveEvent( byte Index )
{
	local Object O;

	if( InActor==None )
		Warn("Set property of none input Object?");
	else
	{
		if( InValue!=None )
			PropertyValue = InValue.GetValue();

		O = InActor.GetObject();
		if( O!=None )
			O.SetPropertyText(PropertyName,PropertyValue);
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
	MenuName="Set Property"
	Description="Change Object property value"
	bClientAction=true
	DrawColor=(R=128,G=58,B=220)

	VarLinks.Add((Name="Object",PropName="InActor",bInput=true))
	VarLinks.Add((Name="Value",PropName="InValue",bInput=true))
}