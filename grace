-- Load OrionLib
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/FabsKebabs/load/refs/heads/main/Source'))()

-- Ensure OrionLib loaded correctly
if not OrionLib then
    warn("Failed to load OrionLib!")
    return
end

-- Create Window with a colorful theme
local Window = OrionLib:MakeWindow({
    Name = "Publoader-Grace Hacks",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "Pubzy_Configs",
    BackgroundColor = Color3.fromRGB(30, 30, 30),
    TitleColor = Color3.fromRGB(255, 0, 255), -- Magenta title
})

-- Create Main Tab with colorful icon
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false,
    TabColor = Color3.fromRGB(255, 165, 0), -- Orange color for main tab
})

-- Create Settings Tab with a different vibrant color
local SettingsTab = Window:MakeTab({
    Name = "Settings",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false,
    TabColor = Color3.fromRGB(0, 255, 255), -- Cyan color for settings tab
})

-- Toggle State Variables
local entityDestroyEnabled = false
local leverMoveEnabled = false
local lightingRemoved = false

-- Store Default Lighting Values
local Lighting = game:GetService("Lighting")
local defaultBrightness = Lighting.Brightness
local defaultAmbient = Lighting.Ambient
local defaultOutdoorAmbient = Lighting.OutdoorAmbient

-- Function to destroy certain entities
local function ToggleEntityDestroy(state)
    entityDestroyEnabled = state
    if entityDestroyEnabled then
        workspace.DescendantAdded:Connect(function(descendant)
            if descendant.Name == "eye" or descendant.Name == "elkman" or descendant.Name == "Rush" or descendant.Name == "Worm" or descendant.Name == "eyePrime" then
                descendant:Destroy()
            end
        end)
        OrionLib:MakeNotification({
            Name = "Entity Destroyer",
            Content = "Entity destroyer enabled.",
            Time = 3
        })
    else
        OrionLib:MakeNotification({
            Name = "Entity Destroyer",
            Content = "Entity destroyer disabled. Reload to stop effects.",
            Time = 3
        })
    end
end

-- Function to move levers to the player
local function ToggleLeverMove(state)
    leverMoveEnabled = state
    if leverMoveEnabled then
        workspace.DescendantAdded:Connect(function(descendant)
            if descendant.Name == "base" and descendant:IsA("BasePart") then
                local player = game.Players.LocalPlayer
                if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    descendant.Position = player.Character.HumanoidRootPart.Position
                    game.StarterGui:SetCore("SendNotification", {
                        Title = "Levers Moved",
                        Text = "Door has been opened",
                        Duration = 3
                    })
                end
            end
        end)
        OrionLib:MakeNotification({
            Name = "Lever Move",
            Content = "Levers will now move to you.",
            Time = 3
        })
    else
        OrionLib:MakeNotification({
            Name = "Lever Move",
            Content = "Lever move disabled. Reload to stop effects.",
            Time = 3
        })
    end
end

-- Function to toggle lighting
local function ToggleLighting(state)
    lightingRemoved = state
    if lightingRemoved then
        Lighting.Brightness = 2 -- Increase brightness
        Lighting.Ambient = Color3.new(1, 1, 1) -- White ambient lighting
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        OrionLib:MakeNotification({
            Name = "Lighting Removed",
            Content = "Lighting has been brightened.",
            Time = 3
        })
    else
        Lighting.Brightness = defaultBrightness -- Restore default brightness
        Lighting.Ambient = defaultAmbient
        Lighting.OutdoorAmbient = defaultOutdoorAmbient
        OrionLib:MakeNotification({
            Name = "Lighting Restored",
            Content = "Lighting has been restored to default.",
            Time = 3
        })
    end
end

-- Add Buttons to the Main Tab with colorful notifications
MainTab:AddToggle({
    Name = "Destroy Entities (eye, elkman, etc.)",
    Default = false,
    Callback = function(state)
        ToggleEntityDestroy(state)
    end,
    ToggleColor = Color3.fromRGB(255, 0, 0) -- Red toggle for destructive entities
})

