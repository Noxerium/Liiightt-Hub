local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Movement = {}

function Movement.Init(section, Elements)
    local player = Players.LocalPlayer

    local flyEnabled = false
    local flySpeed = 35
    local flyKey = Enum.KeyCode.F
    local flyUpKey = Enum.KeyCode.Space
    local flyDownKey = Enum.KeyCode.LeftControl

    local jumpHeightValue = 50
    local infJumpEnabled = false
    local infJumpKey = Enum.KeyCode.I

    local noclipEnabled = false
    local noclipKey = Enum.KeyCode.N

    local bodyGyro
    local bodyVelocity
    local flyConn
    local noclipConn
    local jumpConn
    local charConn
    local currentTilt = CFrame.new()

    local function getCharacter()
        return player.Character
    end

    local function getRoot(char)
        return char and char:FindFirstChild("HumanoidRootPart")
    end

    local function getHumanoid(char)
        return char and char:FindFirstChildOfClass("Humanoid")
    end

    local function stopFly()
        if flyConn then
            flyConn:Disconnect()
            flyConn = nil
        end
        if bodyGyro then
            bodyGyro:Destroy()
            bodyGyro = nil
        end
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        local hum = getHumanoid(getCharacter())
        if hum then
            hum.PlatformStand = false
        end
        currentTilt = CFrame.new()
    end

    local function startFly()
        stopFly()
        local char = getCharacter()
        local root = getRoot(char)
        local hum = getHumanoid(char)
        if not root or not hum then
            return
        end

        hum.PlatformStand = true

        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.P = 90000
        bodyGyro.MaxTorque = Vector3.new(900000, 900000, 900000)
        bodyGyro.CFrame = root.CFrame
        bodyGyro.Parent = root

        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(900000, 900000, 900000)
        bodyVelocity.Velocity = Vector3.zero
        bodyVelocity.Parent = root

        flyConn = RunService.RenderStepped:Connect(function(dt)
            local c = getCharacter()
            local r = getRoot(c)
            local h = getHumanoid(c)
            if not flyEnabled or not r or not h or not bodyGyro or not bodyVelocity then
                stopFly()
                return
            end

            h.PlatformStand = true
            local camera = Workspace.CurrentCamera
            if not camera then
                return
            end

            local moveDir = Vector3.zero
            local forward = Vector3.new(camera.CFrame.LookVector.X, 0, camera.CFrame.LookVector.Z)
            if forward.Magnitude > 0.001 then
                forward = forward.Unit
            end
            local right = Vector3.new(camera.CFrame.RightVector.X, 0, camera.CFrame.RightVector.Z)
            if right.Magnitude > 0.001 then
                right = right.Unit
            end

            if UserInputService.TouchEnabled then
                if h.MoveDirection.Magnitude > 0 then
                    moveDir = moveDir + h.MoveDirection.Unit
                end
            else
                if not UserInputService:GetFocusedTextBox() then
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDir = moveDir + forward
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDir = moveDir - forward
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDir = moveDir + right
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDir = moveDir - right
                    end
                    if flyUpKey and UserInputService:IsKeyDown(flyUpKey) then
                        moveDir = moveDir + Vector3.new(0, 1, 0)
                    end
                    if flyDownKey and UserInputService:IsKeyDown(flyDownKey) then
                        moveDir = moveDir - Vector3.new(0, 1, 0)
                    end
                end
            end

            if moveDir.Magnitude > 0 then
                moveDir = moveDir.Unit
            end

            bodyVelocity.Velocity = moveDir * flySpeed

            local localMove = camera.CFrame:VectorToObjectSpace(moveDir)
            local pitch = math.clamp(localMove.Z * 0.35, -0.35, 0.35)
            local roll = math.clamp(-localMove.X * 0.35, -0.35, 0.35)
            local targetTilt = CFrame.Angles(pitch, 0, roll)
            currentTilt = currentTilt:Lerp(targetTilt, math.clamp(dt * 10, 0, 1))

            local lookFlat = Vector3.new(camera.CFrame.LookVector.X, 0, camera.CFrame.LookVector.Z)
            if lookFlat.Magnitude < 0.001 then
                lookFlat = r.CFrame.LookVector
            end
            local baseCFrame = CFrame.lookAt(r.Position, r.Position + lookFlat.Unit)
            bodyGyro.CFrame = baseCFrame * currentTilt
        end)
    end

    local function applyJumpHeight(val)
        jumpHeightValue = val
        local hum = getHumanoid(getCharacter())
        if hum then
            if hum.UseJumpPower then
                hum.JumpPower = val
            else
                hum.JumpHeight = val * 0.144
            end
        end
    end

    local function updateNoclip()
        if noclipConn then
            noclipConn:Disconnect()
            noclipConn = nil
        end

        if noclipEnabled then
            noclipConn = RunService.Stepped:Connect(function()
                local char = getCharacter()
                if not char then
                    return
                end
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end)
        else
            local char = getCharacter()
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end
        end
    end

    jumpConn = UserInputService.JumpRequest:Connect(function()
        if not infJumpEnabled then
            return
        end
        local hum = getHumanoid(getCharacter())
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)

    charConn = player.CharacterAdded:Connect(function()
        task.wait(0.2)
        applyJumpHeight(jumpHeightValue)
        if flyEnabled then
            startFly()
        end
    end)

    local flyToggle = Elements.CreateToggle(section, "Полёт", false, function(state)
        flyEnabled = state
        if flyEnabled then
            startFly()
        else
            stopFly()
        end
    end)

    local flyBind = Elements.CreateKeybind(section, "Клавиша полёта", flyKey, function()
        flyToggle.Set(not flyToggle.Get())
    end)

    local flyUpBind = Elements.CreateKeybind(section, "Полёт вверх", flyUpKey, nil)
    local flyDownBind = Elements.CreateKeybind(section, "Полёт вниз", flyDownKey, nil)

    if flyUpBind then
        task.spawn(function()
            while flyUpBind do
                flyUpKey = flyUpBind.Get()
                task.wait(0.25)
            end
        end)
    end

    if flyDownBind then
        task.spawn(function()
            while flyDownBind do
                flyDownKey = flyDownBind.Get()
                task.wait(0.25)
            end
        end)
    end

    local speedSlider = Elements.CreateSlider(section, "Скорость полёта", 1, 75, 35, function(val)
        flySpeed = val
    end)

    local jumpSlider = Elements.CreateSlider(section, "Высота прыжка", 1, 120, 50, function(val)
        applyJumpHeight(val)
    end)

    local infJumpToggle = Elements.CreateToggle(section, "Беск. прыжок", false, function(state)
        infJumpEnabled = state
    end)

    local infJumpBind = Elements.CreateKeybind(section, "Клавиша прыжка", infJumpKey, function()
        infJumpToggle.Set(not infJumpToggle.Get())
    end)

    local noclipToggle = Elements.CreateToggle(section, "Ноуклип", false, function(state)
        noclipEnabled = state
        updateNoclip()
    end)

    local noclipBind = Elements.CreateKeybind(section, "Клавиша ноуклипа", noclipKey, function()
        noclipToggle.Set(not noclipToggle.Get())
    end)

    applyJumpHeight(jumpHeightValue)

    local function destroy()
        flyEnabled = false
        infJumpEnabled = false
        noclipEnabled = false
        stopFly()
        updateNoclip()
        if jumpConn then
            jumpConn:Disconnect()
        end
        if charConn then
            charConn:Disconnect()
        end
    end

    return {
        Toggles = {
            Fly = flyToggle,
            InfiniteJump = infJumpToggle,
            Noclip = noclipToggle
        },
        Sliders = {
            FlySpeed = speedSlider,
            JumpHeight = jumpSlider
        },
        Keybinds = {
            Fly = flyBind,
            FlyUp = flyUpBind,
            FlyDown = flyDownBind,
            InfiniteJump = infJumpBind,
            Noclip = noclipBind
        },
        Destroy = destroy
    }
end

return Movement
