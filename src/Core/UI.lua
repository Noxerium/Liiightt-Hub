local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

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

    local isTouch = UserInputService.TouchEnabled
    local baseScale = isTouch and 0.72 or 1

    local mainFrame = create("Frame", {
        Name = "MainFrame",
        Size = UDim2.fromOffset(360, 540),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = COLORS.Background,
        BorderSizePixel = 0,
        Active = true,
        Visible = false,
        ClipsDescendants = true
    }, screenGui)

    round(mainFrame, 12)
    local mainStroke = stroke(mainFrame, COLORS.Black, 2)

    local uiScale = create("UIScale", {
        Scale = baseScale
    }, mainFrame)

    local header = create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 45),
        Position = UDim2.fromOffset(0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 5
    }, mainFrame)

    create("TextLabel", {
        Name = "LogoLime",
        Size = UDim2.fromOffset(70, 35),
        Position = UDim2.fromOffset(15, 5),
        BackgroundTransparency = 1,
        Text = "Liiightt",
        TextColor3 = COLORS.Lime,
        Font = Enum.Font.GothamBlack,
        TextSize = 20,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 6
    }, header)

    create("TextLabel", {
        Name = "LogoHub",
        Size = UDim2.fromOffset(45, 35),
        Position = UDim2.fromOffset(88, 5),
        BackgroundTransparency = 1,
        Text = "Hub",
        TextColor3 = COLORS.White,
        Font = Enum.Font.GothamBlack,
        TextSize = 20,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 6
    }, header)

    create("TextLabel", {
        Name = "Author",
        Size = UDim2.fromOffset(100, 25),
        Position = UDim2.fromOffset(135, 8),
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
        local outline = stroke(button, COLORS.Black, 2)

        local bottomCover = create("Frame", {
            Name = "BottomCover",
            Size = UDim2.new(1, 0, 0, 12),
            Position = UDim2.new(0, 0, 1, -10),
            BackgroundColor3 = COLORS.Background,
            BorderSizePixel = 0,
            ZIndex = 2
        }, button)

        return button, bottomCover, outline
    end

    local mainTab, mainCover = createTab("Основное", UDim2.fromOffset(10, 45))
    local settingsTab, settingsCover = createTab("Настройки", UDim2.fromOffset(185, 45))

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

        mainTab.ZIndex = isMain and 3 or 2
        settingsTab.ZIndex = isMain and 2 or 3

        mainCover.ZIndex = isMain and 3 or 2
        settingsCover.ZIndex = isMain and 2 or 3

        mainTab.TextColor3 = isMain and COLORS.Lime or COLORS.Gray
        settingsTab.TextColor3 = isMain and COLORS.Gray or COLORS.Lime

        mainTab.BackgroundColor3 = isMain and COLORS.Background or COLORS.SurfaceInactive
        settingsTab.BackgroundColor3 = isMain and COLORS.SurfaceInactive or COLORS.Background

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

    local function createColumn(parent, position)
        local column = create("ScrollingFrame", {
            Name = "Column",
            Size = UDim2.new(0.5, -5, 1, 0),
            Position = position,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 0,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ClipsDescendants = false
        }, parent)

        create("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder
        }, column)

        return column
    end

    local leftColumn = createColumn(mainPage, UDim2.fromOffset(0, 0))
    local rightColumn = createColumn(mainPage, UDim2.new(0.5, 5, 0, 0))

    local function createSection(parent, title, defaultOpen)
        local isOpen = defaultOpen or false

        local section = create("Frame", {
            Name = title .. "Section",
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundColor3 = COLORS.Surface,
            BorderSizePixel = 0,
            ClipsDescendants = true
        }, parent)

        round(section, 8)
        stroke(section, COLORS.Black, 2)

        local headerBtn = create("TextButton", {
            Name = "Header",
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundTransparency = 1,
            Text = "",
            AutoButtonColor = false,
            ZIndex = 2
        }, section)

        create("TextLabel", {
            Name = "Title",
            Size = UDim2.new(1, -35, 1, 0),
            Position = UDim2.fromOffset(10, 0),
            BackgroundTransparency = 1,
            Text = title,
            TextColor3 = COLORS.White,
            Font = Enum.Font.GothamBlack,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 3
        }, headerBtn)

        local arrowHolder = create("Frame", {
            Name = "Arrow",
            Size = UDim2.fromOffset(16, 16),
            Position = UDim2.new(1, -24, 0.5, -8),
            BackgroundTransparency = 1,
            Rotation = isOpen and 180 or 0,
            ZIndex = 3
        }, headerBtn)

        local leftLine = create("Frame", {
            Name = "LeftLine",
            Size = UDim2.fromOffset(7, 2),
            Position = UDim2.fromOffset(2, 7),
            BackgroundColor3 = COLORS.Gray,
            BorderSizePixel = 0,
            Rotation = 45,
            ZIndex = 3
        }, arrowHolder)
        round(leftLine, 1)

        local rightLine = create("Frame", {
            Name = "RightLine",
            Size = UDim2.fromOffset(7, 2),
            Position = UDim2.fromOffset(6, 7),
            BackgroundColor3 = COLORS.Gray,
            BorderSizePixel = 0,
            Rotation = -45,
            ZIndex = 3
        }, arrowHolder)
        round(rightLine, 1)

        local container = create("Frame", {
            Name = "Container",
            Size = UDim2.new(1, -16, 0, 0),
            Position = UDim2.fromOffset(8, 36),
            BackgroundTransparency = 1,
            AutomaticSize = Enum.AutomaticSize.Y
        }, section)

        local layout = create("UIListLayout", {
            Padding = UDim.new(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder
        }, container)

        local function updateHeight(instant)
            local contentHeight = layout.AbsoluteContentSize.Y
            local targetHeight = isOpen and (42 + contentHeight) or 32
            local targetRotation = isOpen and 180 or 0

            if instant then
                section.Size = UDim2.new(1, 0, 0, targetHeight)
                arrowHolder.Rotation = targetRotation
            else
                local info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                TweenService:Create(section, info, {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
                TweenService:Create(arrowHolder, info, {Rotation = targetRotation}):Play()
            end
        end

        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            if isOpen then
                updateHeight(true)
            end
        end)

        headerBtn.MouseButton1Click:Connect(function()
            isOpen = not isOpen
            updateHeight(false)
        end)

        updateHeight(true)

        return container
    end

    local movementSection = createSection(leftColumn, "Движение", true)
    local visualSection = createSection(rightColumn, "Визуал", false)
    local miscSection = createSection(rightColumn, "Разное", false)

    switchTab("Основное")

    local menuOpen = false
    local animating = false

    local function toggleMenu(state)
        if animating then
            return
        end
        if state == nil then
            state = not menuOpen
        end
        if state == menuOpen then
            return
        end

        animating = true
        menuOpen = state

        if menuOpen then
            mainFrame.Size = UDim2.fromOffset(0, 4)
            mainFrame.Visible = true
            mainStroke.Thickness = 2

            local expandX = TweenService:Create(
                mainFrame,
                TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Size = UDim2.fromOffset(360, 4)}
            )
            expandX:Play()
            expandX.Completed:Wait()

            local expandY = TweenService:Create(
                mainFrame,
                TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Size = UDim2.fromOffset(360, 540)}
            )
            expandY:Play()
            expandY.Completed:Wait()
            animating = false
        else
            local collapseY = TweenService:Create(
                mainFrame,
                TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                {Size = UDim2.fromOffset(360, 4)}
            )
            collapseY:Play()
            collapseY.Completed:Wait()

            local collapseX = TweenService:Create(
                mainFrame,
                TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                {Size = UDim2.fromOffset(0, 4)}
            )
            collapseX:Play()
            collapseX.Completed:Wait()

            mainFrame.Visible = false
            animating = false
        end
    end

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then
            return
        end
        if UserInputService:GetFocusedTextBox() then
            return
        end
        if input.KeyCode == Enum.KeyCode.RightShift then
            toggleMenu()
        end
    end)

    if isTouch then
        local mobileBtn = create("TextButton", {
            Name = "MobileToggle",
            Size = UDim2.fromOffset(48, 48),
            Position = UDim2.new(0, 20, 0.5, -24),
            BackgroundColor3 = COLORS.Surface,
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
            ClipsDescendants = true,
            ZIndex = 20
        }, screenGui)
        round(mobileBtn, 24)
        stroke(mobileBtn, COLORS.Black, 2)

        create("Frame", {
            Name = "LeftHalf",
            Size = UDim2.new(0.5, 0, 1, 0),
            Position = UDim2.fromScale(0, 0),
            BackgroundColor3 = COLORS.Lime,
            BorderSizePixel = 0,
            ZIndex = 21
        }, mobileBtn)

        create("Frame", {
            Name = "RightHalf",
            Size = UDim2.new(0.5, 0, 1, 0),
            Position = UDim2.fromScale(0.5, 0),
            BackgroundColor3 = COLORS.White,
            BorderSizePixel = 0,
            ZIndex = 21
        }, mobileBtn)

        create("TextLabel", {
            Name = "Letter",
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Text = "L",
            TextColor3 = COLORS.Black,
            Font = Enum.Font.GothamBlack,
            TextSize = 22,
            ZIndex = 22
        }, mobileBtn)

        local mDragging = false
        local mMoved = false
        local mDragStart
        local mStartPos

        mobileBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                mDragging = true
                mMoved = false
                mDragStart = input.Position
                mStartPos = mobileBtn.Position
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if mDragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
                local delta = input.Position - mDragStart
                if delta.Magnitude > 6 then
                    mMoved = true
                end
                mobileBtn.Position = UDim2.new(
                    mStartPos.X.Scale,
                    mStartPos.X.Offset + delta.X,
                    mStartPos.Y.Scale,
                    mStartPos.Y.Offset + delta.Y
                )
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                if mDragging and not mMoved then
                    toggleMenu()
                end
                mDragging = false
            end
        end)
    end

    local loaderFrame = create("Frame", {
        Name = "LoaderFrame",
        Size = UDim2.fromOffset(180, 180),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = COLORS.Background,
        BorderSizePixel = 0,
        ZIndex = 50
    }, screenGui)
    round(loaderFrame, 12)
    stroke(loaderFrame, COLORS.Black, 2)

    create("UIScale", {
        Scale = baseScale
    }, loaderFrame)

    create("TextLabel", {
        Name = "TitleLime",
        Size = UDim2.fromOffset(75, 28),
        Position = UDim2.fromOffset(30, 18),
        BackgroundTransparency = 1,
        Text = "Liiightt",
        TextColor3 = COLORS.Lime,
        Font = Enum.Font.GothamBlack,
        TextSize = 20,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 51
    }, loaderFrame)

    create("TextLabel", {
        Name = "TitleHub",
        Size = UDim2.fromOffset(50, 28),
        Position = UDim2.fromOffset(105, 18),
        BackgroundTransparency = 1,
        Text = "Hub",
        TextColor3 = COLORS.White,
        Font = Enum.Font.GothamBlack,
        TextSize = 20,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 51
    }, loaderFrame)

    local spinner = create("Frame", {
        Name = "Spinner",
        Size = UDim2.fromOffset(36, 36),
        Position = UDim2.fromOffset(72, 64),
        BackgroundTransparency = 1,
        ZIndex = 51
    }, loaderFrame)

    local dotCount = 8
    local dots = {}
    for i = 1, dotCount do
        local angle = math.rad((i - 1) * (360 / dotCount))
        local radius = 13
        local dot = create("Frame", {
            Name = "Dot" .. i,
            Size = UDim2.fromOffset(5, 5),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromOffset(18 + math.cos(angle) * radius, 18 + math.sin(angle) * radius),
            BackgroundColor3 = COLORS.Lime,
            BackgroundTransparency = (i - 1) / dotCount,
            BorderSizePixel = 0,
            ZIndex = 52
        }, spinner)
        round(dot, 3)
        dots[i] = dot
    end

    local barBg = create("Frame", {
        Name = "BarBg",
        Size = UDim2.fromOffset(140, 6),
        Position = UDim2.fromOffset(20, 124),
        BackgroundColor3 = COLORS.Surface,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex = 51
    }, loaderFrame)
    round(barBg, 3)
    stroke(barBg, COLORS.Black, 1.5)

    local barFill = create("Frame", {
        Name = "BarFill",
        Size = UDim2.fromOffset(0, 6),
        BackgroundColor3 = COLORS.Lime,
        BorderSizePixel = 0,
        ZIndex = 52
    }, barBg)
    round(barFill, 3)

    create("TextLabel", {
        Name = "Status",
        Size = UDim2.fromOffset(140, 20),
        Position = UDim2.fromOffset(20, 138),
        BackgroundTransparency = 1,
        Text = "loading...",
        TextColor3 = COLORS.Gray,
        Font = Enum.Font.SourceSans,
        TextSize = 15,
        ZIndex = 51
    }, loaderFrame)

    task.spawn(function()
        local active = true
        task.spawn(function()
            local step = 0
            while active and loaderFrame.Parent do
                step = (step % dotCount) + 1
                for i = 1, dotCount do
                    local dist = (step - i) % dotCount
                    dots[i].BackgroundTransparency = dist / dotCount
                end
                task.wait(0.08)
            end
        end)

        local fillTween = TweenService:Create(
            barFill,
            TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.fromOffset(140, 6)}
        )
        fillTween:Play()
        fillTween.Completed:Wait()

        active = false
        local closeTween = TweenService:Create(
            loaderFrame,
            TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {Size = UDim2.fromOffset(180, 0)}
        )
        closeTween:Play()
        closeTween.Completed:Wait()
        loaderFrame:Destroy()

        toggleMenu(true)
    end)

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
        Colors = COLORS,
        CreateSection = createSection,
        ToggleMenu = toggleMenu,
        Sections = {
            Movement = movementSection,
            Visual = visualSection,
            Misc = miscSection
        }
    }
end

return UI
