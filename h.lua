-- GUI Setup
local Pluh = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local TextButton = Instance.new("TextButton")
local UICorner_2 = Instance.new("UICorner")
local PingDisplay = Instance.new("TextLabel")
local PredictionDisplay = Instance.new("TextLabel")
local ResolverLabel = Instance.new("TextLabel") -- New label

-- Properties
Pluh.Name = "Pluh"
Pluh.Parent = game.CoreGui
Pluh.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = Pluh
Frame.BackgroundColor3 = Color3.fromRGB(26, 26, 26) -- Updated color
Frame.BackgroundTransparency = 0.30 -- 25% opacity (1.0 - 0.25)
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

TextButton.Parent = Frame
TextButton.BackgroundColor3 = Color3.fromRGB(51, 50, 50)
TextButton.BorderSizePixel = 0
TextButton.BackgroundTransparency = 0.40
TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton.Position = UDim2.new(0.03, 0, 0.18571429, 0)
TextButton.Size = UDim2.new(0, 190, 0, 44)
TextButton.Font = Enum.Font.SourceSansSemibold
TextButton.Text = "Pluh Lock"
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.TextScaled = true
TextButton.TextSize = 18.000
TextButton.TextWrapped = true

UICorner_2.Parent = TextButton

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

-- Adding Prediction Display
PredictionDisplay.Parent = Frame
PredictionDisplay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PredictionDisplay.BackgroundTransparency = 1.000
PredictionDisplay.BorderColor3 = Color3.fromRGB(0, 0, 0)
PredictionDisplay.BorderSizePixel = 0
PredictionDisplay.Position = UDim2.new(0.0792079195, 0, -0.1, 0) -- Adjust the position as needed
PredictionDisplay.Size = UDim2.new(0, 170, 0, 20)
PredictionDisplay.Font = Enum.Font.GothamBold
PredictionDisplay.Text = "Prediction: N/A"
PredictionDisplay.TextScaled = true
PredictionDisplay.TextColor3 = Color3.fromRGB(255, 255, 255)
PredictionDisplay.TextSize = 14.000
PredictionDisplay.TextWrapped = true

-- Adding Resolver Label
ResolverLabel.Parent = Frame
ResolverLabel.BackgroundColor3 = Color3.fromRGB(26, 26, 26) -- Same color as frame
ResolverLabel.BackgroundTransparency = 0.30 -- Same opacity as frame
ResolverLabel.BorderSizePixel = 0
ResolverLabel.Position = UDim2.new(0.03, 0, 0.514285714, 0) -- Adjust position below the frame
ResolverLabel.Size = UDim2.new(0, 190, 0, 44)
ResolverLabel.Font = Enum.Font.SourceSansSemibold
ResolverLabel.Text = "Enable Resolver"
ResolverLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
ResolverLabel.TextScaled = true
ResolverLabel.TextSize = 18.000
ResolverLabel.TextWrapped = true

UICorner_2:Clone().Parent = ResolverLabel

local resolverEnabled = false
ResolverLabel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and not resolverEnabled then
        resolverEnabled = true
        ResolverLabel.Text = "Resolver Enabled!"
        
        -- Enable Resolver code
        local RunService = game:GetService("RunService")

        local function zeroOutYVelocity(hrp)
            hrp.Velocity = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z)
            hrp.AssemblyLinearVelocity = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z)
        end

        local function onPlayerAdded(player)
            player.CharacterAdded:Connect(function(character)
                local hrp = character:WaitForChild("HumanoidRootPart")
                zeroOutYVelocity(hrp)
            end)
        end

        game.Players.PlayerAdded:Connect(onPlayerAdded)

        RunService.Heartbeat:Connect(function()
            pcall(function()
                for _, player in pairs(game.Players:GetChildren()) do
                    if player.Name ~= game.Players.LocalPlayer.Name then
                        local hrp = player.Character.HumanoidRootPart
                        zeroOutYVelocity(hrp)
                    end
                end
            end)
        end)

        print("Resolver Enabled")
    end
end)
