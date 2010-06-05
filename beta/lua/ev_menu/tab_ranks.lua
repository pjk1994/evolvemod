/*-------------------------------------------------------------------------------------------------------------------------
	Tab with rank management
-------------------------------------------------------------------------------------------------------------------------*/

local TAB = {}
TAB.Title = "Ranks"
TAB.Description = "Manage ranks."
TAB.Icon = "gui/silkicons/group"
TAB.Author = "Overv"
TAB.Width = 260
TAB.Privileges = { "Rank menu" }

function TAB:Initialize( pnl )
	// Create the rank list
	self.RankList = vgui.Create( "DComboBox", pnl )
	self.RankList:SetPos( 0, 0 )
	self.RankList:SetSize( self.Width, 105 )
	self.RankList:SetMultiple( false )
	self.RankList.Think = function()
		if ( self.LastRank != self.RankList:GetSelectedItems()[1].Rank ) then self.LastRank = self.RankList:GetSelectedItems()[1].Rank else return end
		self.ColorCircle:SetColor( evolve.ranks[ self.LastRank ].Color or color_white )
		self.Immunity:SetValue( evolve.ranks[ self.LastRank ].Immunity or 0 )
		self.Usergroup:SetText( evolve.ranks[ self.LastRank ].UserGroup or "unknown" )
		self.Usergroup.Selected = evolve.ranks[ self.LastRank ].UserGroup or "unknown"
	end
	
	// Create the privilege list
	self.PrivList = vgui.Create( "DListView", pnl )
	self.PrivList:SetPos( 0, self.RankList:GetTall() + 5 + 79 )
	self.PrivList:SetSize( self.Width, pnl:GetParent():GetTall() - 105 - 63 - 79 )
	local col = self.PrivList:AddColumn( "Privilege" )
	col:SetFixedWidth( self.Width * 0.8 )
	self.PrivList:AddColumn( "" )
	
	self.PropertyContainer = vgui.Create( "DPanelList", pnl )
	self.PropertyContainer:SetPos( 0, 110 )
	self.PropertyContainer:SetSize( self.Width, 74 )
	
	// Rank color
	self.ColorCircle = vgui.Create( "DColorCircle", self.PropertyContainer )
	self.ColorCircle:SetPos( 5, 5 )
	self.ColorCircle:SetSize( 64, 64 )
	self.ColorCircle.TranslateValues = function( self, x, y )
		x = x - 0.5
		y = y - 0.5
		
		local angle = math.atan2( x, y )
		
		local length = math.sqrt( x*x + y*y )
		length = math.Clamp( length, 0, 0.5 )
		
		x = 0.5 + math.sin( angle ) * length
		y = 0.5 + math.cos( angle ) * length
		
		self:SetHue( math.Rad2Deg( angle ) + 270 )
		self:SetSaturation( length * 2 )
		
		self:SetRGB( HSVToColor( self:GetHue(), self:GetSaturation(), 1 ) )

		return x, y
	end
	self.ColorCircle.SetColor = function( self, color )		
		local hue, sat, value = ColorToHSV( color )
		
		self:SetHue( hue )
		self:SetSaturation( sat )
		self:SetRGB( color )
		
		local length = sat / 2
		local angle = math.Deg2Rad( hue - 270 )
		
		local x = 0.5 + math.sin( angle ) * length
		local y = 0.5 + math.cos( angle ) * length
		
		self:SetSlideX( x )
		self:SetSlideY( y )
	end
	self.ColorCircle.OldRelease = self.ColorCircle.OnMouseReleased
	self.ColorCircle.OnMouseReleased = function( mcode )
		self.ColorCircle.OldRelease( mcode )
		local color = self.ColorCircle:GetRGB()
		RunConsoleCommand( "ev_setrankp", self.RankList:GetSelectedItems()[1].Rank, self.Immunity:GetValue(), self.Usergroup.Selected, color.r, color.g, color.b )
	end
	self.ColorCircle:SetColor( color_white )
	
	// Immunity
	self.Immunity = vgui.Create( "DNumSlider", self.PropertyContainer )
	self.Immunity:SetPos( 74, 5 )
	self.Immunity:SetWide( self.Width - 79 )
	self.Immunity:SetDecimals( 0 )
	self.Immunity:SetMin( 0 )
	self.Immunity:SetMax( 99 )
	self.Immunity:SetText( "Immunity" )
	self.Immunity.Think = function()
		if ( input.IsMouseDown( MOUSE_LEFT ) ) then
			self.applySettings = true
		elseif ( !input.IsMouseDown( MOUSE_LEFT ) and self.applySettings ) then
			local rank = self.RankList:GetSelectedItems()[1].Rank
			if ( evolve.ranks[ rank ].Immunity != self.Immunity:GetValue() ) then
				local color = self.ColorCircle:GetRGB()
				RunConsoleCommand( "ev_setrankp", self.RankList:GetSelectedItems()[1].Rank, self.Immunity:GetValue(), self.Usergroup.Selected, color.r, color.g, color.b )
			end
			self.applySettings = false
		end
	end
	
	// User group
	self.Usergroup = vgui.Create( "DMultiChoice", self.PropertyContainer )
	self.Usergroup:SetPos( 74, 49 )
	self.Usergroup:SetSize( self.Width - 79, 20 )
	self.Usergroup:SetEditable( false )
	self.Usergroup:AddChoice( "guest" )
	self.Usergroup:AddChoice( "admin" )
	self.Usergroup:AddChoice( "superadmin" )
	self.Usergroup:ChooseOptionID( 1 )
	self.Usergroup.OnSelect = function( id, value, data )
		self.Usergroup.Selected = data
		local color = self.ColorCircle:GetRGB()
		RunConsoleCommand( "ev_setrankp", self.RankList:GetSelectedItems()[1].Rank, self.Immunity:GetValue(), data, color.r, color.g, color.b )
	end
	
	// New button
	self.NewButton = vgui.Create( "EvolveButton", pnl )
	self.NewButton:SetPos( 0, pnl:GetParent():GetTall() - 53 )
	self.NewButton:SetSize( 60, 22 )
	self.NewButton:SetButtonText( "New" )
	self.NewButton:SetNotHighlightedColor( 50 )
	self.NewButton:SetHighlightedColor( 90 )
	self.NewButton.DoClick = function()
		Derma_StringRequest( "Create a rank", "Enter the title of your rank (e.g. Noob):", "", function( title )
			Derma_StringRequest( "Create a rank", "Enter the id of your rank (e.g. noob):", string.gsub( string.lower( title ), " ", "" ), function( id )
				if ( string.find( id, " " ) or string.lower( id ) != id or evolve.ranks[ id ] ) then
					chat.AddText( evolve.colors.red, "You specified an invalid identifier. Make sure it doesn't exist yet and does not contain spaces or capitalized characters." )
				else
					local curRank = self.RankList:GetSelectedItems()[1].Rank
					Derma_Query( "Do you want to derive the settings and privileges of the currently selected rank, " .. evolve.ranks[ curRank ].Title .. "?", "Rank inheritance",
					
						"Yes",
						function()
							RunConsoleCommand( "ev_createrank", id, title, curRank )
						end,
						
						"No",
						function()
							RunConsoleCommand( "ev_createrank", id, title )
						end
					)
				end
			end )
		end )
	end
	
	// Remove button
	self.RemoveButton = vgui.Create( "EvolveButton", pnl )
	self.RemoveButton:SetPos( self.Width - 60, pnl:GetParent():GetTall() - 53 )
	self.RemoveButton:SetSize( 60, 22 )
	self.RemoveButton:SetButtonText( "Remove" )
	self.RemoveButton.DoClick = function()
		local id = self.RankList:GetSelectedItems()[1].Rank
		local rank = evolve.ranks[ id ].Title
		
		if ( id == "guest" ) then
			Derma_Message( "You can't remove the guest rank.", "Removing rank guest", "Ok" )
		else
			Derma_Query( "Are you sure you want to remove the rank " .. rank .. "?", "Removing rank " .. rank, "Yes", function() RunConsoleCommand( "ev_removerank", id ) end, "No", function() end )
		end
	end
	
	// Rename button
	self.RenameButton = vgui.Create( "EvolveButton", pnl )
	self.RenameButton:SetPos( self.Width - 125, pnl:GetParent():GetTall() - 53 )
	self.RenameButton:SetSize( 60, 22 )
	self.RenameButton:SetButtonText( "Rename" )
	self.RenameButton.DoClick = function()
			local rank = self.RankList:GetSelectedItems()[1].Rank
			Derma_StringRequest( "Rename rank " .. evolve.ranks[ rank ].Title, "Enter a new name:", evolve.ranks[ rank ].Title, function( name )
				RunConsoleCommand( "ev_renamerank", rank, name )
			end )
	end
	
	self.ColorCircle:SetColor( evolve.ranks.guest.Color or color_white )
	self.Immunity:SetValue( evolve.ranks.guest.Immunity or 0 )
	self.Usergroup:SetText( evolve.ranks.guest.UserGroup or "unknown" )
	self.Usergroup.Selected = evolve.ranks.guest.UserGroup or "unknown"
