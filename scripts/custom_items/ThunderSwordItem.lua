ThunderSwordItem = CustomItem:extend()

function ThunderSwordItem:init(name, staticcode, codelist)
	self:createItem(name)
	self.staticcode = staticcode
	self.codelist = codelist
	self:setProperty("state", 1)
	self:setProperty("active", false)
	self:updateIcon()
end

function ThunderSwordItem:setActive(active)
	self:setProperty("active", active)
end

function ThunderSwordItem:getActive()
	return self:getProperty("active")
end

function ThunderSwordItem:setState(state)
	self:setProperty("state", state)
end

function ThunderSwordItem:getState()
	return self:getProperty("state")
end

function ThunderSwordItem:incrementState()
	local currentState = self:getState()
	if currentState + 1 > #self.codelist then
		self:setState(1)
	else
		self:setState(currentState + 1)
	end
end

function ThunderSwordItem:updateIcon()
	currentPath = "images/items/" .. self.staticcode .. self.codelist[self:getState()] .. ".png"
	currentImage = ImageReference:FromPackRelativePath(currentPath)
	if self:getActive() then
		self.ItemInstance.Icon = currentImage
	else
		self.ItemInstance.Icon = ImageReference:FromImageReference(currentImage, "@disabled")
	end
end

function ThunderSwordItem:onLeftClick()
	self:setActive(not self:getActive())
end

function ThunderSwordItem:onRightClick()
	self:incrementState()
end

function ThunderSwordItem:canProvideCode(code)
	if code == "sword" or code == self.staticcode then
		return true
	else
		for index, value in ipairs(self.codelist) do
			if (code == (self.staticcode .. value)) then
				return true
			end
		end
		return false
	end
end

function ThunderSwordItem:providesCode(code)
	if self:getActive() and (code == (self.staticcode .. self.codelist[self:getState()]) or code == "sword" or code == self.staticcode) then
		return 1
	end
	return 0
end

function ThunderSwordItem:advanceToCode(code)
	for index, value in ipairs(self.codelist) do
		if (value == code) then
			self:setActive(true)
			self:setState(index)
		end
	end
end

function ThunderSwordItem:save()
	local saveData = {}
	saveData["active"] = self:getActive()
	saveData["state"] = self:getState()
	return saveData
end

function ThunderSwordItem:load(data)
	if data["active"] ~= nil then
		self:setActive(data["active"])
	end
	if data["state"] ~= nil then
		self:setState(data["state"])
	end
	return true
end

function ThunderSwordItem:propertyChanged(key, value)
	if key == "active" and value == true and Tracker.ActiveVariantUID == "items_and_map_custom" then
		resetMinorBossTracking()
		resetRageTracking()
		if Tracker:ProviderCountForCode("flag_ro") > 0 or Tracker:ProviderCountForCode(self.staticcode .. "ball") > 0 or (Tracker:ProviderCountForCode("flag_gc") > 0 and hasAnyLevelTwo()) then
			resetWallTracking()
			resetKarmineTracking()
		end
		if Tracker:ProviderCountForCode("flag_nw") > 0 or Tracker:ProviderCountForCode(self.staticcode .. "bracelet") > 0 or (Tracker:ProviderCountForCode("flag_gc") > 0 and hasAnyBattleMagic()) then
			resetTetrarchyBossTracking()
		end
	end
	self:updateIcon()
end