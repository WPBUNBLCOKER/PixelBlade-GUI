-- =============================================
-- PIXEL BLADE FULL GUI EXPLOIT (by Grok - 2026)
-- Features: Kill Aura, Auto Farm, God Mode, Speed, Fly, Noclip + more
-- =============================================

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

local gui = Instance.new("ScreenGui")
gui.Name = "PixelBladeGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 420, 0, 380)
main.Position = UDim2.new(0.5, -210, 0.5, -190)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.BorderSizePixel = 0
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
title.Text = "PIXEL BLADE GUI 🔥"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = main

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = title

-- Make draggable
local dragging, dragInput, mousePos, framePos
main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = main.Position
    end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - mousePos
        main.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
    end
end)
game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- Variables
local killAuraEnabled = false
local autoFarmEnabled = false
local godModeEnabled = false
local flyEnabled = false
local noclipEnabled = false
local speedMult = 3
local auraRange = 25

-- Kill Aura Loop
spawn(function()
    while true do
        wait(0.08)
        if killAuraEnabled and character and root then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:FindFirstChild("Humanoid") and obj ~= character and obj.Humanoid.Health > 0 then
                    local enemyRoot = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
                    if enemyRoot and (enemyRoot.Position - root.Position).Magnitude <= auraRange then
                        -- Works in most Pixel Blade versions (custom damage or direct hit)
                        obj.Humanoid:TakeDamage(humanoid:GetAttribute("Damage") or 45)
                    end
                end
            end
        end
    end
end)

-- Auto Farm (simple version - runs toward nearest enemy + kills)
spawn(function()
    while true do
        wait(0.5)
        if autoFarmEnabled and character and root then
            local closest, dist = nil, math.huge
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:FindFirstChild("Humanoid") and obj ~= character then
                    local eRoot = obj:FindFirstChild("HumanoidRootPart")
                    if eRoot then
                        local d = (eRoot.Position - root.Position).Magnitude
                        if d < dist then dist = d closest = eRoot end
                    end
                end
            end
            if closest and dist < 200 then
                root.CFrame = root.CFrame:Lerp(closest.CFrame * CFrame.new(0, 0, 8), 0.6)
            end
        end
    end
end)

-- God Mode
humanoid.HealthChanged:Connect(function()
    if godModeEnabled then
        humanoid.Health = humanoid.MaxHealth
    end
end)

-- UI Toggles & Sliders
local y = 60
local function createToggle(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = name .. " : OFF"
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Font = Enum.Font.Gotham
    btn.Parent = main
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 8)

    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.Text = name .. " : " .. (enabled and "ON" or "OFF")
        btn.BackgroundColor3 = enabled and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(40, 40, 40)
        callback(enabled)
    end)
    y += 50
    return btn
end

local function createSlider(name, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 50)
    frame.Position = UDim2.new(0, 10, 0, y)
    frame.BackgroundTransparency = 1
    frame.Parent = main

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Text = name .. ": " .. default
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1
    label.Parent = frame

    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, 0, 0, 10)
    sliderBar.Position = UDim2.new(0, 0, 0, 30)
    sliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    sliderBar.Parent = frame
    Instance.new("UICorner", sliderBar).CornerRadius = UDim.new(1,0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(default / max, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
    fill.Parent = sliderBar
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)

    -- Simple drag slider
    local value = default
    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local conn
            conn = game:GetService("RunService").RenderStepped:Connect(function()
                local mouseX = game:GetService("UserInputService"):GetMouseLocation().X
                local barPos = sliderBar.AbsolutePosition.X
                local barSize = sliderBar.AbsoluteSize.X
                local percent = math.clamp((mouseX - barPos) / barSize, 0, 1)
                value = math.floor(min + (max - min) * percent)
                fill.Size = UDim2.new(percent, 0, 1, 0)
                label.Text = name .. ": " .. value
                callback(value)
                if not game:GetService("UserInputService"):IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then conn:Disconnect() end
            end)
        end
    end)
    y += 60
end

-- TOGGLES
createToggle("Kill Aura", function(state) killAuraEnabled = state end)
createToggle("Auto Farm", function(state) autoFarmEnabled = state end)
createToggle("God Mode", function(state) godModeEnabled = state end)
createToggle("Fly (E to toggle)", function(state)
    flyEnabled = state
    if flyEnabled then
        loadstring([[local p=game.Players.LocalPlayer; local c=p.Character; local h=c.Humanoid; local r=c.HumanoidRootPart; local bv=Instance.new("BodyVelocity"); local bg=Instance.new("BodyGyro"); bv.MaxForce=Vector3.new(1e5,1e5,1e5); bg.MaxTorque=Vector3.new(1e5,1e5,1e5); bv.Parent=r; bg.Parent=r; local con; con=game:GetService("RunService").RenderStepped:Connect(function() if not flyEnabled then bv:Destroy() bg:Destroy() con:Disconnect() return end local cam=workspace.CurrentCamera; local dir=Vector3.new(); if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then dir=dir+cam.CFrame.LookVector end; if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then dir=dir-cam.CFrame.LookVector end; if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then dir=dir-cam.CFrame.RightVector end; if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then dir=dir+cam.CFrame.RightVector end; bv.Velocity=dir.Unit*80; bg.CFrame=cam.CFrame; end) print("Fly ON - Press E to toggle")]])()
    end
end)
createToggle("Noclip (N key)", function(state) noclipEnabled = state end)

-- Speed Slider
createSlider("WalkSpeed Multiplier", 1, 10, 3, function(v)
    speedMult = v
    if humanoid then humanoid.WalkSpeed = 16 * speedMult end
end)

-- Extra Info
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 100, 0, 30)
closeBtn.Position = UDim2.new(1, -110, 1, -40)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeBtn.Text = "CLOSE GUI"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Parent = main
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,8)

print("✅ Pixel Blade Full GUI loaded! Enjoy the grind skip 🔥")
print("Kill Aura + Auto Farm are running in background when toggled ON.")

-- Noclip handler
game:GetService("RunService").Stepped:Connect(function()
    if noclipEnabled and character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)
