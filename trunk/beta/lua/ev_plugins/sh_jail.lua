/*-------------------------------------------------------------------------------------------------------------------------
	Jail a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Jail"
PLUGIN.Description = "Jail a player."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "jail"
PLUGIN.Usage = "[players] [1/0]"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin() ) then
		if ( evolve.jailPos ) then
			local pls = evolve:FindPlayer( args, ply, true )
			if ( #pls > 0 and !pls[1]:IsValid() ) then pls = { } end
			local enabled = true
			if ( tonumber( args[ #args ] ) ) then enabled = tonumber( args[ #args ] ) > 0 end
			
			for _, pl in pairs( pls ) do
				pl.EV_Jailed = enabled
				
				if ( enabled ) then
					pl:StripWeapons()
					pl.EV_RestorePos = pl:GetPos()
					pl:SetPos( evolve.jailPos )
					pl:SetMoveType( MOVETYPE_WALK )
					pl:SetCollisionGroup( COLLISION_GROUP_WEAPON )
				else
					pl:Spawn()
					timer.Simple( 0.1, function() pl:SetPos( pl.EV_RestorePos ) end )
				end
			end
			
			if ( #pls > 0 ) then
				if ( enabled ) then
					evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has jailed ", evolve.colors.red, evolve:CreatePlayerList( pls ), evolve.colors.white, "." )
				else
					evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has released ", evolve.colors.red, evolve:CreatePlayerList( pls ), evolve.colors.white, "." )
				end
			else
				evolve:Notify( ply, evolve.colors.red, "No matching players found." )
			end
		else
			evolve:Notify( ply, evolve.colors.red, "No jail position set yet." )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:CanPlayerSuicide( ply )
	if ( ply.EV_Jailed ) then return false end
end
function PLUGIN:PlayerNoClip( ply )
	if ( ply.EV_Jailed ) then return false end
end
function PLUGIN:PlayerSpawnProp( ply )
	if ( ply.EV_Jailed ) then return false end
end
function PLUGIN:PlayerSpawnSENT( ply )
	if ( ply.EV_Jailed ) then return false end
end
function PLUGIN:PlayerSpawnSWEP( ply )
	if ( ply.EV_Jailed ) then return false end
end
function PLUGIN:PlayerSpawnNPC( ply )
	if ( ply.EV_Jailed ) then return false end
end
function PLUGIN:PlayerSpawnEffect( ply )
	if ( ply.EV_Jailed ) then return false end
end
function PLUGIN:PlayerSpawnRagdoll( ply )
	if ( ply.EV_Jailed ) then return false end
end
function PLUGIN:PlayerSpawnedVehicle( ply, veh )
	if ( ply.EV_Jailed ) then veh:Remove() end
end

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		table.insert( players, arg )
		RunConsoleCommand( "ev", "jail", unpack( players ) )
	else
		return "Jail", evolve.category.punishment, { { "Enable", 1 }, { "Disable", 0 } }
	end
end

evolve:RegisterPlugin( PLUGIN )

local PLUGIN = { }
PLUGIN.Title = "Set jail"
PLUGIN.Description = "Set the jail position."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "setjail"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin() ) then
		evolve.jailPos = ply:GetEyeTrace().HitPos
		evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has set the jail position." )
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

evolve:RegisterPlugin( PLUGIN )