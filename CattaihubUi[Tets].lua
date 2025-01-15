
-- Main UI Library Code
local Cat = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Utility Functions
local function CreateTween(instance, properties, duration)
    local tween = TweenService:Create(instance, TweenInfo.new(duration), properties)
    return tween
end

-- Main Window Creator
function Cat:CreateWindow(config)
    config = config or {}
    local window = {
        Title = config.Title or "Cat Hub",
        SubTitle = config.SubTitle or "",
        Size = config.Size or UDim2.fromOffset(580, 460),
        Theme = config.Theme or "Dark",
        Acrylic = (config.Acrylic == nil) and true or config.Acrylic,
        MinimizeKey = config.MinimizeKey or Enum.KeyCode.LeftControl
    }

    -- Main GUI Elements
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local TopBar = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local TabContainer = Instance.new("ScrollingFrame")
    local ContentContainer = Instance.new("Frame")

    -- Setup ScreenGui
    ScreenGui.Name = "CatHub"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Setup MainFrame
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = (window.Theme == "Dark") and Color3.fromRGB(30, 30, 30) or Color3.fromRGB(240, 240, 240)
    MainFrame.Position = UDim2.new(0.5, -window.Size.X.Offset/2, 0.5, -window.Size.Y.Offset/2)
    MainFrame.Size = window.Size
    MainFrame.ClipsDescendants = true

    -- Apply Acrylic Effect if enabled
    if window.Acrylic then
        local blur = Instance.new("BlurEffect")
        blur.Parent = game.Lighting
        blur.Size = 10
    end

    -- Setup TopBar
    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = (window.Theme == "Dark") and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(230, 230, 230)
    TopBar.Size = UDim2.new(1, 0, 0, 30)

    -- Setup Title
    Title.Name = "Title"
    Title.Parent = TopBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = window.Title
    Title.TextColor3 = (window.Theme == "Dark") and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- Setup TabContainer
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = MainFrame
    TabContainer.Position = UDim2.new(0, 0, 0, 30)
    TabContainer.Size = UDim2.new(0, config.TabWidth or 160, 1, -30)
    TabContainer.BackgroundColor3 = (window.Theme == "Dark") and Color3.fromRGB(35, 35, 35) or Color3.fromRGB(235, 235, 235)
    TabContainer.BorderSizePixel = 0
    TabContainer.ScrollBarThickness = 2

    -- Setup ContentContainer
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Parent = MainFrame
    ContentContainer.Position = UDim2.new(0, TabContainer.Size.X.Offset, 0, 30)
    ContentContainer.Size = UDim2.new(1, -TabContainer.Size.X.Offset, 1, -30)
    ContentContainer.BackgroundTransparency = 1

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

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    game:GetService("RunService").RenderStepped:Connect(function()
        if dragging and dragInput then
            updateDrag(dragInput)
        end
    end)

    -- Minimize Functionality
    local minimized = false
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == window.MinimizeKey then
            minimized = not minimized
            local targetSize = minimized and UDim2.new(1, 0, 0, 30) or window.Size
            CreateTween(MainFrame, {Size = targetSize}, 0.3):Play()
        end
    end)

    -- Return window object with methods
    local WindowObject = {}

    function WindowObject:CreateTab(name)
        -- Tab creation logic here
        local tab = {}
        -- Add methods for creating buttons, toggles, sliders, etc.
        return tab
    end

    return WindowObject
end

return Cat