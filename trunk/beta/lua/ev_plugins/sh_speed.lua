/*-------------------------------------------------------------------------------------------------------------------------
	Enable speedmode for a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Speed"
PLUGIN.Description = "Enable speedmode for a player."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "speed"
PLUGIN.Usage = "[players] [speed]"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin() ) then
		local players = evolve:FindPlayer( args, ply, true )
		local speed = math.abs( tonumber( args[ #args ] ) or 250 )
		
		for _, pl in ipairs( players ) do
			GAMEMODE:SetPlayerSpeed( pl, speed, speed * 2 )
		end
		
		if ( #players > 0 ) then
			evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has set the speed of ", evolve.colors.red, evolve:CreatePlayerList( players ), evolve.colors.white, " to " .. speed .. "." )
		else
			evolve:Notify( ply, evolve.colors.red, "No matching players found." )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		table.insert( players, arg )
		RunConsoleCommand( "ev", "speed", unpack( players ) )
	else
		return "Speed", evolve.category.actions, { { "Default", 250 }, { "Double", 500 } }
	end
end

evolve:RegisterPlugin( PLUGIN )