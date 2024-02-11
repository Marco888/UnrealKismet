Class VAR_SoundDuration extends VAR_Float;

var() Sound Sound; // Duration of this sound.
var() float SoundPitch; // Pitch of the sound.

function BeginPlay()
{
	Value += (bool(Sound) ? (Level.GetSoundDuration(Sound) * SoundPitch) : 0.f);
	BACKUP_Value = Value;
}
function string GetInfo() // Editor info.
{
	if( !Sound )
		return "None";
	if( Value>0.f )
		return string(Sound.Name)$" +"$Value;
	else if( Value<0.f )
		return string(Sound.Name)@Value;
	return string(Sound.Name);
}

defaultproperties
{
	MenuName="Sound Duration"
	SoundPitch=1
	bConstant=true
	bNoReset=true
	Description="Obtain sound duration"
}