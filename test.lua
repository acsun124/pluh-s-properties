getgenv().Prediction = 0.1248710929171	
getgenv().AimPart = "HumanoidRootPart"	
getgenv().Key = "Q"	
getgenv().DisableKey = "P"	
	
getgenv().FOV = false
getgenv().ShowFOV = false	
getgenv().FOVSize = 55	
	
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
	
local AimlockState = true	
local Locked	
local Victim	
	
local SelectedKey = getgenv().Key	
local SelectedDisableKey = getgenv().DisableKey	
	
--// Notification function	
	
function Notify(tx)	
    SG:SetCore("SendNotification", {	
        Title = "Pluh Camlock,	
        Text = tx,	
Duration = 5	
    })	
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
	
--// Checks if key is down	
	
Mouse.KeyDown:Connect(function(k)	
    SelectedKey = SelectedKey:lower()	
    SelectedDisableKey = SelectedDisableKey:lower()	
    if k == SelectedKey then	
        if AimlockState == true then	
            Locked = not Locked	
            if Locked then	
                Victim = getClosest()	
	
                Notify("!Abusing: "..tostring(Victim.Character.Humanoid.DisplayName))	
            else	
                if Victim ~= nil then	
                    Victim = nil	
	
                    Notify("!Spared")	
                end	
            end	
        else	
            Notify("Aimlock is not enabled!")	
        end	
    end	
    if k == SelectedDisableKey then	
        AimlockState = not AimlockState	
    end	
end)	
	
--// Loop update FOV and loop camera lock onto target	
	
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

local Hellbound = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Logo = Instance.new("ImageLabel")
local TextButton = Instance.new("TextButton")
local UICorner_2 = Instance.new("UICorner")

-- Properties
Hellbound.Name = "Hellbound"
Hellbound.Parent = game.CoreGui
Hellbound.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = Hellbound
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
Logo.BackgroundTransparency = 3.000
Logo.BorderColor3 = Color3.fromRGB(0, 0, 0)
Logo.BorderSizePixel = 0
Logo.Position = UDim2.new(0.326732665, 0, 0, 0)
Logo.Size = UDim2.new(0, 70, 0, 70)
Logo.Image = "rbxassetid://830610397"
Logo.ImageTransparency = 0.300

TextButton.Parent = Frame
TextButton.BackgroundColor3 = Color3.fromRGB(75, 80, 255)
TextButton.BackgroundTransparency = 5.000
TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton.BorderSizePixel = 0
TextButton.Position = UDim2.new(0.0792079195, 0, 0.18571429, 0)
TextButton.Size = UDim2.new(0, 170, 0, 44)
TextButton.Font = Enum.Font.SourceSansSemibold
TextButton.Text = "Toggle Hellbound"
TextButton.TextColor3 = Color3.fromRGB(180, 180, 255)
TextButton.TextScaled = true
TextButton.TextSize = 18.000
TextButton.TextWrapped = true

local state = true
TextButton.MouseButton1Click:Connect(function()
    state = not state
    if state then
        TextButton.Text = "Pluh ON"
        AimlockState = true
        Victim = getClosest()
        
        if Victim then
            Notify("!Abusing: " .. tostring(Victim.Humanoid.DisplayName))
        else
            Notify("who you aiming at cunt")
        end
    else
        TextButton.Text = "Pluh OFF"
        AimlockState = false
        if Victim then
            Victim = nil
            Notify("!Spared his life")
        end
    end
end)

	-- New GUI for Prediction Display
local PredictionDisplay = Instance.new("Frame")
local PredictionText = Instance.new("TextLabel")
local UICorner_3 = Instance.new("UICorner")

-- Properties for the new GUI
PredictionDisplay.Parent = Hellbound
PredictionDisplay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
PredictionDisplay.BorderColor3 = Color3.fromRGB(0, 0, 0)
PredictionDisplay.BorderSizePixel = 0
PredictionDisplay.Position = UDim2.new(0.133798108, 0, 0.37267238, 0) -- Positioned below the existing GUI
PredictionDisplay.Size = UDim2.new(0, 202, 0, 50)
PredictionDisplay.Active = true
PredictionDisplay.Draggable = true

UICorner_3.Parent = PredictionDisplay

PredictionText.Parent = PredictionDisplay
PredictionText.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
PredictionText.BackgroundTransparency = 1
PredictionText.Size = UDim2.new(1, 0, 1, 0)
PredictionText.Font = Enum.Font.SourceSansSemibold
PredictionText.Text = "Current Prediction: N/A"
PredictionText.TextColor3 = Color3.fromRGB(180, 180, 255)
PredictionText.TextScaled = true
PredictionText.TextSize = 18.000
PredictionText.TextWrapped = true

