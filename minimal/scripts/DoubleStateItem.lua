DoubleStateItem = CustomItem:extend()

BADGE_IMAGE_PATH = "images/badges/"

-- States:
-- 1: Neither selected
-- 2: First
-- 3: Second
-- 4: Both

function DoubleStateItem:init(name, code, imagePath, badges)
	self.canUpdateIcon = false
	self:createItem(name)
	self.code = code
    self.badges = badges
	self:setProperty("active", false)
	self:setProperty("state", 1)
	self.imageBase = ImageReference:FromPackRelativePath(imagePath)
	self.canUpdateIcon = true
	self:updateIcon()
end

function DoubleStateItem:setActive(active)
	self:setProperty("active", active)
end

function DoubleStateItem:getActive()
	return self:getProperty("active")
end

function DoubleStateItem:setState(state)
	self:setProperty("state", state)
end

function DoubleStateItem:getState()
	return self:getProperty("state")
end

function DoubleStateItem:incrementState()
	local currentState = self:getState()
	if currentState + 1 > 4 then
		self:setState(1)
	else
		self:setState(currentState + 1)
	end
end

function DoubleStateItem:updateIcon()
	if self.canUpdateIcon then
		local img_mod = ""
        local state = self:getProperty("state")
        if state and state == 2 then
            img_mod = "overlay|".. BADGE_IMAGE_PATH .. self.badges[1]
        elseif state and state == 3 then
            img_mod = "overlay|".. BADGE_IMAGE_PATH .. self.badges[2]
        elseif state and state == 4 then
            img_mod = "overlay|".. BADGE_IMAGE_PATH .. self.badges[1] .. ",overlay|".. BADGE_IMAGE_PATH .. self.badges[2]
        end
		if not self:getProperty("active") then
            img_mod = img_mod .. ",@disabled"
		end
		self.ItemInstance.Icon = ImageReference:FromImageReference(self.imageBase, img_mod)
	end
end

function DoubleStateItem:onLeftClick()
    local state = self:getProperty("state")
    local newState = 1
    if state and state == 1 or state == 3 then
        newState = state + 1
    elseif state and state == 2 or state == 4 then
        newState = state - 1
    end
    self:setState(newState)
	self:setActive(newState > 1)
end

function DoubleStateItem:onRightClick()
    local state = self:getProperty("state")
    local newState = 1
    if state and state == 1 or state == 2 then
        newState = state + 2
    elseif state and state == 3 or state == 4 then
        newState = state - 2
    end
    self:setState(newState)
	self:setActive(newState > 1)
end

function DoubleStateItem:canProvideCode(code)
	if code == self.code then
		return true
	else
		return false
	end
end

function DoubleStateItem:providesCode(code)
	if self:getActive() and code == self.code then
		return 1
	end
	return 0
end

function DoubleStateItem:advanceToCode(code)
    if (code == self.code) then
        self:setActive(true)
    end
end

function DoubleStateItem:save()
	local saveData = {}
	saveData["active"] = self:getActive()
	saveData["state"] = self:getState()
	return saveData
end

function DoubleStateItem:load(data)
	if data["active"] ~= nil then
		self:setActive(data["active"])
	end
	if data["state"] ~= nil then
		self:setState(data["state"])
	end
	return true
end

function DoubleStateItem:propertyChanged(key, value)
	self:updateIcon()
end