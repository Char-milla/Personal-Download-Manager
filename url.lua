local curl = {}

local returnLinks
if love.filesystem.isFused() then
    local dir = love.filesystem.getSourceBaseDirectory()
    local success = love.filesystem.mount(dir, "PDM")
 
    if success then
		 returnLinks = loadstring(love.filesystem.read("PDM/links.txt"))
    end
end


curl.links = {}

curl.url = returnLinks() or {}


curl.links = curl.url

curl.order = function (t)
	if t == "" then curl.links = curl.url end
	curl.links = {}
	for i = 1, #curl.url do 
		if curl.url[i].name:lower():find(t:lower()) then 
			table.insert(curl.links, curl.url[i])
		end
	end
end

curl.get_file = function (url)
	os.execute("curl -L " .. url.url .. " -o ".. url.name)
end

return curl
