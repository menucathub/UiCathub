
--[[ Cat Hub Premium Library V2 ]]--

local CatHub = {
    Flags = {},
    Theme = {
        Primary = Color3.fromRGB(24, 24, 36),
        Secondary = Color3.fromRGB(32, 32, 48),
        Accent = Color3.fromRGB(96, 76, 244),
        TextColor = Color3.fromRGB(255, 255, 255),
        DarkText = Color3.fromRGB(175, 175, 175),
        
        -- UI Elements
        TopbarColor = Color3.fromRGB(28, 28, 42),
        SidebarColor = Color3.fromRGB(28, 28, 42),
        ContainerColor = Color3.fromRGB(32, 32, 48),
        ElementColor = Color3.fromRGB(36, 36, 54),
        
        -- Special Elements
        SuccessColor = Color3.fromRGB(0, 255, 138),
        WarningColor = Color3.fromRGB(255, 155, 0),
        ErrorColor = Color3.fromRGB(255, 0, 68),
    },
    Hidden = false,
}

-- Services
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

-- Constants
local TWEEN_INFO = TweenInfo.new(0.3, Enum.EasingStyle.Quint)
local SPRING_INFO = {
    OPEN = {damping = 12, frequency = 5},
    CLOSE = {damping = 15, frequency = 6}
}

-- Utility Functions
local function Create(className, properties, children)
    local instance = Instance.new(className)
    
    for k, v in pairs(properties or {}) do
        instance[k] = v
    end
    
    for _, child in pairs(children or {}) do
        child.Parent = instance
    end
    
    return instance
end

local function AddEffect(button)
    local effect = Create("Frame", {
        Name = "Effect",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.8,
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0, 0),
    }, {
        Create("UICorner", {
            CornerRadius = UDim.new(1, 0)
        })
    })
    
    effect.Parent = button
    
    local goal = {}
    goal.Size = UDim2.fromScale(1.5, 1.5)
    goal.BackgroundTransparency = 1
    
    local tween = TweenService:Create(effect, TweenInfo.new(0.5), goal)
    tween:Play()
    
    tween.Completed:Connect(function()
        effect:Destroy()
    end)
end

local function Spring(instance, property, goal, speed, damping, frequency)
    local spring = {
        Instance = instance,
        Property = property,
        Goal = goal,
        Speed = speed or 1,
        Damping = damping or 9,
        Frequency = frequency or 4
    }
    
    local position = instance[property]
    local velocity = 0
    
    RunService:BindToRenderStep(HttpService:GenerateGUID(false), Enum.RenderPriority.Camera.Value, function(delta)
        local displacement = goal - position
        local springForce = displacement * spring.Frequency * spring.Frequency
        local dampingForce = velocity * spring.Damping
        
        local acceleration = (springForce - dampingForce) * delta
        velocity = velocity + acceleration
        
        local newPosition = position + velocity * delta * spring.Speed
        position = newPosition
        
        instance[property] = newPosition
        
        if math.abs(velocity) < 0.001 and math.abs(displacement) < 0.001 then
            RunService:UnbindFromRenderStep(HttpService:GenerateGUID(false))
        end
    end)
end

local function AddCorner(instance, radius)
    return Create("UICorner", {
        CornerRadius = UDim.new(0, radius or 6),
        Parent = instance
    })
end

local function AddStroke(instance, color, thickness)
    return Create("UIStroke", {
        Color = color or CatHub.Theme.Accent,
        Thickness = thickness or 1,
        Parent = instance
    })
end

local function AddBlur(instance)
    local blur = Create("BlurEffect", {
        Size = 0,
        Parent = game:GetService("Lighting")
    })
    
    local goal = {}
    goal.Size = 20
    
    local tween = TweenService:Create(blur, TWEEN_INFO, goal)
    tween:Play()
    
    return blur
end

