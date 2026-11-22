local BASE_URL = "https://githubusercontent.com"

local function loadModule(path)
    local url = BASE_URL .. path .. "?t=" .. tostring(os.time())
    local source = game:HttpGet(url)
    return loadstring(source)()
end

local UI = loadModule("src/Core/UI.lua")
local Elements = loadModule("src/Components/Elements.lua")
local Movement = loadModule("src/Movement/Movement.lua")

local hub = UI.Create()

local movementState = Movement.Init(hub.Sections.Movement, Elements)

Elements.CreateButton(hub.Sections.Misc, "Закрыть скрипт", function()
    if movementState and movementState.Destroy then
        movementState.Destroy()
    end
    hub.ScreenGui:Destroy()
end)
