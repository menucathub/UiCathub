
-- Cat Hub UI Library V2
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local Cat = {
    Flags = {},
    Theme = {
        Primary = Color3.fromRGB(24, 24, 24),
        Secondary = Color3.fromRGB(30, 30, 30),
        Accent = Color3.fromRGB(255, 50, 50),
        Text = Color3.fromRGB(255, 255, 255)
    },
    Effects = {
        Ripple = true,
        Hover = true,
        Sound = true
    }
}

-- Utility Functions
local function CreateTween(instance, properties, duration, style)
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(duration or 0.3, style or Enum.EasingStyle.Quad),
        properties
    )
    return tween
end

local function CreateRipple(parent)
    local ripple = Instance.new("Frame")
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.6
    ripple.BorderSizePixel = 0
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple

    return ripple
end

function Cat:CreateWindow(config)
    config = config or {}
    local Window = {
        Tabs = {},
        CurrentTab = nil,
        Toggled = true
    }

    -- Create Main GUI
    local CatHubGui = Instance.new("ScreenGui")
    CatHubGui.Name = "CatHubGui"
    CatHubGui.Parent = CoreGui
    CatHubGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Main Container
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = CatHubGui
    Main.BackgroundColor3 = Cat.Theme.Primary
    Main.Position = UDim2.new(0.5, -300, 0.5, -200)
    Main.Size = UDim2.new(0, 600, 0, 400)
    Main.ClipsDescendants = true

    -- UI Corner
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = Main

    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Parent = Main
    TopBar.BackgroundColor3 = Cat.Theme.Secondary
    TopBar.Size = UDim2.new(1, 0, 0, 30)

    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 8)
    TopBarCorner.Parent = TopBar

    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = TopBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = config.Title or "Cat Hub V2"
    Title.TextColor3 = Cat.Theme.Text
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = Main
    TabContainer.BackgroundColor3 = Cat.Theme.Secondary
    TabContainer.Position = UDim2.new(0, 0, 0, 40)
    TabContainer.Size = UDim2.new(0, 150, 1, -40)

    local TabContainerCorner = Instance.new("UICorner")
    TabContainerCorner.CornerRadius = UDim.new(0, 8)
    TabContainerCorner.Parent = TabContainer

    local TabList = Instance.new("ScrollingFrame")
    TabList.Name = "TabList"
    TabList.Parent = TabContainer
    TabList.BackgroundTransparency = 1
    TabList.Size = UDim2.new(1, 0, 1, 0)
    TabList.ScrollBarThickness = 2

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Parent = TabList
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 5)

    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Parent = Main
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 160, 0, 40)
    ContentContainer.Size = UDim2.new(1, -170, 1, -50)

    -- Create Tab Function
    function Window:CreateTab(name)
        local Tab = {
            Name = name,
            Elements = {}
        }

        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name.."Tab"
        TabButton.Parent = TabList
        TabButton.BackgroundColor3 = Cat.Theme.Primary
        TabButton.Size = UDim2.new(1, -10, 0, 40)
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.Text = name
        TabButton.TextColor3 = Cat.Theme.Text
        TabButton.TextSize = 14
        TabButton.AutoButtonColor = false

        local TabButtonCorner = Instance.new("UICorner")
        TabButtonCorner.CornerRadius = UDim.new(0, 6)
        TabButtonCorner.Parent = TabButton

        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name.."Content"
        TabContent.Parent = ContentContainer
        TabContent.BackgroundTransparency = 1
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.ScrollBarThickness = 2
        TabContent.Visible = false

        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Parent = TabContent
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Padding = UDim.new(0, 10)

        -- Tab Button Click
        TabButton.MouseButton1Click:Connect(function()
            if Window.CurrentTab then
                Window.CurrentTab.Content.Visible = false
                CreateTween(Window.CurrentTab.Button, {BackgroundColor3 = Cat.Theme.Primary}):Play()
            end
            
            Window.CurrentTab = {
                Button = TabButton,
                Content = TabContent
            }
            
            TabContent.Visible = true
            CreateTween(TabButton, {BackgroundColor3 = Cat.Theme.Accent}):Play()
            
            if Cat.Effects.Sound then
                local sound = Instance.new("Sound")
                sound.SoundId = "rbxassetid://6895079853"
                sound.Parent = TabButton
                sound:Play()
                game.Debris:AddItem(sound, 1)
            end
        end)

        -- Create Elements Functions
        function Tab:CreateButton(text, callback)
            local Button = Instance.new("TextButton")
            Button.Name = text.."Button"
            Button.Parent = TabContent
            Button.BackgroundColor3 = Cat.Theme.Secondary
            Button.Size = UDim2.new(1, -20, 0, 40)
            Button.Font = Enum.Font.GothamSemibold
            Button.Text = text
            Button.TextColor3 = Cat.Theme.Text
            Button.TextSize = 14
            Button.AutoButtonColor = false

            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 6)
            ButtonCorner.Parent = Button

            -- Button Effects
            Button.MouseButton1Down:Connect(function()
                if Cat.Effects.Ripple then
                    local ripple = CreateRipple(Button)
                    local x, y = UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y
                    local position = Vector2.new(x, y) - Button.AbsolutePosition
                    ripple.Position = UDim2.new(0, position.X, 0, position.Y)
                    CreateTween(ripple, {Size = UDim2.new(0, 300, 0, 300), BackgroundTransparency = 1}):Play()
                    game.Debris:AddItem(ripple, 0.5)
                end

                CreateTween(Button, {BackgroundColor3 = Cat.Theme.Accent}):Play()
                if callback then callback() end
            end)

            Button.MouseButton1Up:Connect(function()
                CreateTween(Button, {BackgroundColor3 = Cat.Theme.Secondary}):Play()
            end)

            if Cat.Effects.Hover then
                Button.MouseEnter:Connect(function()
                    CreateTween(Button, {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
                end)

                Button.MouseLeave:Connect(function()
                    CreateTween(Button, {BackgroundColor3 = Cat.Theme.Secondary}):Play()
                end)
            end

            return Button
        end

        function Tab:CreateToggle(text, default, callback)
            local Toggle = Instance.new("Frame")
            Toggle.Name = text.."Toggle"
            Toggle.Parent = TabContent
            Toggle.BackgroundColor3 = Cat.Theme.Secondary
            Toggle.Size = UDim2.new(1, -20, 0, 40)

            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 6)
            ToggleCorner.Parent = Toggle

            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Parent = Toggle
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
            ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
            ToggleLabel.Font = Enum.Font.GothamSemibold
            ToggleLabel.Text = text
            ToggleLabel.TextColor3 = Cat.Theme.Text
            ToggleLabel.TextSize = 14
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left

            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Parent = Toggle
            ToggleButton.BackgroundColor3 = default and Cat.Theme.Accent or Cat.Theme.Primary
            ToggleButton.Position = UDim2.new(1, -50, 0.5, -10)
            ToggleButton.Size = UDim2.new(0, 40, 0, 20)
            ToggleButton.Text = ""
            ToggleButton.AutoButtonColor = false

            local ToggleButtonCorner = Instance.new("UICorner")
            ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
            ToggleButtonCorner.Parent = ToggleButton

            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Parent = ToggleButton
            ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleCircle.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            ToggleCircle.Size = UDim2.new(0, 16, 0, 16)

            local ToggleCircleCorner = Instance.new("UICorner")
            ToggleCircleCorner.CornerRadius = UDim.new(1, 0)
            ToggleCircleCorner.Parent = ToggleCircle

            local toggled = default
            ToggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                CreateTween(ToggleButton, {BackgroundColor3 = toggled and Cat.Theme.Accent or Cat.Theme.Primary}):Play()
                CreateTween(ToggleCircle, {Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
                
                if callback then callback(toggled) end
                
                if Cat.Effects.Sound then
                    local sound = Instance.new("Sound")
                    sound.SoundId = "rbxassetid://6895079853"
                    sound.Parent = ToggleButton
                    sound:Play()
                    game.Debris:AddItem(sound, 1)
                end
            end)

            return Toggle
        end

        function Tab:CreateSlider(text, min, max, default, callback)
            local Slider = Instance.new("Frame")
            Slider.Name = text.."Slider"
            Slider.Parent = TabContent
            Slider.BackgroundColor3 = Cat.Theme.Secondary
            Slider.Size = UDim2.new(1, -20, 0, 50)

            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 6)
            SliderCorner.Parent = Slider

            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Parent = Slider
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Position = UDim2.new(0, 10, 0, 0)
            SliderLabel.Size = UDim2.new(1, -20, 0, 25)
            SliderLabel.Font = Enum.Font.GothamSemibold
            SliderLabel.Text = text
            SliderLabel.TextColor3 = Cat.Theme.Text
            SliderLabel.TextSize = 14
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left

            local SliderValue = Instance.new("TextLabel")
            SliderValue.Parent = Slider
            SliderValue.BackgroundTransparency = 1
            SliderValue.Position = UDim2.new(1, -60, 0, 0)
            SliderValue.Size = UDim2.new(0, 50, 0, 25)
            SliderValue.Font = Enum.Font.GothamSemibold
            SliderValue.Text = tostring(default)
            SliderValue.TextColor3 = Cat.Theme.Text
            SliderValue.TextSize = 14


            local SliderBar = Instance.new("Frame")
            SliderBar.Parent = Slider
            SliderBar.BackgroundColor3 = Cat.Theme.Primary
            SliderBar.Position = UDim2.new(0, 10, 0, 35)
            SliderBar.Size = UDim2.new(1, -20, 0, 5)

            local SliderBarCorner = Instance.new("UICorner")
            SliderBarCorner.CornerRadius = UDim.new(1, 0)
            SliderBarCorner.Parent = SliderBar

            local SliderFill = Instance.new("Frame")
            SliderFill.Parent = SliderBar
            SliderFill.BackgroundColor3 = Cat.Theme.Accent
            SliderFill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)

            local SliderFillCorner = Instance.new("UICorner")
            SliderFillCorner.CornerRadius = UDim.new(1, 0)
            SliderFillCorner.Parent = SliderFill

            local SliderButton = Instance.new("TextButton")
            SliderButton.Parent = SliderFill
            SliderButton.AnchorPoint = Vector2.new(1, 0.5)
            SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SliderButton.Position = UDim2.new(1, 0, 0.5, 0)
            SliderButton.Size = UDim2.new(0, 15, 0, 15)
            SliderButton.Text = ""

            local SliderButtonCorner = Instance.new("UICorner")
            SliderButtonCorner.CornerRadius = UDim.new(1, 0)
            SliderButtonCorner.Parent = SliderButton

            local isDragging = false
            SliderButton.MouseButton1Down:Connect(function()
                isDragging = true
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    isDragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement and isDragging then
                    local mousePos = UserInputService:GetMouseLocation().X
                    local sliderPos = SliderBar.AbsolutePosition.X
                    local sliderWidth = SliderBar.AbsoluteSize.X
                    local percent = math.clamp((mousePos - sliderPos) / sliderWidth, 0, 1)
                    local value = math.floor(min + (max - min) * percent)
                    
                    SliderValue.Text = tostring(value)
                    SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                    
                    if callback then callback(value) end
                end
            end)

            return Slider
        end

        -- Add more element types here (Dropdown, Textbox, etc.)

        function Tab:CreateLabel(text)
            local Label = Instance.new("TextLabel")
            Label.Name = text.."Label"
            Label.Parent = TabContent
            Label.BackgroundTransparency = 1
            Label.Size = UDim2.new(1, -20, 0, 30)
            Label.Font = Enum.Font.GothamSemibold
            Label.Text = text
            Label.TextColor3 = Cat.Theme.Text
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left

            return Label
        end

        function Tab:CreateDropdown(text, options, callback)
            local Dropdown = Instance.new("Frame")
            Dropdown.Name = text.."Dropdown"
            Dropdown.Parent = TabContent
            Dropdown.BackgroundColor3 = Cat.Theme.Secondary
            Dropdown.Size = UDim2.new(1, -20, 0, 40)
            Dropdown.ClipsDescendants = true

            local DropdownCorner = Instance.new("UICorner")
            DropdownCorner.CornerRadius = UDim.new(0, 6)
            DropdownCorner.Parent = Dropdown

            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Parent = Dropdown
            DropdownButton.BackgroundTransparency = 1
            DropdownButton.Size = UDim2.new(1, 0, 0, 40)
            DropdownButton.Font = Enum.Font.GothamSemibold
            DropdownButton.Text = text
            DropdownButton.TextColor3 = Cat.Theme.Text
            DropdownButton.TextSize = 14

            local OptionContainer = Instance.new("Frame")
            OptionContainer.Parent = Dropdown
            OptionContainer.BackgroundTransparency = 1
            OptionContainer.Position = UDim2.new(0, 0, 0, 40)
            OptionContainer.Size = UDim2.new(1, 0, 0, #options * 30)
            OptionContainer.Visible = false

            local isOpen = false
            DropdownButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                if isOpen then
                    CreateTween(Dropdown, {Size = UDim2.new(1, -20, 0, 40 + #options * 30)}):Play()
                    OptionContainer.Visible = true
                else
                    CreateTween(Dropdown, {Size = UDim2.new(1, -20, 0, 40)}):Play()
                    OptionContainer.Visible = false
                end
            end)

            for i, option in ipairs(options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Parent = OptionContainer
                OptionButton.BackgroundColor3 = Cat.Theme.Primary
                OptionButton.Position = UDim2.new(0, 0, 0, (i-1) * 30)
                OptionButton.Size = UDim2.new(1, 0, 0, 30)
                OptionButton.Font = Enum.Font.GothamSemibold
                OptionButton.Text = option
                OptionButton.TextColor3 = Cat.Theme.Text
                OptionButton.TextSize = 12

                OptionButton.MouseButton1Click:Connect(function()
                    DropdownButton.Text = text..": "..option
                    CreateTween(Dropdown, {Size = UDim2.new(1, -20, 0, 40)}):Play()
                    OptionContainer.Visible = false
                    isOpen = false
                    if callback then callback(option) end
                end)
            end

            return Dropdown
        end

        return Tab
    end

    -- Make first tab visible by default
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.RightShift then
            Window.Toggled = not Window.Toggled
            Main.Visible = Window.Toggled
        end
    end)

    -- Dragging Functionality
    local dragging
    local dragInput
    local dragStart
    local startPos

    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)

    TopBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    return Window
end

return Cat