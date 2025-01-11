
-- Cắt Tai Hub UI Library
local cattailib = {}
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

-- Constants
local BACKGROUND_COLOR = Color3.fromRGB(30, 30, 30)
local ACCENT_COLOR = Color3.fromRGB(40, 40, 40)
local TEXT_COLOR = Color3.fromRGB(255, 255, 255)
local BUTTON_COLOR = Color3.fromRGB(60, 60, 60)
local HOVER_COLOR = Color3.fromRGB(70, 70, 70)

-- Utility Functions
local function CreateTween(instance, properties, duration)
    return TweenService:Create(
        instance,
        TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        properties
    )
end

-- Main GUI Creation
function cattailib:CreateMainGUI(config)
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local TopBar = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local CloseButton = Instance.new("TextButton")
    local TabContainer = Instance.new("ScrollingFrame")
    local ContentContainer = Instance.new("Frame")
    local UIListLayout = Instance.new("UIListLayout")

    -- Screen GUI Setup
    ScreenGui.Name = "CatTaiHub"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Main Frame Setup
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = BACKGROUND_COLOR
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
    MainFrame.Size = UDim2.new(0, 500, 0, 300)
    MainFrame.ClipsDescendants = true

    UICorner.Parent = MainFrame
    UICorner.CornerRadius = UDim.new(0, 8)

    -- Top Bar Setup
    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = ACCENT_COLOR
    TopBar.Size = UDim2.new(1, 0, 0, 30)

    Title.Name = "Title"
    Title.Parent = TopBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Size = UDim2.new(1, -40, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = config.Title or "Cắt Tai Hub"
    Title.TextColor3 = TEXT_COLOR
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- Close Button
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = TopBar
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -30, 0, 0)
    CloseButton.Size = UDim2.new(0, 30, 1, 0)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "X"
    CloseButton.TextColor3 = TEXT_COLOR
    CloseButton.TextSize = 14

    -- Tab Container Setup
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = MainFrame
    TabContainer.BackgroundTransparency = 1
    TabContainer.Position = UDim2.new(0, 0, 0, 35)
    TabContainer.Size = UDim2.new(0, 120, 1, -35)
    TabContainer.ScrollBarThickness = 2

    UIListLayout.Parent = TabContainer
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 5)

    -- Content Container Setup
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Parent = MainFrame
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 125, 0, 35)
    ContentContainer.Size = UDim2.new(1, -130, 1, -40)

    -- Dragging Functionality
    local dragging
    local dragInput
    local dragStart
    local startPos

    local function updateDrag(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)

    TopBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateDrag(input)
        end
    end)

    -- Close Button Functionality
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Tab Creation Function
    local function CreateTab(name)
        local tab = {}
        
        -- Tab Button
        tab.Button = Instance.new("TextButton")
        tab.Button.Name = name
        tab.Button.Parent = TabContainer
        tab.Button.BackgroundColor3 = BUTTON_COLOR
        tab.Button.Size = UDim2.new(1, -10, 0, 30)
        tab.Button.Position = UDim2.new(0, 5, 0, 0)
        tab.Button.Text = name
        tab.Button.TextColor3 = TEXT_COLOR
        tab.Button.Font = Enum.Font.Gotham
        tab.Button.TextSize = 14
        
        local UICorner = Instance.new("UICorner")
        UICorner.Parent = tab.Button
        UICorner.CornerRadius = UDim.new(0, 6)

        -- Tab Content
        tab.Container = Instance.new("ScrollingFrame")
        tab.Container.Name = name.."Container"
        tab.Container.Parent = ContentContainer
        tab.Container.BackgroundTransparency = 1
        tab.Container.Size = UDim2.new(1, 0, 1, 0)
        tab.Container.ScrollBarThickness = 2
        tab.Container.Visible = false

        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.Parent = tab.Container
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Padding = UDim.new(0, 5)

        -- Button Hover Effect
        tab.Button.MouseEnter:Connect(function()
            CreateTween(tab.Button, {BackgroundColor3 = HOVER_COLOR}, 0.2):Play()
        end)

        tab.Button.MouseLeave:Connect(function()
            CreateTween(tab.Button, {BackgroundColor3 = BUTTON_COLOR}, 0.2):Play()
        end)

        return tab
    end

    -- Element Creation Functions
    local function CreateButton(parent, config)
        local Button = Instance.new("TextButton")
        Button.Name = config.Title or "Button"
        Button.Parent = parent
        Button.BackgroundColor3 = BUTTON_COLOR
        Button.Size = UDim2.new(1, -10, 0, 30)
        Button.Position = UDim2.new(0, 5, 0, 0)
        Button.Text = config.Title
        Button.TextColor3 = TEXT_COLOR
        Button.Font = Enum.Font.Gotham
        Button.TextSize = 14

        local UICorner = Instance.new("UICorner")
        UICorner.Parent = Button
        UICorner.CornerRadius = UDim.new(0, 6)

        Button.MouseButton1Click:Connect(config.Callback or function() end)

        -- Hover Effect
        Button.MouseEnter:Connect(function()
            CreateTween(Button, {BackgroundColor3 = HOVER_COLOR}, 0.2):Play()
        end)

        Button.MouseLeave:Connect(function()
            CreateTween(Button, {BackgroundColor3 = BUTTON_COLOR}, 0.2):Play()
        end)

        return Button
    end

    local function CreateToggle(parent, config)
        local Toggle = Instance.new("Frame")
        Toggle.Name = config.Title or "Toggle"
        Toggle.Parent = parent
        Toggle.BackgroundColor3 = BUTTON_COLOR
        Toggle.Size = UDim2.new(1, -10, 0, 30)
        Toggle.Position = UDim2.new(0, 5, 0, 0)

        local UICorner = Instance.new("UICorner")
        UICorner.Parent = Toggle
        UICorner.CornerRadius = UDim.new(0, 6)

        local Title = Instance.new("TextLabel")
        Title.Name = "Title"
        Title.Parent = Toggle
        Title.BackgroundTransparency = 1
        Title.Position = UDim2.new(0, 10, 0, 0)
        Title.Size = UDim2.new(1, -50, 1, 0)
        Title.Font = Enum.Font.Gotham
        Title.Text = config.Title
        Title.TextColor3 = TEXT_COLOR
        Title.TextSize = 14
        Title.TextXAlignment = Enum.TextXAlignment.Left

        local ToggleButton = Instance.new("Frame")
        ToggleButton.Name = "ToggleButton"
        ToggleButton.Parent = Toggle
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        ToggleButton.Position = UDim2.new(1, -40, 0.5, -10)
        ToggleButton.Size = UDim2.new(0, 30, 0, 20)

        local UICorner = Instance.new("UICorner")
        UICorner.Parent = ToggleButton
        UICorner.CornerRadius = UDim.new(1, 0)

        local Circle = Instance.new("Frame")
        Circle.Name = "Circle"
        Circle.Parent = ToggleButton
        Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Circle.Position = UDim2.new(0, 2, 0.5, -8)
        Circle.Size = UDim2.new(0, 16, 0, 16)

        local UICorner = Instance.new("UICorner")
        UICorner.Parent = Circle
        UICorner.CornerRadius = UDim.new(1, 0)

        local enabled = config.Default or false
        local function updateToggle()
            if enabled then
                CreateTween(Circle, {Position = UDim2.new(1, -18, 0.5, -8)}, 0.2):Play()
                CreateTween(ToggleButton, {BackgroundColor3 = Color3.fromRGB(0, 255, 128)}, 0.2):Play()
            else
                CreateTween(Circle, {Position = UDim2.new(0, 2, 0.5, -8)}, 0.2):Play()
                CreateTween(ToggleButton, {BackgroundColor3 = Color3.fromRGB(200, 200, 200)}, 0.2):Play()
            end
            if config.Callback then
                config.Callback(enabled)
            end
        end

        Toggle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                enabled = not enabled
                updateToggle()
            end
        end)

        updateToggle()
        return Toggle
    end

    local function CreateSlider(parent, config)
        local Slider = Instance.new("Frame")
        Slider.Name = config.Title or "Slider"
        Slider.Parent = parent
        Slider.BackgroundColor3 = BUTTON_COLOR
        Slider.Size = UDim2.new(1, -10, 0, 50)
        Slider.Position = UDim2.new(0, 5, 0, 0)

        local UICorner = Instance.new("UICorner")
        UICorner.Parent = Slider
        UICorner.CornerRadius = UDim.new(0, 6)

        local Title = Instance.new("TextLabel")
        Title.Name = "Title"
        Title.Parent = Slider
        Title.BackgroundTransparency = 1
        Title.Position = UDim2.new(0, 10, 0, 0)
        Title.Size = UDim2.new(1, -20, 0, 25)
        Title.Font = Enum.Font.Gotham
        Title.Text = config.Title
        Title.TextColor3 = TEXT_COLOR
        Title.TextSize = 14
        Title.TextXAlignment = Enum.TextXAlignment.Left

        local ValueLabel = Instance.new("TextLabel")
        ValueLabel.Name = "Value"
        ValueLabel.Parent = Slider
        ValueLabel.BackgroundTransparency = 1
        ValueLabel.Position = UDim2.new(1, -50, 0, 0)
        ValueLabel.Size = UDim2.new(0, 40, 0, 25)
        ValueLabel.Font = Enum.Font.Gotham
        ValueLabel.Text = tostring(config.Default or config.Min)
        ValueLabel.TextColor3 = TEXT_COLOR
        ValueLabel.TextSize = 14

        local SliderBar = Instance.new("Frame")
        SliderBar.Name = "SliderBar"
        SliderBar.Parent = Slider
        SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        SliderBar.Position = UDim2.new(0, 10, 0, 35)
        SliderBar.Size = UDim2.new(1, -20, 0, 5)

        local UICorner = Instance.new("UICorner")
        UICorner.Parent = SliderBar
        UICorner.CornerRadius = UDim.new(1, 0)

        local SliderFill = Instance.new("Frame")
        SliderFill.Name = "SliderFill"
        SliderFill.Parent = SliderBar
        SliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 128)
        SliderFill.Size = UDim2.new(0, 0, 1, 0)

        local UICorner = Instance.new("UICorner")
        UICorner.Parent = SliderFill
        UICorner.CornerRadius = UDim.new(1, 0)

        local Dragger = Instance.new("TextButton")
        Dragger.Name = "Dragger"
        Dragger.Parent = SliderFill
        Dragger.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Dragger.Position = UDim2.new(1, -10, 0.5, -10)
        
        Dragger.Size = UDim2.new(0, 20, 0, 20)
        Dragger.Text = ""

        local UICorner = Instance.new("UICorner")
        UICorner.Parent = Dragger
        UICorner.CornerRadius = UDim.new(1, 0)

        -- Slider Functionality
        local MinValue = config.Min or 0
        local MaxValue = config.Max or 100
        local CurrentValue = config.Default or MinValue

        local function UpdateSlider(value)
            CurrentValue = math.clamp(value, MinValue, MaxValue)
            local percent = (CurrentValue - MinValue) / (MaxValue - MinValue)
            
            CreateTween(SliderFill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.1):Play()
            ValueLabel.Text = tostring(math.round(CurrentValue))
            
            if config.Callback then
                config.Callback(CurrentValue)
            end
        end

        local dragging = false

        Dragger.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)

        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)

        UIS.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local percent = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                local value = MinValue + ((MaxValue - MinValue) * percent)
                UpdateSlider(value)
            end
        end)

        UpdateSlider(CurrentValue)
        return Slider
    end

    local function CreateDropdown(parent, config)
        local Dropdown = Instance.new("Frame")
        Dropdown.Name = config.Title or "Dropdown"
        Dropdown.Parent = parent
        Dropdown.BackgroundColor3 = BUTTON_COLOR
        Dropdown.Size = UDim2.new(1, -10, 0, 30)
        Dropdown.Position = UDim2.new(0, 5, 0, 0)
        Dropdown.ClipsDescendants = true

        local UICorner = Instance.new("UICorner")
        UICorner.Parent = Dropdown
        UICorner.CornerRadius = UDim.new(0, 6)

        local Title = Instance.new("TextLabel")
        Title.Name = "Title"
        Title.Parent = Dropdown
        Title.BackgroundTransparency = 1
        Title.Position = UDim2.new(0, 10, 0, 0)
        Title.Size = UDim2.new(1, -40, 0, 30)
        Title.Font = Enum.Font.Gotham
        Title.Text = config.Title
        Title.TextColor3 = TEXT_COLOR
        Title.TextSize = 14
        Title.TextXAlignment = Enum.TextXAlignment.Left

        local Arrow = Instance.new("TextLabel")
        Arrow.Name = "Arrow"
        Arrow.Parent = Dropdown
        Arrow.BackgroundTransparency = 1
        Arrow.Position = UDim2.new(1, -30, 0, 0)
        Arrow.Size = UDim2.new(0, 30, 0, 30)
        Arrow.Font = Enum.Font.Gotham
        Arrow.Text = "▼"
        Arrow.TextColor3 = TEXT_COLOR
        Arrow.TextSize = 14

        local OptionsFrame = Instance.new("Frame")
        OptionsFrame.Name = "Options"
        OptionsFrame.Parent = Dropdown
        OptionsFrame.BackgroundColor3 = BUTTON_COLOR
        OptionsFrame.Position = UDim2.new(0, 0, 0, 35)
        OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
        OptionsFrame.Visible = false

        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.Parent = OptionsFrame
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Padding = UDim.new(0, 5)

        local open = false
        local selected = config.Default or {}

        local function UpdateDropdown()
            local options = config.Options or {}
            for _, child in pairs(OptionsFrame:GetChildren()) do
                if child:IsA("TextButton") then
                    child:Destroy()
                end
            end

            for _, option in pairs(options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Name = option
                OptionButton.Parent = OptionsFrame
                OptionButton.BackgroundColor3 = ACCENT_COLOR
                OptionButton.Size = UDim2.new(1, -10, 0, 25)
                OptionButton.Position = UDim2.new(0, 5, 0, 0)
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.Text = option
                OptionButton.TextColor3 = TEXT_COLOR
                OptionButton.TextSize = 14
                OptionButton.AutoButtonColor = false

                local UICorner = Instance.new("UICorner")
                UICorner.Parent = OptionButton
                UICorner.CornerRadius = UDim.new(0, 4)

                OptionButton.MouseButton1Click:Connect(function()
                    if config.Multi then
                        if table.find(selected, option) then
                            table.remove(selected, table.find(selected, option))
                            CreateTween(OptionButton, {BackgroundColor3 = ACCENT_COLOR}, 0.2):Play()
                        else
                            table.insert(selected, option)
                            CreateTween(OptionButton, {BackgroundColor3 = Color3.fromRGB(0, 255, 128)}, 0.2):Play()
                        end
                    else
                        selected = {option}
                        for _, btn in pairs(OptionsFrame:GetChildren()) do
                            if btn:IsA("TextButton") then
                                CreateTween(btn, {BackgroundColor3 = ACCENT_COLOR}, 0.2):Play()
                            end
                        end
                        CreateTween(OptionButton, {BackgroundColor3 = Color3.fromRGB(0, 255, 128)}, 0.2):Play()
                        open = false
                        CreateTween(Dropdown, {Size = UDim2.new(1, -10, 0, 30)}, 0.2):Play()
                        CreateTween(Arrow, {Rotation = 0}, 0.2):Play()
                    end

                    if config.Callback then
                        if config.Multi then
                            config.Callback(selected)
                        else
                            config.Callback(selected[1])
                        end
                    end
                end)

                if (config.Multi and table.find(selected, option)) or (not config.Multi and selected[1] == option) then
                    CreateTween(OptionButton, {BackgroundColor3 = Color3.fromRGB(0, 255, 128)}, 0):Play()
                end
            end
        end

        Dropdown.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                open = not open
                local optionsHeight = UIListLayout.AbsoluteContentSize.Y + 40
                if open then
                    CreateTween(Dropdown, {Size = UDim2.new(1, -10, 0, optionsHeight)}, 0.2):Play()
                    CreateTween(Arrow, {Rotation = 180}, 0.2):Play()
                    OptionsFrame.Visible = true
                else
                    CreateTween(Dropdown, {Size = UDim2.new(1, -10, 0, 30)}, 0.2):Play()
                    CreateTween(Arrow, {Rotation = 0}, 0.2):Play()
                    wait(0.2)
                    OptionsFrame.Visible = false
                end
            end
        end)

        UpdateDropdown()
        return Dropdown
    end

    -- Create Notification System
    function cattailib:CreateNotification(config)
        local Notification = Instance.new("Frame")
        Notification.Name = "Notification"
        Notification.Parent = ScreenGui
        Notification.BackgroundColor3 = BACKGROUND_COLOR
        Notification.Position = UDim2.new(1, 20, 1, -90)
        Notification.Size = UDim2.new(0, 300, 0, 70)
        Notification.AnchorPoint = Vector2.new(1, 1)

        local UICorner = Instance.new("UICorner")
        UICorner.Parent = Notification
        UICorner.CornerRadius = UDim.new(0, 6)

        local Title = Instance.new("TextLabel")
        Title.Name = "Title"
        Title.Parent = Notification
        Title.BackgroundTransparency = 1
        Title.Position = UDim2.new(0, 10, 0, 5)
        Title.Size = UDim2.new(1, -20, 0, 20)
        Title.Font = Enum.Font.GothamBold
        Title.Text = config.Title or "Notification"
        Title.TextColor3 = TEXT_COLOR
        Title.TextSize = 14
        Title.TextXAlignment = Enum.TextXAlignment.Left

        local Content = Instance.new("TextLabel")
        Content.Name = "Content"
        Content.Parent = Notification
        Content.BackgroundTransparency = 1
        Content.Position = UDim2.new(0, 10, 0, 30)
        Content.Size = UDim2.new(1, -20, 0, 35)
        Content.Font = Enum.Font.Gotham
        Content.Text = config.Content or ""
        Content.TextColor3 = TEXT_COLOR
        Content.TextSize = 14
        Content.TextWrapped = true
        Content.TextXAlignment = Enum.TextXAlignment.Left

        -- Animation
        CreateTween(Notification,
            {Position = UDim2.new(1, -20, 1, -90)},
            0.5
        ):Play()

        wait(config.Duration or 3)

        CreateTween(Notification,
            {Position = UDim2.new(1, 320, 1, -90)},
            0.5
        ):Play()

        wait(0.5)
        Notification:Destroy()
    end

    local lib = {}
    
    function lib:CreateTab(config)
        local tab = CreateTab(config.Name)
        
        function tab:AddButton(config)
            return CreateButton(tab.Container, config)
        end
        
        function tab:AddToggle(config)
            return CreateToggle(tab.Container, config)
        end
        
        function tab:AddSlider(config)
            return CreateSlider(tab.Container, config)
        end
        
        function tab:AddDropdown(config)
            return CreateDropdown(tab.Container, config)
        end
        
        tab.Button.MouseButton1Click:Connect(function()
            for _, container in pairs(ContentContainer:GetChildren()) do
                container.Visible = false
            end
            tab.Container.Visible = true
        end)
        
        if #ContentContainer:GetChildren() == 0 then
            tab.Container.Visible = true
        end
        
        return tab
    end

    function lib:Notify(config)
        cattailib:CreateNotification(config)
    end

    return lib
end

return cattailib
