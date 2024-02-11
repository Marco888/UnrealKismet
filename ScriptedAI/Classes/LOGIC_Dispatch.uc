Class LOGIC_Dispatch extends LOGICBASE;

var() byte NumBranches; // 0 = infinite

function ReceiveEvent( byte Index )
{
	local SActionBase S;
	local bool bServer;

	bServer = (Level.NetMode!=NM_Client);
	if( bServer || bClientAction )
	{
		for( Index=0; Index<NumBranches; ++Index )
		{
			S = LinkedOutput[Index].Link;
			if( S!=None && (bServer || S.bClientAction) )
				S.ReceiveEvent(LinkedOutput[Index].OutIndex);
		}
	}
}

event OnPropertyChange( name Property, name ParentProperty )
{
	local byte i;

	if( Property=='NumBranches' )
	{
		OutputLinks.SetSize(NumBranches);
		for( i=0; i<NumBranches; ++i )
			OutputLinks[i] = string(i+1);
	}
}

defaultproperties
{
	MenuName="Dispatcher"
	Description="Split a call into multiple branches"
	bClientAction=true
	DrawColor=(R=128,G=128,B=138)
	NumBranches=1
	OutputLinks(0)="1"
}