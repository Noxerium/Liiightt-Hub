local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local UI = {}

local COLORS = {
    Background = Color3.fromRGB(15, 15, 15),
    Surface = Color3.fromRGB(25, 25, 25),
    SurfaceInactive = Color3.fromRGB(20, 20, 20),
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
        ZIndex = 5
    }, mainFrame)

    local titleLabel = create("TextLabel", {
        Name = "TitleLabel",
        Size = UDim2.new(1, -120, 0, 35),
        Position = UDim2.fromOffset(15, 5),
        BackgroundTransparency = 1,
        Text = "LiiighttHub",
        TextColor3 = COLORS.White,
        Font = Enum.Font.GothamBlack,
        TextSize = 20,
        TextXAlignment = Enum.TextXAlignment.Left,
        RichText = true,
        ZIndex = 6
    }, header)
    titleLabel.Text = '<font color="rgb(0,255,120)">Liiightt</font>Hub'

    local author = create("TextLabel", {
        Name = "Author",
        Size = UDim2.fromOffset(100, 25),
        Position = UDim2.fromOffset(165, 8),
        BackgroundTransparency = 1,
        Text = "by @Noxer",
        TextColor3 = COLORS.Gray,
        TextTransparency = 0.55,
        Font = Enum.Font.SourceSans,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 6
    }, header)

    local separator = create("Frame", {
        Name = "Separator",
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.fromOffset(0, 77),
        BackgroundColor3 = COLORS.Black,
        BorderSizePixel = 0,
        ZIndex = 4
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
        local outline = stroke(button, COLORS.Black, 2)

        local bottomCover = create("Frame", {
            Name = "BottomCover",
            Size = UDim2.new(1, 0, 0, 10),
            Position = UDim2.new(0, 0, 1, -10),
            BackgroundColor3 = COLORS.Surface,
            BorderSizePixel = 0,
            ZIndex = 3
        }, button)

        return button, bottomCover, outline
    end

    local mainTab, mainCover, mainStroke = createTab("Основное", UDim2.fromOffset(10, 45))
    local settingsTab, settingsCover, settingsStroke = createTab("Настройки", UDim2.fromOffset(185, 45))

    local pages = create("Folder", {
        Name = "Pages"
    }, mainFrame)

    local mainPage = create("Frame", {
        Name = "MainPage",
        Size = UDim2.new(1, -20, 1, -110),
        Position = UDim2.fromOffset(10, 95),
        BackgroundTransparency = 1,
        Visible = true,
        ZIndex = 1
    }, pages)

    local settingsPage = create("Frame", {
        Name = "SettingsPage",
        Size = UDim2.new(1, -20, 1, -110),
        Position = UDim2.fromOffset(10, 95),
        BackgroundTransparency = 1,
        Visible = false,
        ZIndex = 1
    }, pages)

    local function switchTab(selected)
        local isMain = selected == "Основное"

        mainPage.Visible = isMain
        settingsPage.Visible = not isMain

        mainTab.ZIndex = isMain and 4 or 2
        settingsTab.ZIndex = isMain and 2 or 4

        mainTab.TextColor3 = isMain and COLORS.Lime or COLORS.Gray
        settingsTab.TextColor3 = isMain and COLORS.Gray or COLORS.Lime

        mainTab.BackgroundColor3 = isMain and COLORS.Surface or COLORS.SurfaceInactive
        settingsTab.BackgroundColor3 = isMain and COLORS.SurfaceInactive or COLORS.Surface

        mainCover.BackgroundColor3 = isMain and COLORS.Surface or COLORS.SurfaceInactive
        settingsCover.BackgroundColor3 = isMain and COLORS.SurfaceInactive or COLORS.Surface

        mainCover.Visible = isMain
        settingsCover.Visible = not isMain
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
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
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
        MainTab = mainTab,
        SettingsTab = settingsTab,
        Separator = separator,
        UIScale = uiScale,
        Colors = COLORS
    }
end

return UI
