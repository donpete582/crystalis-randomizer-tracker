FlagGroupItem = CustomItem:extend()

function FlagGroupItem:init(name, codelist, imagePath)
	self:createItem(name)
	self.codelist = codelist
	self.flags = flags
	self:setProperty("active", false)
	self.activeImage = ImageReference:FromPackRelativePath(imagePath)
	self.disabledImage = ImageReference:FromImageReference(self.activeImage, "@disabled")
	self.ItemInstance.PotentialIcon = self.activeImage
	self:updateIcon()	
	self.allowResets = true
    -- self.allFlags = { "gf", "gs", "gn", "gg", "gc", "gt", "gr", "wm", "wh", "wt", "wu", "we", "wg", "me", "ro", "rd", "et", "eu", "er",
    --     "nw", "ns", "nb", "ng", "vm", "vbangm", "vw", "vb" }
    self.allFlags = { "me" }
end

function FlagGroupItem:setActive(active)
	self:setProperty("active", active)
end

function FlagGroupItem:getActive()
	return self:getProperty("active")
end

function FlagGroupItem:updateIcon()
	if self:getActive() then
		self.ItemInstance.Icon = self.activeImage
	else
		self.ItemInstance.Icon = self.disabledImage
	end
end

function FlagGroupItem:onLeftClick()
	self:setActive(not self:getActive())
end

function FlagGroupItem:onRightClick()
	self:setActive(not self:getActive())
end

function FlagGroupItem:canProvideCode(code)
    for index, value in ipairs(self.codelist) do
        if code == value then
            return true
        end
    end
    return false
end

function FlagGroupItem:providesCode(code)
	if self:getActive() then
        for index, value in ipairs(self.codelist) do
            if code == value then
                return 1
            end
        end
		return 0
	end
	return 0
end

function FlagGroupItem:advanceToCode(code)
	if code == nil or code == self.codelist[1] then
		self:setActive(true)
	end
end

function FlagGroupItem:save()
	local saveData = {}
	saveData["active"] = self:getActive()
	return saveData
end

function FlagGroupItem:load(data)
	self.allowResets = false
	if data["active"] ~= nil then
		self:setActive(data["active"])
	end
	self.allowResets = true
	return true
end

-- function FlagGroupItem:setFlags()
--     for index, value in ipairs(self.allFlags) do
--         if Tracker:ProviderCountForCode("flag_" .. value) > 0 then
--             local flag = Tracker:FindObjectForCode("flag_" .. value)
--             flag.setProperty("active", false)
--         end
--     end
--     for index, value in ipairs(self.codelist) do
--         if index > 1 then
--             local flag = Tracker:FindObjectForCode("flag_" .. value)
--             flag.setProperty("active", true)
--         end
--     end
-- end

function FlagGroupItem:propertyChanged(key, value)
	-- if key == "active" and value == true then
    --     self:setFlags()
	-- end
	self:updateIcon()
end