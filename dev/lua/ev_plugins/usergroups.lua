/*-------------------------------------------------------------------------------------------------------------------------
	Plugin which handles usergroups
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Hooks = {}
PLUGIN.Title = "User Groups"
PLUGIN.Description = "Handle usergroups"
PLUGIN.Author = "Overv"
PLUGIN.Chat = "group"
PLUGIN.Usage = "<player> <group>"

function PLUGIN:SetGroup( ply, group )
	local gr = Evolve:GetGroup( group )
	
	ply:SetNWString( "EV_UserGroup", gr.name )
	ply:SetUserGroup( gr.group )
end

function PLUGIN:Call( ply, args )
	// Find the player to group
	local pl = Evolve:FindPlayer( args[1] )
	
	// Check if the player exists
	if pl then
		local group = table.concat( args, " ", 2 )
		
		if !ply:BetterThan( pl ) then
			return false, "You can't group a player with the same or a higher rank!"
		end
		
		// Check if the player isn't making someone the same group as himself or higher :o
		if Evolve:GetGroup( group ) then
			if Evolve:GetGroup( group ).immunity >= ply:GetGroup( ).immunity then
				return false, "You can't promote someone to the same as or higher than your group!"
			else
				self:SetGroup( pl, group )
				local statid = self:FindStats( pl:UniqueID() )
				Evolve.Stats[ statid ].UserGroup = group
				self:SaveStats( )
				
				if string.find( string.lower( string.Left( group, 1 ) ), "aeuihyo" ) then
					return true, ply:Nick( ) .. " has made " .. pl:Nick( ) .. " an " .. group .. "."
				else
					return true, ply:Nick( ) .. " has made " .. pl:Nick( ) .. " a " .. group .. "."
				end
			end
		else
			return false, "Unknown group specified!"
		end
	else
		return false, "Player not found!"
	end
end

function PLUGIN:FindStats( unid )
	for i, v in pairs( Evolve.Stats ) do
		if v.UniqueID == unid then return i end
	end
end

function PLUGIN:SaveStats( )
	local str = glon.encode( Evolve.Stats )
	file.Write( "Evolve/playerstats.txt", str )
end

function PLUGIN:PlayerSpawn( ply )
	if ply.EV_GroupSet then return  end
	ply.EV_GroupSet = true
	
	local statid = self:FindStats( ply:UniqueID() )
	if !statid then
		if Evolve:GetGroup( ply:GetNWString( "UserGroup", "unknown" ) ) then
			self:SetGroup( ply, ply:GetNWString( "UserGroup" ) )
		else
			for _, g in pairs( Evolve.UserGroups ) do
				if g.group == ply:GetNWString( "UserGroup", "unknown" ) then
					self:SetNWString( "EV_UserGroup", g.name )
					return 
				end
			end
			self:SetGroup( ply, "Guest" )
		end
	else
		self:SetGroup( ply, Evolve.Stats[ statid ].UserGroup )
	end
end

Evolve:RegisterPlugin( PLUGIN )