/*-------------------------------------------------------------------------------------------------------------------------
	Enable godmode for a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Godmode"
PLUGIN.Description = "Enable godmode for a player."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "god"
PLUGIN.Usage = "[players] [1/0]"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin( ) ) then
		local pls = evolve:findPlayer( args, ply, true )
		if ( #pls > 0 and !pls[1]:IsValid( ) ) then pls = { } end
		local enabled = true
		if ( tonumber( args[ #args ] ) ) then enabled = tonumber( args[ #args ] ) > 0 end
		
		for _, pl in pairs( pls ) do
			if ( enabled ) then pl:GodEnable( ) else pl:GodDisable( ) end
			pl.EV_GodMode = enabled
		end
		
		if ( #pls > 0 ) then
			if ( enabled ) then
				evolve:notify( evolve.colors.blue, ply:Nick( ), evolve.colors.white, " has enabled godmode for ", evolve.colors.red, evolve:createPlayerList( pls ), evolve.colors.white, "." )
			else
				evolve:notify( evolve.colors.blue, ply:Nick( ), evolve.colors.white, " has disabled godmode for ", evolve.colors.red, evolve:createPlayerList( pls ), evolve.colors.white, "." )
			end
		else
			evolve:notify( ply, evolve.colors.red, "No matching players found." )
		end
	else
		evolve:notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:PlayerSpawn( ply )
	if ( ply.EV_GodMode ) then ply:GodEnable( ) end
end

evolve:registerPlugin( PLUGIN )