end

function TAB:Update()	
	self.RankList:Clear()
	for id, rank in pairs( evolve.ranks ) do
		if ( id != "owner" ) then
			local item = self.RankList:AddItem( "" )
			item:SetTall( 20 )
			item.Rank = id
			
			item.Icon = vgui.Create( "DImage", item )
			item.Icon:SetImage( "gui/silkicons/" .. rank.Icon )
			item.Icon:SetPos( 4, 4 )
			item.Icon:SetSize( 14, 14 )
			item.PaintOver = function()
				draw.SimpleText( rank.Title, "Default", 28, 5, Color( 0, 0, 0, 255 ) )
			end
		end
	end
	self.RankList:SelectItem( self.RankList:GetItems()[1] )
	
	self.PrivList:Clear()
	
	for _, privilege in ipairs( evolve.privileges ) do
		local line = self.PrivList:AddLine( privilege, "" )
		
		line.State = vgui.Create( "DImage", line )
		line.State:SetImage( "gui/silkicons/check_on_s" )
		line.State:SetSize( 16, 16 )
		line.State:SetPos( self.Width * 0.875 - 12, 1 )
		
		line.Think = function()
			if ( line.LastRank != self.RankList:GetSelectedItems()[1].Rank ) then line.LastRank = self.RankList:GetSelectedItems()[1].Rank else return end
			
			line.State:SetVisible( line.LastRank == "owner" or table.HasValue( evolve.ranks[ line.LastRank ].Privileges, privilege ) )
		end
		
		line.OnPress = line.OnMousePressed
		line.LastPress = os.clock()
		
		line.OnMousePressed = function()
			if ( line.LastPress + 0.5 > os.clock() ) then
				if ( line.State:IsVisible() ) then
					RunConsoleCommand( "ev_setrank", line.LastRank, line:GetColumnText( 1 ), 0 )
				else
					RunConsoleCommand( "ev_setrank", line.LastRank, line:GetColumnText( 1 ), 1 )
				end
				
				line.State:SetVisible( !line.State:IsVisible() )				
			end
			
			line.LastPress = os.clock()
			line:OnPress()
		end
	end
	self.PrivList:SelectFirstItem()
