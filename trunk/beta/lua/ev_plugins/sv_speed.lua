/*-------------------------------------------------------------------------------------------------------------------------
	Enable speedmode for a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Speed"
PLUGIN.Description = "Enable speedmode for a player."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "speed"
PLUGIN.Usage = "[players] [1/0]"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin( ) ) then
		local pls = evolve:findPlayer( args, ply, true )
		if ( #pls > 0 and !pls[1]:IsValid( ) ) then pls = { } end
		local enabled = true
		if ( tonumber( args[ #args ] ) ) then enabled = tonumber( args[ #args ] ) > 0 end
		
		for _, pl in pairs( pls ) do
			if ( enabled ) then
				GAMEMODE:SetPlayerSpeed( pl, 1000, 2000 )
			else
				GAMEMODE:SetPlayerSpeed( pl, 200, 500 )
			end
			
			pl.EV_Speed = enabled
		end
		
		if ( #pls > 0 ) then
			if ( enabled ) then
				evolve:notify( evolve.colors.blue, ply:Nick( ), evolve.colors.white, " has enabled speed for ", evolve.colors.red, evolve:createPlayerList( pls ), evolve.colors.white, "." )
			else
				evolve:notify( evolve.colors.blue, ply:Nick( ), evolve.colors.white, " has disabled speed for ", evolve.colors.red, evolve:createPlayerList( pls ), evolve.colors.white, "." )
			end
		else
			evolve:notify( ply, evolve.colors.red, "No matching players found." )
		end
	else
		evolve:notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

evolve:registerPlugin( PLUGIN )