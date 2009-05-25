/*-------------------------------------------------------------------------------------------------------------------------
	View commands
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Hooks = {}
PLUGIN.Title = "Commands"
PLUGIN.Description = "List all commands"
PLUGIN.Author = "Overv"
PLUGIN.Chat = "commands"

function PLUGIN:Call( ply, args )
	ply:PrintMessage( HUD_PRINTCONSOLE, "\n================================================================\n" )
		ply:PrintMessage( HUD_PRINTCONSOLE, "Evolve Command List\n" )
		ply:PrintMessage( HUD_PRINTCONSOLE, "-> " .. #Evolve.Plugins .. " plugins installed.\n" )
	ply:PrintMessage( HUD_PRINTCONSOLE, "================================================================\n\n" )
	
	local plugs = Evolve.Plugins
	table.SortByMember( plugs, "Chat", true )
	
	for _, p in pairs( plugs ) do
		if p.Chat then
			if p.Usage then
				ply:PrintMessage( HUD_PRINTCONSOLE, "!" .. p.Chat .. " " .. p.Usage .. " : " ..  p.Description .. "\n" )
			else
				ply:PrintMessage( HUD_PRINTCONSOLE, "!" .. p.Chat .. " : " ..  p.Description .. "\n" )
			end
		end
	end
	
	ply:PrintMessage( HUD_PRINTCONSOLE, "\n" )
	
	return false, "The commands have been printed to your console!"
end

Evolve:RegisterPlugin( PLUGIN )