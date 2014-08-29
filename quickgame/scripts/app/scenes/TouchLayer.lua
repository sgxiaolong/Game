import("..utility.functions")
local TouchLayer = class("TouchLayer",function()
 	local layer= display.newLayer()
 	return layer
 end)

function TouchLayer:ctor()
	self.Direct = "standy"
	self:initTouch()
end

function TouchLayer:initTouch()
    self:setTouchEnabled(true)
    self:setTouchMode(cc.TOUCH_MODE_ALL_AT_ONCE)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, 
    	handler(self,self.onTouch))

    self.btnDirect = display.newNode():addTo(self)
    self.btnDirect.key = -1
    function self.btnDirect:onTouch(name,poi)
    	print("btnDirect","x=",poi.x,"y=",poi.y)
    end
    self.btnDirect:setContentSize(cc.Size(500,100))
    drawBoundingBox(self, self.btnDirect,cc.c4f(0, 1.0, 0, 1.0))

    self.btnAttack = display.newSprite("image/attack-auto.png")
    :pos(800,100)
    :addTo(self)
    function self.btnAttack:onTouch(name,poi)
    	if name == "began" then
    		--todo
    	end
    	print("btnAttack","x=",poi.x,"y=",poi.y)
    end
    self.btnAttack.key = -1

    self.tableBtn = {self.btnDirect,self.btnAttack}
end

function TouchLayer:onTouch(event)
    	--print_lua_table(event)
        local x = nil
        if event.name == "began" or event.name == "added" then
        	for k,v in pairs(event.points) do
	     		for i,btn in ipairs(self.tableBtn) do
	     			if btn:getBoundingBox():containsPoint(ccp(v.x, v.y)) then
	     				if btn.key == -1 then
		     				btn.key = v.id
		     				local poi = btn:convertToNodeSpace(ccp(v.x, v.y))
		     				btn:onTouch(event.name,poi)
		     				break
		     			end
	     			end
	     		end
     		end
     	elseif event.name == "moved" then
     		for k,v in pairs(event.points) do
	     		for i,btn in ipairs(self.tableBtn) do
	     			if btn.key == v.id then
	     				local poi = btn:convertToNodeSpace(ccp(v.x, v.y))
	     				btn:onTouch(event.name,poi)
	     			end
	     		end
     		end
     	elseif event.name == "removed" then
     		for k,v in pairs(event.points) do
	     		for i,btn in ipairs(self.tableBtn) do
	     			if btn.key == v.id then
	     				btn.key = -1
	     			end
	     		end
     		end
     	elseif event.name == "ended" or event.name == "canceled" then
     			for i,btn in ipairs(self.tableBtn) do
	     			btn.key = -1
	     		end
        end
end
return TouchLayer
