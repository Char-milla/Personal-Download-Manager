local tbox = {}
tbox.__index = tbox
local utf8 = require("utf8")
local g = love.graphics

function tbox:draw()
	g.setFont(self.font)	

	g.setColor(.3, .3, .3)
	g.rectangle('fill',
        self.x, self.y,
        self.w, self.h, 3, 3, 5)
	
	if self.active then 
		g.setColor(.45, .45, .45)
		g.rectangle('line', 
		self.x, self.y,
		self.w, self.h, 3, 3, 5)
	end
	g.setColor(1, 1, 1)

	g.printf(self.text, self.x + 10, self.y + self.h/2 - self.font:getHeight()/2, self.w - 10, "left")	
end


function tbox:Text(t)
	if not t then return self.text end
	self.text = t
end


function tbox:mousepressed(x, y)
    if
        x >= self.x and
        x <= self.x + self.w and
        y >= self.y and 
        y <= self.y + self.h 
    then
        self.active = true
    elseif self.active then
        self.active = false
    end
end


function tbox:keypressed(key)
    if key == "backspace" then
        local byteoffset = utf8.offset(self.text, -1)
 
        if byteoffset then
            self.text = string.sub(self.text, 1, byteoffset - 1)
        end
    end
end


function tbox:textinput(text)
    if self.active and #self.text < 22 then
        self.text = self.text .. text
    end
end


return {
	new = function (x, y, w, h, font)
		return setmetatable({ text="", x=x, y=y, w=w, h=h, font=font or g.getFont(), active=false }, tbox)
	end
}
