local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Elements = {}

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

function Elements.CreateToggle(parent, text, default, callback)
    local state = default or false

    local holder = create("Frame", {
        Name = text .. "Toggle",
        Size = UDim2.new(1, 0, 0, 26),
        BackgroundTransparency = 1
    }, parent)

    local label = create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, -46, 1, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = COLORS.White,
        Font = Enum.Font.SourceSans,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd
    }, holder)

    local switch = create("TextButton", {
        Name = "Switch",
        Size = UDim2.fromOffset(38, 20),
        Position = UDim2.new(1, -40, 0.5, -10),
        BackgroundColor3 = state and COLORS.Lime or COLORS.Gray,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false
    }, holder)
    round(switch, 10)
    stroke(switch, COLORS.Black, 2)

    local knob = create("Frame", {
        Name = "Knob",
        Size = UDim2.fromOffset(14, 14),
        Position = state and UDim2.fromOffset(21, 3) or UDim2.fromOffset(3, 3),
        BackgroundColor3 = COLORS.White,
        BorderSizePixel = 0
    }, switch)
    round(knob, 7)
    stroke(knob, COLORS.Black, 1.5)

    local function update(instant)
        local targetColor = state and COLORS.Lime or COLORS.Gray
        local targetPos = state and UDim2.fromOffset(21, 3) or UDim2.fromOffset(3, 3)

        if instant then
            switch.BackgroundColor3 = targetColor
            knob.Position = targetPos
        else
            local info = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            TweenService:Create(switch, info, {BackgroundColor3 = targetColor}):Play()
            TweenService:Create(knob, info, {Position = targetPos}):Play()
        end
    end

    switch.MouseButton1Click:Connect(function()
        state = not state
        update(false)
        if callback then
            callback(state)
        end
    end)

    return {
        Set = function(value)
            state = value
            update(false)
            if callback then
                callback(state)
            end
        end,
        Get = function()
            return state
        end
    }
end

function Elements.CreateSlider(parent, text, min, max, default, callback)
    local current = math.clamp(default or min, min, max)
    local dragging = false

    local holder = create("Frame", {
        Name = text .. "Slider",
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundTransparency = 1
    }, parent)

    local label = create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, -46, 0, 20),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = COLORS.White,
        Font = Enum.Font.SourceSans,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd
    }, holder)

    local box = create("TextBox", {
        Name = "ValueBox",
        Size = UDim2.fromOffset(38, 18),
        Position = UDim2.new(1, -40, 0, 1),
        BackgroundColor3 = COLORS.Background,
        BorderSizePixel = 0,
        Text = tostring(current),
        TextColor3 = COLORS.White,
        Font = Enum.Font.SourceSans,
        TextSize = 14,
        ClearTextOnFocus = false
    }, holder)
    round(box, 4)
    stroke(box, COLORS.Black, 1.5)

    local track = create("Frame", {
        Name = "Track",
        Size = UDim2.new(1, -4, 0, 6),
        Position = UDim2.new(0, 2, 0, 26),
        BackgroundColor3 = COLORS.Background,
        BorderSizePixel = 0
    }, holder)
    round(track, 3)
    stroke(track, COLORS.Black, 1.5)

    local fill = create("Frame", {
        Name = "Fill",
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = COLORS.Lime,
        BorderSizePixel = 0
    }, track)
    round(fill, 3)

    local knob = create("Frame", {
        Name = "Knob",
        Size = UDim2.fromOffset(12, 12),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0),
        BackgroundColor3 = COLORS.White,
        BorderSizePixel = 0,
        ZIndex = 2
    }, track)
    round(knob, 6)
    stroke(knob, COLORS.Black, 1.5)

    local hitArea = create("TextButton", {
        Name = "HitArea",
        Size = UDim2.new(1, 0, 0, 18),
        Position = UDim2.new(0, 0, 0.5, -9),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 3
    }, track)

    local function setValue(val, trigger)
        current = math.clamp(math.floor(val + 0.5), min, max)
        local alpha = (max > min) and ((current - min) / (max - min)) or 0
        fill.Size = UDim2.new(alpha, 0, 1, 0)
        knob.Position = UDim2.new(alpha, 0, 0.5, 0)
        box.Text = tostring(current)
        if trigger and callback then
            callback(current)
        end
    end

    local function updateFromInput(input)
        local pos = input.Position.X - track.AbsolutePosition.X
        local alpha = math.clamp(pos / track.AbsoluteSize.X, 0, 1)
        setValue(min + (max - min) * alpha, true)
    end

    hitArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateFromInput(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateFromInput(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    box.FocusLost:Connect(function()
        local num = tonumber(box.Text)
        if num then
            setValue(num, true)
        else
            box.Text = tostring(current)
        end
    end)

    setValue(current, false)

    return {
        Set = function(val)
            setValue(val, true)
        end,
        Get = function()
            return current
        end
    }
end

function Elements.CreateKeybind(parent, text, defaultKey, callback)
    if UserInputService.TouchEnabled then
        return nil
    end

    local currentKey = defaultKey
    local listening = false

    local holder = create("Frame", {
        Name = text .. "Keybind",
        Size = UDim2.new(1, 0, 0, 26),
        BackgroundTransparency = 1
    }, parent)

    local label = create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, -56, 1, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = COLORS.White,
        Font = Enum.Font.SourceSans,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd
    }, holder)

    local bindBtn = create("TextButton", {
        Name = "BindButton",
        Size = UDim2.fromOffset(50, 20),
        Position = UDim2.new(1, -52, 0.5, -10),
        BackgroundColor3 = COLORS.Background,
        BorderSizePixel = 0,
        Text = currentKey and currentKey.Name or "None",
        TextColor3 = COLORS.Lime,
        Font = Enum.Font.SourceSans,
        TextSize = 13,
        AutoButtonColor = false
    }, holder)
    round(bindBtn, 5)
    stroke(bindBtn, COLORS.Black, 1.5)

    bindBtn.MouseButton1Click:Connect(function()
        listening = true
        bindBtn.Text = "..."
        bindBtn.TextColor3 = COLORS.White
    end)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then
            return
        end
        if UserInputService:GetFocusedTextBox() then
            return
        end

        if listening and input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Escape then
                currentKey = nil
                bindBtn.Text = "None"
            else
                currentKey = input.KeyCode
                bindBtn.Text = currentKey.Name
            end
            bindBtn.TextColor3 = COLORS.Lime
            listening = false
        elseif not listening and currentKey and input.KeyCode == currentKey then
            if callback then
                callback(currentKey)
            end
        end
    end)

    return {
        Set = function(keyCode)
            currentKey = keyCode
            bindBtn.Text = currentKey and currentKey.Name or "None"
        end,
        Get = function()
            return currentKey
        end
    }
end

function Elements.CreateButton(parent, text, callback)
    local btn = create("TextButton", {
        Name = text .. "Button",
        Size = UDim2.new(1, 0, 0, 26),
        BackgroundColor3 = COLORS.Background,
        BorderSizePixel = 0,
        Text = text,
        TextColor3 = COLORS.White,
        Font = Enum.Font.SourceSans,
        TextSize = 15,
        AutoButtonColor = false
    }, parent)
    round(btn, 6)
    stroke(btn, COLORS.Black, 1.5)

    btn.MouseButton1Click:Connect(function()
        local info = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(btn, info, {TextColor3 = COLORS.Lime}):Play()
        task.delay(0.15, function()
            TweenService:Create(btn, info, {TextColor3 = COLORS.White}):Play()
        end)
        if callback then
            callback()
        end
    end)

    return btn
end

return Elements