MainTab:AddToggle({
    Name = "Auto-Move Levers",
    Default = false,
    Callback = function(state)
        ToggleLeverMove(state)
    end,
    ToggleColor = Color3.fromRGB(0, 255, 0) -- Green toggle for auto-move levers
})

MainTab:AddButton({
    Name = "Smile GUI - Locked 🔒",
    Callback = function()
        OrionLib:MakeNotification({
            Name = "Locked Feature",
            Content = "Smile GUI is under development.",
            Time = 3,
            Image = "rbxassetid://4483345998",
            ImageColor = Color3.fromRGB(255, 105, 180) -- Hot pink icon color for smile
        })
    end,
    ButtonColor = Color3.fromRGB(255, 105, 180) -- Hot pink button color
})

MainTab:AddButton({
    Name = "Bloodrain - Locked 🔒",
    Callback = function()
        OrionLib:MakeNotification({
            Name = "Locked Feature",
            Content = "Bloodrain is under development.",
            Time = 3,
            Image = "rbxassetid://4483345998",
            ImageColor = Color3.fromRGB(255, 0, 0) -- Red icon color for bloodrain
        })
    end,
    ButtonColor = Color3.fromRGB(255, 0, 0) -- Red button color
})

-- Add Lighting Toggle to Settings Tab with cool color options
SettingsTab:AddToggle({
    Name = "Remove Lighting (Brighten Map)",
    Default = false,
    Callback = function(state)
        ToggleLighting(state)
    end,
    ToggleColor = Color3.fromRGB(0, 255, 255) -- Cyan toggle for lighting removal
})

-- Notify Script is Loaded with a colorful notification
OrionLib:MakeNotification({
    Name = "Script Loaded!",
    Content = "Publoader has been initialized successfully.",
    Image = "rbxassetid://4483345998",
    ImageColor = Color3.fromRGB(0, 255, 0), -- Green icon for success
    Time = 5
})


-- Track the toggle state globally
local seeThroughWallsEnabled = false
local connection -- Connection for DescendantAdded

-- Function to apply transparency to walls
local function ApplySeeThroughWalls()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.CanCollide == true and not v:IsDescendantOf(character) then
            v.Transparency = 0.7
        end
    end
end

-- Function to reset transparency for all walls
local function ResetWallTransparency()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v:IsDescendantOf(character) then
            v.Transparency = 0 -- Reset transparency
        end
    end
end

-- Function to toggle see-through walls dynamically
local function ToggleSeeThroughWalls(state)
    seeThroughWallsEnabled = state
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    if seeThroughWallsEnabled then
        -- Apply transparency to existing walls
        ApplySeeThroughWalls()

        -- Listen for new walls being added
        connection = workspace.DescendantAdded:Connect(function(descendant)
            if seeThroughWallsEnabled 
               and descendant:IsA("BasePart") 
               and descendant.CanCollide == true 
               and not descendant:IsDescendantOf(character) then
                descendant.Transparency = 0.7
            end
        end)

        OrionLib:MakeNotification({
            Name = "See Through Walls",
            Content = "Walls are now semi-transparent.",
            Time = 3
        })
    else
        -- Reset all walls to fully opaque
        ResetWallTransparency()

        -- Disconnect any existing connections
        if connection then
            connection:Disconnect()
            connection = nil
        end

        OrionLib:MakeNotification({
            Name = "See Through Walls",
            Content = "Walls are back to normal.",
            Time = 3
        })
    end
end

-- Add See Through Walls Toggle to the Settings Tab
SettingsTab:AddToggle({
    Name = "See Through Walls",
    Default = false,
    Callback = function(state)
        ToggleSeeThroughWalls(state)
    end,
    ToggleColor = Color3.fromRGB(128, 0, 128) -- Purple toggle for see-through walls
})
