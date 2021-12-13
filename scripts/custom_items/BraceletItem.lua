BraceletItem = CustomItem:extend()

function BraceletItem:init(name, code, imagePath)
	self:createItem(name)
	self.code = code
	self:setProperty("active", false)
	self.activeImage = ImageReference:FromPackRelativePath(imagePath)
	self.disabledImage = ImageReference:FromImageReference(self.activeImage, "@disabled")
	self.ItemInstance.PotentialIcon = self.activeImage
	self:updateIcon()	
	self.allowResets = true
end

function BraceletItem:setActive(active)
	self:setProperty("active", active)
end

function BraceletItem:getActive()
	return self:getProperty("active")
end

function BraceletItem:updateIcon()
	if self:getActive() then
		self.ItemInstance.Icon = self.activeImage
	else
		self.ItemInstance.Icon = self.disabledImage
	end
end

function BraceletItem:onLeftClick()
	self:setActive(not self:getActive())
end

function BraceletItem:onRightClick()
	self:setActive(not self:getActive())
end

function BraceletItem:canProvideCode(code)
	if code == self.code then
		return true
	elseif code == "bracelet" then
		return true
	else
		return false
	end
end

function BraceletItem:providesCode(code)
	if self:getActive() and (code == self.code or code == "bracelet") then
		return 1
	end
	return 0
end

function BraceletItem:advanceToCode(code)
	if code == nil or code == self.code then
		self:setActive(true)
	end
end

function BraceletItem:save()
	local saveData = {}
	saveData["active"] = self:getActive()
	return saveData
end

function BraceletItem:load(data)
	self.allowResets = false
	if data["active"] ~= nil then
		self:setActive(data["active"])
	end
	self.allowResets = true
	return true
end

function BraceletItem:propertyChanged(key, value)
	if key == "active" and value == true and Tracker.ActiveVariantUID == "items_and_map_custom" and self.allowResets then
		if negate("flag_nw") and Tracker:ProviderCountForCode(string.sub(self.code, 1, -9)) > 0 and (negate("flag_gc") or battleMagicCount() == 1) then
			resetTetrarchyBossTracking()
		end
	end
	self:updateIcon()
end