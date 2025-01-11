local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")

-- Constants
local THEME = {
    Background = Color3.fromRGB(25, 25, 25),
    DarkContrast = Color3.fromRGB(15, 15, 15), 
    LightContrast = Color3.fromRGB(35, 35, 35),
    TextColor = Color3.fromRGB(255, 255, 255),
    AccentColor = Color3.fromRGB(0, 255, 149),
    DarkAccent = Color3.fromRGB(0, 210, 123),
    OutlineColor = Color3.fromRGB(50, 50, 50),
    DefaultFont = Enum.Font.GothamBold
}

-- Utility Functions
local function CreateTween(instance, properties, duration, style, direction)
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(
            duration or 0.3,
            style or Enum.EasingStyle.Quart,
            direction or Enum.EasingDirection.Out
        ),
        properties
    )
    return tween
end

local function AddRippleEffect(button)
    local ripple = Instance.new("Frame")
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.75
    ripple.BorderSizePixel = 0
    ripple.ZIndex = button.ZIndex + 1
    ripple.Parent = button
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    
    local rippleEffect = Instance.new("UICorner")
    rippleEffect.CornerRadius = UDim.new(1, 0)
    rippleEffect.Parent = ripple
    
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            ripple.Position = UDim2.new(0, input.Position.X - button.AbsolutePosition.X, 0, input.Position.Y - button.AbsolutePosition.Y)
            ripple.Size = UDim2.new(0, 0, 0, 0)
            
            local buttonSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y)
            local rippleSize = UDim2.new(0, buttonSize * 2, 0, buttonSize * 2)
            
            local growTween = CreateTween(ripple, {Size = rippleSize, Position = UDim2.new(0.5, -buttonSize, 0.5, -buttonSize)}, 0.5)
            local fadeTween = CreateTween(ripple, {BackgroundTransparency = 1}, 0.5)
            
            growTween:Play()
            fadeTween:Play()
            
            fadeTween.Completed:Connect(function()
                ripple:Destroy()
            end)
        end
    end)
end

local function AddGlowEffect(button)
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://4996891970" -- Glow texture
    glow.ImageColor3 = THEME.AccentColor
    glow.ImageTransparency = 0.5
    glow.Size = UDim2.new(1.5, 0, 1.5, 0)
    glow.Position = UDim2.new(-0.25, 0, -0.25, 0)
    glow.ZIndex = button.ZIndex - 1
    glow.Parent = button
end

-- Main Library
local CatTaiLib = {}

