/*-------------------------------------------------------------------------------------------------------------------------
	Player tab
-------------------------------------------------------------------------------------------------------------------------*/

local TAB = {}
TAB.Title = "Players"
TAB.Description = "Player commands."
TAB.Author = "Overv"

TAB.CategoryNames = {
	"Administration",
	"Actions",
	"Punishment",
	"Teleportation"
}

if ( CLIENT ) then
	TAB.iconUser = surface.GetTextureID( "gui/silkicons/user" )
	TAB.iconRespected = surface.GetTextureID( "gui/silkicons/user_add" )
	TAB.iconAdmin = surface.GetTextureID( "gui/silkicons/shield" )
	TAB.iconSuperAdmin = surface.GetTextureID( "gui/silkicons/shield_add" )
	TAB.iconOwner = surface.GetTextureID( "gui/silkicons/key" )
	TAB.iconChat = surface.GetTextureID( "gui/silkicons/comments" )
end

TAB.Buttons = {}
TAB.LAlts = {}
TAB.SubmenuButtons = {}

function TAB:GetSelectedPlayers()
	local players = {}
	
	for _, v in pairs( self.PlayerList:GetSelectedItems() ) do
		table.insert( players, v.Value )
	end
	
	return players
end

function TAB:ClearSubmenu()
	for _, v in pairs( self.SubmenuButtons ) do
		self.Submenu.Container:RemoveItem( v, true )
		v:RemoveEx()
	end
	
	self.SubmenuButtons = {}
	
	if ( self.Submenu:GetExpanded() == true ) then self.Submenu:Toggle() end
end

function TAB:CloseSubmenu()
	timer.Destroy( "tmSubmenu" )
	timer.Create( "tmSubmenu", 0.01, 0, function()
		local x, y = self.CategoryContainer:GetPos()
		self.CategoryContainer:SetPos( x + ( -x / 5 ), y )
		self.Submenu:SetPos( self.CategoryContainer:GetPos() + self.CategoryContainer:GetWide(), 0 )
		
		if ( x > -5 ) then
			self.CategoryContainer:SetPos( 0, y )
			self.Submenu:SetPos( self.CategoryContainer:GetWide(), 0 )
			self:ClearSubmenu()
			
			timer.Destroy( "tmSubmenu" )
		end
	end )
end

function TAB:AddButton( plugin )
	if ( !plugin.Menu ) then return end
	
	local button = vgui.Create( "ToolMenuButton" )
	button.title, button.category, button.submenu = plugin:Menu()
	button.plugin = plugin
	button:SetText( button.title )
	button.OnSelect = function()
		if ( button.submenu ) then
			self:ClearSubmenu()			
			self.Submenu:Toggle()
			self.Submenu:InvalidateLayout()
			self.Submenu:SetLabel( button.title )
			
			local lAlt = false
			for _, item in pairs( button.submenu ) do
				local button = vgui.Create( "ToolMenuButton", self.Submenu.container )
				button:SetText( item[1] )
				button.text = item[1]
				if ( item[2] ) then button.value = item[2] else button.value = item[1] end
				button.plugin = plugin
				button.OnSelect = function()
					button.plugin:Menu( button.value, self:GetSelectedPlayers() )
					self:CloseSubmenu()
				end
				button.m_bAlt = lAlt
				self.Submenu.Container:AddItem( button )
				lAlt = !lAlt
				
				table.insert( self.SubmenuButtons, button )
			end
			local button = vgui.Create( "ToolMenuButton", self.Submenu.Container )
			button:SetText( "Cancel" )
			button.OnSelect = function()
				self:CloseSubmenu()
			end
			button.m_bAlt = lAlt
			self.Submenu.Container:AddItem( button )
			table.insert( self.SubmenuButtons, button )
			
			timer.Destroy( "tmSubmenu" )
			timer.Create( "tmSubmenu", 0.01, 0, function()
				local x, y = self.CategoryContainer:GetPos()
				self.CategoryContainer:SetPos( x - ( x + self.CategoryContainer:GetWide() ) / 5, y )
				self.Submenu:SetPos( self.CategoryContainer:GetPos() + self.CategoryContainer:GetWide(), 0 )
				
				if ( x - 5 <= -self.CategoryContainer:GetWide() ) then
					self.CategoryContainer:SetPos( -self.CategoryContainer:GetWide(), y )
					self.Submenu:SetPos( 0, 0 )
					timer.Destroy( "tmSubmenu" )
				end
			end )
		else
			button.plugin:Menu( "", self:GetSelectedPlayers() )
		end
	end
	
	button.m_bAlt = self.LAlts[ button.category ]
	self.LAlts[ button.category ] = !self.LAlts[ button.category ]
	
	table.insert( self.Buttons, button )
	
	self.Categories[ button.category ].Container:AddItem( button )
end

function TAB:RebuildPlayerList()
	self.PlayerList:Clear()
	self.PlayerList.Players = {}
	
	local tempList = {}
	
	for _, ply in pairs( player.GetAll() ) do
		table.insert( tempList, { Ply = ply, Nick = ply:Nick() } )
	end
	table.SortByMember( tempList, "Nick", function( a, b ) return a > b end )
	
	for _, entry in ipairs( tempList ) do
		local ply = entry.Ply
		local li = self.PlayerList:AddItem( "" )
		li.Value = ply:Nick()
		
		li.PaintOver = function()
			draw.SimpleText( ply:GetNWString( "SteamID" ), "DefaultSmall", li:GetWide() - 100, 4, Color( 0, 0, 0, 255 ) )
			draw.SimpleText( ply:Nick(), "Default", 24, 3, Color( 0, 0, 0, 255 ) )
			
			surface.SetDrawColor( 255, 255, 255, 255 )
			
			if ( ply:EV_IsOwner() ) then
				surface.SetTexture( self.iconOwner )
			elseif ( ply:EV_IsSuperAdmin() ) then
				surface.SetTexture( self.iconSuperAdmin )
			elseif ( ply:EV_IsAdmin() ) then
				surface.SetTexture( self.iconAdmin )
			elseif ( ply:EV_IsRespected() ) then
				surface.SetTexture( self.iconRespected)
			else
				surface.SetTexture( self.iconUser )
			end
			
			surface.DrawTexturedRect( 3, 2, 16, 16 )
		end
		
		if ( table.HasValue( self.PlayerList.Selected, ply:Nick() ) ) then
			li:Select()
		end
		
		table.insert( self.PlayerList.Players, ply )
	end
