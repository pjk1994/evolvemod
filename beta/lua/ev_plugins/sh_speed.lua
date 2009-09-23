/*-------------------------------------------------------------------------------------------------------------------------
	Enable speedmode for a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Speed"
PLUGIN.Description = "Enable speedmode for a player."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "speed"
PLUGIN.Usage = "[players] [speed]"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin() ) then
		local pls = evolve:findPlayer( args, ply, true )
		if ( #pls > 0 and !pls[1]:IsValid() ) then pls = { } end
		local speed = 250
		if ( tonumber( args[ #args ] ) ) then speed = math.abs( tonumber( args[ #args ] ) ) end
		
		for _, pl in pairs( pls ) do
			GAMEMODE:SetPlayerSpeed( pl, speed, speed * 2 )
		end
		
		if ( #pls > 0 ) then
			evolve:notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has set the speed of ", evolve.colors.red, evolve:createPlayerList( pls ), evolve.colors.white, " to " .. speed .. "." )
		else
			evolve:notify( ply, evolve.colors.red, "No matching players found." )
		end
	else
		evolve:notify( ply, evolve.colors.red, evolve.constants.notallowed )
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

evolve:registerPlugin( PLUGIN )