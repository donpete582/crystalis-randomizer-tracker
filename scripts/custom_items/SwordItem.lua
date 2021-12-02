SwordItem = CustomItem:extend()

function SwordItem:init(name, code, imagePath)
	self:createItem(name)
	self.code = code
	self:setProperty("active", false)
	self.activeImage = ImageReference:FromPackRelativePath(imagePath)
	self.disabledImage = ImageReference:FromImageReference(self.activeImage, "@disabled")
	self.ItemInstance.PotentialIcon = self.activeImage
	self:updateIcon()	
end

function SwordItem:setActive(active)
	self:setProperty("active", active)
end

function SwordItem:getActive()
	return self:getProperty("active")
end

function SwordItem:updateIcon()
	if self:getActive() then
		self.ItemInstance.Icon = self.activeImage
	else
		self.ItemInstance.Icon = self.disabledImage
	end
end

function SwordItem:onLeftClick()
	self:setActive(not self:getActive())
end

function SwordItem:onRightClick()
	self:setActive(not self:getActive())
end

function SwordItem:canProvideCode(code)
	if code == self.code then
		return true
	elseif code == "sword" then
		return true
	else
		return false
	end
end

function SwordItem:providesCode(code)
	if self:getActive() and (code == self.code or code == "sword") then
		return 1
	end
	return 0
end

function SwordItem:advanceToCode(code)
	if code == nil or code == self.code then
		self:setActive(true)
	end
end

function SwordItem:save()
	local saveData = {}
	saveData["active"] = self:getActive()
	return saveData
end

function SwordItem:load(data)
	if data["active"] ~= nil then
		self:setActive(data["active"])
	end
	return true
end

function SwordItem:propertyChanged(key, value)
	if key == "active" and value == true and Tracker.ActiveVariantUID == "items_and_map_custom" then
		resetMinorBossTracking()
		resetRageTracking()
		if Tracker:ProviderCountForCode("flag_ro") > 0 or Tracker:ProviderCountForCode(self.code .. "ball") > 0 or (Tracker:ProviderCountForCode("flag_gc") > 0 and hasAnyLevelTwo()) then
			resetWallTracking()
			resetKarmineTracking()
		end
		if Tracker:ProviderCountForCode("flag_nw") > 0 or Tracker:ProviderCountForCode(self.code .. "bracelet") > 0 or (Tracker:ProviderCountForCode("flag_gc") > 0 and hasAnyBattleMagic()) then
			resetTetrarchyBossTracking()
		end
	end
	self:updateIcon()
end