function CatTaiLib:CreateWindow(config)
    local windowConfig = config or {}
    local windowName = windowConfig.Name or "Cat Tai Hub"
    
    -- Main GUI Creation
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CatTaiHubV2"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Container
    local MainContainer = Instance.new("Frame")
    MainContainer.Name = "MainContainer"
    MainContainer.Parent = ScreenGui
    MainContainer.BackgroundColor3 = THEME.Background
    MainContainer.Position = UDim2.new(0.5, -300, 0.5, -200)
    MainContainer.Size = UDim2.new(0, 600, 0, 400)
    MainContainer.ClipsDescendants = true
    MainContainer.AnchorPoint = Vector2.new(0.5, 0.5)
    
    -- Add smooth shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Parent = MainContainer
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Shadow.Size = UDim2.new(1, 47, 1, 47)
    Shadow.ZIndex = 0
    Shadow.Image = "rbxassetid://6015897843"
    Shadow.ImageColor3 = Color3.new(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    
    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Parent = MainContainer
    TopBar.BackgroundColor3 = THEME.DarkContrast
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = TopBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Font = THEME.DefaultFont
    Title.Text = windowName
    Title.TextColor3 = THEME.TextColor
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Close Button with animation
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = TopBar
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -35, 0, 0)
    CloseButton.Size = UDim2.new(0, 35, 1, 0)
    CloseButton.Font = THEME.DefaultFont
    CloseButton.Text = "×"
    CloseButton.TextColor3 = THEME.TextColor
    CloseButton.TextSize = 25
    
    CloseButton.MouseEnter:Connect(function()
        CreateTween(CloseButton, {TextColor3 = Color3.fromRGB(255, 75, 75)}, 0.2):Play()
    end)
    
    CloseButton.MouseLeave:Connect(function()
        CreateTween(CloseButton, {TextColor3 = THEME.TextColor}, 0.2):Play()
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        CreateTween(MainContainer, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.5):Play()
        wait(0.5)
        ScreenGui:Destroy()
    end)
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Parent = MainContainer
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 0, 0, 35)
    ContentContainer.Size = UDim2.new(1, 0, 1, -35)
    
    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = ContentContainer
    TabContainer.BackgroundColor3 = THEME.DarkContrast
    TabContainer.Size = UDim2.new(0, 150, 1, 0)
    
    local TabList = Instance.new("ScrollingFrame")
    TabList.Name = "TabList"
    TabList.Parent = TabContainer
    TabList.BackgroundTransparency = 1
    TabList.Size = UDim2.new(1, 0, 1, 0)
    TabList.ScrollBarThickness = 2
    TabList.ScrollBarImageColor3 = THEME.AccentColor
    
    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Parent = TabList
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 5)
    
    -- Tab Content Area
    local TabContentArea = Instance.new("Frame")
    TabContentArea.Name = "TabContentArea"
    TabContentArea.Parent = ContentContainer
    TabContentArea.BackgroundTransparency = 1
    TabContentArea.Position = UDim2.new(0, 150, 0, 0)
    TabContentArea.Size = UDim2.new(1, -150, 1, 0)
    local window = {}
    
    -- Tab Creation Function with Enhanced Animations
    function window:CreateTab(config)
        local tabName = config.Name or "New Tab"
        local tabIcon = config.Icon or "rbxassetid://8559790237"
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName.."Tab"
        TabButton.Parent = TabList
        TabButton.BackgroundColor3 = THEME.LightContrast
        TabButton.Size = UDim2.new(1, -10, 0, 40)
        TabButton.Position = UDim2.new(0, 5, 0, 0)
        TabButton.AutoButtonColor = false
        TabButton.Font = THEME.DefaultFont
        TabButton.TextSize = 14
        TabButton.TextColor3 = THEME.TextColor
        TabButton.BackgroundTransparency = 0.5
        
        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 6)
        UICorner.Parent = TabButton
        
        -- Tab Icon
        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Name = "Icon"
        TabIcon.Parent = TabButton
        TabIcon.BackgroundTransparency = 1
        TabIcon.Position = UDim2.new(0, 8, 0.5, -12)
        TabIcon.Size = UDim2.new(0, 24, 0, 24)
        TabIcon.Image = tabIcon
        TabIcon.ImageColor3 = THEME.TextColor
        
        -- Tab Title
        local TabTitle = Instance.new("TextLabel")
        TabTitle.Name = "Title"
        TabTitle.Parent = TabButton
        TabTitle.BackgroundTransparency = 1
        TabTitle.Position = UDim2.new(0, 40, 0, 0)
        TabTitle.Size = UDim2.new(1, -40, 1, 0)
        TabTitle.Font = THEME.DefaultFont
        TabTitle.Text = tabName
        TabTitle.TextColor3 = THEME.TextColor
        TabTitle.TextSize = 14
        TabTitle.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabName.."Content"
        TabContent.Parent = TabContentArea
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.ScrollBarThickness = 2
        TabContent.ScrollBarImageColor3 = THEME.AccentColor
        TabContent.Visible = false
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Parent = TabContent
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Padding = UDim.new(0, 8)
        
        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.Parent = TabContent
        ContentPadding.PaddingLeft = UDim.new(0, 10)
        ContentPadding.PaddingRight = UDim.new(0, 10)
        ContentPadding.PaddingTop = UDim.new(0, 10)
        
        -- Tab Selection Effect
        local function selectTab()
            for _, button in pairs(TabList:GetChildren()) do
                if button:IsA("TextButton") then
                    CreateTween(button, {BackgroundTransparency = 0.5}, 0.2):Play()
                    CreateTween(button.Icon, {ImageColor3 = THEME.TextColor}, 0.2):Play()
                end
            end
            
            for _, content in pairs(TabContentArea:GetChildren()) do
                if content:IsA("ScrollingFrame") then
                    content.Visible = false
                end
            end
            
            CreateTween(TabButton, {BackgroundTransparency = 0}, 0.2):Play()
            CreateTween(TabIcon, {ImageColor3 = THEME.AccentColor}, 0.2):Play()
            TabContent.Visible = true
            
            -- Add Tab Select Animation
            local selectEffect = Instance.new("Frame")
            selectEffect.Name = "SelectEffect"
            selectEffect.Parent = TabButton
            selectEffect.BackgroundColor3 = THEME.AccentColor
            selectEffect.Size = UDim2.new(0, 2, 0, 0)
            selectEffect.Position = UDim2.new(0, -1, 0.5, 0)
            selectEffect.AnchorPoint = Vector2.new(0, 0.5)
            
            CreateTween(selectEffect, {Size = UDim2.new(0, 2, 1, 0)}, 0.2):Play()
        end
        
        TabButton.MouseButton1Click:Connect(selectTab)
        
        -- Select first tab by default
        if #TabList:GetChildren() == 1 then
            selectTab()
        end
        
        -- Tab Content Functions
        local tab = {}
        
        -- Create Section
        function tab:CreateSection(name)
            local Section = Instance.new("Frame")
            Section.Name = name.."Section"
            Section.Parent = TabContent
            Section.BackgroundColor3 = THEME.LightContrast
            Section.Size = UDim2.new(1, 0, 0, 40)
            
            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(0, 6)
            UICorner.Parent = Section
            
            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = "Title"
            SectionTitle.Parent = Section
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Position = UDim2.new(0, 15, 0, 0)
            SectionTitle.Size = UDim2.new(1, -30, 1, 0)
            SectionTitle.Font = THEME.DefaultFont
            SectionTitle.Text = name
            SectionTitle.TextColor3 = THEME.TextColor
            SectionTitle.TextSize = 16
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            return Section
        end
        
        -- Create Button with Animation
        function tab:CreateButton(config)
            local ButtonFrame = Instance.new("Frame")
            ButtonFrame.Name = "ButtonFrame"
            ButtonFrame.Parent = TabContent
            ButtonFrame.BackgroundTransparency = 1
            ButtonFrame.Size = UDim2.new(1, 0, 0, 35)
            
            local Button = Instance.new("TextButton")
            Button.Name = "Button"
            Button.Parent = ButtonFrame
            Button.BackgroundColor3 = THEME.LightContrast
            Button.Size = UDim2.new(1, 0, 1, 0)
            Button.AutoButtonColor = false
            Button.Font = THEME.DefaultFont
            Button.TextColor3 = THEME.TextColor
            Button.TextSize = 14
            Button.Text = config.Name or "Button"
            
            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(0, 6)
            UICorner.Parent = Button
            
            -- Add Ripple Effect
            AddRippleEffect(Button)
            
            -- Button Hover & Click Effects
            Button.MouseEnter:Connect(function()
                CreateTween(Button, {BackgroundColor3 = THEME.DarkAccent}, 0.2):Play()
            end)
            
            Button.MouseLeave:Connect(function()
                CreateTween(Button, {BackgroundColor3 = THEME.LightContrast}, 0.2):Play()
            end)
            
            Button.MouseButton1Down:Connect(function()
                CreateTween(Button, {Size = UDim2.new(0.97, 0, 0.97, 0)}, 0.1):Play()
            end)
            
            Button.MouseButton1Up:Connect(function()
                CreateTween(Button, {Size = UDim2.new(1, 0, 1, 0)}, 0.1):Play()
                if config.Callback then
                    config.Callback()
                end
            end)
            
            return Button
        end
           function tab:CreateToggle(config)
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = "ToggleFrame"
            ToggleFrame.Parent = TabContent
            ToggleFrame.BackgroundTransparency = 1
            ToggleFrame.Size = UDim2.new(1, 0, 0, 35)

            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Name = "ToggleButton"
            ToggleButton.Parent = ToggleFrame
            ToggleButton.BackgroundColor3 = THEME.LightContrast
            ToggleButton.Size = UDim2.new(1, 0, 1, 0)
            ToggleButton.AutoButtonColor = false
            ToggleButton.Font = THEME.DefaultFont
            ToggleButton.Text = ""

            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(0, 6)
            UICorner.Parent = ToggleButton

            local Title = Instance.new("TextLabel")
            Title.Name = "Title"
            Title.Parent = ToggleButton
            Title.BackgroundTransparency = 1
            Title.Position = UDim2.new(0, 15, 0, 0)
            Title.Size = UDim2.new(1, -65, 1, 0)
            Title.Font = THEME.DefaultFont
            Title.Text = config.Name or "Toggle"
            Title.TextColor3 = THEME.TextColor
            Title.TextSize = 14
            Title.TextXAlignment = Enum.TextXAlignment.Left

            -- Create Toggle Indicator
            local ToggleIndicator = Instance.new("Frame")
            ToggleIndicator.Name = "Indicator"
            ToggleIndicator.Parent = ToggleButton
            ToggleIndicator.AnchorPoint = Vector2.new(0, 0.5)
            ToggleIndicator.BackgroundColor3 = THEME.DarkContrast
            ToggleIndicator.Position = UDim2.new(1, -45, 0.5, 0)
            ToggleIndicator.Size = UDim2.new(0, 35, 0, 18)

            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(1, 0)
            UICorner.Parent = ToggleIndicator

            local Circle = Instance.new("Frame")
            Circle.Name = "Circle"
            Circle.Parent = ToggleIndicator
            Circle.AnchorPoint = Vector2.new(0, 0.5)
            Circle.BackgroundColor3 = THEME.TextColor
            Circle.Position = UDim2.new(0, 2, 0.5, 0)
            Circle.Size = UDim2.new(0, 14, 0, 14)

            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(1, 0)
            UICorner.Parent = Circle

            -- Add Glow Effect
            AddGlowEffect(ToggleIndicator)

            -- Toggle Logic
            local toggled = config.Default or false
            local function updateToggle()
                if toggled then
                    CreateTween(Circle, {Position = UDim2.new(1, -16, 0.5, 0)}, 0.2):Play()
                    CreateTween(ToggleIndicator, {BackgroundColor3 = THEME.AccentColor}, 0.2):Play()
                    CreateTween(Circle, {BackgroundColor3 = THEME.TextColor}, 0.2):Play()
                else
                    CreateTween(Circle, {Position = UDim2.new(0, 2, 0.5, 0)}, 0.2):Play()
                    CreateTween(ToggleIndicator, {BackgroundColor3 = THEME.DarkContrast}, 0.2):Play()
                    CreateTween(Circle, {BackgroundColor3 = THEME.TextColor}, 0.2):Play()
                end
                
                if config.Callback then
                    config.Callback(toggled)
                end
            end

            ToggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                updateToggle()
            end)

            -- Initialize toggle state
            updateToggle()

            -- Hover Effect
            ToggleButton.MouseEnter:Connect(function()
                CreateTween(ToggleButton, {BackgroundColor3 = THEME.AccentColor}, 0.2):Play()
            end)

            ToggleButton.MouseLeave:Connect(function()
                CreateTween(ToggleButton, {BackgroundColor3 = THEME.LightContrast}, 0.2):Play()
            end)

            return {
                Set = function(value)
                    toggled = value
                    updateToggle()
                end
            }
        end

        -- Create Slider with Smooth Animation
        function tab:CreateSlider(config)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = "SliderFrame"
            SliderFrame.Parent = TabContent
            SliderFrame.BackgroundTransparency = 1
            SliderFrame.Size = UDim2.new(1, 0, 0, 55)

            local SliderTitle = Instance.new("TextLabel")
            SliderTitle.Name = "Title"
            SliderTitle.Parent = SliderFrame
            SliderTitle.BackgroundTransparency = 1
            SliderTitle.Position = UDim2.new(0, 0, 0, 0)
            SliderTitle.Size = UDim2.new(1, 0, 0, 25)
            SliderTitle.Font = THEME.DefaultFont
            SliderTitle.Text = config.Name or "Slider"
            SliderTitle.TextColor3 = THEME.TextColor
            SliderTitle.TextSize = 14
            SliderTitle.TextXAlignment = Enum.TextXAlignment.Left

            local ValueDisplay = Instance.new("TextLabel")
            ValueDisplay.Name = "Value"
            ValueDisplay.Parent = SliderFrame
            ValueDisplay.BackgroundTransparency = 1
            ValueDisplay.Position = UDim2.new(1, -50, 0, 0)
            ValueDisplay.Size = UDim2.new(0, 50, 0, 25)
            ValueDisplay.Font = THEME.DefaultFont
            ValueDisplay.Text = tostring(config.Default or config.Min)
            ValueDisplay.TextColor3 = THEME.TextColor
            ValueDisplay.TextSize = 14

            local SliderContainer = Instance.new("Frame")
            SliderContainer.Name = "SliderContainer"
            SliderContainer.Parent = SliderFrame
            SliderContainer.BackgroundColor3 = THEME.DarkContrast
            SliderContainer.Position = UDim2.new(0, 0, 0, 30)
            SliderContainer.Size = UDim2.new(1, 0, 0, 6)

            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(1, 0)
            UICorner.Parent = SliderContainer

            local SliderFill = Instance.new("Frame")
            SliderFill.Name = "Fill"
            SliderFill.Parent = SliderContainer
            SliderFill.BackgroundColor3 = THEME.AccentColor
            SliderFill.Size = UDim2.new(0, 0, 1, 0)

            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(1, 0)
            UICorner.Parent = SliderFill

            local SliderDot = Instance.new("Frame")
            SliderDot.Name = "Dot"
            SliderDot.Parent = SliderFill
            SliderDot.AnchorPoint = Vector2.new(0.5, 0.5)
            SliderDot.BackgroundColor3 = THEME.TextColor
            SliderDot.Position = UDim2.new(1, 0, 0.5, 0)
            SliderDot.Size = UDim2.new(0, 12, 0, 12)

            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(1, 0)
            UICorner.Parent = SliderDot

            -- Add Glow to Slider Dot
            AddGlowEffect(SliderDot)

            -- Slider Logic
            local MinValue = config.Min or 0
            local MaxValue = config.Max or 100
            local DefaultValue = math.clamp(config.Default or MinValue, MinValue, MaxValue)

            local function UpdateSlider(value)
                value = math.clamp(value, MinValue, MaxValue)
                local percent = (value - MinValue) / (MaxValue - MinValue)
                
                CreateTween(SliderFill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.1):Play()
                ValueDisplay.Text = string.format("%.0f", value)
                
                if config.Callback then
                    config.Callback(value)
                end
            end

            -- Slider Drag Functionality
            local dragging = false

            SliderContainer.InputBegan:Connect(function(input)
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
                    local percent = math.clamp((input.Position.X - SliderContainer.AbsolutePosition.X) / SliderContainer.AbsoluteSize.X, 0, 1)
                    local value = MinValue + ((MaxValue - MinValue) * percent)
                    UpdateSlider(value)
                end
            end)

            -- Initialize slider
            UpdateSlider(DefaultValue)

            return {
                Set = function(value)
                    UpdateSlider(value)
                end
            }
        end
        function tab:CreateDropdown(config)
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Name = "DropdownFrame"
            DropdownFrame.Parent = TabContent
            DropdownFrame.BackgroundTransparency = 1
            DropdownFrame.Size = UDim2.new(1, 0, 0, 35)
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Name = "DropdownButton"
            DropdownButton.Parent = DropdownFrame
            DropdownButton.BackgroundColor3 = THEME.LightContrast
            DropdownButton.Size = UDim2.new(1, 0, 0, 35)
            DropdownButton.AutoButtonColor = false
            DropdownButton.Font = THEME.DefaultFont
            DropdownButton.Text = ""
            
            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(0, 6)
            UICorner.Parent = DropdownButton
            
            local Title = Instance.new("TextLabel")
            Title.Name = "Title"
            Title.Parent = DropdownButton
            Title.BackgroundTransparency = 1
            Title.Position = UDim2.new(0, 15, 0, 0)
            Title.Size = UDim2.new(1, -35, 1, 0)
            Title.Font = THEME.DefaultFont
            Title.Text = config.Name or "Dropdown"
            Title.TextColor3 = THEME.TextColor
            Title.TextSize = 14
            Title.TextXAlignment = Enum.TextXAlignment.Left
            
            local Arrow = Instance.new("ImageLabel")
            Arrow.Name = "Arrow"
            Arrow.Parent = DropdownButton
            Arrow.AnchorPoint = Vector2.new(1, 0.5)
            Arrow.BackgroundTransparency = 1
            Arrow.Position = UDim2.new(1, -10, 0.5, 0)
            Arrow.Size = UDim2.new(0, 15, 0, 15)
            Arrow.Image = "rbxassetid://6034818372"
            Arrow.ImageColor3 = THEME.AccentColor
            
            local OptionsFrame = Instance.new("Frame")
            OptionsFrame.Name = "Options"
            OptionsFrame.Parent = DropdownFrame
            OptionsFrame.BackgroundColor3 = THEME.LightContrast
            OptionsFrame.Position = UDim2.new(0, 0, 0, 40)
            OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
            OptionsFrame.ClipsDescendants = true
            OptionsFrame.Visible = false
            
            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(0, 6)
            UICorner.Parent = OptionsFrame
            
            local OptionsList = Instance.new("ScrollingFrame")
            OptionsList.Name = "List"
            OptionsList.Parent = OptionsFrame
            OptionsList.BackgroundTransparency = 1
            OptionsList.Size = UDim2.new(1, 0, 1, 0)
            OptionsList.ScrollBarThickness = 2
            OptionsList.ScrollBarImageColor3 = THEME.AccentColor
            
            local UIListLayout = Instance.new("UIListLayout")
            UIListLayout.Parent = OptionsList
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout.Padding = UDim.new(0, 5)
            
            local UIPadding = Instance.new("UIPadding")
            UIPadding.Parent = OptionsList
            UIPadding.PaddingTop = UDim.new(0, 5)
            UIPadding.PaddingBottom = UDim.new(0, 5)
            
            -- Dropdown Logic
            local open = false
            local selected = config.Default or ""
            
            local function toggleDropdown()
                open = not open
                if open then
                    CreateTween(Arrow, {Rotation = 180}, 0.2):Play()
                    OptionsFrame.Visible = true
                    CreateTween(OptionsFrame, {Size = UDim2.new(1, 0, 0, math.min(#config.Options * 30, 150))}, 0.2):Play()
                else
                    CreateTween(Arrow, {Rotation = 0}, 0.2):Play()
                    CreateTween(OptionsFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.2).Completed:Connect(function()
                        OptionsFrame.Visible = false
                    end)
                end
            end

            DropdownButton.MouseButton1Click:Connect(toggleDropdown)
            
            -- Create Options
            for _, option in ipairs(config.Options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Name = option
                OptionButton.Parent = OptionsList
                OptionButton.BackgroundColor3 = THEME.DarkContrast
                OptionButton.Size = UDim2.new(1, -10, 0, 25)
                OptionButton.Position = UDim2.new(0, 5, 0, 0)
                OptionButton.Font = THEME.DefaultFont
                OptionButton.Text = option
                OptionButton.TextColor3 = THEME.TextColor
                OptionButton.TextSize = 14
                OptionButton.AutoButtonColor = false
                
                local UICorner = Instance.new("UICorner")
                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = OptionButton
                
                OptionButton.MouseEnter:Connect(function()
                    CreateTween(OptionButton, {BackgroundColor3 = THEME.AccentColor}, 0.2):Play()
                end)
                
                OptionButton.MouseLeave:Connect(function()
                    CreateTween(OptionButton, {BackgroundColor3 = THEME.DarkContrast}, 0.2):Play()
                end)
                
                OptionButton.MouseButton1Click:Connect(function()
                    selected = option
                    Title.Text = config.Name .. ": " .. selected
                    toggleDropdown()
                    if config.Callback then
                        config.Callback(selected)
                    end
                end)
            end
            
            -- Set default value
            if selected ~= "" then
                Title.Text = config.Name .. ": " .. selected
            end
            
            return {
                Set = function(value)
                    selected = value
                    Title.Text = config.Name .. ": " .. selected
                    if config.Callback then
                        config.Callback(selected)
                    end
                end
            }
        end
        
        -- Create ColorPicker
        function tab:CreateColorPicker(config)
            local ColorPickerFrame = Instance.new("Frame")
            ColorPickerFrame.Name = "ColorPickerFrame"
            ColorPickerFrame.Parent = TabContent
            ColorPickerFrame.BackgroundColor3 = THEME.LightContrast
            ColorPickerFrame.Size = UDim2.new(1, 0, 0, 35)
            
            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(0, 6)
            UICorner.Parent = ColorPickerFrame
            
            local Title = Instance.new("TextLabel")
            Title.Name = "Title"
            Title.Parent = ColorPickerFrame
            Title.BackgroundTransparency = 1
            Title.Position = UDim2.new(0, 15, 0, 0)
            Title.Size = UDim2.new(1, -55, 1, 0)
            Title.Font = THEME.DefaultFont
            Title.Text = config.Name or "ColorPicker"
            Title.TextColor3 = THEME.TextColor
            Title.TextSize = 14
            Title.TextXAlignment = Enum.TextXAlignment.Left
            
            local Preview = Instance.new("Frame")
            Preview.Name = "Preview"
            Preview.Parent = ColorPickerFrame
            Preview.AnchorPoint = Vector2.new(1, 0.5)
            Preview.BackgroundColor3 = config.Default or Color3.fromRGB(255, 255, 255)
            Preview.Position = UDim2.new(1, -10, 0.5, 0)
            Preview.Size = UDim2.new(0, 30, 0, 30)
            
            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(0, 6)
            UICorner.Parent = Preview
            
            -- ColorPicker Window
            local PickerWindow = Instance.new("Frame")
            PickerWindow.Name = "PickerWindow"
            PickerWindow.Parent = ColorPickerFrame
            PickerWindow.BackgroundColor3 = THEME.Background
            PickerWindow.Position = UDim2.new(1, 10, 0, 0)
            PickerWindow.Size = UDim2.new(0, 200, 0, 220)
            PickerWindow.Visible = false
            PickerWindow.ZIndex = 5
            
            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(0, 6)
            UICorner.Parent = PickerWindow
            
            -- Add color picker content here
            -- (HSV color wheel, sliders, etc.)
            
            local open = false
            Preview.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    open = not open
                    PickerWindow.Visible = open
                end
            end)
            
            return {
                Set = function(color)
                    Preview.BackgroundColor3 = color
                    if config.Callback then
                        config.Callback(color)
                    end
                end
            }
        end
        
        -- Create Notification System
        function window:CreateNotification(config)
            local NotifFrame = Instance.new("Frame")
            NotifFrame.Name = "Notification"
            NotifFrame.Parent = ScreenGui
            NotifFrame.BackgroundColor3 = THEME.Background
            NotifFrame.Position = UDim2.new(1, 20, 1, -90)
            NotifFrame.Size = UDim2.new(0, 300, 0, 80)
            NotifFrame.AnchorPoint = Vector2.new(1, 1)
            
            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(0, 10)
            UICorner.Parent = NotifFrame
            
            local Title = Instance.new("TextLabel")
            Title.Name = "Title"
            Title.Parent = NotifFrame
            Title.BackgroundTransparency = 1
            Title.Position = UDim2.new(0, 15, 0, 10)
            Title.Size = UDim2.new(1, -30, 0, 20)
            Title.Font = THEME.DefaultFont
            Title.Text = config.Title or "Notification"
            Title.TextColor3 = THEME.AccentColor
            Title.TextSize = 16
            Title.TextXAlignment = Enum.TextXAlignment.Left
            
            local Content = Instance.new("TextLabel")
            Content.Name = "Content"
            Content.Parent = NotifFrame
            Content.BackgroundTransparency = 1
            Content.Position = UDim2.new(0, 15, 0, 35)
            Content.Size = UDim2.new(1, -30, 0, 35)
            Content.Font = THEME.DefaultFont
            Content.Text = config.Content or ""
            Content.TextColor3 = THEME.TextColor
            Content.TextSize = 14
            Content.TextWrapped = true
            Content.TextXAlignment = Enum.TextXAlignment.Left
            
            -- Add progress bar
            local ProgressBar = Instance.new("Frame")
            ProgressBar.Name = "Progress"
            ProgressBar.Parent = NotifFrame
            ProgressBar.BackgroundColor3 = THEME.AccentColor
            ProgressBar.Position = UDim2.new(0, 0, 1, -2)
            ProgressBar.Size = UDim2.new(1, 0, 0, 2)
            
            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(1, 0)
            UICorner.Parent = ProgressBar
            
            -- Animation
            CreateTween(NotifFrame, {Position = UDim2.new(1, -20, 1, -90)}, 0.5):Play()
            
            wait(0.5)
            
            CreateTween(ProgressBar, {Size = UDim2.new(0, 0, 0, 2)}, config.Duration or 3):Play()
            
            wait(config.Duration or 3)
            
            CreateTween(NotifFrame, {Position = UDim2.new(1, 320, 1, -90)}, 0.5):Play()
            
            game:GetService("Debris"):AddItem(NotifFrame, 0.5)
        end
        
        return tab
    end
    
    -- Initialize first tab
    if config.DefaultTab then
        window:CreateTab({Name = config.DefaultTab})
    end
    
    return window
end

-- Example usage:
--[[
local UI = CatTaiLib:CreateWindow({
    Name = "Cắt Tai Hub",
    DefaultTab = "Main"
})

local MainTab = UI:CreateTab({Name = "Main"})

MainTab:CreateButton({
    Name = "Click Me",
    Callback = function()
        print("Button clicked!")
    end
})

MainTab:CreateToggle({
    Name = "Toggle Me",
    Default = false,
    Callback = function(Value)
        print("Toggle:", Value)
    end
})

MainTab:CreateSlider({
    Name = "Slider",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(Value)
        print("Slider:", Value)
    end
})

MainTab:CreateDropdown({
    Name = "Dropdown",
    Options = {"Option 1", "Option 2", "Option 3"},
    Default = "Option 1",
    Callback = function(Selected)
        print("Selected:", Selected)
    end
})

UI:CreateNotification({
    Title = "Notification",
    Content = "This is a test notification",
    Duration = 3
})
]]

return CatTaiLib