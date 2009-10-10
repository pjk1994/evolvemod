/*-------------------------------------------------------------------------------------------------------------------------
	Run Lua on the server
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Run Lua"
PLUGIN.Description = "Execute Lua on the server."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "lua"
PLUGIN.Usage = "<code>"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsOwner() ) then
		local code = table.concat( args, " " )
		
		if ( #code > 0 ) then
			me = ply
			this = ply:GetEyeTrace().Entity
			RunString( code )
			
			evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " ran Lua code: ", evolve.colors.red, code )
			
			this, me = nil
		else
			evolve:Notify( ply, evolve.colors.red, "No code specified." )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

evolve:RegisterPlugin( PLUGIN )