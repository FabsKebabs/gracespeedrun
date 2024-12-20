
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/FabsKebabs/load/refs/heads/main/Source'))()

if not OrionLib then
    warn("Failed to load OrionLib!")
    return
end

local Window = OrionLib:MakeWindow({
    Name = "Publoader-Grace Hacks",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "Pubzy_Configs",
    BackgroundColor = Color3.fromRGB(30, 30, 30),
    TitleColor = Color3.fromRGB(255, 0, 255), 
})


local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false,
    TabColor = Color3.fromRGB(255, 165, 0), 
})

local SettingsTab = Window:MakeTab({
    Name = "Settings",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false,
    TabColor = Color3.fromRGB(0, 255, 255), 
})

local entityDestroyEnabled = false
local leverMoveEnabled = false
local lightingRemoved = false

local Lighting = game:GetService("Lighting")
local defaultBrightness = Lighting.Brightness
local defaultAmbient = Lighting.Ambient
local defaultOutdoorAmbient = Lighting.OutdoorAmbient

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


local function ToggleLighting(state)
    lightingRemoved = state
    if lightingRemoved then
        Lighting.Brightness = 2 -- Increase brightness
        Lighting.Ambient = Color3.new(1, 1, 1) 
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


MainTab:AddToggle({
    Name = "Destroy Entities (eye, elkman, etc.)",
    Default = false,
    Callback = function(state)
        ToggleEntityDestroy(state)
    end,
    ToggleColor = Color3.fromRGB(255, 0, 0) 
})

MainTab:AddToggle({
    Name = "Auto-Move Levers",
    Default = false,
    Callback = function(state)
        ToggleLeverMove(state)
    end,
    ToggleColor = Color3.fromRGB(0, 255, 0) 
})

