Class Actor_GameRules extends GameRules
	NoUserCreate;

struct FGodUsers
{
	var Pawn User;
	var float Duration;
};
var array<FGodUsers> GodUsers;

var EVENT_PawnDied DieCallback;
var EVENT_PawnPrevDeath PreventCallback;
var EVENT_PawnHurt HurtCallback;
var EVENT_PlayerSpawn SpawnCallback;
var EVENT_InvPickup InvCallback;

var bool bAnyGod;

static final function Actor_GameRules GetRules( LevelInfo L )
{
	local GameRules G;

	if( L.Game==None )
		return None;
	
	for( G=L.Game.GameRules; G!=None; G=G.NextRules )
		if( G.Class==Class'Actor_GameRules' )
			break;
	
	if( G==None )
	{
		G = L.Spawn(class'Actor_GameRules');
		if( L.Game.GameRules==None )
			L.Game.GameRules = G;
		else L.Game.GameRules.AddRules(G);
	}
	return Actor_GameRules(G);
}

function NotifyKilled( Pawn Killed, Pawn Killer, name DamageType )
{
	local EVENT_PawnDied D;
	local int i;
	
	for( D=DieCallback; D!=None; D=D.NextCallback )
		D.NotifyKilled(Killed,Killer,DamageType);

	if( bAnyGod )
	{
		for( i=(Array_Size(GodUsers)-1); i>=0; --i )
			if( GodUsers[i].User==None || GodUsers[i].User==Killed || GodUsers[i].User.bDeleteMe || GodUsers[i].Duration<Level.TimeSeconds )
				Array_Remove(GodUsers,i);
		if( Array_Size(GodUsers)==0 )
			bAnyGod = false;
	}
}
function bool PreventDeath( Pawn Dying, Pawn Killer, name DamageType )
{
	local EVENT_PawnPrevDeath D;
	
	for( D=PreventCallback; D!=None; D=D.NextCallback )
		if( D.PreventDeath(Dying,Killer,DamageType) )
			return true;
	return false;
}
function ModifyDamage( Pawn Injured, Pawn EventInstigator, out int Damage, vector HitLocation, name DamageType, out vector Momentum )
{
	local EVENT_PawnHurt D;
	local int i;
	
	if( bAnyGod )
	{
		for( i=(Array_Size(GodUsers)-1); i>=0; --i )
		{
			if( GodUsers[i].User==Injured )
			{
				if( GodUsers[i].Duration<Level.TimeSeconds )
					Array_Remove(GodUsers,i);
				else
				{
					Damage = 0;
					Momentum = vect(0,0,0);
					return;
				}
				break;
			}
		}
		if( Array_Size(GodUsers)==0 )
			bAnyGod = false;
	}
	for( D=HurtCallback; D!=None; D=D.NextCallback )
		D.NotifyDamage(Injured,EventInstigator,Damage,HitLocation,DamageType);
}
function ModifyPlayer( Pawn Other )
{
	local EVENT_PlayerSpawn D;
	
	for( D=SpawnCallback; D!=None; D=D.NextCallback )
		D.NotifyPlayer(Other);
}
function bool CanPickupInventory( Pawn Other, Inventory Inv )
{
	local EVENT_InvPickup D;
	
	for( D=InvCallback; D!=None; D=D.NextCallback )
		D.NotifyInventory(Other,Inv);
	Return True;
}

final function SetGodMode( Pawn P, bool bEnable, float Duration )
{
	local int i;
	
	if( Duration<=0 )
		Duration = 999999;
	if( bEnable )
	{
		bModifyDamage = true;
		bAnyGod = true;

		for( i=(Array_Size(GodUsers)-1); i>=0; --i )
		{
			if( GodUsers[i].User==P )
			{
				GodUsers[i].Duration = Level.TimeSeconds+Duration;
				return;
			}
			else if( GodUsers[i].User==None || GodUsers[i].User.bDeleteMe || GodUsers[i].Duration<Level.TimeSeconds )
				Array_Remove(GodUsers,i);
		}
		i = Array_Size(GodUsers);
		GodUsers[i].User = P;
		GodUsers[i].Duration = Level.TimeSeconds+Duration;
	}
	else
	{
		for( i=(Array_Size(GodUsers)-1); i>=0; --i )
		{
			if( GodUsers[i].User==None || GodUsers[i].User==P || GodUsers[i].User.bDeleteMe || GodUsers[i].Duration<Level.TimeSeconds )
				Array_Remove(GodUsers,i);
		}
		if( Array_Size(GodUsers)==0 )
			bAnyGod = false;
	}
}
