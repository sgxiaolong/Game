local Player = import("..roles.Role")
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    ui.newTTFLabel({text = "Hello, World", size = 64, align = ui.TEXT_ALIGN_CENTER})
        :pos(display.cx, display.cy)
        :addTo(self)
    self:initScene()
    self.layerTouch:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.tick))
    self.layerTouch:scheduleUpdate()
    self.Direct = "standy"
end

function MainScene:initScene()
	self:addRoles()
    self:addTouchLayer()
end

function MainScene:addTouchLayer()
    local function onTouch(eventName, x, y)
    	if(true ~=self.layerTouch:getBoundingBox():containsPoint(ccp(x, y))) then
    		return false
    	end
        if (eventName == "began" or eventName == "moved") then
            if x<80 then
                self.Direct = "left"
            else
            	self.Direct = "right"
            end
        elseif eventName == "end" then
        		self.Direct = "standy"
        end
        print(self.Direct,eventName, x, y)
        return true
    end

    
    --self.layerTouch = display.newSprite("image/privilege_icon_21.png")
    self.layerTouch = display.newColorLayer(ccc4(255, 255, 255, 128))
    self.layerTouch:setAnchorPoint(ccp(0, 0))
    self.layerTouch:setContentSize(CCSizeMake(500,100))
    self.layerTouch:addNodeEventListener(cc.NODE_TOUCH_EVENT, 
    	function(event)
    	print_lua_table(event)
        return onTouch(event.name, event.x, event.y)
    end)
    self.layerTouch:setTouchEnabled(true)
    self.layerTouch:setPosition(ccp(0,0))
    self:addChild(self.layerTouch, -5)
end

function print_lua_table (lua_table, indent)
	indent = indent or 0
	for k, v in pairs(lua_table) do
		if type(k) == "string" then
			k = string.format("%q", k)
		end
		local szSuffix = ""
		if type(v) == "table" then
			szSuffix = "{"
		end
		local szPrefix = string.rep("    ", indent)
		formatting = szPrefix.."["..k.."]".." = "..szSuffix
		if type(v) == "table" then
			print(formatting)
			print_lua_table(v, indent + 1)
			print(szPrefix.."},")
		else
			local szValue = ""
			if type(v) == "string" then
				szValue = string.format("%q", v)
			else
				szValue = tostring(v)
			end
			print(formatting..szValue..",")
		end
	end
end

function MainScene:tick(dt)
    print(self.Direct)
end

function MainScene:addRoles()
    -- 玩家
    self.player = Player.new()
    self.player:setPosition(display.left + self.player:getContentSize().width/2, display.cy)
    self:addChild(self.player)
end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
