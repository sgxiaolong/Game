local Player = import("..roles.role")
local TouchLayer = import(".TouchLayer")
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    self:initScene()
end

function MainScene:initScene()
	self:addRoles()
    self.touchLayer = TouchLayer:new()
    self:addChild(self.touchLayer)
    -- self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.tick))
    -- self:scheduleUpdate()
end

function MainScene:tick(dt)
    --print(self.Direct)
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
