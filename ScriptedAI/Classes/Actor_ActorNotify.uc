Class Actor_ActorNotify extends SpawnNotify
	NoUserCreate;

var EVENT_ActorSpawned SpawnCallback;

function PostBeginPlay();

simulated final function Linkup()
{
	local SpawnNotify N;

	for(N = Level.SpawnNotify; N; N = N.Next)
		if(N == Self)
			return;

	Next = Level.SpawnNotify;
	Level.SpawnNotify = Self;
}
simulated final function Unlink()
{
	local SpawnNotify N;
	
	if(Level.SpawnNotify == Self)
		Level.SpawnNotify = Next;
	else
	{
		for(N=Level.SpawnNotify; N; N=N.Next)
		{
			if(N.Next == Self)
			{
				N.Next = Next;
				break;
			}
		}
	}
	Next = None;
}

simulated event Actor SpawnNotification(Actor A)
{
	SpawnCallback.NotifySpawned(A);
	if( !A || A.bDeleteMe )
		return None;
	return A;
}

defaultproperties
{
	RemoteRole=ROLE_None
	bHidden=true
}