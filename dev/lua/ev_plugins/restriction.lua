/*-------------------------------------------------------------------------------------------------------------------------
	View commands
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Hooks = {}
PLUGIN.Title = "Restriction"
PLUGIN.Description = "Restrict weapons and entities"
PLUGIN.Author = "Overv"
PLUGIN.Chat = "restrict"
PLUGIN.Enabled = false

function PLUGIN:Call( ply, args )
	// First check if the caller is an admin
	if ply:IsSuperAdmin() then
		
		if args[1] then
			if tonumber( args[1] ) then
				if tonumber( args[1] ) > 0 then
					self.Enabled = true
				else
					self.Enabled = false
				end
			else
				return false, "The enabled argument must be numeric!"
			end
		else
			self.Enabled = !self.Enabled
		end
		
		if self.Enabled then
			return true, ply:Nick() .. " has restricted weapons and entities for guests."
		else
			return true, ply:Nick() .. " has allowed weapons and entities for guests."
		end
		
	end
end

function PLUGIN:PlayerLoadout( ply )
	if self.Enabled and !ply:IsAdmin() then
		ply:Give( "weapon_physgun" )
		ply:Give( "weapon_physcannon" )
		ply:Give( "gmod_camera" )
		ply:Give( "gmod_tool" )
		
		return true
	end
end

function PLUGIN:PlayerCanPickupWeapon( ply, wep )
	if !self.Enabled then
		local class = wep:GetClass()
		if class == "weapon_physgun" or class == "weapon_physcannon" or class == "gmod_camera" or class == "gmod_tool" or class == ply:GetNWString( "EV_AllowedWeapon", "" ) then
			if ply:GetNWString( "EV_AllowedWeapon", "" ) != "" then ply:SetNWString( "EV_AllowedWeapon", "" ) end
			return true
		elseif !ply:IsAdmin() then
			wep:Remove()
			return false
		end
	end
end

function PLUGIN:PlayerSpawnSENT( ply )
	if self.Enabled and !ply:IsAdmin() then
		return false
	end
end

Evolve:RegisterPlugin( PLUGIN )