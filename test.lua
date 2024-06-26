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

	local predictionTable = {
    {50, 0.1433}, {55, 0.1412}, {60, 0.1389}, {65, 0.1367}, {70, 0.1346},
    {75, 0.1324}, {80, 0.1303}, {85, 0.1282}, {90, 0.1261}, {95, 0.1240},
    {100, 0.1219}, {105, 0.1198}, {110, 0.1177}, {115, 0.1157}, {120, 0.1136},
    {125, 0.1116}, {130, 0.1095}, {135, 0.1075}, {140, 0.1055}, {145, 0.1035},
    {150, 0.1015}, {155, 0.0995}, {160, 0.0975}, {165, 0.0956}, {170, 0.0936},
    {175, 0.0917}, {180, 0.0897}, {185, 0.0878}, {190, 0.0859}, {195, 0.0840},
    {200, 0.0821}, {205, 0.0802}, {210, 0.0783}, {215, 0.0765}, {220, 0.0746},
    {225, 0.0728}, {230, 0.0710}, {235, 0.0692}, {240, 0.0674}, {245, 0.0656},
    {250, 0.0638}, {255, 0.0620}, {260, 0.0603}, {265, 0.0585}, {270, 0.0568},
    {275, 0.0551}, {280, 0.0534}, {285, 0.0517}, {290, 0.0500}
}

local function getPrediction(ping)
    for _, data in ipairs(predictionTable) do
        if ping <= data[1] then
            return data[2]
        end
    end
    return predictionTable[#predictionTable][2]  -- Default to the last value if ping is very high
end

while wait() do
    if getgenv().AutoPrediction == true then
        local pingValue = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
        local split = string.split(pingValue, '(')
        local ping = tonumber(split[1])

        getgenv().Prediction = getPrediction(ping)
    end
end