MainTab:AddButton({
    Name = "Smile GUI - Locked 🔒",
    Callback = function()
        OrionLib:MakeNotification({
            Name = "Locked Feature",
            Content = "Smile GUI is under development.",
            Time = 3,
            Image = "rbxassetid://4483345998",
            ImageColor = Color3.fromRGB(255, 105, 180) 
        })
    end,
    ButtonColor = Color3.fromRGB(255, 105, 180) 
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
        if v:IsA("BasePart") and v.CanCollide == true and not v:IsDescendantOf(character) then
            v.Transparency = 0
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
        workspace.DescendantAdded:Connect(function(descendant)
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







-- Function to update TextLabels named "text" for keys and bricks separately
local function UpdateTextLabelForKeyAndBrick(value, type)
    -- Loop through all descendants in the game to find TextLabels named "text"
    for _, child in pairs(game:GetDescendants()) do
        -- Check if the child is a TextLabel and its name is "text"
        if child:IsA("TextLabel") and child.Name == "text" then
            -- Update the TextLabel based on the type (key or brick)
            if type == "key" and child.Parent.Name == "Keys" then
                child.Text = value -- Set the TextLabel's Text to the provided value for keys
            elseif type == "brick" and child.Parent.Name == "Bricks" then
                child.Text = value -- Set the TextLabel's Text to the provided value for bricks
            end
        end
    end
end

-- Function to set the Key or Brick value independently
local function SetKeyOrBrickValue(keyValue, brickValue)
    -- Convert the input values to numbers
    keyValue = tonumber(keyValue) or 0
    brickValue = tonumber(brickValue) or 0

    -- If keyValue is provided, update keys only
    if keyValue > 0 then
        UpdateTextLabelForKeyAndBrick(tostring(keyValue), "key")
        OrionLib:MakeNotification({
            Name = "Key Giver",
            Content = "Keys set to " .. tostring(keyValue),
            Time = 3
        })
    end

    -- If brickValue is provided, update bricks only
    if brickValue > 0 then
        UpdateTextLabelForKeyAndBrick(tostring(brickValue), "brick")
        OrionLib:MakeNotification({
            Name = "Brick Giver",
            Content = "Bricks set to " .. tostring(brickValue),
            Time = 3
        })
    end

    -- If no values were entered, show an error
    if keyValue <= 0 and brickValue <= 0 then
        OrionLib:MakeNotification({
            Name = "Error",
            Content = "Please enter a valid key or brick value.",
            Time = 3
        })
    end
end



-- Auto-submit when focus is lost (i.e., when user clicks away)
SettingsTab:AddTextbox({
    Name = "Bricks:", -- For auto-submit Bricks input
    Default = "",
    TextDisappear = true,
    Callback = function(value)
        brickAmount = value
        SetKeyOrBrickValue(keyAmount, brickAmount) -- Automatically apply values when focus is lost
    end,
    FocusLostCallback = function(value)
        brickAmount = value
        SetKeyOrBrickValue(keyAmount, brickAmount) -- Automatically apply values when focus is lost
    end
})

SettingsTab:AddTextbox({
    Name = "Keys:", -- For auto-submit Keys input
    Default = "",
    TextDisappear = true,
    Callback = function(value)
        keyAmount = value
        SetKeyOrBrickValue(keyAmount, brickAmount) -- Automatically apply values when focus is lost
    end,
    FocusLostCallback = function(value)
        keyAmount = value
        SetKeyOrBrickValue(keyAmount, brickAmount) -- Automatically apply values when focus is lost
    end
})


-- Variable to store the toggle state
local removeIcons = false

-- Function to hide or show player icons (BillboardGuis)
local function TogglePlayerIconsVisibility()
    -- Loop through all players in the game
    for _, player in pairs(game.Players:GetPlayers()) do
        -- Wait for the player's character and check for any BillboardGui objects
        local character = player.Character or player.CharacterAdded:Wait()
        
        -- Loop through all the parts and find any BillboardGuis
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BillboardGui") then
                part.Enabled = not removeIcons -- Toggle the visibility of the BillboardGui
            end
        end
    end
end

-- Add a new section for the "Remove Icons" toggle in the settings
SettingsTab:AddToggle({
    Name = "Remove Icons", -- Toggle text
    Default = false, -- Default state of the toggle
    Callback = function(state)
        removeIcons = state -- Store the toggle state
        TogglePlayerIconsVisibility() -- Apply visibility change based on toggle state
    end
})












-- Create Misc Tab with its own color and icon
local MiscTab = Window:MakeTab({
    Name = "Misc",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false,
    TabColor = Color3.fromRGB(255, 0, 255), -- Magenta color for misc tab
})

-- Function to change Walk Speed
local function SetWalkSpeed(value)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    character:WaitForChild("Humanoid") -- Ensure Humanoid is loaded before accessing it
    local humanoid = character.Humanoid
    humanoid.WalkSpeed = value
end

-- Variable to store the current WalkSpeed (from the slider)
local DefaultWalkSpeed = 16  -- Default value
local BoostedWalkSpeed = DefaultWalkSpeed  -- Initial WalkSpeed value

-- Add Walk Speed Slider to Misc Tab
local walkSpeedSlider = MiscTab:AddSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 200,
    Default = DefaultWalkSpeed,
    Color = Color3.fromRGB(255, 255, 0), -- Yellow color for the slider
    Increment = 1,
    Callback = function(value)
        BoostedWalkSpeed = value  -- Store the new WalkSpeed from the slider
        SetWalkSpeed(value)       -- Set WalkSpeed immediately when the slider value changes
    end
})

-- Continuously maintain Walk Speed value to lock it in place
game:GetService("RunService").Heartbeat:Connect(function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = BoostedWalkSpeed  -- Keeps the WalkSpeed constant based on slider
    end
end)

-- Add Reset Walk Speed Button to Misc Tab
MiscTab:AddButton({
    Name = "Reset Walk Speed",
    Callback = function()
        BoostedWalkSpeed = DefaultWalkSpeed  -- Reset WalkSpeed to default value (16)
        SetWalkSpeed(BoostedWalkSpeed)  -- Apply the reset value to the character
        walkSpeedSlider:SetValue(DefaultWalkSpeed)  -- Reset the slider value to default
    end
})

-- Notify that the Reset Walk Speed button is added
OrionLib:MakeNotification({
    Name = "Walk Speed Reset",
    Content = "The Walk Speed has been reset to default!",
    Image = "rbxassetid://4483345998",  -- Notification icon
    ImageColor = Color3.fromRGB(255, 255, 0),  -- Yellow notification icon
    Time = 3
})

-- Function to change Gravity
local function SetGravity(value)
    game.Workspace.Gravity = value
end

-- Variable to store the current Gravity (from the slider)
local DefaultGravity = 196.2  -- Default gravity value (normal gravity)

-- Add Gravity Slider to Misc Tab
local gravitySlider = MiscTab:AddSlider({
    Name = "Gravity",
    Min = 0,
    Max = 1000, -- Max value to allow flying
    Default = DefaultGravity, -- Default gravity value (normal gravity)
    Color = Color3.fromRGB(255, 165, 0), -- Orange color for the slider
    Increment = 1,
    Callback = function(value)
        SetGravity(value)
    end
})

-- Add Reset Gravity Button to Misc Tab
MiscTab:AddButton({
    Name = "Reset Gravity",
    Callback = function()
        SetGravity(DefaultGravity)  -- Reset Gravity to default value (196.2)
        gravitySlider:SetValue(DefaultGravity)  -- Reset the slider value to default
    end
})

-- Notify that the Reset Gravity button is added
OrionLib:MakeNotification({
    Name = "Gravity Reset",
    Content = "Gravity has been reset to the default value!",
    Image = "rbxassetid://4483345998",  -- Notification icon
    ImageColor = Color3.fromRGB(255, 165, 0),  -- Orange notification icon
    Time = 3
})



-- Function to toggle Day Mode (formerly Night Mode)
local function ToggleDayMode(state)
    if state then
        game.Lighting.TimeOfDay = "14:00:00" -- Set to noon (daytime)
        game.Lighting.Ambient = Color3.fromRGB(255, 255, 255) -- Default ambient light
    else
        game.Lighting.TimeOfDay = "00:00:00" -- Set to midnight
        game.Lighting.Ambient = Color3.fromRGB(50, 50, 50) -- Darker ambient light
    end
end

-- Add Day Mode Toggle to Misc Tab
MiscTab:AddToggle({
    Name = "Day Mode",
    Default = false,
    Callback = function(state)
        ToggleDayMode(state)
    end
})

-- Function to reset the character
local function ResetCharacter()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    character:BreakJoints() -- This will reset the character
end

MiscTab:AddButton({
    Name = "Reset Character",
    Callback = function()
        ResetCharacter()
    end
})

OrionLib:MakeNotification({
    Name = "Misc Tab Loaded",
    Content = "Walk Speed, Gravity, Day Mode, and Reset Character added!",
    Image = "rbxassetid://4483345998",
    ImageColor = Color3.fromRGB(255, 0, 255), -- Pink notification icon
    Time = 3
})
