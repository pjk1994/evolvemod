/*-------------------------------------------------------------------------------------------------------------------------
	GUI player tab
-------------------------------------------------------------------------------------------------------------------------*/

local tab = { }
local buttons = { }

local function getSelectedPlayers( )
	local players = { }
	for _, v in pairs( tab.playerList:GetSelectedItems( ) ) do
		table.insert( players, v:GetValue( ) )
	end
	
	return players
end

local lAlts = { }
local submenuButtons = { }

local function clearSubmenu( )
	for _, v in pairs( submenuButtons ) do
		tab.submenu.container:RemoveItem( v, true )
		v:RemoveEx( )
	end
	submenuButtons = { }
	if ( tab.submenu:GetExpanded( ) == true ) then tab.submenu:Toggle( ) end
end

local function closeSubmenu( )
	timer.Destroy( "tmSubmenu" )
	timer.Create( "tmSubmenu", 0.01, 0, function( )
		local x, y = tab.categoryContainer:GetPos( )
		tab.categoryContainer:SetPos( x + ( -x / 5 ), y )
		tab.submenu:SetPos( tab.categoryContainer:GetPos( ) + tab.categoryContainer:GetWide( ), 0 )
		
		if ( x > -5 ) then
			tab.categoryContainer:SetPos( 0, y )
			tab.submenu:SetPos( tab.categoryContainer:GetWide( ), 0 )
			clearSubmenu( )
			
			timer.Destroy( "tmSubmenu" )
		end
	end )
end

local function addButton( plugin )
	if ( !plugin.Menu ) then return end
	
	local button = vgui.Create( "ToolMenuButton" )
	button.title, button.category, button.submenu = plugin:Menu( )
	button.plugin = plugin
	button:SetText( button.title )
	button.OnSelect = function( )
		if ( button.submenu ) then
			clearSubmenu( )			
			tab.submenu:Toggle( )
			tab.submenu:InvalidateLayout( )
			tab.submenu:SetLabel( button.title )
			
			local lAlt = false
			for _, item in pairs( button.submenu ) do
				local button = vgui.Create( "ToolMenuButton", tab.submenu.container )
				button:SetText( item[1] )
				button.text = item[1]
				if ( item[2] ) then button.value = item[2] else button.value = item[1] end
				button.plugin = plugin
				button.OnSelect = function( )
					button.plugin:Menu( button.value, getSelectedPlayers( ) )
					closeSubmenu( )
				end
				button.m_bAlt = lAlt
				tab.submenu.container:AddItem( button )
				lAlt = !lAlt
				
				table.insert( submenuButtons, button )
			end
			local button = vgui.Create( "ToolMenuButton", tab.submenu.container )
			button:SetText( "Cancel" )
			button.OnSelect = function( )
				closeSubmenu( )
			end
			button.m_bAlt = lAlt
			tab.submenu.container:AddItem( button )
			table.insert( submenuButtons, button )
			
			timer.Destroy( "tmSubmenu" )
			timer.Create( "tmSubmenu", 0.01, 0, function( )
				local x, y = tab.categoryContainer:GetPos( )
				tab.categoryContainer:SetPos( x - ( x + tab.categoryContainer:GetWide( ) ) / 5, y )
				tab.submenu:SetPos( tab.categoryContainer:GetPos( ) + tab.categoryContainer:GetWide( ), 0 )
				
				if ( x - 5 <= -tab.categoryContainer:GetWide( ) ) then
					tab.categoryContainer:SetPos( -tab.categoryContainer:GetWide( ), y )
					tab.submenu:SetPos( 0, 0 )
					timer.Destroy( "tmSubmenu" )
				end
			end )
		else
			button.plugin:Menu( "", getSelectedPlayers( ) )
		end
	end
	
	button.m_bAlt = lAlts[ button.category ]
	lAlts[ button.category ] = !lAlts[ button.category ]
	
	table.insert( buttons, button )
	
	tab.categories[ button.category ].container:AddItem( button )
