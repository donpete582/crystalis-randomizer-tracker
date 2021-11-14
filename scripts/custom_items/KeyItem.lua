KeyItem = CustomItem:extend()

BADGE_IMAGE_PATH = "images/badges/"

function KeyItem:init(name, code, category, imagePath, badges)
	self.canUpdateIcon = false
	self:createItem(name)
	self.name = name
	--print("name: " .. name .. " code: " .. code)
	self.code = code
	self.category = category
	self.badges = badges
	self:setProperty("active", false)
	self:setProperty("badgeNum", 0)
	self.imageBase = ImageReference:FromPackRelativePath(imagePath)
	self.ItemInstance.PotentialIcon = self.imageBase
	self:cacheAndUpdateFromFlags()
	self.canUpdateIcon = true
	self:updateIcon()
end

function KeyItem:cacheAndUpdateFromFlags()
	self.isCaching = true
	local flag_wt = Tracker:ProviderCountForCode("flag_wt") > 0
	local flag_wu = Tracker:ProviderCountForCode("flag_wu") > 0
	if self.flag_wt == nil or self.flag_wt ~= flag_wt or self.flag_wu == nil or self.flag_wu ~= flag_wu then
		--print("caching")
		self.flag_wt = flag_wt
		self.flag_wu = flag_wu
		local badgeNum = self:getProperty("badgeNum")
		local badge = self.badges[badgeNum]
		if not flag_wt and not flag_wu then
			self:setProperty("badgeNum", 0)
		elseif	badgeNum > 0 and
			((flag_wt and not flag_wu and badge["flag_wt"]) or
			(not flag_wt and flag_wu and badge["flag_wu"]) or
			(flag_wt and flag_wu and badge["both"])) then
				--no need to update
		else
			--print("right-clicking: " .. self.name)
			self:onRightClick()
		end
	end
	self.isCaching = false
end

function KeyItem:updateIcon()
	if self.canUpdateIcon then
		local img_mod = ""
		if self:getProperty("badgeNum") and self:getProperty("badgeNum") > 0 then
			img_mod = "overlay|".. BADGE_IMAGE_PATH .. self.badges[self:getProperty("badgeNum")]["code"] .. ".png"
		end
		if not self:getProperty("active") then
			img_mod = img_mod .. ",@disabled"
		end
		self.ItemInstance.Icon = ImageReference:FromImageReference(self.imageBase, img_mod)
	end
end

function KeyItem:onLeftClick()
	self:cacheAndUpdateFromFlags()
	self:setProperty("active", not self:getProperty("active"))
end

function KeyItem:onRightClick()
	local flag_wt = Tracker:ProviderCountForCode("flag_wt") > 0
	local flag_wu = Tracker:ProviderCountForCode("flag_wu") > 0
	--print ("flag_wt: " .. (flag_wt and 'true' or 'false') .. " flag_wu: " .. (flag_wu and 'true' or 'false'))
	if not flag_wt and not flag_wu then
		self:setProperty("badgeNum", 0)
	else
		local badgeNum = self:getProperty("badgeNum")
		local initialBadgeNum = badgeNum
		badgeNum = badgeNum + 1
		if badgeNum > #self.badges then
			badgeNum = 1
		end
		while badgeNum ~= initialBadgeNum do
			local currentBadge = self.badges[badgeNum]
			if	(flag_wt and not flag_wu and currentBadge["flag_wt"]) or
				(not flag_wt and flag_wu and currentBadge["flag_wu"]) or
				(flag_wt and flag_wu and currentBadge["both"]) then
					break
			end
			badgeNum = badgeNum + 1
			if badgeNum > #self.badges then
				if initialBadgeNum == 0 then
					break
				end
				badgeNum = 1
			end
		end
		if badgeNum == initialBadgeNum or badgeNum > #self.badges then
			self:setProperty("badgeNum", 0)
		else
			self:setProperty("badgeNum", badgeNum)
		end
	end
end

function KeyItem:canProvideCode(code)
	if self.code and self.code == code then
		return true
	end
	if self.category and self.category == code then
		return true
	end
	for _, badge in ipairs(self.badges) do
		if 	code == badge["code"] or
			code == "not" .. badge["code"] then
			return true
		end
	end
	return false
end

function KeyItem:providesCode(code)
	local badgeNum = self:getProperty("badgeNum")
	if 	self:getProperty("active") and 
		(code == self.code or 
		code == self.category or
		(badgeNum > 0 and code == self.badges[badgeNum]["code"])) then
			return 1
	end
	if 	not self:getProperty("active") and
		(badgeNum > 0 and code == ("not" .. self.badges[badgeNum]["code"])) then
			return 1
	end
	return 0
end

function KeyItem:advanceToCode(code)
	local flag_wt = Tracker:ProviderCountForCode("flag_wt") > 0
	local flag_wu = Tracker:ProviderCountForCode("flag_wu") > 0
	if code ~= nil and code == self.code then
		self:setProperty("active", true)
	else
		for badgeIndex, badge in ipairs(self.badges) do
			if code == badge["code"] then
				if	(flag_wt and not flag_wu and currentBadge["flag_wt"]) or
					(not flag_wt and flag_wu and currentBadge["flag_wu"]) or
					(flag_wt and flag_wu and currentBadge["both"]) then
						self:setProperty("badgeNum", badgeIndex)
						self:setProperty("active", true)
				end
				break
			end
		end
	end
end

function KeyItem:save()
	local saveData = {}
	saveData["active"] = self:getProperty("active")
	saveData["badgeNum"] = self:getProperty("badgeNum")
	return saveData
end

function KeyItem:load(data)
	self.canUpdateIcon = false
	if data["active"] ~= nil then
		self:setProperty("active", data["active"])
	end
	if data["badgeNum"] ~= nil then
		self:setProperty("badgeNum", data["badgeNum"])
	end
	self.canUpdateIcon = true
	self:updateIcon()
	return true
end

function KeyItem:propertyChanged(key, value)
	self:updateIcon()
end
