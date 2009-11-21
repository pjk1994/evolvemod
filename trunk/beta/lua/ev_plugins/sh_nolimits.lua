/*-------------------------------------------------------------------------------------------------------------------------
	Enable no limits for a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "No Limits"
PLUGIN.Description = "Disable limits for a player."
PLUGIN.Author = "Overv and Divran"
PLUGIN.ChatCommand = "nolimits"
PLUGIN.Usage = "[players] [1/0]"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin() ) then
		local pls = evolve:FindPlayer( args, ply, true )
		if ( #pls > 0 and !pls[1]:IsValid() ) then pls = { } end
		local enabled = true
		if ( tonumber( args[ #args ] ) ) then enabled = tonumber( args[ #args ] ) > 0 end
		
		for _, pl in ipairs( pls ) do
			pl.EV_NoLimits = enabled
		end
		
		if ( #pls > 0 ) then
			if ( enabled ) then
				evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has disabled limits for ", evolve.colors.red, evolve:CreatePlayerList( pls ), evolve.colors.white, "." )
			else
				evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has enabled limits for ", evolve.colors.red, evolve:CreatePlayerList( pls ), evolve.colors.white, "." )
			end
		else
			evolve:Notify( ply, evolve.colors.red, "No matching players found." )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN.CheckLimit( ply, limit )
	local count = server_settings.Int( "sbox_max" .. limit, -1 )
	
	if ( ply.EV_NoLimits ) then
		return true
	elseif ( ply:GetCount( limit ) < count or count == -1 ) then 
		return true
	else
		ply:LimitHit( limit )
		return false
	end
end

timer.Simple( 1, function()
	function GAMEMODE:PlayerSpawnProp( ply, mdl ) return PLUGIN.CheckLimit( ply, "props" ) end
	function GAMEMODE:PlayerSpawnVehicle( ply, mdl ) return PLUGIN.CheckLimit( ply, "vehicles" ) end
	function GAMEMODE:PlayerSpawnNPC( ply, mdl ) return PLUGIN.CheckLimit( ply, "npcs" ) end
	function GAMEMODE:PlayerSpawnEffect( ply, mdl ) return PLUGIN.CheckLimit( ply, "effects" ) end
	function GAMEMODE:PlayerSpawnRagdoll( ply, mdl ) return PLUGIN.CheckLimit( ply, "ragdolls" ) end 
	
	_R.Player.CheckLimit = PLUGIN.CheckLimit
end )

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		table.insert( players, arg )
		RunConsoleCommand( "ev", "nolimits", unpack( players ) )
	else
		return "No limits", evolve.category.actions, { { "Enable", 1 }, { "Disable", 0 } }
	end
end

evolve:RegisterPlugin( PLUGIN )