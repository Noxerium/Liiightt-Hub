
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
        Active = true
    }, screenGui)

    round(mainFrame, 12)
    stroke(mainFrame, COLORS.Black, 2)

    local uiScale = create("UIScale", {
        Scale = UserInputService.TouchEnabled and 0.72 or 1
    }, mainFrame)

    local header = create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundTransparency = 1,
        BorderSizePixel = 0
    }, mainFrame)

    local logo = create("TextLabel", {
        Name = "Logo",
        Size = UDim2.fromOffset(175, 35),
        Position = UDim2.fromOffset(15, 5),
        BackgroundTransparency = 1,
        Text = "Liiightt",
        TextColor3 = COLORS.Lime,
        Font = Enum.Font.GothamBlack,
        TextSize = 21,
        TextXAlignment = Enum.TextXAlignment.Left
    }, header)

    local hub = create("TextLabel", {
        Name = "Hub",
        Size = UDim2.fromOffset(55, 35),
        Position = UDim2.fromOffset(105, 5),
        BackgroundTransparency = 1,
        Text = "Hub",
        TextColor3 = COLORS.White,
        Font = Enum.Font.GothamBlack,
        TextSize = 21,
        TextXAlignment = Enum.TextXAlignment.Left
    }, header)

    local author = create("TextLabel", {
        Name = "Author",
        Size = UDim2.fromOffset(100, 25),
        Position = UDim2.new(1, -108, 0, 10),
        BackgroundTransparency = 1,
        Text = "by @Noxer",
        TextColor3 = COLORS.Gray,
        Font = Enum.Font.SourceSans,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Right
    }, header)

    local tabs = create("Frame", {
        Name = "Tabs",
        Size = UDim2.new(1, -20, 0, 32),
        Position = UDim2.fromOffset(10, 45),
        BackgroundColor3 = COLORS.Surface,
        BorderSizePixel = 0
    }, mainFrame)

    round(tabs, 8)

    local function createTab(name, position)
        local button = create("TextButton", {
            Name = name,
            Size = UDim2.new(0.5, 0, 1, 0),
            Position = position,
            BackgroundColor3 = COLORS.Surface,
            BorderSizePixel = 0,
            Text = name,
            TextColor3 = COLORS.Gray,
            Font = Enum.Font.SourceSans,
            TextSize = 16,
            AutoButtonColor = false
        }, tabs)

        round(button, 8)

        return button
    end

    local mainTab = createTab(
        "Основное",
        UDim2.fromScale(0, 0)
    )

    local settingsTab = createTab(
        "Настройки",
        UDim2.fromScale(0.5, 0)
    )

    local pages = create("Folder", {
        Name = "Pages"
    }, mainFrame)

    local mainPage = create("Frame", {
        Name = "MainPage",
        Size = UDim2.new(1, -20, 1, -92),
        Position = UDim2.fromOffset(10, 82),
        BackgroundTransparency = 1,
        Visible = true
    }, pages)

    local settingsPage = create("Frame", {
        Name = "SettingsPage",
        Size = UDim2.new(1, -20, 1, -92),
        Position = UDim2.fromOffset(10, 82),
        BackgroundTransparency = 1,
        Visible = false
    }, pages)

    local function switchTab(selected)
        local isMain = selected == "Основное"

        mainPage.Visible = isMain
        settingsPage.Visible = not isMain

        mainTab.TextColor3 = isMain and COLORS.Lime or COLORS.Gray
        settingsTab.TextColor3 = isMain and COLORS.Gray or COLORS.Lime
    end

    mainTab.MouseButton1Click:Connect(function()
        switchTab("Основное")
    end)

    settingsTab.MouseButton1Click:Connect(function()
        switchTab("Настройки")
    end)

    local dragging = false
    local dragInput
    local dragStart
    local startPosition

    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            dragStart = input.Position
            startPosition = mainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then

            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart

            mainFrame.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)

    switchTab("Основное")

    return {
        ScreenGui = screenGui,
        MainFrame = mainFrame,
        Header = header,
        MainPage = mainPage,
        SettingsPage = settingsPage,
        UIScale = uiScale,
        Colors = COLORS
    }
end

return UI
