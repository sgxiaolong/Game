
function createTouchableSprite(p)
    local sprite = display.newScale9Sprite(p.image)
    sprite:setContentSize(p.size)

    local cs = sprite:getContentSize()
    local label = ui.newTTFLabel({text = p.label, color = p.labelColor})
    label:setPosition(cs.width / 2, label:getContentSize().height)
    sprite:addChild(label)
    sprite.label = label

    return sprite
end

function createSimpleButton(imageName, name, movable, listener)
    local sprite = display.newSprite(imageName)

    if name then
        local cs = sprite:getContentSize()
        local label = ui.newTTFLabel({text = name, color = display.COLOR_BLACK})
        label:setPosition(cs.width / 2, cs.height / 2)
        -- sprite:addChild(label)
    end

    sprite:setTouchEnabled(true) -- enable sprite touch
    -- sprite:setTouchMode(cc.TOUCH_ALL_AT_ONCE) -- enable multi touches
    sprite:setTouchSwallowEnabled(false)
    sprite:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        local name, x, y, prevX, prevY = event.name, event.x, event.y, event.prevX, event.prevY
        if name == "began" then
            sprite:setOpacity(128)
            -- return cc.TOUCH_BEGAN -- stop event dispatching
            return cc.TOUCH_BEGAN_NO_SWALLOWS -- continue event dispatching
        end

        local touchInSprite = sprite:getCascadeBoundingBox():containsPoint(CCPoint(x, y))
        if name == "moved" then
            sprite:setOpacity(128)
            if movable then
                local offsetX = x - prevX
                local offsetY = y - prevY
                local sx, sy = sprite:getPosition()
                sprite:setPosition(sx + offsetX, sy + offsetY)
                return cc.TOUCH_MOVED_RELEASE_OTHERS -- stop event dispatching, remove others node
                -- return cc.TOUCH_MOVED_SWALLOWS -- stop event dispatching
            end

        elseif name == "ended" then
            if touchInSprite then listener() end
            sprite:setOpacity(255)
        else
            sprite:setOpacity(255)
        end
    end)

    return sprite
end

function drawBoundingBox(parent, target, color)
    local cbb = target:getCascadeBoundingBox()
    local left, bottom, width, height = cbb.origin.x, cbb.origin.y, cbb.size.width, cbb.size.height
    local points = {
        {left, bottom},
        {left + width, bottom},
        {left + width, bottom + height},
        {left, bottom + height},
        {left, bottom},
    }
    local box = display.newPolygon(points, 1.0)
    box:setLineColor(color)
    parent:addChild(box, 1000)
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