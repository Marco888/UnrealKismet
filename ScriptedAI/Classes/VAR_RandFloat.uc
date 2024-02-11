Class VAR_RandFloat extends VAR_Float;

var() float ValueMax,ValueMin;

function string GetInfo() // Editor info.
{
	return string(ValueMin)$"-"$string(ValueMax);
}

function string GetValue()
{
	Value = ValueMin+FRand()*(ValueMax-ValueMin);
	return string(Value);
}
function int GetInt()
{
	Value = ValueMin+FRand()*(ValueMax-ValueMin);
	return Value;
}
function float GetFloat()
{
	Value = ValueMin+FRand()*(ValueMax-ValueMin);
	return Value;
}

defaultproperties
{
	MenuName="Random Float"
	ValueMax=1
	bConstant=true
	Description="Random float variable"
	bRequestBeginPlay=false
}