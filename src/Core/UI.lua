
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local UI = {}

local COLORS = {
    Background = Color3.fromRGB(15, 15, 15),
    Surface = Color3.fromRGB(25, 25, 25),
    Lime = Color3.fromRGB(0, 255, 120),
    White = Color3.fromRGB(255, 255, 255),
    Gray = Color3.fromRGB(125, 125, 125),
    Black = Color3.fromRGB(0, 0, 0)
}

local function create(className, properties, parent)
    local object = Instance.new(className)

    for property, value in pairs(properties) do
        object[property] = value
    end

    object.Parent = parent

    return object
end

local function round(parent, radius)
    create("UICorner", {
        CornerRadius = UDim.new(0, radius)
    }, parent)
end

local function stroke(parent, color, thickness)
    return create("UIStroke", {
        Color = color,
        Thickness = thickness
    }, parent)
end

function UI.Create()
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    local previous = playerGui:FindFirstChild("LiiighttHubUI")

    if previous then
        previous:Destroy()
    end

    local screenGui = create("ScreenGui", {
        Name = "LiiighttHubUI",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = 100,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    }, playerGui)

    local mainFrame = create("Frame", {
        Name = "MainFrame",
        Size = UDim2.fromOffset(360, 540),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = COLORS.Background,
        BorderSizePixel = 0,
        Active = true,
        ClipsDescendants = false
    }, screenGui)

    round(mainFrame, 12)
    stroke(mainFrame, COLORS.Black, 2)

    local uiScale = create("UIScale", {
        Scale = UserInputService.TouchEnabled and 0.72 or 1
    }, mainFrame)

    local header = create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 45),
        Position = UDim2.fromOffset(0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 2
    }, mainFrame)

    local logo = create("TextLabel", {
        Name = "Logo",
        Size = UDim2.fromOffset(105, 35),
        Position = UDim2.fromOffset(15, 5),
        BackgroundTransparency = 1,
        Text = "Liiightt",
        TextColor3 = COLORS.Lime,
        Font = Enum.Font.GothamBlack,
        TextSize = 20,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 3
    }, header)

    local hub = create("TextLabel", {
        Name = "Hub",
        Size = UDim2.fromOffset(45, 35),
        Position = UDim2.fromOffset(112, 5),
        BackgroundTransparency = 1,
        Text = "Hub",
        TextColor3 = COLORS.White,
        Font = Enum.Font.GothamBlack,
        TextSize = 20,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 3
    }, header)

    local author = create("TextLabel", {
        Name = "Author",
        Size = UDim2.fromOffset(100, 25),
        Position = UDim2.fromOffset(160, 10),
        BackgroundTransparency = 1,
        Text = "by @Noxer",
        TextColor3 = COLORS.Gray,
        TextTransparency = 0.55,
        Font = Enum.Font.SourceSans,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 3
    }, header)

local separator = create("Frame", {
    Name = "Separator",
    Size = UDim2.new(1, 0, 0, 2),
    Position = UDim2.fromOffset(0, 45),
    BackgroundColor3 = COLORS.Black,
    BorderSizePixel = 0,
    ZIndex = 1
}, mainFrame)

local function createTab(name, position)
    local button = create("TextButton", {
        Name = name,
        Size = UDim2.fromOffset(165, 34),
        Position = position,
        BackgroundColor3 = COLORS.Surface,
        BorderSizePixel = 0,
        Text = name,
        TextColor3 = COLORS.Gray,
        Font = Enum.Font.SourceSans,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
        AutoButtonColor = false,
        ZIndex = 2
    }, mainFrame)

    round(button, 8)
    stroke(button, COLORS.Black, 2)

    local bottomCover = create("Frame", {
        Name = "BottomCover",
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 1, -10),
        BackgroundColor3 = COLORS.Surface,
        BorderSizePixel = 0,
        ZIndex = 2
    }, button)

    return button
end

local mainTab = createTab("Основное", UDim2.fromOffset(10, 43))
local settingsTab = createTab("Настройки", UDim2.fromOffset(185, 43))

local pages = create("Folder", {Name = "Pages"}, mainFrame)

local mainPage = create("Frame", {
    Name = "MainPage",
    Size = UDim2.new(1, -20, 1, -126),
    Position = UDim2.fromOffset(10, 81),
    BackgroundTransparency = 1,
    Visible = true,
    ZIndex = 1
}, pages)

local settingsPage = create("Frame", {
    Name = "SettingsPage",
    Size = UDim2.new(1, -20, 1, -126),
    Position = UDim2.fromOffset(10, 81),
    BackgroundTransparency = 1,
    Visible = false,
    ZIndex = 1
}, pages)

local function switchTab(selected)
    local isMain = selected == "Основное"

    mainPage.Visible = isMain
    settingsPage.Visible = not isMain

    mainTab.ZIndex = isMain and 3 or 2
    settingsTab.ZIndex = isMain and 2 or 3

    separator.ZIndex = 1

    mainTab.TextColor3 = isMain and COLORS.Lime or COLORS.Gray
    settingsTab.TextColor3 = isMain and COLORS.Gray or COLORS.Lime

    mainTab.BackgroundColor3 = COLORS.Surface
    settingsTab.BackgroundColor3 = COLORS.Surface
end

mainTab.MouseButton1Click:Connect(function()
    switchTab("Основное")
end)

settingsTab.MouseButton1Click:Connect(function()
    switchTab("Настройки")
end)

switchTab("Основное")