-- Function to update the prediction display
local function updatePredictionDisplay(prediction)
    PredictionText.Text = "Current Prediction: " .. tostring(prediction)
end

-- Function to animate the RGB colors
local function animateRGB()
    while true do
        for hue = 0, 1, 0.01 do
            local color = Color3.fromHSV(hue, 1, 1)
            PredictionText.TextColor3 = color
            wait(0.05)
        end
    end
end

-- Start the RGB animation
spawn(animateRGB)

-- Example of updating the prediction display (replace this with your actual logic)
-- Example: updatePredictionDisplay(getgenv().Prediction)
	while wait() do
        if getgenv().AutoPrediction == true then	
        local pingvalue = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()	
        local split = string.split(pingvalue,'(')	
local ping = tonumber(split[1])	
        if ping > 285 then
            getgenv().Prediction = 0.0500
        elseif ping > 280 then
            getgenv().Prediction = 0.0517
        elseif ping > 275 then
            getgenv().Prediction = 0.0534
        elseif ping > 270 then
            getgenv().Prediction = 0.0551
        elseif ping > 265 then
            getgenv().Prediction = 0.0568
        elseif ping > 260 then
            getgenv().Prediction = 0.0585
        elseif ping > 255 then
            getgenv().Prediction = 0.0603
        elseif ping > 250 then
            getgenv().Prediction = 0.0620
        elseif ping > 245 then
            getgenv().Prediction = 0.0638
        elseif ping > 240 then
            getgenv().Prediction = 0.0656
        elseif ping > 235 then
            getgenv().Prediction = 0.0674
        elseif ping > 230 then
            getgenv().Prediction = 0.0692
        elseif ping > 225 then
            getgenv().Prediction = 0.0710
        elseif ping > 220 then
            getgenv().Prediction = 0.0728
        elseif ping > 215 then
            getgenv().Prediction = 0.0746
        elseif ping > 210 then
            getgenv().Prediction = 0.0765
        elseif ping > 205 then
            getgenv().Prediction = 0.0783
        elseif ping > 200 then
            getgenv().Prediction = 0.0802
        elseif ping > 195 then
            getgenv().Prediction = 0.0821
        elseif ping > 190 then
            getgenv().Prediction = 0.0840
        elseif ping > 185 then
            getgenv().Prediction = 0.0859
        elseif ping > 180 then
            getgenv().Prediction = 0.0878
        elseif ping > 175 then
            getgenv().Prediction = 0.0897
        elseif ping > 170 then
            getgenv().Prediction = 0.0917
        elseif ping > 165 then
            getgenv().Prediction = 0.0936
        elseif ping > 160 then
            getgenv().Prediction = 0.0956
        elseif ping > 155 then
            getgenv().Prediction = 0.0975
        elseif ping > 150 then
            getgenv().Prediction = 0.0995
        elseif ping > 145 then
            getgenv().Prediction = 0.1015
        elseif ping > 140 then
            getgenv().Prediction = 0.1035
        elseif ping > 135 then
            getgenv().Prediction = 0.1055
        elseif ping > 130 then
            getgenv().Prediction = 0.1075
        elseif ping > 125 then
            getgenv().Prediction = 0.1095
        elseif ping > 120 then
            getgenv().Prediction = 0.1116
        elseif ping > 115 then
            getgenv().Prediction = 0.1136
        elseif ping > 110 then
            getgenv().Prediction = 0.1157
        elseif ping > 105 then
            getgenv().Prediction = 0.1177
        elseif ping > 100 then
            getgenv().Prediction = 0.1198
        elseif ping > 95 then
            getgenv().Prediction = 0.1219
        elseif ping > 90 then
            getgenv().Prediction = 0.1240
        elseif ping > 85 then
            getgenv().Prediction = 0.1261
        elseif ping > 80 then
            getgenv().Prediction = 0.1282
        elseif ping > 75 then
            getgenv().Prediction = 0.1303
        elseif ping > 70 then
            getgenv().Prediction = 0.1324
        elseif ping > 65 then
            getgenv().Prediction = 0.1346
        elseif ping > 60 then
            getgenv().Prediction = 0.1367
        elseif ping > 55 then
            getgenv().Prediction = 0.1389
        elseif ping > 50 then
            getgenv().Prediction = 0.1412
        else
            getgenv().Prediction = 0.1433    

        updatePredictionDisplay(getgenv().Prediction)
    end
end
end
