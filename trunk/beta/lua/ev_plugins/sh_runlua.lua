/*-------------------------------------------------------------------------------------------------------------------------
	Run Lua on the server
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Run Lua"
PLUGIN.Description = "Execute Lua on the server."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "lua"
PLUGIN.Usage = "<code>"

local mt = {}
EVERYONE = {}

function mt.__index( t, k )
	return function( ply, ... )
		for _, pl in ipairs( player.GetAll() ) do
			pl[ k ]( pl, ... )
		end
	end
end

setmetatable( EVERYONE, mt )

function PLUGIN:Call( ply, args )	
	if ( ply:EV_IsOwner() and ValidEntity( ply ) ) then
		local code = table.concat( args, " " )
		
		if ( #code > 0 ) then
			ME = ply
			THIS = ply:GetEyeTrace().Entity
			PLAYER = function( nick ) return evolve:FindPlayer( nick )[1] end
			
			RunString( code )
			
			evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " ran Lua code: ", evolve.colors.red, code )
			
			THIS, ME, PLAYER = nil
		else
			evolve:Notify( ply, evolve.colors.red, "No code specified." )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

evolve:RegisterPlugin( PLUGIN )