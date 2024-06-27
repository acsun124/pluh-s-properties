-- Example content of "Protected_2873413326373898.txt"

--// Variables (Service)
local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local WS = game:GetService("Workspace")
local GS = game:GetService("GuiService")
local SG = game:GetService("StarterGui")

--// Variables (regular)
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()
local Camera = WS.CurrentCamera
local GetGuiInset = GS.GetGuiInset

local AimlockState = false
local Locked
local Victim

local SelectedKey = getgenv().Key
local SelectedDisableKey = getgenv().DisableKey

--// Notification function
function Notify(tx)
    SG:SetCore("SendNotification", {
        Title = "Aimlock Status",
        Text = tx,
        Duration = 5
    })
end

--// Game detection notification
if game.PlaceId == 2788229376 then
    Notify("Player detected playing Da Hood, using Da Hood aiming system for lock")
else
    Notify("You're not playing Da Hood, using aim lock logic for other games")
end

--// Check if aimlock is loaded
if getgenv().Loaded == true then
    Notify("Aimlock is already loaded!")
    return
end

getgenv().Loaded = true

--// FOV Circle
local fov = Drawing.new("Circle")
fov.Filled = false
fov.Transparency = 1
fov.Thickness = 1
fov.Color = Color3.fromRGB(255, 255, 0)
fov.NumSides = 1000

--// Functions
function update()
    if getgenv().FOV == true then
        if fov then
            fov.Radius = getgenv().FOVSize * 2
            fov.Visible = getgenv().ShowFOV
            fov.Position = Vector2.new(Mouse.X, Mouse.Y + GetGuiInset(GS).Y)

            return fov
        end
    end
end

function WTVP(arg)
    return Camera:WorldToViewportPoint(arg)
end

function WTSP(arg)
    return Camera.WorldToScreenPoint(Camera, arg)
end

function getClosest()
    local ClosestDistance = math.huge
    local ClosestPlayer = nil
    local LocalPlayer = game.Players.LocalPlayer
    local CenterPosition = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, Player in ipairs(game.Players:GetPlayers()) do
        if Player ~= LocalPlayer then
            local Character = Player.Character
            if Character and Character:FindFirstChild("HumanoidRootPart") and Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                local Position, IsVisibleOnViewport = Camera:WorldToViewportPoint(Character.HumanoidRootPart.Position)

                if IsVisibleOnViewport then
                    local Distance = (CenterPosition - Vector2.new(Position.X, Position.Y)).Magnitude
                    if Distance < ClosestDistance then
                        ClosestPlayer = Character
                        ClosestDistance = Distance
                    end
                end
            end
        end
    end

    return ClosestPlayer
end

--// Loop update FOV and loop camera lock onto target
if game.PlaceId == 2788229376 then
    RS.RenderStepped:Connect(function()
        update()
        if AimlockState and Victim then
            local aimPart = Victim:FindFirstChild(getgenv().AimPart)
            if aimPart then
                Camera.CFrame = CFrame.new(Camera.CFrame.p, aimPart.Position + aimPart.Velocity * getgenv().Prediction)
            else
                Victim = nil
                Notify("Lost target!")
            end
        end
    end)
else
    RS.Heartbeat:Connect(function()
        if AimlockState and Victim then
            local aimPart = Victim:FindFirstChild(getgenv().AimPart)
            if aimPart then
                Camera.CFrame = CFrame.new(Camera.CFrame.p, aimPart.Position + aimPart.Velocity * pridiction)
            else
                Victim = nil
                Notify("Lost target!")
            end
        end
    end)
end

-- GUI Setup
local Pluh = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Logo = Instance.new("ImageLabel")
local TextButton = Instance.new("TextButton")
local UICorner_2 = Instance.new("UICorner")
local PingDisplay = Instance.new("TextLabel")

-- Properties
Pluh.Name = "Pluh"
Pluh.Parent = game.CoreGui
Pluh.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = Pluh
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.133798108, 0, 0.20107238, 0)
Frame.Size = UDim2.new(0, 202, 0, 70)
Frame.Active = true
Frame.Draggable = true

local function TopContainer()
    Frame.Position = UDim2.new(0.5, -Frame.AbsoluteSize.X / 2, 0, -Frame.AbsoluteSize.Y / 2)
end

TopContainer()
Frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(TopContainer)

UICorner.Parent = Frame

Logo.Name = "Logo"
Logo.Parent = Frame
Logo.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
Logo.BackgroundTransparency = 1.000
Logo.BorderColor3 = Color3.fromRGB(0, 0, 0)
Logo.BorderSizePixel = 0
Logo.Position = UDim2.new(0.326732665, 0, 0, 0)
Logo.Size = UDim2.new(0, 70, 0, 70)
Logo.Image = "rbxassetid://830610397"
Logo.ImageTransparency = 0.300

