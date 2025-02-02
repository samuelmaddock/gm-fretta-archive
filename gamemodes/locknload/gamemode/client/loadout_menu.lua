--WELCOME to the FUN FILE.
--Trespassers will DIE OF FEAR.

function ScreenScaleH( size )
	return size * ( ScrH() / 400.0 )	
end

local function rs (size)
	return size * math.min (1440, math.max (ScrW(), 800)) / 1440
end

surface.CreateFont ("csd", rs(90), 500, true, true, "CSSWeapons90")
surface.CreateFont ("csd", rs(80), 500, true, true, "CSSWeapons80")
surface.CreateFont ("csd", rs(70), 500, true, true, "CSSWeapons70")
surface.CreateFont ("csd", rs(60), 500, true, true, "CSSWeapons60")
surface.CreateFont ("csd", ScreenScaleH (45), 500, true, true, "CSSWeapons90Scaled")
surface.CreateFont ("csd", ScreenScaleH (40), 500, true, true, "CSSWeapons80Scaled")
surface.CreateFont ("csd", ScreenScaleH (35), 500, true, true, "CSSWeapons70Scaled")
surface.CreateFont ("csd", ScreenScaleH (30), 500, true, true, "CSSWeapons60Scaled")
surface.CreateFont ("HL2MP", rs(90), 500, true, true, "HL2Weapons90")
surface.CreateFont ("HL2MP", rs(80), 500, true, true, "HL2Weapons80")
surface.CreateFont ("HL2MP", rs(70), 500, true, true, "HL2Weapons70")
surface.CreateFont ("HL2MP", rs(60), 500, true, true, "HL2Weapons60")
surface.CreateFont ("HL2MP", ScreenScaleH (45), 500, true, true, "HL2Weapons90Scaled")
surface.CreateFont ("HL2MP", ScreenScaleH (40), 500, true, true, "HL2Weapons80Scaled")
surface.CreateFont ("HL2MP", ScreenScaleH (35), 500, true, true, "HL2Weapons70Scaled")
surface.CreateFont ("HL2MP", ScreenScaleH (30), 500, true, true, "HL2Weapons60Scaled")

local font = "coolvetica"
local mul = 1.05
if ScrW() < 1280 then
	font = "arial"
	if ScrW() < 1024 then mul = 1.1 end
end

surface.CreateFont (font, rs(24) * mul, 400, true, true, "CV24")
surface.CreateFont (font, rs(20) * mul, 400, true, true, "CV20")
surface.CreateFont (font, rs(20) * mul, 400, true, true, "CV12")

surface.CreateFont (font, ScreenScaleH (12) * mul, 300, true, true, "CV24Scaled")
surface.CreateFont (font, ScreenScaleH (12) * mul, 300, false, false, "CV24ScaledNonAA")
surface.CreateFont (font, ScreenScaleH (10) * mul, 300, true, true, "CV20Scaled")
surface.CreateFont (font, ScreenScaleH (7.5) * mul, 300, true, true, "CV12Scaled")
surface.CreateFont (font, ScreenScaleH (7.5) * mul, 300, false, false, "CV12ScaledNonAA")

