/*-------------------------------------------------------------------------------------------------------------------------
	Ban
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Ban"
PLUGIN.Description = "Ban players with an optional reason and time"
require( "glon" )

PLUGIN.Author = "Overv"
PLUGIN.Chat = "ban"
PLUGIN.Usage = "<player> <time 0=perma> [reason]"
PLUGIN.Bans = {}

function PLUGIN:Call( ply, args )
	// First check if the caller is an admin
	if ply:IsSuperAdmin() then
	
		// Find the player to god
		local pl = Evolve:FindPlayer( args[1] )
		
		if pl then
			// Is the caller allowed to god this player?
			if Evolve:SameOrBetter(ply, pl) then
				return false, "You can't ban a player with an equal or higher rank!"
			end
			
			// Check the time
			if !args[2] or !tonumber(args[2]) then
				return false, "The time must be a number!"
			elseif tonumber(args[2]) < 0 then
				return false, "The time can't be a negative number!"
			end
			local Time = tonumber(args[2])
			
			// Get the optional reason or choose the default N/A
			local Reason = "N/A"
			if #args > 2 then
				Reason = table.concat( args, " ", 3 )
			end
			
			// Handle the ban
			if Time == 0 then
				pl:Kick( "You have been permabanned (" .. Reason .. ")" )
				self:AddBan( pl:UniqueID(), pl:IPAddress(), 0, Reason, ply:UniqueID() )
				
				return true, ply:Nick() .. " has permabanned " .. pl:Nick() .. " (" .. Reason .. ")"
			else
				pl:Kick( "You have been banned for " .. Time .. " minutes (" .. Reason .. ")" )
				self:AddBan( pl:UniqueID(), pl:IPAddress(), Time * 60, Reason, ply:UniqueID() )
				
				return true, ply:Nick() .. " has banned " .. pl:Nick() .. " for " .. Time .. " minutes (" .. Reason .. ")"
			end
		else
			return false, "Player not found!"
		end
	else
		return false, "You are not a super admin!"
	end
end

// Add a new ban
function PLUGIN:AddBan( bannedid, bannedip, time, reason, bannedid, banner )
	local NewBan = {}
	NewBan.BannedUI = bannedid
	NewBan.BannedIP = bannedip
	if time > 0 then NewBan.EndTime = math.floor(CurTime() + time) else NewBan.EndTime = 0 end
	NewBan.Time = time
	NewBan.Reason = reason
	NewBan.BannerUI = bannedid
	
	table.insert( self.Bans, NewBan )
	RunConsoleCommand( "addip", time, bannedip )
	self:SaveBans()
end

function PLUGIN:SaveBans()
	// Save bans internally
	local str = glon.encode( self.Bans )
	file.Write( "Evolve/bans.txt", str )
end

function PLUGIN:LoadBans()
	// Load bans
	if file.Exists( "Evolve/bans.txt" ) then
		local str = file.Read( "Evolve/bans.txt" )
		self.Bans = glon.decode( str )
		
		// Re-ban everyone
		for _, v in pairs(self.Bans) do
			RunConsoleCommand( "addip", v.Time, v.BannedIP )
		end
	end
end
PLUGIN:LoadBans()

Evolve:RegisterPlugin( PLUGIN )