TextButton.Parent = Frame
TextButton.BackgroundColor3 = Color3.fromRGB(75, 80, 255)
TextButton.BackgroundTransparency = 1.000
TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton.BorderSizePixel = 0
TextButton.Position = UDim2.new(0.0792079195, 0, 0.18571429, 0)
TextButton.Size = UDim2.new(0, 170, 0, 44)
TextButton.Font = Enum.Font.SourceSansSemibold
TextButton.Text = "Pluh Lock"
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.TextScaled = true
TextButton.TextSize = 18.000
TextButton.TextWrapped = true

local state = false
TextButton.MouseButton1Click:Connect(function()
    state = not state
    if state then
        TextButton.Text = "Lock • On"
        AimlockState = true
        Victim = getClosest()
        
        if Victim then
            Notify("Locked onto: " .. tostring(Victim.Humanoid.DisplayName))
        else
            Notify("No target found")
        end
    else
        TextButton.Text = "Lock • Off"
        AimlockState = false
        Victim = nil
        Notify("Unlocked!")
    end
end)

-- Adding Ping Display
PingDisplay.Parent = Frame
PingDisplay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PingDisplay.BackgroundTransparency = 1.000
PingDisplay.BorderColor3 = Color3.fromRGB(0, 0, 0)
PingDisplay.BorderSizePixel = 0
PingDisplay.Position = UDim2.new(0.0792079195, 0, -0.3, 0)
PingDisplay.Size = UDim2.new(0, 170, 0, 20)
PingDisplay.Font = Enum.Font.GothamBold
PingDisplay.Text = "Ping: 0 | ms"
PingDisplay.TextScaled = true
PingDisplay.TextColor3 = Color3.fromRGB(255, 255, 255)
PingDisplay.TextSize = 14.000
PingDisplay.TextWrapped = true

-- Function to update the Ping Display
local function updatePing()
    while true do
        local ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
        PingDisplay.Text = "Ping: " .. tostring(ping) .. " | ms"
        wait(1) -- Update every second
    end
end

-- Start updating the Ping Display in a separate thread
coroutine.wrap(updatePing)()

-- Update AutoPrediction based on ping
coroutine.wrap(function()
    while wait() do
        if getgenv().AutoPrediction == true then
            local pingValue = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
            if pingValue > 280 then
                getgenv().Prediction = 0.0500
            elseif pingValue > 270 then
                getgenv().Prediction = 0.0517
            elseif pingValue > 260 then
                getgenv().Prediction = 0.0534
            elseif pingValue > 250 then
                getgenv().Prediction = 0.0551
            elseif pingValue > 240 then
                getgenv().Prediction = 0.0568
            elseif pingValue > 230 then
                getgenv().Prediction = 0.0585
            elseif pingValue > 220 then
                getgenv().Prediction = 0.0603
            elseif pingValue > 210 then
                getgenv().Prediction = 0.0620
            elseif pingValue > 200 then
                getgenv().Prediction = 0.0638
            elseif pingValue > 190 then
                getgenv().Prediction = 0.0656
            elseif pingValue > 180 then
                getgenv().Prediction = 0.0674
            elseif pingValue > 170 then
                getgenv().Prediction = 0.163
            elseif pingValue > 160 then
                getgenv().Prediction = 0.1628
            elseif pingValue > 150 then
                getgenv().Prediction = 0.1625
            elseif pingValue > 140 then
                getgenv().Prediction = 0.16183
            elseif pingValue > 130 then
                getgenv().Prediction = 0.161
            elseif pingValue > 120 then
                getgenv().Prediction = 0.1609
            elseif pingValue > 110 then
                getgenv().Prediction = 0.1637
            elseif pingValue > 100 then
                getgenv().Prediction = 0.137
            elseif pingValue > 90 then
                getgenv().Prediction = 0.1611
            elseif pingValue > 80 then
                getgenv().Prediction = 0.15
            elseif pingValue > 70 then
                getgenv().Prediction = 0.144433333333392
            elseif pingValue > 60 then
                getgenv().Prediction = 0.1443
            elseif pingValue > 50 then
                getgenv().Prediction = 0.143321
            elseif pingValue > 40 then
                getgenv().Prediction = 0.13
            elseif pingValue > 30 then
                getgenv().Prediction = 0.11
            elseif pingValue > 20 then
                getgenv().Prediction = 0.10
            elseif pingValue > 10 then
                getgenv().Prediction = 0.0922
            else
                getgenv().Prediction = 0.1015
            end
        end
    end
end)()
