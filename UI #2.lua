-- Place this LocalScript in StarterPlayerScripts

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- Function to create the UI
local function createUI()
    -- Check if UI already exists
    if Player:FindFirstChild("PlayerGui"):FindFirstChild("MenuScreenGui") then
        return
    end

    -- Create ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MenuScreenGui"
    screenGui.Parent = Player:WaitForChild("PlayerGui")

    -- Create a Frame to act as the menu layer
    local menuLayer = Instance.new("Frame")
    menuLayer.Name = "MenuLayer"
    menuLayer.BackgroundColor3 = Color3.new(0, 0, 0)
    menuLayer.BackgroundTransparency = 0.5
    menuLayer.Parent = screenGui

    -- Create Title TextLabel
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleTextLabel"
    titleLabel.Text = "TheRealC_ROZA’s UI #2"
    titleLabel.Size = UDim2.new(0, 300, 0, 50)
    titleLabel.TextSize = 24
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.BackgroundColor3 = Color3.new(0, 0, 0)
    titleLabel.BackgroundTransparency = 0.5
    titleLabel.TextStrokeTransparency = 0.5
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.Parent = menuLayer

    -- Create SOON TextLabel
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "MenuTextLabel"
    textLabel.Text = "SOON..."
    textLabel.Size = UDim2.new(0, 200, 0, 50)
    textLabel.TextSize = 36
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.BackgroundColor3 = Color3.new(0, 0, 0)
    textLabel.BackgroundTransparency = 0.5
    textLabel.TextStrokeTransparency = 0.8
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.Parent = menuLayer

    -- Create Hide Button
    local hideButton = Instance.new("TextButton")
    hideButton.Name = "HideButton2"
    hideButton.Text = "Hide UI #2"
    hideButton.Size = UDim2.new(0, 100, 0, 30)
    hideButton.Position = UDim2.new(0, 10, 0, 10)  -- Top-left corner
    hideButton.TextSize = 18
    hideButton.TextColor3 = Color3.new(1, 1, 1)
    hideButton.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
    hideButton.BackgroundTransparency = 0.5
    hideButton.Font = Enum.Font.SourceSansBold
    hideButton.Parent = screenGui

    -- Create Show Button (initially hidden)
    local showButton = Instance.new("TextButton")
    showButton.Name = "ShowButton"
    showButton.Text = "Show UI"
    showButton.Size = UDim2.new(0, 100, 0, 30)
    showButton.Position = UDim2.new(0, 10, 0, 50)  -- Below Hide UI #2
    showButton.TextSize = 18
    showButton.TextColor3 = Color3.new(1, 1, 1)
    showButton.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
    showButton.BackgroundTransparency = 0.5
    showButton.Font = Enum.Font.SourceSansBold
    showButton.Visible = false
    showButton.Parent = screenGui

    -- Update menuLayer size based on content
    local function updateMenuLayerSize()
        -- Calculate the size needed for the content
        local contentWidth = math.max(titleLabel.AbsoluteSize.X, textLabel.AbsoluteSize.X) + 20
        local contentHeight = titleLabel.AbsoluteSize.Y + textLabel.AbsoluteSize.Y + 80  -- Add padding

        -- Update the menuLayer size and position
        menuLayer.Size = UDim2.new(0, contentWidth, 0, contentHeight)
        menuLayer.Position = UDim2.new(0.5, -contentWidth/2, 0.5, -contentHeight/2)

        -- Move UI elements inside the menuLayer
        titleLabel.Position = UDim2.new(0.5, -titleLabel.Size.X.Offset/2, 0, 10)
        textLabel.Position = UDim2.new(0.5, -textLabel.Size.X.Offset/2, 0, 60)  -- Adjusted vertical position
    end

    updateMenuLayerSize()

    -- Drag functionality for the menuLayer
    local dragging, dragStart, startPos

    local function onInputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if input.Target == menuLayer then
                dragging = true
                dragStart = input.Position
                startPos = menuLayer.Position
                UIS.InputChanged:Connect(onInputChanged)
            elseif input.Target == titleLabel then
                dragging = true
                dragStart = input.Position
                startPos = titleLabel.Position
                UIS.InputChanged:Connect(onInputChangedTitle)
            end
        end
    end

    local function onInputChanged(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            menuLayer.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end

    local function onInputChangedTitle(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            titleLabel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end

    local function onInputEnded(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end

    UIS.InputBegan:Connect(onInputBegan)
    UIS.InputChanged:Connect(onInputChanged)
    UIS.InputChanged:Connect(onInputChangedTitle)
    UIS.InputEnded:Connect(onInputEnded)

    -- Button functionality
    hideButton.MouseButton1Click:Connect(function()
        menuLayer.Visible = false
        showButton.Visible = true
    end)

    showButton.MouseButton1Click:Connect(function()
        menuLayer.Visible = true
        showButton.Visible = false
    end)
end

-- Connect to PlayerAdded and CharacterAdded events to ensure UI is created for each respawn
Player.CharacterAdded:Connect(function()
    -- Wait for PlayerGui to be ready
    Player:WaitForChild("PlayerGui"):WaitForChild("MenuScreenGui"):Destroy()
    createUI()
end)

-- Initial UI creation if Player already has a character
if Player.Character then
    createUI()
end