function GM:ShowLoadoutMenu()
	self.LoadoutMenuStartTime = CurTime()
	if not self.LoadoutMenu1 then
		--sort registered weapons
		self:SortRegisteredWeapons()
		
		self.LoadoutMenu1 = vgui.Create("DPanel")
		--self.LoadoutMenu1:SetPos (0, 0)
		self.LoadoutMenu1:SetSize (rs(310), rs(345))
		self.LoadoutMenu1:MakePopup()
		self.LoadoutMenu1:SetKeyboardInputEnabled( false )
		
		self.LoadoutMenu2 = vgui.Create("DPanel")
		--self.LoadoutMenu2:SetPos (320, 0)
		self.LoadoutMenu2:SetSize (rs(190), rs(345))
		self.LoadoutMenu2:MakePopup()
		self.LoadoutMenu2:SetKeyboardInputEnabled( false )
		
		self.LoadoutMenu2:SetAlpha (100)
		self.LoadoutMenu2.Think = function (self)
			local x,y = gui.MousePos()
			if x > self.X and y > self.Y and x < self.X + self:GetWide() and y < self.Y + self:GetTall() then
				self:SetAlpha (200)
			else
				self:SetAlpha (100) --fade out alternative weapons when player is not interested
			end
		end
		
		self.LoadoutMenu3 = vgui.Create("DPanel")
		--self.LoadoutMenu1:SetPos (0, 0)
		self.LoadoutMenu3:SetSize (rs(310), rs(115))
		self.LoadoutMenu3:MakePopup()
		self.LoadoutMenu3:SetKeyboardInputEnabled( false )
		
		local x = (ScrW() - rs(310)) / 2
		local y = (ScrH() - rs(565)) / 2
		
		self.LoadoutMenu1:SetPos (x,y)
		self.LoadoutMenu2:SetPos (x-rs(200),y)
		self.LoadoutMenu3:SetPos (x+rs(100),y+rs(355))
		
		
		self.RespawnButtonParent = vgui.Create("DPanel", self.LoadoutMenu3)
		self.RespawnButtonParent:SetPos (rs(10), rs(10))
		self.RespawnButtonParent:SetSize (rs(290), rs(95))
		
		self.RespawnButton = vgui.Create ("DButton", self.RespawnButtonParent)
		self.RespawnButton:SetPos (rs(10), rs(55))
		self.RespawnButton:SetSize (rs(270), rs(30))
		self.RespawnButton.Paint = function (self)
			local col = derma.GetDefaultSkin().bg_color_dark
			if self.Depressed then col = derma.GetDefaultSkin().bg_color end
			draw.RoundedBox (4, 0, 0, self:GetWide(), self:GetTall(), col)
			local txt = "Click me to LOADOUT or hit Space"
			if (not GAMEMODE.ActiveList.Weapon[1].WeaponIcon.WeaponClassname) or (not GAMEMODE.ActiveList.Weapon[2].WeaponIcon.WeaponClassname) then txt = "Need two weapons to respawn" end
			draw.SimpleText(txt, "CV20", self:GetWide() / 2, self:GetTall() / 2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		self.RespawnButton:SetText ("")
		self.RespawnButton.DoClick = function ()
			if GAMEMODE:RequestRespawn() then
				GAMEMODE:HideLoadoutMenu()
			end
		end
		--[[self.RespawnButton.Think = function (self)
			if input.IsKeyDown (KEY_SPACE) and (GAMEMODE.LoadoutMenuStartTime + 2 < CurTime()) then
				self:DoClick()
			end
		end]]
		
		self.RandButton = vgui.Create ("DButton", self.RespawnButtonParent)
		self.RandButton:SetPos (rs(160), rs(10))
		self.RandButton:SetSize (rs(120), rs(30))
		self.RandButton.Paint = function (self)
			local col = derma.GetDefaultSkin().bg_color_dark
			if self.Depressed then col = derma.GetDefaultSkin().bg_color end
			draw.RoundedBox (4, 0, 0, self:GetWide(), self:GetTall(), col)
			local txt = "Randomise"
			draw.SimpleText(txt, "CV20", self:GetWide() / 2, self:GetTall() / 2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		self.RandButton:SetText ("")
		self.RandButton.DoClick = function ()
			GAMEMODE:StartRandomiseLoadoutMenu()
		end
		
		self.ActiveListParent = vgui.Create("DPanel", self.LoadoutMenu1)
		self.ActiveListParent:SetPos (rs(10), rs(10))
		self.ActiveListParent:SetSize (rs(290), rs(325))
		
		self.ActiveList = vgui.Create("DPanelList", self.ActiveListParent)
		self.ActiveList:EnableVerticalScrollbar (true)
		self.ActiveList:SetPadding (rs(5))
		self.ActiveList:SetSpacing (rs(5))
		self.ActiveList:StretchToParent (rs(10), rs(10), rs(10), rs(10))
		
		self.ActiveList.Title = vgui.Create("OutlinedLabel", self.ActiveList)
		self.ActiveList.Title:StretchToParent (rs(5),rs(5),rs(5),rs(5))
		self.ActiveList.Title:SetText ("Equipped Weapons")
		self.ActiveList.Title:SetTall (rs(30))
		self.ActiveList:AddItem (self.ActiveList.Title)
		
		self.ActiveList.Weapon = {}
		
		for i=1, 2 do
			self.ActiveList.Weapon[i] = vgui.Create ("ActiveWeaponPanel", self.ActiveListParent)
			self.ActiveList:AddItem (self.ActiveList.Weapon[i])
			self.ActiveList.Weapon[i].WeaponIcon:SetWeaponData (i)
		end
		
		self.WeaponListParent = vgui.Create("DPanel", self.LoadoutMenu2)
		self.WeaponListParent:SetPos (rs(10), rs(10))
		self.WeaponListParent:SetSize (rs(170), rs(325))
		
		self.WeaponList = vgui.Create("DPanelList", self.WeaponListParent)
		self.WeaponList:EnableVerticalScrollbar (true)
		self.WeaponList:SetPadding (rs(5))
		self.WeaponList:SetSpacing (rs(5))
		self.WeaponList:StretchToParent (rs(10), rs(10), rs(10), rs(10))
		
		self.WeaponList.Title = vgui.Create("OutlinedLabel", self.WeaponList)
		self.WeaponList.Title:StretchToParent (rs(5),rs(5),rs(5),rs(5))
		self.WeaponList.Title:SetText ("Alternatives")
		self.WeaponList.Title:SetTall (rs(30))
		self.WeaponList:AddItem (self.WeaponList.Title)
		
		self.WeaponList.Weapons = {}
		for k,v in pairs (self.RegisteredWeapons) do
			if k > 2 then
				local wpn = vgui.Create ("WeaponIcon", self.WeaponListParent)
				--wpn:SetDrawingTable (v.drawtable)
				wpn:SetWeaponData (k)
				self.WeaponList:AddItem (wpn)
				self.WeaponList.Weapons[k] = wpn
				wpn.Draggable = true
				wpn.WeaponList = self.WeaponList
			end
		end
	else
		self.LoadoutMenu1:SetVisible(true)
		self.LoadoutMenu2:SetVisible(true)
		self.LoadoutMenu3:SetVisible(true)
	end
end

function GM:CatchJumpOnLoadoutMenu (ply, key)
	if key == IN_JUMP and self.LoadoutMenu1 and self.LoadoutMenu1:IsVisible() then
		self.RespawnButton:DoClick()
	end
end

GM:AddHook ("KeyPress", "CatchJumpOnLoadoutMenu")

function GM:StartRandomiseLoadoutMenu ()
	self.Randomising = CurTime()
	--print ("Starting", self.Randomising)
end

function GM:ThinkRandomiseLoadoutMenu ()
	if not self.Randomising then return end
	if (self.LastRandomRun or 0) + 0.05 > CurTime() then return end
	self.LastRandomRun = CurTime()
	self:DoRandomiseLoadoutMenu()
	if (self.Randomising + 0.8 < CurTime()) then
		self.Randomising = false
	end
end

GM:AddHook ("Think", "ThinkRandomiseLoadoutMenu")

function GM:DoRandomiseLoadoutMenu()
	actvPnl1 = self.ActiveList.Weapon[1]
	actvPnl1:ReleaseWeapon()
	actvPnl2 = self.ActiveList.Weapon[2]
	actvPnl2:ReleaseWeapon()
	local rnd1 = math.random(#self.RegisteredWeapons)
	actvPnl1.WeaponIcon:SetWeaponData (rnd1)
	if self.WeaponList.Weapons[rnd1] and self.WeaponList.Weapons[rnd1]:IsValid() then
		self.WeaponList:RemoveItem (self.WeaponList.Weapons[rnd1], true)
		self.WeaponList.Weapons[rnd1]:Remove()
	end
	for k,v in pairs (actvPnl1.WeaponModIcons) do
		local mods = {false}
		for k,v in pairs (self.WeaponModsByCategory[k]) do
			if v:IsApplicable (actvPnl1.WeaponIcon.WeaponClassname) then
				mods[#mods+1] = k
			end
		end
		local rnd = math.random(#mods)
		v:SetWeaponModData (mods[rnd])
	end
	local rnd2 = math.random(#self.RegisteredWeapons)
	while rnd2 == rnd1 do
		rnd2 = math.random(#self.RegisteredWeapons)
	end
	actvPnl2.WeaponIcon:SetWeaponData (rnd2)
	if self.WeaponList.Weapons[rnd2] and self.WeaponList.Weapons[rnd2]:IsValid() then
		self.WeaponList:RemoveItem (self.WeaponList.Weapons[rnd2], true)
		self.WeaponList.Weapons[rnd2]:Remove()
	end
	for k,v in pairs (actvPnl2.WeaponModIcons) do
		local mods = {false}
		for k,v in pairs (self.WeaponModsByCategory[k]) do
			if v:IsApplicable (actvPnl2.WeaponIcon.WeaponClassname) then
				mods[#mods+1] = k
			end
		end
		local rnd = math.random(#mods)
		v:SetWeaponModData (mods[rnd])
	end
end

function UMOpenLoadoutMenu (um)
	GAMEMODE:ShowLoadoutMenu()
end

usermessage.Hook ("lnl_lo_menu", UMOpenLoadoutMenu)

function GM:QuickSwitch()
	local wpns = LocalPlayer():GetWeapons()
	for k,v in pairs (wpns) do
		if v != LocalPlayer():GetActiveWeapon() then
			RunConsoleCommand ("use", v:GetClass())
			return
		end
	end
end

GM:AddConCommand ("+menu", "QuickSwitch")

--GM:AddConCommand ("+menu", "ShowLoadoutMenu")

function GM:HideLoadoutMenu()
	if self.LoadoutMenu1 then
		self.LoadoutMenu1:SetVisible(false)
		self.LoadoutMenu2:SetVisible(false)
		self.LoadoutMenu3:SetVisible(false)
		if LNL_CurrentMenu then
			LNL_CurrentMenu:Remove()
		end
	end
end

--GM:AddConCommand ("-menu", "HideLoadoutMenu")

function GM:RequestRespawn()
	--check they've selected weapons
	if (not self.ActiveList.Weapon[1].WeaponIcon.WeaponClassname) or (not self.ActiveList.Weapon[2].WeaponIcon.WeaponClassname) then return end
	--send weapon info
	--print ("We is sending")
	--weapon 1
	RunConsoleCommand ("lnl_wpn", 1, string.sub (self.ActiveList.Weapon[1].WeaponIcon.WeaponClassname, 12), self.ActiveList.Weapon[1].WeaponModIcons[1].WeaponModName or "none", self.ActiveList.Weapon[1].WeaponModIcons[2].WeaponModName or "none", self.ActiveList.Weapon[1].WeaponModIcons[3].WeaponModName or "none")
	--weapon 2
	RunConsoleCommand ("lnl_wpn", 2, string.sub (self.ActiveList.Weapon[2].WeaponIcon.WeaponClassname, 12), self.ActiveList.Weapon[2].WeaponModIcons[1].WeaponModName or "none", self.ActiveList.Weapon[2].WeaponModIcons[2].WeaponModName or "none", self.ActiveList.Weapon[2].WeaponModIcons[3].WeaponModName or "none")
	--respawn
	RunConsoleCommand ("lnl_respawn")
	--print ("We as sent")
	return true
end

local PANEL = {}

function PANEL:Init ()
	self.WeaponIcon = vgui.Create("WeaponIcon", self)
	self.WeaponIcon:SetPos (rs(5), rs(5))
	self.WeaponIcon.ActiveWeaponPanel = self
	self.WeaponModIcons = {}
	for i=1, 3 do
		local wmodicon = vgui.Create ("WeaponModIcon", self)
		wmodicon:SetPos (rs(130), rs(-30+35*i))
		wmodicon:SetCategory (i)
		self.WeaponModIcons[i] = wmodicon
		wmodicon.ActiveWeaponPanel = self
	end
end

function PANEL:ReleaseWeapon ()
	--print ("Okay?")
	if self.WeaponIcon.WeaponDataID then
		--print ("Okay.")
		local wpn = vgui.Create ("WeaponIcon", self.WeaponListParent)
		wpn:SetWeaponData (self.WeaponIcon.WeaponDataID)
		GAMEMODE.WeaponList:AddItem (wpn)
		GAMEMODE.WeaponList.Weapons[self.WeaponIcon.WeaponDataID] = wpn
		wpn.Draggable = true
		wpn.WeaponList = GAMEMODE.WeaponList
	end
	for k,v in pairs (self.WeaponModIcons) do
		v:ReleaseWeaponMod()
	end
	self.WeaponIcon.WeaponDataID = nil
	self.WeaponIcon.WeaponClassname = nil
	self.WeaponIcon.TextElements = nil
	self.WeaponIcon.Pressable = false
	for k,v in pairs (self.WeaponModIcons) do
		v:SetVisible (false)
	end
end

function PANEL:RevealWeaponModIcons()
	for k,v in pairs (self.WeaponModIcons) do
		for k2,v2 in pairs (GAMEMODE.WeaponModsByCategory[k]) do
			if v2:IsApplicable (self.WeaponIcon.WeaponClassname) then
				v.WeaponClassname = self.WeaponIcon.WeaponClassname
				v:SetVisible (true)
			end
		end
	end
end

function PANEL:Paint ()
	--surface.SetDrawColor (255,255,255,255)
	--surface.DrawOutlinedRect (0,0,self:GetWide(),self:GetTall())
end

function PANEL:PerformLayout ()
	self:SetSize (rs(260), rs(120))
end

vgui.Register ("ActiveWeaponPanel", PANEL, "DPanel")

local PANEL = {}

function PANEL:Init ()
	
end

function PANEL:OnMousePressed (mc)
	local x,y = self:CursorPos()
	local x = - x + gui.MouseX()
	local y = - y + gui.MouseY()
	if mc == MOUSE_LEFT and self.Draggable then
		self.WeaponList:RemoveItem (self, true)
		
		self:SetParent(nil)
		self:SetDrawOnTop (true)
		self:MouseCapture (true)
		--self:SetZPos (100)
		self:SetPos (x,y)
		
		self:BackgroundHighlight (true)
		
		self.BeingDragged = true
		GAMEMODE.SomethingIsBeingDragged = true
		self.LastMouseX, self.LastMouseY = gui.MousePos()
	elseif mc == MOUSE_LEFT and self.Pressable then
		self.BeingPressed = true
		self:BackgroundHighlight (true)
	end
end

function PANEL:OnMouseReleased (mc, actuallyleft)
	--print ("YEAH DAWG")
	if self.BeingDragged and mc == MOUSE_LEFT then
		self.BeingDragged = false
		GAMEMODE.SomethingIsBeingDragged = false
		
		self:SetDrawOnTop (false)
		self:MouseCapture (false)
		
		--now we must work out where it is going
		local targetPanels = GAMEMODE.ActiveList.Weapon
		local nomore = false
		for k,v in pairs(targetPanels) do
			v.WeaponIcon:OutlineHighlight (false)
			local x,y = v.WeaponIcon:LocalToScreen(-self.X,-self.Y)
			if (not nomore) and x > rs(-40) and x < rs(40) and y > rs(-40) and y < rs(40) then
				v:ReleaseWeapon()
				v.WeaponIcon:SetWeaponData (self.WeaponDataID)
				v.WeaponIcon:BackgroundHighlight (false)
				self:Remove()
				nomore = true
			end
		end
		if nomore then return end
		
		self:BackgroundHighlight (false)
		
		self:SetParent (self.WeaponList)
		self.WeaponList:AddItem (self)
		self.WeaponList:InvalidateLayout()
	elseif self.BeingPressed and mc == MOUSE_LEFT then
		if not actuallyleft then self:GetParent():ReleaseWeapon() end
		self.BeingPressed = false
		self:BackgroundHighlight (false)
	end
end

function PANEL:Think()
	if self.BeingDragged then
		local x,y = gui.MousePos()
		local newx,newy = x,y
		x = x - self.LastMouseX
		y = y - self.LastMouseY
		self:SetPos (self.X + x, self.Y + y)
		self.LastMouseX, self.LastMouseY = newx, newy
		
		--highlight possible drops
		local targetPanels = GAMEMODE.ActiveList.Weapon
		for k,v in pairs(targetPanels) do
			local x,y = v.WeaponIcon:LocalToScreen(-self.X,-self.Y)
			if x > rs(-40) and x < rs(40) and y > rs(-40) and y < rs(40) then
				v.WeaponIcon:BackgroundHighlight (true)
			else
				v.WeaponIcon:BackgroundHighlight (false)
			end
			v.WeaponIcon:OutlineHighlight (true)
		end
	elseif self.BeingPressed then
		local x,y = gui.MousePos()
		local px,py = self:LocalToScreen(0,0)
		if not (x > px and y > py and x < px + self:GetWide() and y < py + self:GetTall()) then
			self:OnMouseReleased (MOUSE_LEFT, true)
		end
	else
		local px,py = self:LocalToScreen (0, 0)
		local x,y = gui.MousePos()
		if x > px and y > py and x < px + self:GetWide() and y < py + self:GetTall() then
			if not self.CursorOver then
				self:ActuallyOnCursorEntered()
			end
		elseif self.CursorOver then
			self:ActuallyOnCursorExited()
		end
	end
end

function PANEL:ActuallyOnCursorEntered ()
	self.CursorOver = true
	--if self.WeaponModPrintName or self.Pressable then
	if GAMEMODE.SomethingIsBeingDragged then return end
		self.Extender = vgui.Create ("WeaponIconExtender")
		self.Extender:SetPos (self:LocalToScreen (rs(-314), 0))
		local txt1, txt2 = "None", "None"
		if self.WeaponKVs then
			txt1 = self.WeaponKVs.PositiveDesc
			txt2 = self.WeaponKVs.NegativeDesc
		end
		self.Extender:SetText (txt1, txt2)
		self.Extender:SetDrawOnTop (true)
		self.Extender.PanelBeingExtended = self
	--end
end

function PANEL:ActuallyOnCursorExited ()
	self.CursorOver = false
	if self.Extender and self.Extender:IsValid() then self.Extender:Remove() end
end

function PANEL:SetWeaponData (wpndata_id)
	if LNL_CurrentMenu and LNL_CurrentMenu:IsValid() then
		LNL_CurrentMenu:Remove()
	end
	
	self.Pressable = true
	
	self.WeaponDataID = wpndata_id
	
	local wpndata = GAMEMODE.RegisteredWeapons[wpndata_id]
	
	self.WeaponClassname = wpndata.classname
	self.WeaponKVs = wpndata.keyvaluetable
	
	local dtable = wpndata.drawtable
	
	self.DrawingTable = dtable
	self.TextElements = {}
	for k,v in pairs(dtable) do
		if v.typ == "text" then
			self.TextElements[k] = v
		end
	end
	
	if self.Extender and self.Extender:IsValid() then
		local txt1, txt2 = "None", "None"
		if self.WeaponKVs then
			txt1 = self.WeaponKVs.PositiveDesc
			txt2 = self.WeaponKVs.NegativeDesc
		end
		self.Extender:SetText (txt1, txt2)
	else
		local px,py = self:LocalToScreen (0, 0)
		local x,y = gui.MousePos()
		if x > px and y > py and x < px + self:GetWide() and y < py + self:GetTall() then
			self:ActuallyOnCursorEntered()
		end
	end
	
	if self.ActiveWeaponPanel then
		self.ActiveWeaponPanel:RevealWeaponModIcons()
	end
end

function PANEL:BackgroundHighlight (bool)
	self.HighlightBackground = bool
end

function PANEL:OutlineHighlight (bool)
	self.HighlightOutline = bool
end

function PANEL:Paint ()
	local col = derma.GetDefaultSkin().bg_color_dark
	if self.HighlightBackground then col = derma.GetDefaultSkin().bg_color end
	surface.SetDrawColor (col.r,col.g,col.b,col.a)
	surface.DrawRect (0,0,self:GetWide(),self:GetTall())
	col = Color(255,255,255,255)
	if self.Pressable and not GAMEMODE.SomethingIsBeingDragged then col = Color(255,125,0,255) end
	if self.Pressable and self.BeingPressed then col = Color(255,0,0,255) end
	if self.HighlightOutline then col = Color(0,255,0,255) end
	if self.Draggable and ((not GAMEMODE.SomethingIsBeingDragged) or self.BeingDragged) then col = Color(255,255,0,255) end
	surface.SetDrawColor (col.r,col.g,col.b,col.a)
	surface.DrawOutlinedRect (0,0,self:GetWide(),self:GetTall())
	
	if not self.TextElements then return end
	for k,v in pairs (self.TextElements) do
		surface.SetTextColor (255,255,255,255)
		surface.SetFont (v.font or "ChatText")
		surface.SetTextPos (rs(v.x) or 0, rs(v.y) or 0)
		surface.DrawText (v.text)
	end
end

function PANEL:PerformLayout ()
	self:SetSize (rs(120), rs(50))
end

vgui.Register ("WeaponIcon", PANEL, "DPanel")

local PANEL = {}

function PANEL:Paint ()
	if not (self.PanelBeingExtended:IsValid() and (not self.PanelBeingExtended.BeingDragged) and self.PanelBeingExtended:IsVisible() and GAMEMODE.LoadoutMenu1:IsVisible()) then
		self:Remove()
		return
	end
	
	if not self.PanelBeingExtended.WeaponDataID then
		self.PositiveDesc = nil
	end
	
	surface.SetDrawColor (255,255,255,255)
	surface.DrawOutlinedRect (0,0,self:GetWide()+1,self:GetTall() * 0.5)
	
	local col = derma.GetDefaultSkin().bg_color_dark
	surface.SetDrawColor (col.r,col.g,col.b,col.a)
	surface.DrawRect (0,1,self:GetWide()-rs(20),self:GetTall()-2)
	
	surface.SetDrawColor (255,255,255,255)
	surface.DrawOutlinedRect (0,0,self:GetWide()-rs(19),self:GetTall())
	
	surface.SetDrawColor (col.r,col.g,col.b,col.a)
	surface.DrawRect (2,1,self:GetWide(),self:GetTall() * 0.5 - 2)
	
	if self.PositiveDesc then
		draw.SimpleText("+ "..(self.PositiveDesc or "None"), "CV20", rs(10), rs(15), Color (0,255,0,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("- "..(self.NegativeDesc or "None"), "CV20", rs(10), rs(40), Color (255,0,0,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	else
		draw.SimpleText("This is an empty weapon slot", "CV20", rs(10), rs(15), Color (255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("Drag on a weapon from the left", "CV20", rs(10), rs(40), Color (255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
end

function PANEL:SetText (pos, neg)
	self.PositiveDesc = pos
	self.NegativeDesc = neg
end

function PANEL:PerformLayout ()
	self:SetSize (rs(315), rs(55))
end

vgui.Register ("WeaponIconExtender", PANEL, "DPanel")

local PANEL = {}

function PANEL:Init ()
	
end

function PANEL:OnMousePressed (mc)
	
end

function PANEL:OnMouseReleased (mc)
	--produce a menu!
	if not self.SendPressesToParent then
		if LNL_CurrentMenu then
			LNL_CurrentMenu:Remove()
		end
		local menu = vgui.Create ("WeaponModMenu")
		local x,y = self:LocalToScreen(self:GetWide()-1,rs(-10))
		menu:SetPos (x,y)
		menu.Target = self
		menu:SetCategory (self.Category or 1)
		menu:AddWeaponMod (nil)
		for k,v in pairs (GAMEMODE.WeaponModsByCategory[self.Category]) do
			if v:IsApplicable (self.ActiveWeaponPanel.WeaponIcon.WeaponClassname) then
				local wpn = menu:AddWeaponMod (k)
				wpn.WeaponClassname = self.WeaponClassname
			end
		end
		menu:SetDrawOnTop (true)
		menu:MouseCapture (true)
		LNL_CurrentMenu = menu
		self.CurrentMenu = menu
		self:ActuallyOnCursorExited ()
	else
		self:GetParent():WeaponModSelected (self.WeaponModID)
	end
end

function PANEL:ActuallyOnCursorEntered ()
	--if self.WeaponModPrintName or self.Pressable then
	if (self.CurrentMenu and self.CurrentMenu:IsValid()) then return end
		self.Extender = vgui.Create ("WeaponModIconExtender")
		self.Extender:SetPos (self:LocalToScreen (self:GetWide()-1, 0))
		local txt1, txt2 = "None", "None"
		--print ("Evenin'", self.WeaponClassname)
		if self.ModData then
			--print ("Type", type (self.ModData.PositiveDesc))
			if type (self.ModData.PositiveDesc) == "function" then
				txt1 = self.ModData.PositiveDesc(self.WeaponClassname)
			else
				txt1 = self.ModData.PositiveDesc
			end
			if type (self.ModData.NegativeDesc) == "function" then
				txt2 = self.ModData.NegativeDesc(self.WeaponClassname)
			else
				txt2 = self.ModData.NegativeDesc
			end
		end
		self.Extender:SetText (txt1, txt2)
		self.Extender:SetDrawOnTop (true)
		self.Extender.PanelBeingExtended = self
	--end
end

function PANEL:ActuallyOnCursorExited ()
	if self.Extender and self.Extender:IsValid() then self.Extender:Remove() end
end

function PANEL:Think()
	local px,py = self:LocalToScreen (0, 0)
	local x,y = gui.MousePos()
	if x > px and y > py and x < px + self:GetWide() and y < py + self:GetTall() then
		if not self.CursorOver then
			self.CursorOver = true
			self:ActuallyOnCursorEntered()
		end
	elseif self.CursorOver then
		self.CursorOver = false
		self:ActuallyOnCursorExited()
	end
end

function PANEL:SetCategory (cat)
	self.Category = cat
end

function PANEL:SetWeaponModData (wpnmod_id)	
	self.Category = self.Category or 1
	self.WeaponModID = wpnmod_id
	
	local moddata = GAMEMODE.WeaponModsByCategory[self.Category][wpnmod_id]
	if not moddata then return end
	--PrintTable (moddata)
	self.ModData = moddata
	
	self.WeaponModName = moddata.Codename
	self.WeaponModPrintName = moddata.Name
end

function PANEL:ReleaseWeaponMod ()
	self.WeaponModID = false
	self.WeaponModName = false
	self.WeaponModPrintName = false
end

function PANEL:BackgroundHighlight (bool)
	self.HighlightBackground = bool
end

function PANEL:OutlineHighlight (bool)
	self.HighlightOutline = bool
end

local catNames = {
	"Fire Type",
	"Load Type",
	"Attachment"
}

local catDefaults = {
	"Balanced",
	"Standard",
	"None"
}

function PANEL:Paint ()
	local col = derma.GetDefaultSkin().bg_color_dark
	if self.HighlightBackground then col = derma.GetDefaultSkin().bg_color end
	surface.SetDrawColor (col.r,col.g,col.b,col.a)
	surface.DrawRect (0,0,self:GetWide(),self:GetTall())
	col = Color(255,255,255,255)
	if self.Pressable and not GAMEMODE.SomethingIsBeingDragged then col = Color(255,125,0,255) end
	if self.Pressable and self.BeingPressed then col = Color(255,0,0,255) end
	if self.HighlightOutline then col = Color(0,255,0,255) end
	if self.Draggable and ((not GAMEMODE.SomethingIsBeingDragged) or self.BeingDragged) then col = Color(255,255,0,255) end
	surface.SetDrawColor (col.r,col.g,col.b,col.a)
	surface.DrawOutlinedRect (0,0,self:GetWide(),self:GetTall())
	local col = Color(255,255,255,255)
	if not self.WeaponModPrintName then
		col = Color(255,255,255,75)
	end
	if self.SendPressesToParent then
		draw.SimpleText(self.WeaponModPrintName or catDefaults[self.Category] or "None", "CV20", self:GetWide() / 2, self:GetTall() / 2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	else
		draw.SimpleText(self.WeaponModPrintName or catNames[self.Category] or "None", "CV20", self:GetWide() / 2, self:GetTall() / 2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end

function PANEL:PerformLayout ()
	self:SetSize (rs(120), rs(30))
end

vgui.Register ("WeaponModIcon", PANEL, "DPanel")

local PANEL = {}

function PANEL:Paint ()
	if not (self.PanelBeingExtended:IsValid() and self.PanelBeingExtended:IsVisible() and GAMEMODE.LoadoutMenu1:IsVisible()) then
		self:Remove()
		return
	end
	
	if not self.PanelBeingExtended.WeaponModPrintName then
		self.PositiveDesc = nil
	end
	
	surface.SetDrawColor (255,255,255,255)
	surface.DrawOutlinedRect (-1,0,self:GetWide()+1,self:GetTall() * 0.5)
	
	local col = derma.GetDefaultSkin().bg_color_dark
	surface.SetDrawColor (col.r,col.g,col.b,col.a)
	surface.DrawRect (rs(20),1,self:GetWide()-rs(20),self:GetTall()-2)
	
	surface.SetDrawColor (255,255,255,255)
	surface.DrawOutlinedRect (rs(19),0,self:GetWide()-rs(19),self:GetTall())
	
	surface.SetDrawColor (col.r,col.g,col.b,col.a)
	surface.DrawRect (0,1,self:GetWide()-2,self:GetTall() * 0.5 - 2)
	
	if self.PositiveDesc then
		draw.SimpleText("+ "..(self.PositiveDesc or "None"), "CV20", rs(30), rs(15), Color (0,255,0,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("- "..(self.NegativeDesc or "None"), "CV20", rs(30), rs(40), Color (255,0,0,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	elseif self.PanelBeingExtended.SendPressesToParent then
		draw.SimpleText("No bonuses or penalties", "CV20", rs(30), rs(15), Color (255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("(Sometimes a good choice!)", "CV20", rs(30), rs(40), Color (255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	else
		draw.SimpleText("This is a weapon mod slot", "CV20", rs(30), rs(15), Color (255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("Click to add a modification", "CV20", rs(30), rs(40), Color (255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
end

function PANEL:SetText (pos, neg)
	self.PositiveDesc = pos
	self.NegativeDesc = neg
end

function PANEL:PerformLayout ()
	self:SetSize (rs(285), rs(55))
end

vgui.Register ("WeaponModIconExtender", PANEL, "DPanel")

local PANEL = {}

function PANEL:Init()
	self.WeaponMods = {}
	self.Category = 1
end

function PANEL:SetCategory (cat)
	self.Category = cat
end

function PANEL:AddWeaponMod (wpnmod_id)
	local wpn = vgui.Create ("WeaponModIcon", self)
	wpn:SetCategory (self.Category)
	wpn:SetWeaponModData (wpnmod_id)
	wpn.SendPressesToParent = true
	table.insert (self.WeaponMods, wpn)
	return wpn
end

function PANEL:WeaponModSelected (wpnmod_id)
	self.Target:ReleaseWeaponMod()
	self.Target:SetWeaponModData (wpnmod_id)
	self:Remove()
end

function PANEL:Paint ()
	local col = derma.GetDefaultSkin().bg_color_dark
	surface.SetDrawColor (255,255,255,255)
	surface.DrawOutlinedRect (rs(-5),rs(14),rs(60),rs(22))
	surface.SetDrawColor (col.r,col.g,col.b,col.a)
	surface.DrawRect (rs(35),0,rs(140),self:GetTall())
	surface.SetDrawColor (255,255,255,255)
	surface.DrawOutlinedRect (rs(35),0,rs(140),self:GetTall())
	surface.SetDrawColor (col.r,col.g,col.b,col.a)
	surface.DrawRect (0,rs(15),rs(50),rs(20))
	return true
end

function PANEL:PerformLayout ()
	self:SetSize (rs(175), rs(15+(#self.WeaponMods * 35)))
	for k,v in pairs (self.WeaponMods) do
		v:SetPos (rs(45), rs(-25 + k * 35))
	end
end

vgui.Register ("WeaponModMenu", PANEL, "DPanel")

local PANEL = {}

function PANEL:Paint ()
	local col = derma.GetDefaultSkin().bg_color
	surface.SetDrawColor (col.r,col.g,col.b,col.a)
	surface.DrawRect (0,0,self:GetWide(),self:GetTall())
	surface.SetDrawColor (255,255,255,255)
	surface.DrawOutlinedRect (0,0,self:GetWide(),self:GetTall())
	local col = Color(255,255,255,255)
	draw.SimpleText(self.Text or "Label", "CV20", self:GetWide() / 2, self:GetTall() / 2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function PANEL:SetText (text)
	self.Text = text
end

vgui.Register ("OutlinedLabel", PANEL, "DPanel")