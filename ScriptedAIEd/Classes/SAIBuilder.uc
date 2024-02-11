Class SAIBuilder extends BrushBuilder;

#exec Texture Import File=Textures\S_AIScriptIco.pcx Name=S_AIScriptIco Mips=Off Flags=2

event bool Build()
{
	Class'NativeHook'.Static.ShowEdWindow();
	return false;
}

defaultproperties
{
	BitmapImage=Texture'S_AIScriptIco'
	ToolTip="Show kismet manager."
}
