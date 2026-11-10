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
