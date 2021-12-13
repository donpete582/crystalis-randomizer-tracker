BallItem = CustomItem:extend()

function BallItem:init(name, code, imagePath)
	self:createItem(name)
	self.code = code
	self:setProperty("active", false)
	self.activeImage = ImageReference:FromPackRelativePath(imagePath)
	self.disabledImage = ImageReference:FromImageReference(self.activeImage, "@disabled")
	self.ItemInstance.PotentialIcon = self.activeImage
	self:updateIcon()	
	self.allowResets = true
end

function BallItem:setActive(active)
	self:setProperty("active", active)
end

function BallItem:getActive()
	return self:getProperty("active")
end

function BallItem:updateIcon()
	if self:getActive() then
		self.ItemInstance.Icon = self.activeImage
	else
		self.ItemInstance.Icon = self.disabledImage
	end
end

function BallItem:onLeftClick()
	self:setActive(not self:getActive())
end

function BallItem:onRightClick()
	self:setActive(not self:getActive())
end

function BallItem:canProvideCode(code)
	if code == self.code then
		return true
	elseif code == "ball" then
		return true
	else
		return false
	end
end

function BallItem:providesCode(code)
	if self:getActive() and (code == self.code or code == "ball") then
		return 1
	end
	return 0
end

function BallItem:advanceToCode(code)
	if code == nil or code == self.code then
		self:setActive(true)
	end
end

function BallItem:save()
	local saveData = {}
	saveData["active"] = self:getActive()
	return saveData
end

function BallItem:load(data)
	self.allowResets = false
	if data["active"] ~= nil then
		self:setActive(data["active"])
	end
	self.allowResets = true
	return true
end

function BallItem:propertyChanged(key, value)
	if key == "active" and value == true and Tracker.ActiveVariantUID == "items_and_map_custom" and self.allowResets then
		if negate("flag_ro") and Tracker:ProviderCountForCode(string.sub(self.code, 1, -5)) > 0 and (negate("flag_gc") or levelTwoCount() == 1) then
			resetWallTracking()
		end
		if negate("flag_nw") and Tracker:ProviderCountForCode(string.sub(self.code, 1, -5)) > 0 and (negate("flag_gc") or levelTwoCount() == 1) then
			resetKarmineTracking()
		end
	end
	self:updateIcon()
end