end

function TAB:Update()
	self:RebuildPlayerList()
	
	if ( #self.SubmenuButtons > 0 ) then
		timer.Destroy( "tmSubmenu" )
		
		self.CategoryContainer:SetPos( 0, y )
		self.Submenu:SetPos( self.CategoryContainer:GetWide(), 0 )
		
		for _, v in pairs( self.SubmenuButtons ) do
			self.Submenu.Container:RemoveItem( v, true )
			v:RemoveEx()
		end
		
		self.SubmenuButtons = { }
		self.Submenu:Toggle()
	end
end

function TAB:Initialize()
	self.Container = vgui.Create( "DHorizontalDivider", evolve.menuContainer )
	self.Container:SetSize( evolve.menuw - 10, evolve.menuh - 30 )
	self.Container:SetDividerWidth( 5 )
	self.Container:SetLeftWidth( 420 )
	self.Container:SetLeftMin( 200 )
	self.Container:SetRightMin( 120 )
	evolve.menuContainer:AddSheet( self.Title, self.Container, "gui/silkicons/group", false, false, self.Description )
	
	self.PlayerList = vgui.Create( "DComboBox", self.Container )
	self.PlayerList:SetPos( 0, 2 )
	self.PlayerList:SetMultiple( true )
	self.PlayerList.Players = {}
	self.PlayerList.Selected = { player.GetAll()[1]:Nick() }
	
	local fi = false
	
	for _, ply in pairs( player.GetAll() ) do
		local li = self.PlayerList:AddItem( ply:Nick() )
		
		if ( !fi ) then
			li:Select( true )
			fi = true
		end
		
		table.insert( self.PlayerList.Players, ply )
	end
	
	self.PlayerList.PaintOver = function()
		for _, v in pairs( self.PlayerList.Players ) do
			if ( !ValidEntity( v ) ) then
				self:RebuildPlayerList()	
				break
			end
		end
		
		self.PlayerList.Selected = self:GetSelectedPlayers()
	end
	
	self.Container:SetLeft( self.PlayerList )
	
	self.CommandsContainer = vgui.Create( "DPanelList", self.Container )
	self.CommandsContainer:SetPos( self.PlayerList:GetWide() + 5, 0 )
	self.CommandsContainer:SetSize( evolve.menuw - 15 - self.PlayerList:GetWide(), self.Container:GetTall() - 1 )
	self.CategoryContainer = vgui.Create( "DPanelList", self.CommandsContainer )
	self.CategoryContainer:SetPos( 0, 0 )
	self.CategoryContainer:SetSize( self.CommandsContainer:GetWide(), self.CommandsContainer:GetTall() )
	
	self.Categories = { }
	
	for i = 1, 4 do
		self.Categories[i] = vgui.Create( "DCollapsibleCategory", self.CategoryContainer )
		self.Categories[i]:SetPos( 0, 22 * ( i - 1 ) )
		self.Categories[i]:SetSize( self.CategoryContainer:GetWide(), 22 )
		self.Categories[i]:SetExpanded( 0 )
		self.Categories[i]:SetLabel( self.CategoryNames[i] )
		self.Categories[i].Container = vgui.Create( "DPanelList", self.Categories[i] )
		self.Categories[i].Container:SetAutoSize( true )
		self.Categories[i].Container:SetSpacing( 0 )
		self.Categories[i].Container:EnableHorizontal( false )
		self.Categories[i].Container:EnableVerticalScrollbar( true )
		self.Categories[i]:SetContents( self.Categories[i].Container )
	end
	
	self.Submenu = vgui.Create( "DCollapsibleCategory", self.CommandsContainer )
	self.Submenu:SetPos( self.CategoryContainer:GetWide(), 0 )
	self.Submenu:SetSize( self.CategoryContainer:GetWide(), 22 )
	self.Submenu:SetExpanded( 0 )
	self.Submenu:SetLabel( "#Command" )
	self.Submenu:SetAnimTime( 0.0 )
	self.Submenu.Container = vgui.Create( "DPanelList", self.Submenu )
	self.Submenu.Container:SetAutoSize( true )
	self.Submenu.Container:SetSpacing( 0 )
	self.Submenu.Container:EnableHorizontal( false )
	self.Submenu.Container:EnableVerticalScrollbar( true )
	self.Submenu:SetContents( self.Submenu.Container )
	
	for _, v in pairs( evolve.plugins ) do self:AddButton( v ) end
	table.SortByMember( self.Buttons, "title", function( a, b ) return a > b end )
	
	timer.Create( "tmUpdateEVMenus", 0.01, 0, function()
		local offset = 0
		for _, v in ipairs( self.Categories ) do
			v:SetPos( 0, offset )
			offset = offset + v:GetTall() + 1
		end
	end )
	
	self.Container:SetRight( self.CommandsContainer )
end

function TAB:PlayerInitialSpawn( ply )
	ply:SetNWString( "SteamID", ply:SteamID() )
end

evolve:RegisterMenuTab( TAB )