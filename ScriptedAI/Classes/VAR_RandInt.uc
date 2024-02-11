Class VAR_RandInt extends VAR_Int;

var() int ValueMax,ValueMin;

function string GetInfo() // Editor info.
{
	return string(ValueMin)$"-"$string(ValueMax);
}

function string GetValue()
{
	Value = ValueMin+Rand(ValueMax-ValueMin+1);
	return string(Value);
}
function int GetInt()
{
	Value = ValueMin+Rand(ValueMax-ValueMin+1);
	return Value;
}
function float GetFloat()
{
	Value = ValueMin+Rand(ValueMax-ValueMin+1);
	return Value;
}

defaultproperties
{
	MenuName="Random Int"
	ValueMax=1
	bConstant=true
	Description="Random integer variable"
	bRequestBeginPlay=false
}