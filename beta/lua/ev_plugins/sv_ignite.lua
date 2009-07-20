/*-------------------------------------------------------------------------------------------------------------------------
	Ignite a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Ignite"
PLUGIN.Description = "Ignite a player."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "ignite"
PLUGIN.Usage = "[players] [1/0]"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin( ) ) then
		local pls = evolve:findPlayer( evolve:filterNumber( args ), ply )
		if ( #pls > 0 and !pls[1]:IsValid( ) ) then pls = { } end
		local enabled = true
		if ( tonumber( args[ #args ] ) ) then enabled = tonumber( args[ #args ] ) > 0 end
		
		for _, pl in pairs( pls ) do
			if ( enabled ) then pl:Ignite( 99999, 1 ) else pl:Extinguish( ) end
		end
		
		if ( #pls > 0 ) then
			if ( enabled ) then
				evolve:notify( evolve.colors.blue, ply:Nick( ), evolve.colors.white, " has ignited ", evolve.colors.red, evolve:createPlayerList( pls ), evolve.colors.white, "." )
			else
				evolve:notify( evolve.colors.blue, ply:Nick( ), evolve.colors.white, " has extinguished ", evolve.colors.red, evolve:createPlayerList( pls ), evolve.colors.white, "." )
			end
		else
			evolve:notify( ply, evolve.colors.red, "No matching players found." )
		end
	else
		evolve:notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:PlayerDeath( ply )
	if ( ply:IsOnFire( ) ) then
		ply:Extinguish( )
	end
end

function PLUGIN:Move( ply )
	if ( ply:IsOnFire( ) and ply:WaterLevel( ) == 3 ) then
		ply:Extinguish( )
		evolve:notify( evolve.colors.blue, ply:Nick( ), evolve.colors.white, " extinguished himself by jumping into water." )
	end
end

evolve:registerPlugin( PLUGIN )