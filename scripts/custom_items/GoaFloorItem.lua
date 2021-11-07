GoaFloorItem = CustomItem:extend()

BOSSNAMES = 
{
	"unknown",
	"kelbesque",
	"sabera",
	"mado",
	"karmine"
}

function GoaFloorItem:init(name, defaultState)
	self.enableIconUpdates = false
	self.name = name
	self.displayName = "Goa " .. name .. " Floor"
	self:createItem(self.displayName)
	self:setProperty("state", defaultState)
	self:setProperty("reversed", false)
	self.enableIconUpdates = true
	self:updateIcon()
end

function GoaFloorItem:getState()
	return self:getProperty("state")
end

function GoaFloorItem:setState(state)
	self:setProperty("state", state)
end

function GoaFloorItem:updateIcon()
	if self.enableIconUpdates then
		local filename = "images/goa floors/" .. self.name .. "_"
		local state = self:getState()
		if state == 0 then
			filename = filename .. "badge"
		elseif state == 1 then
			filename = filename .. "kelbesque"
		elseif state == 2 then
			filename = filename .. "sabera"
		elseif state == 3 then
			filename = filename .. "mado"
		elseif state == 4 then
			filename = filename .. "karmine"
		end
		if self:getProperty("reversed") and state ~= 0 then
			filename = filename .. "_r"
		end
		filename = filename .. ".png"
		self.ItemInstance.Icon = ImageReference:FromPackRelativePath(filename)
	end
end

function GoaFloorItem:onLeftClick()
	local state = self:getState()
	state = state + 1
	if state == 5 then
		state = 0
	end
	self:setState(state)
end

function GoaFloorItem:onRightClick()
	self:setProperty("reversed",  not self:getProperty("reversed"))
end

function GoaFloorItem:canProvideCode(code)
	if code == "goaknownfloor" then return true end
	if code == "goa" .. self.name then return true end
	for index, bossName in ipairs(BOSSNAMES) do
		if	code == "goa" .. bossName or
			code == "goa" .. bossName .. "_r" or
			code == "goa" .. self.name .. bossName then
				return true
		end
	end
end

function GoaFloorItem:providesCode(code)
	if code == "goa" .. self.name then return 1 end
	local state = self:getProperty("state")
	if code == "goaknownfloor" and state > 0 then return 1 end
	local bossName = BOSSNAMES[state + 1]
	if	code == "goa" .. bossName or
		code == "goa" .. self.name .. bossName then
			return 1
	end
	if self:getProperty("reversed") and code == "goa" .. bossName .. "_r" then
		return 1
	end
	return 0
end

function GoaFloorItem:advanceToCode(code)
	self.enableIconUpdates = false
	if string.find(code, "unknown") ~= nil then
		self:setState(0)
	elseif string.find(code, "kelbesque") ~= nil then
		self:setState(1)
	elseif string.find(code, "sabera") ~= nil then
		self:setState(2)
	elseif string.find(code, "mado") ~= nil then
		self:setState(3)
	elseif string.find(code, "karmine") ~= nil then
		self:setState(4)
	end
	if string.find(code, "_r") ~= nil then
		self:setProperty("reversed", true)
	else
		self:setProperty("reversed", false)
	end
	self.enableIconUpdates = true
	self:updateIcon()
end

function GoaFloorItem:save()
	local saveData = {}
	saveData["state"] = self:getState()
	saveData["reversed"] = self:getProperty("reversed")
	return saveData
end

function GoaFloorItem:load(data)
	self.enableIconUpdates = false
	if data["reversed"] ~= nil then
		self:setProperty("reversed", data["reversed"])
	end
	if data["state"] ~= nil then
		self:setState(data["state"])
	end
	self.enableIconUpdates = true
	self:updateIcon()
	return true
end

function GoaFloorItem:propertyChanged(key, value)
	self:updateIcon()
end