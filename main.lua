local nuklear = require("nuklear")
local ui = nuklear.newUI()
local tbox = require("charsc_tbox")
local g = love.graphics

local font = g.newFont(27)
local font2 = g.newFont(20)

local search_box = tbox.new(10, 53, 240, 40, g.newFont(16))
local url = require("url")


local selected 
local current_download 


local frame = 0
local go_download = false

function love.update(dt)
	ui:frame(window)
end


function love.draw()
	ui:draw()
	search_box:draw()
	g.setColor(0.25, 0.25, 0.25)
	g.line(width(1/3), 0, width(1/3), height())
	g.setColor(1, 1, 1)

	if go_download then
		local text = "Downloading " .. current_download.name
		local fontw = font:getWidth(text)
		g.setColor(62/255, 68/255, 84/255)
		g.rectangle("fill", width()/2 - fontw/2-15, height()/2-100-10, fontw+30, 50, 3, 3, 5)
		g.setFont(font)
		g.setColor(1, 1, 1)
		g.print(text, width()/2 - fontw/2, height()/2-100)
	end 
end


function window()
	ui:window("Search downloads", 0, 0, width(1/3), 120, 'title', search_bar)
	ui:window("Search download content", 0, 120, width(1/3), height()-120, 'scrollbar', 'scroll auto hide', search_download)
	ui:window("Download Info", width(1/3), 0, width(2/3), height()-40, 'title', 'scrollbar', 'scroll auto hide', 'background', info_download)
	ui:window("Download Button", width(1/3), 560, width(2/3), 50, button_download)
end



function search_bar()

	-- Actualy part of the search window i just didnt want to have an empty function
	if not selected then 
		selected = {} 
		for i = 1, #url.links do 
			selected[i] = false
		end
	end
end


function search_download()
	ui:layoutRow("dynamic", 30, 1)
	for i = 1, #url.links do

		if current_download ~= url.links[i] then
			selected[i]=false 
		end

		selected[i] = ui:selectable(url.links[i].name, selected[i])
		
		if selected[i] then 
			current_download = url.links[i]
		end

	end

	-- Check if there is no selected text
	for s = 1, #selected do 
		if selected[s] then 
			return
		end
	end
	current_download = nil
end






function info_download()

	if current_download then 

		ui:stylePush{font = font2}
		ui:layoutRow("dynamic", 80, 1)
		ui:label(current_download.name, "centered")
		ui:layoutRow("dynamic", 40, 1)
		ui:label("") 
		ui:stylePop()
		ui:layoutRow("dynamic", 400, 1)
		ui:label(current_download.description, "wrap")

		if go_download then
			frame = frame + 1
		end

		if frame > 2 then 
			url.get_file(current_download)
			go_download = false
			frame = 0
		end

	end

end



function button_download()
	if current_download then

		ui:layoutRow("dynamic", 30, 3)
		ui:label("") 

		if ui:button("Download") then 
			go_download = true
		end
	end
end

























-- Dont edit these functions

function width(num) return num and g.getWidth() * num or g.getWidth() end
function height(num) return num and g.getHeight() * num or g.getHeight() end

function love.keypressed(key, scancode, isrepeat)
	ui:keypressed(key, scancode, isrepeat)
	if key == 'escape' then love.event.quit() end
	search_box:keypressed(key)
	url.order(search_box:Text())
	selected = nil
end

function love.keyreleased(key, scancode)
	ui:keyreleased(key, scancode)
end

function love.mousepressed(x, y, button, istouch, presses)
	ui:mousepressed(x, y, button, istouch, presses)
	search_box:mousepressed(x, y)
end

function love.mousereleased(x, y, button, istouch, presses)
	ui:mousereleased(x, y, button, istouch, presses)
end

function love.mousemoved(x, y, dx, dy, istouch)
	ui:mousemoved(x, y, dx, dy, istouch)
end

function love.textinput(text)
	ui:textinput(text)
	search_box:textinput(text)
	url.order(search_box:Text())
	selected = nil
end

function love.wheelmoved(x, y)
	ui:wheelmoved(x, y)
end
