Class VAR_RandString extends VAR_String;

var() array<string> StringList;
var int Count;

function BeginPlay()
{
	Count = Array_Size(StringList);
}
function string GetInfo() // Editor info.
{
	return "TextLines #"$Array_Size(StringList);
}

function string GetValue()
{
	if( Count>0 )
		return StringList[Rand(Count)];
	return Value;
}

function bool GetBool()
{
	if( Count>0 )
		return bool(StringList[Rand(Count)]);
	return bool(Value);
}

function int GetInt()
{
	if( Count>0 )
		return int(StringList[Rand(Count)]);
	return int(Value);
}

function float GetFloat()
{
	if( Count>0 )
		return float(StringList[Rand(Count)]);
	return float(Value);
}

function Object GetObject()
{
	if( Count>0 )
		return FindObject(class'Object',StringList[Rand(Count)]);
	return FindObject(class'Object',Value);
}

defaultproperties
{
	MenuName="Random String"
	bConstant=true
	DrawColor=(R=48,G=220,B=0,A=255)
	Description="Multi-text line variable"
}