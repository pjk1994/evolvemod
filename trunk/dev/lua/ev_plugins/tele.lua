/*-------------------------------------------------------------------------------------------------------------------------
	Teleporting
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Hooks = {}
PLUGIN.Title = "Teleport"
PLUGIN.Description = "Teleport to where you aim or certain coordinates"
PLUGIN.Author = "Overv"
PLUGIN.Chat = "tp"

function PLUGIN:Call( ply, args )
	// First check if the caller is an admin
	if ply:IsAdmin() then
	
		if #args == 0 then
			ply:SetPos( ply:GetEyeTrace( ).HitPos )
		elseif tonumber( args[1] ) and tonumber( args[2] ) and tonumber( args[3] ) then
			ply:SetPos( Vector( args[1], args[2], args[3] ) )
		else
			return false, "Invalid coordinates!"
		end
		
	else
		return false, "You are not an administrator!"
	end
end

Evolve:RegisterPlugin( PLUGIN )