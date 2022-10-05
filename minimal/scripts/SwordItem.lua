SwordItem = CustomItem:extend()

BADGE_IMAGE_PATH = "images/badges/"

function SwordItem:init(name, code, imagePath, disabledImagePath, badges)
	self.canUpdateIcon = false
	self:createItem(name)
	self.code = code
	self.badges = badges
	self:setProperty("active", false)
	self:setProperty("state", 1)
	self.imageBase = ImageReference:FromPackRelativePath(imagePath)
	self.disabledImageBase = ImageReference:FromPackRelativePath(disabledImagePath)
	self.canUpdateIcon = true
	self:updateIcon()
end

function SwordItem:setActive(active)
	self:setProperty("active", active)
end

function SwordItem:getActive()
	return self:getProperty("active")
end

function SwordItem:setState(state)
	self:setProperty("state", state)
end

function SwordItem:getState()
	return self:getProperty("state")
end

function SwordItem:incrementState()
	local currentState = self:getState()
	if currentState + 1 > #self.badges then
		self:setState(1)
	else
		self:setState(currentState + 1)
	end
end

function SwordItem:updateIcon()
	if self.canUpdateIcon then
		local img_mod = ""
        local state = self:getProperty("state")
		if state and state > 0 and self.badges[state] ~= "none" then
            img_mod = "overlay|".. BADGE_IMAGE_PATH .. self.badges[self:getProperty("state")] .. ".png"
		end
		if self:getProperty("active") then
			self.ItemInstance.Icon = ImageReference:FromImageReference(self.imageBase, img_mod)
		else
            img_mod = img_mod .. ",@disabled"
			self.ItemInstance.Icon = ImageReference:FromImageReference(self.disabledImageBase, img_mod)
		end
	end
end

function SwordItem:onLeftClick()
	self:setActive(not self:getActive())
end

function SwordItem:onRightClick()
	self:incrementState()
end

function SwordItem:canProvideCode(code)
	if code == self.code then
		return true
	else
		return false
	end
end

function SwordItem:providesCode(code)
	if self:getActive() and code == self.code then
		return 1
	end
	return 0
end

function SwordItem:advanceToCode(code)
    if (code == self.code) then
        self:setActive(true)
        -- self:setState(1)
    end
end

function SwordItem:save()
	local saveData = {}
	saveData["active"] = self:getActive()
	saveData["state"] = self:getState()
	return saveData
end

function SwordItem:load(data)
	if data["active"] ~= nil then
		self:setActive(data["active"])
	end
	if data["state"] ~= nil then
		self:setState(data["state"])
	end
	return true
end

function SwordItem:propertyChanged(key, value)
	self:updateIcon()
end