end

local function rebuildPlayerList( )
	tab.playerList:Clear( )
	tab.playerList.players = { }
	
	for _, ply in pairs( player.GetAll( ) ) do
		local li = tab.playerList:AddItem( ply:Nick( ) )
		
		if ( table.HasValue( tab.playerList.selected, ply:Nick( ) ) ) then
			li:Select( )
		end
		
		table.insert( tab.playerList.players, ply )
	end
end

local function updateTab( )
	rebuildPlayerList( )
	
	if ( #submenuButtons > 0 ) then
		timer.Destroy( "tmSubmenu" )
		tab.categoryContainer:SetPos( 0, y )
		tab.submenu:SetPos( tab.categoryContainer:GetWide( ), 0 )
		for _, v in pairs( submenuButtons ) do
			tab.submenu.container:RemoveItem( v, true )
			v:RemoveEx( )
		end
		submenuButtons = { }
		tab.submenu:Toggle( )
	end
end

local function buildTab( )
	tab.container = vgui.Create( "DHorizontalDivider", evolve.menuContainer )
	tab.container:SetSize( evolve.menuw - 10, evolve.menuh - 30 )
	tab.container:SetDividerWidth( 5 )
	tab.container:SetLeftWidth( 420 )
	tab.container:SetLeftMin( 200 )
	tab.container:SetRightMin( 120 )
	evolve.menuContainer:AddSheet( "Players", tab.container, "gui/silkicons/group", false, false, "Player commands." )
	
	tab.playerList = vgui.Create( "DComboBox", tab.container )
	tab.playerList:SetPos( 0, 2 )
	tab.playerList:SetMultiple( true )
	tab.playerList.players = { }
	tab.playerList.selected = { player.GetAll( )[1]:Nick( ) }
	local fi = false
	for _, ply in pairs( player.GetAll( ) ) do
		local li = tab.playerList:AddItem( ply:Nick( ) )
		
		if ( !fi ) then
			li:Select( true )
			fi = true
		end
		
		table.insert( tab.playerList.players, ply )
	end
	tab.playerList.oldPaint = tab.playerList.Paint
	tab.playerList.Paint = function( )
		for _, v in pairs( tab.playerList.players ) do
			if ( !ValidEntity( v ) ) then
				rebuildPlayerList( )	
				break
			end
		end
		
		tab.playerList.selected = getSelectedPlayers( )
		tab.playerList:oldPaint( )
	end
	
	tab.container:SetLeft( tab.playerList )
	
	tab.commandsContainer = vgui.Create( "DPanelList", tab.container )
	tab.commandsContainer:SetPos( tab.playerList:GetWide( ) + 5, 0 )
	tab.commandsContainer:SetSize( evolve.menuw - 15 - tab.playerList:GetWide( ), tab.container:GetTall( ) - 1 )
	tab.categoryContainer = vgui.Create( "DPanelList", tab.commandsContainer )
	tab.categoryContainer:SetPos( 0, 0 )
	tab.categoryContainer:SetSize( tab.commandsContainer:GetWide( ), tab.commandsContainer:GetTall( ) )
	
	tab.categories = { }
	tab.categories[1] = vgui.Create( "DCollapsibleCategory", tab.categoryContainer )
	tab.categories[1]:SetPos( 0, 0 )
	tab.categories[1]:SetSize( tab.categoryContainer:GetWide( ), 22 )
	tab.categories[1]:SetExpanded( 0 )
	tab.categories[1]:SetLabel( "Administration" )
	tab.categories[1].container = vgui.Create( "DPanelList", tab.categories[1] )
	tab.categories[1].container:SetAutoSize( true )
	tab.categories[1].container:SetSpacing( 0 )
	tab.categories[1].container:EnableHorizontal( false )
	tab.categories[1].container:EnableVerticalScrollbar( true )
	tab.categories[1]:SetContents( tab.categories[1].container )
	
	tab.categories[2] = vgui.Create( "DCollapsibleCategory", tab.categoryContainer )
	tab.categories[2]:SetPos( 0, tab.categories[1]:GetTall( ) + 1 )
	tab.categories[2]:SetSize( tab.categoryContainer:GetWide( ), 22 )
	tab.categories[2]:SetExpanded( 0 )
	tab.categories[2]:SetLabel( "Actions" )
	tab.categories[2].container = vgui.Create( "DPanelList", tab.categories[2] )
	tab.categories[2].container:SetAutoSize( true )
	tab.categories[2].container:SetSpacing( 0 )
	tab.categories[2].container:EnableHorizontal( false )
	tab.categories[2].container:EnableVerticalScrollbar( true )
	tab.categories[2]:SetContents( tab.categories[2].container )
	
	tab.categories[3] = vgui.Create( "DCollapsibleCategory", tab.categoryContainer )
	tab.categories[3]:SetPos( 0, tab.categories[1]:GetTall( ) + tab.categories[2]:GetTall( ) + 2 )
	tab.categories[3]:SetSize( tab.categoryContainer:GetWide( ), 22 )
	tab.categories[3]:SetExpanded( 0 )
	tab.categories[3]:SetLabel( "Punishment" )
	tab.categories[3].container = vgui.Create( "DPanelList", tab.categories[3] )
	tab.categories[3].container:SetAutoSize( true )
	tab.categories[3].container:SetSpacing( 0 )
	tab.categories[3].container:EnableHorizontal( false )
	tab.categories[3].container:EnableVerticalScrollbar( true )
	tab.categories[3]:SetContents( tab.categories[3].container )
	
	tab.categories[4] = vgui.Create( "DCollapsibleCategory", tab.categoryContainer )
	tab.categories[4]:SetPos( 0, tab.categories[1]:GetTall( ) + tab.categories[2]:GetTall( ) + tab.categories[3]:GetTall( ) + 3 )
	tab.categories[4]:SetSize( tab.categoryContainer:GetWide( ), 22 )
	tab.categories[4]:SetExpanded( 0 )
	tab.categories[4]:SetLabel( "Teleportation" )
	tab.categories[4].container = vgui.Create( "DPanelList", tab.categories[4] )
	tab.categories[4].container:SetAutoSize( true )
	tab.categories[4].container:SetSpacing( 0 )
	tab.categories[4].container:EnableHorizontal( false )
	tab.categories[4].container:EnableVerticalScrollbar( true )
	tab.categories[4]:SetContents( tab.categories[4].container )
	
	tab.submenu = vgui.Create( "DCollapsibleCategory", tab.commandsContainer )
	tab.submenu:SetPos( tab.categoryContainer:GetWide( ), 0 )
	tab.submenu:SetSize( tab.categoryContainer:GetWide( ), 22 )
	tab.submenu:SetExpanded( 0 )
	tab.submenu:SetLabel( "#Command" )
	tab.submenu:SetAnimTime( 0.0 )
	tab.submenu.container = vgui.Create( "DPanelList", tab.submenu )
	tab.submenu.container:SetAutoSize( true )
	tab.submenu.container:SetSpacing( 0 )
	tab.submenu.container:EnableHorizontal( false )
	tab.submenu.container:EnableVerticalScrollbar( true )
	tab.submenu:SetContents( tab.submenu.container )
	
	for _, v in pairs( evolve.plugins ) do addButton( v ) end
	table.SortByMember( buttons, "title", function( a, b ) return a > b end )
	
	timer.Create( "tmUpdateEVMenus", 0.01, 0, function( )
		local offset = 0
		for _, v in ipairs( tab.categories ) do
			v:SetPos( 0, offset )
			offset = offset + v:GetTall( ) + 1
		end
	end )
	
	tab.container:SetRight( tab.commandsContainer )
end

evolve:registerMenuTab( buildTab, updateTab )