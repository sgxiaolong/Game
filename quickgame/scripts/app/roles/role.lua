local Role = class("Role",function ()
	-- body
	local sprite = display.newSprite("#player1-1-1.png")
    return sprite
end)

function Role:addUI()
--    self.mBlood =
end

function Role:ctor()
	self:addAnimation()
    self:addStateMachine()
end

function Role:addAnimation()
	-- body
	    local animationNames = {"walk", "attack", "dead", "hit", "skill"}
    local animationFrameNum = {4, 4, 4, 2, 4}

    for i = 1, #animationNames do
        local frames = display.newFrames("player1-" .. i .. "-%d.png", 1, animationFrameNum[i])
        local animation = display.newAnimation(frames, 0.2)
        display.setAnimationCache("Role1-" .. animationNames[i], animation)
    end
end

function Role:idle()
    transition.stopTarget(self)
end

function Role:walkTo(pos, callback)

    local function moveStop()
        self:doEvent("stop")
        if callback then
            callback()
        end
    end

    if self.moveAction then
        self:stopAction(self.moveAction)
        self.moveAction = nil
    end

    local currentPos = CCPoint(self:getPosition())
    local destPos = CCPoint(pos.x, pos.y)

    -- 感谢lcf8858同学的建议
    if pos.x < currentPos.x then
        self:setFlipX(true)
    else
        self:setFlipX(false)
    end

    local posDiff = cc.PointDistance(currentPos, destPos)
    self.moveAction = transition.sequence({CCMoveTo:create(5 * posDiff / display.width, CCPoint(pos.x,pos.y)), CCCallFunc:create(moveStop)})
    transition.playAnimationForever(self, display.getAnimationCache("Role1-walk"))
    self:runAction(self.moveAction)
    return true
end

function Role:attack()

    local function attackEnd()
        self:doEvent("stop")
    end

    local animation = display.getAnimationCache("Role1-attack")
    animation:setRestoreOriginalFrame(true)
    transition.playAnimationOnce(self, animation, false, attackEnd)
end

function Role:hit()
    local animation = display.getAnimationCache("Role1-hit")
    animation:setRestoreOriginalFrame(true)
    transition.playAnimationOnce(self, animation)
end

function Role:dead()
    transition.playAnimationOnce(self, display.getAnimationCache("Role1-dead"))
end

function Role:doEvent(event, ...)
    self.fsm_:doEvent(event, ...)
end

function Role:getState()
    return self.fsm_:getState()
end

function Role:addStateMachine()
    self.fsm_ = {}
    cc.GameObject.extend(self.fsm_)
    :addComponent("components.behavior.StateMachine")
    :exportMethods()

    self.fsm_:setupState({
        -- 初始状态
        initial = "idle",

        -- 事件和状态转换
        events = {
            -- t1:clickScreen; t2:clickEnemy; t3:beKilled; t4:stop
            {name = "clickScreen", from = {"idle", "attack"},   to = "walk" },
            {name = "clickEnemy",  from = {"idle", "walk"},  to = "attack"},
            {name = "beKilled", from = {"idle", "walk", "attack"},  to = "dead"},
            {name = "stop", from = {"walk", "attack"}, to = "idle"},
        },

        -- 状态转变后的回调
        callbacks = {
            onidle = function (event) self:idle() end,
            onwalk = function (event)  end,
            onattack = function (event) self:attack()  end,
            ondead = function (event) self:dead() end
        },
    })

end

return Role