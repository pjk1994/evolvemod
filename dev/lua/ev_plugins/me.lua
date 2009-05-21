/*-------------------------------------------------------------------------------------------------------------------------
	Action Chat
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Hooks = {}
PLUGIN.Title = "Me"
PLUGIN.Description = "The /me you know of IRC"
PLUGIN.Author = "Overv"
PLUGIN.Chat = "me"
PLUGIN.Usage = "<message>"

function PLUGIN:Call( ply, args )
	if #args > 0 then
		local msg = table.concat( args, " " )
		return true, ply:Nick() .. " " .. msg
	else
		return false, "No message specified!"
	end
end

Evolve:RegisterPlugin( PLUGIN )