local function RemoveBlur(blur)
    local goal = {}
    goal.Size = 0
    
    local tween = TweenService:Create(blur, TWEEN_INFO, goal)
    tween:Play()
    
    tween.Completed:Connect(function()
        blur:Destroy()
    end)
end

-- Window Creator
function CatHub.new(config)
    config = config or {}
    config.Title = config.Title or "Cat Hub Premium"
    config.SubTitle = config.SubTitle or "v2.0"
    config.Size = config.Size or UDim2.new(0, 700, 0, 500)
    
    -- Create Main GUI
    local ScreenGui = Create("ScreenGui", {
        Name = "CatHubPremium",
        Parent = CoreGui,
        ResetOnSpawn = false
    })
    
    -- Main Container
    local Container = Create("Frame", {
        Name = "Container",
        Size = config.Size,
        Position = UDim2.new(0.5, -config.Size.X.Offset/2, 0.5, -config.Size.Y.Offset/2),
        BackgroundColor3 = CatHub.Theme.ContainerColor,
        BackgroundTransparency = 0,
        ClipsDescendants = true,
    }, {
        -- Add corner
        Create("UICorner", {
            CornerRadius = UDim.new(0, 8)
        }),
        
        -- Add gradient
        Create("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(230, 230, 230))
            }),
            Rotation = 45,
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.98),
                NumberSequenceKeypoint.new(1, 0.96)
            })
        })
    })
    
    -- Topbar
    local Topbar = Create("Frame", {
        Name = "Topbar",
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = CatHub.Theme.TopbarColor,
        Parent = Container
    }, {
        Create("UICorner", {
            CornerRadius = UDim.new(0, 8)
        })
    })
    
    -- Title
    local Title = Create("TextLabel", {
        Name = "Title",
        Text = config.Title,
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        TextColor3 = CatHub.Theme.TextColor,
        TextSize = 22,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Topbar
    })
    
    -- Subtitle
    local SubTitle = Create("TextLabel", {
        Name = "SubTitle",
        Text = config.SubTitle,
        Size = UDim2.new(0, 100, 1, 0),
        Position = UDim2.new(0, 220, 0, 0),
        BackgroundTransparency = 1,
        TextColor3 = CatHub.Theme.DarkText,
        TextSize = 16,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Topbar
    })
    
    -- Window Controls
    local Controls = Create("Frame", {
        Name = "Controls",
        Size = UDim2.new(0, 150, 1, 0),
        Position = UDim2.new(1, -150, 0, 0),
        BackgroundTransparency = 1,
        Parent = Topbar
    })

    -- Tab System
    local TabList = {}
    local SelectedTab = nil
    
    local function CreateTabButton(name)
        local TabButton = Create("TextButton", {
            Name = name.."Button",
            Size = UDim2.new(1, -10, 0, 40),
            Position = UDim2.new(0, 5, 0, #TabList * 45),
            BackgroundColor3 = CatHub.Theme.ElementColor,
            Text = name,
            TextColor3 = CatHub.Theme.TextColor,
            TextSize = 14,
            Font = Enum.Font.GothamBold,
            AutoButtonColor = false,
            Parent = TabContainer
        })
        
        AddCorner(TabButton, 6)
        
        -- Indicator
        local Indicator = Create("Frame", {
            Name = "Indicator",
            Size = UDim2.new(0, 3, 0.8, 0),
            Position = UDim2.new(0, 0, 0.1, 0),
            BackgroundColor3 = CatHub.Theme.Accent,
            BackgroundTransparency = 1,
            Parent = TabButton
        })
        
        AddCorner(Indicator, 4)
        
        return TabButton
    end
    
    -- Window Methods
    local Window = {}
    
    function Window:AddTab(name)
        local Tab = {}
        
        -- Create Tab Button
        local TabButton = CreateTabButton(name)
        
        -- Create Tab Content
        local TabContent = Create("ScrollingFrame", {
            Name = name.."Content",
            Size = UDim2.new(1, -20, 1, -20),
            Position = UDim2.new(0, 10, 0, 10),
            BackgroundTransparency = 1,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = CatHub.Theme.Accent,
            Visible = false,
            Parent = ContentArea
        })
        
        local UIListLayout = Create("UIListLayout", {
            Padding = UDim.new(0, 10),
            Parent = TabContent
        })
        
        -- Tab Selection
        TabButton.MouseButton1Click:Connect(function()
            if SelectedTab then
                -- Deselect old tab
                TweenService:Create(SelectedTab.Button, TWEEN_INFO, {
                    BackgroundColor3 = CatHub.Theme.ElementColor
                }):Play()
                
                TweenService:Create(SelectedTab.Button.Indicator, TWEEN_INFO, {
                    BackgroundTransparency = 1
                }):Play()
                
                SelectedTab.Content.Visible = false
            end
            
            -- Select new tab
            SelectedTab = {
                Button = TabButton,
                Content = TabContent
            }
            
            TweenService:Create(TabButton, TWEEN_INFO, {
                BackgroundColor3 = CatHub.Theme.Accent
            }):Play()
            
            TweenService:Create(TabButton.Indicator, TWEEN_INFO, {
                BackgroundTransparency = 0
            }):Play()
            
            TabContent.Visible = true
            AddRippleEffect(TabButton)
        end)
        
        -- Element Creation Methods
        function Tab:AddButton(text, callback)
            local Button = Create("TextButton", {
                Name = text.."Button",
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = CatHub.Theme.ElementColor,
                Text = text,
                TextColor3 = CatHub.Theme.TextColor,
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                AutoButtonColor = false,
                Parent = TabContent
            })
            
            AddCorner(Button, 6)
            
            Button.MouseButton1Click:Connect(function()
                AddRippleEffect(Button)
                if callback then callback() end
            end)
            
            return Button
        end
        
        function Tab:AddToggle(text, default, callback)
            local toggle = {Value = default or false}
            
            local Toggle = Create("Frame", {
                Name = text.."Toggle",
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = CatHub.Theme.ElementColor,
                Parent = TabContent
            })
            
            AddCorner(Toggle, 6)
            
            local Title = Create("TextLabel", {
                Text = text,
                Size = UDim2.new(1, -60, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                TextColor3 = CatHub.Theme.TextColor,
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Toggle
            })
            
            local Switch = Create("Frame", {
                Size = UDim2.new(0, 40, 0, 20),
                Position = UDim2.new(1, -50, 0.5, -10),
                BackgroundColor3 = toggle.Value and CatHub.Theme.Accent or CatHub.Theme.ElementColor,
                Parent = Toggle
            })
            
            AddCorner(Switch, 999)
            
            local Knob = Create("Frame", {
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(toggle.Value and 1 or 0, toggle.Value and -18 or 2, 0.5, -8),
                BackgroundColor3 = CatHub.Theme.TextColor,
                Parent = Switch
            })
            
            AddCorner(Knob, 999)
            
            Toggle.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    toggle.Value = not toggle.Value
                    
                    TweenService:Create(Switch, TWEEN_INFO, {
                        BackgroundColor3 = toggle.Value and CatHub.Theme.Accent or CatHub.Theme.ElementColor
                    }):Play()
                    
                    TweenService:Create(Knob, TWEEN_INFO, {
                        Position = UDim2.new(toggle.Value and 1 or 0, toggle.Value and -18 or 2, 0.5, -8)
                    }):Play()
                    
                    AddRippleEffect(Toggle)
                    if callback then callback(toggle.Value) end
                end
            end)
            
            return toggle
        end
        
        function Tab:AddSlider(text, config)
            local slider = {Value = config.default or config.min}
            config.min = config.min or 0
            config.max = config.max or 100
            config.increment = config.increment or 1
            
            local Slider = Create("Frame", {
                Name = text.."Slider",
                Size = UDim2.new(1, 0, 0, 50),
                BackgroundColor3 = CatHub.Theme.ElementColor,
                Parent = TabContent
            })
            
            AddCorner(Slider, 6)
            
            local Title = Create("TextLabel", {
                Text = text,
                Size = UDim2.new(1, -20, 0, 20),
                Position = UDim2.new(0, 10, 0, 5),
                BackgroundTransparency = 1,
                TextColor3 = CatHub.Theme.TextColor,
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Slider
            })
            
            local Value = Create("TextLabel", {
                Text = slider.Value,
                Size = UDim2.new(0, 50, 0, 20),
                Position = UDim2.new(1, -60, 0, 5),
                BackgroundTransparency = 1,
                TextColor3 = CatHub.Theme.DarkText,
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                Parent = Slider
            })
            
            local SliderBar = Create("Frame", {
                Size = UDim2.new(1, -20, 0, 4),
                Position = UDim2.new(0, 10, 0, 35),
                BackgroundColor3 = CatHub.Theme.Secondary,
                Parent = Slider
            })
            
            AddCorner(SliderBar, 999)
            
            local Fill = Create("Frame", {
                Size = UDim2.new((slider.Value - config.min)/(config.max - config.min), 0, 1, 0),
                BackgroundColor3 = CatHub.Theme.Accent,
                Parent = SliderBar
            })
            
            AddCorner(Fill, 999)
            
            -- Slider Functionality
            local dragging = false
            
            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                    local value = math.floor((pos * (config.max - config.min) + config.min) / config.increment) * config.increment
                    
                    slider.Value = value
                    Value.Text = tostring(value)
                    
                    TweenService:Create(Fill, TWEEN_INFO, {
                        Size = UDim2.new(pos, 0, 1, 0)
                    }):Play()
                    
                    if config.callback then config.callback(value) end
                end
            end)
            
            return slider
        end
        
        table.insert(TabList, Tab)
        
        -- Select first tab
        if #TabList == 1 then
            TabButton.MouseButton1Click:Fire()
        end
        
        return Tab
    end
    
    -- Control Button Functionality
    local minimized = false
    local maximized = false
    local originalSize = config.Size
    local originalPos = Container.Position
    
    MinimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        
        TweenService:Create(Container, TWEEN_INFO, {
            Size = minimized and UDim2.new(0, config.Size.X.Offset, 0, 50) or config.Size
        }):Play()
        
        ContentArea.Visible = not minimized
        Sidebar.Visible = not minimized
        AddRippleEffect(MinimizeBtn)
    end)
    
    MaximizeBtn.MouseButton1Click:Connect(function()
        maximized = not maximized
        
        if maximized then
            originalSize = Container.Size
            originalPos = Container.Position
            
            TweenService:Create(Container, TWEEN_INFO, {
                Size = UDim2.new(1, -10, 1, -10),
                Position = UDim2.new(0, 5, 0, 5)
            }):Play()
        else
            TweenService:Create(Container, TWEEN_INFO, {
                Size = originalSize,
                Position = originalPos
            }):Play()
        end
        
        AddRippleEffect(MaximizeBtn)
    end)
    
    CloseBtn.MouseButton1Click:Connect(function()
        AddRippleEffect(CloseBtn)
        TweenService:Create(Container, TWEEN_INFO, {
            Size = UDim2.new(0, Container.Size.X.Offset, 0, 0),
            Position = UDim2.new(Container.Position.X.Scale, Container.Position.X.Offset, 
                Container.Position.Y.Scale, Container.Position.Y.Offset + Container.Size.Y.Offset/2)
        }):Play()
        wait(0.3)
        ScreenGui:Destroy()
    end)
    
    -- Make window draggable
    local dragging = false
    local dragInput, dragStart, startPos
    
    Topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Container.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Container.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, 
                startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    return Window
end

return CatHub