/*-------------------------------------------------------------------------------------------------------------------------
	Set the armor of a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Armor"
PLUGIN.Description = "Set the armor of a player."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "armor"
PLUGIN.Usage = "<players> [armor]"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin() ) then
		local pls = evolve:FindPlayer( args, ply, true )
		if ( #pls > 0 and !pls[1]:IsValid() ) then pls = { } end
		local armor = 100
		if ( tonumber( args[ #args ] ) ) then armor = tonumber( args[ #args ] ) end
		
		for _, pl in ipairs( pls ) do
			pl:SetArmor( armor )
		end
		
		if ( #pls > 0 ) then
			evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has set the armor of ", evolve.colors.red, evolve:CreatePlayerList( pls ), evolve.colors.white, " to " .. armor .. "." )
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
		RunConsoleCommand( "ev", "armor", unpack( players ) )
	else
		args = { }
		for i = 1, 10 do
			args[i] = { i * 10 }
		end
		return "Armor", evolve.category.actions, args
	end
end

evolve:RegisterPlugin( PLUGIN )