end

function TAB:EV_RankRemoved( rank )
	for _, rankitem in pairs( self.RankList:GetItems() ) do
		if ( rankitem.Rank == rank ) then
			self.RankList:RemoveItem( rankitem )
			break
		end
	end
	self.RankList:SelectItem( self.RankList:GetItems()[1] )
end

function TAB:EV_RankRenamed( rank, title )
	for _, rankitem in pairs( self.RankList:GetItems() ) do
		if ( rankitem.Rank == rank ) then
			rankitem.PaintOver = function()
				draw.SimpleText( title, "Default", 28, 5, Color( 0, 0, 0, 255 ) )
			end
			
			break
		end
	end
end

function TAB:EV_RankPrivilegeChange( rank, privilege, enabled )
	if ( rank == self.RankList:GetSelectedItems()[1].Rank ) then
		for _, line in pairs( self.PrivList:GetLines() ) do
			if ( line:GetColumnText( 1 ) == privilege ) then
				line.State:SetVisible( enabled )
				break
			end
		end
	end
end

function TAB:EV_RankCreated( id )
	local rank = evolve.ranks[ id ]
	local item = self.RankList:AddItem( "" )
	
	item:SetTall( 20 )
	item.Rank = id
	
	item.Icon = vgui.Create( "DImage", item )
	item.Icon:SetImage( "gui/silkicons/" .. rank.Icon )
	item.Icon:SetPos( 4, 4 )
	item.Icon:SetSize( 14, 14 )
	item.PaintOver = function()
		draw.SimpleText( rank.Title, "Default", 28, 5, Color( 0, 0, 0, 255 ) )
	end
end

function TAB:EV_RankUpdated( id )
	if ( id == self.RankList:GetSelectedItems()[1].Rank ) then
		self.ColorCircle:SetColor( evolve.ranks[ id ].Color or color_white )
		self.Immunity:SetValue( evolve.ranks[ id ].Immunity or 0 )
		self.Usergroup:SetText( evolve.ranks[ id ].UserGroup or "unknown" )
		self.Usergroup.Selected = evolve.ranks[ id ].UserGroup or "unknown"
	end
end

function TAB:IsAllowed()
	return LocalPlayer():EV_HasPrivilege( "Rank menu" )
end

evolve:RegisterTab( TAB )