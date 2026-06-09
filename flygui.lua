local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Prevent Stacking: Destroy older instance if it exists before running
if CoreGui:FindFirstChild("FlyGui") then
    CoreGui.FlyGui:Destroy()
end

local Library = {}
Library.__index = Library

local Section = {}
Section.__index = Section

-- Clean Dragging Engine Utility
local function MakeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function Library.new(hubTitle, hubVersion)
    local self = setmetatable({}, Library)
    
    self.CurrentSection = nil
    self.SectionsList = {}
    self.Toggled = true

    -- FlyGui Base Screen Container
    self.FlyGui = Instance.new("ScreenGui")
    self.FlyGui.Name = "FlyGui"
    self.FlyGui.Parent = CoreGui
    self.FlyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Main Presentation Canvas Frame
    self.Canvas = Instance.new("Frame")
    self.Canvas.Name = "Canvas"
    self.Canvas.Parent = self.FlyGui
    self.Canvas.AnchorPoint = Vector2.new(0.5, 0.5)
    self.Canvas.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    self.Canvas.BackgroundTransparency = 1.000
    self.Canvas.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.Canvas.Size = UDim2.new(1, 0, 1, 0)

    -- Left Control Sidebar Frame Layout (Preserving exact layout coordinates from your file)
    self.Left = Instance.new("Frame")
    self.Left.Name = "Left"
    self.Left.Parent = self.Canvas
    self.Left.AnchorPoint = Vector2.new(0, 0.5)
    self.Left.BackgroundColor3 = Color3.fromRGB(255, 0, 4)
    self.Left.BackgroundTransparency = 1.000
    self.Left.Position = UDim2.new(0, 0, 0.499566346, 0)
    self.Left.Size = UDim2.new(0.257129937, 0, 1, 0)
    MakeDraggable(self.Left)

    local UIAspectRatioConstraint_4 = Instance.new("UIAspectRatioConstraint")
    UIAspectRatioConstraint_4.Parent = self.Left
    UIAspectRatioConstraint_4.AspectRatio = 0.493

    -- Brand Header Banner Frame Panel
    local Title = Instance.new("ImageLabel")
    Title.Name = "Title"
    Title.Parent = self.Left
    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1.000
    Title.Position = UDim2.new(0.0193661973, 0, 0.0858629644, 0)
    Title.Size = UDim2.new(0.883802712, 0, 0.0641803965, 0)
    Title.ZIndex = 2
    Title.Image = "rbxassetid://93575451903318"

    local PinkTheme = Instance.new("UIGradient")
    PinkTheme.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 251)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 148, 255))}
    PinkTheme.Rotation = 90
    PinkTheme.Parent = Title

    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
    UIAspectRatioConstraint.Parent = Title
    UIAspectRatioConstraint.AspectRatio = 6.784

    -- Title Brand Label
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Parent = Title
    TitleLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    TitleLabel.BackgroundTransparency = 1.000
    TitleLabel.Position = UDim2.new(0.37649402, 0, 0.493243247, 0)
    TitleLabel.Size = UDim2.new(0.464143425, 0, 0.82432431, 0)
    TitleLabel.Font = Enum.Font.FredokaOne
    TitleLabel.Text = hubTitle or "Fly"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextScaled = true
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
    UITextSizeConstraint.Parent = TitleLabel
    UITextSizeConstraint.MaxTextSize = 61

    -- Hub Version Label
    local VersionLabel = Instance.new("TextLabel")
    VersionLabel.Name = "VersionLabel"
    VersionLabel.Parent = Title
    VersionLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    VersionLabel.BackgroundTransparency = 1.000
    VersionLabel.Position = UDim2.new(0.585657358, 0, 0.668918908, 0)
    VersionLabel.Size = UDim2.new(0.464143425, 0, 0.472972959, 0)
    VersionLabel.Font = Enum.Font.Cartoon
    VersionLabel.Text = hubVersion or "v1.1"
    VersionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    VersionLabel.TextScaled = true
    VersionLabel.TextXAlignment = Enum.TextXAlignment.Right

    -- Primary Navigation Menu Frame Holder
    self.MainMenu = Instance.new("Frame")
    self.MainMenu.Name = "MainMenu"
    self.MainMenu.Parent = self.Left
    self.MainMenu.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    self.MainMenu.BorderSizePixel = 0
    self.MainMenu.Position = UDim2.new(0.0827464685, 0, 0.143972278, 0)
    self.MainMenu.Size = UDim2.new(0.658450663, 0, 0.780572414, 0)

    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(30, 30, 30)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(48, 48, 48))}
    UIGradient.Rotation = 90
    UIGradient.Parent = self.MainMenu

    self.Sections = Instance.new("Frame")
    self.Sections.Name = "Sections"
    self.Sections.Parent = self.MainMenu
    self.Sections.BackgroundTransparency = 1.000
    self.Sections.Position = UDim2.new(0.0470023751, 0, 0.0247101504, 0)
    self.Sections.Size = UDim2.new(0.903153181, 0, 0.828303397, 0)

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = self.Sections
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0.02, 0)

    local DiscordInviteLabel = Instance.new("TextLabel")
    DiscordInviteLabel.Name = "DiscordInviteLabel"
    DiscordInviteLabel.Parent = self.MainMenu
    DiscordInviteLabel.BackgroundTransparency = 1.000
    DiscordInviteLabel.Position = UDim2.new(0, 0, 0.953333318, 0)
    DiscordInviteLabel.Size = UDim2.new(0.99999994, 0, 0.0344444439, 0)
    DiscordInviteLabel.Font = Enum.Font.Highway
    DiscordInviteLabel.Text = "discord.gg/WFyhpUvBRU"
    DiscordInviteLabel.TextColor3 = Color3.fromRGB(200, 0, 255)
    DiscordInviteLabel.TextScaled = true

    -- Interactive Functional Minimize Window Toggle Action Control
    local HideButton = Instance.new("TextButton")
    HideButton.Name = "HideButton"
    HideButton.Parent = self.Left
    HideButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    HideButton.BackgroundTransparency = 1.000
    HideButton.Position = UDim2.new(0.878521144, 0, 0.103209019, 0)
    HideButton.Size = UDim2.new(0.17605634, 0, 0.0468343459, 0)
    HideButton.ZIndex = 2
    HideButton.Text = ""

    local HideButtonImg = Instance.new("ImageLabel")
    HideButtonImg.Size = UDim2.new(1, 0, 1, 0)
    HideButtonImg.BackgroundTransparency = 1.000
    HideButtonImg.Image = "rbxassetid://93575451903318"
    HideButtonImg.ImageTransparency = 0.5
    HideButtonImg.Parent = HideButton

    local ArrowLabel = Instance.new("TextLabel")
    ArrowLabel.Name = "ArrowLabel"
    ArrowLabel.Parent = HideButton
    ArrowLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    ArrowLabel.BackgroundTransparency = 1.000
    ArrowLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
    ArrowLabel.Size = UDim2.new(1, 0, 1, 0)
    ArrowLabel.Font = Enum.Font.Cartoon
    ArrowLabel.Text = "Hide"
    ArrowLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ArrowLabel.TextScaled = true

    local UIGradient_2 = Instance.new("UIGradient")
    UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 51, 51)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 128, 17))}
    UIGradient_2.Rotation = 90
    UIGradient_2.Parent = HideButtonImg

    -- Right Section Content Panel
    self.Middle = Instance.new("Frame")
    self.Middle.Name = "Middle"
    self.Middle.Parent = self.Canvas
    self.Middle.AnchorPoint = Vector2.new(0.5, 0.5)
    self.Middle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    self.Middle.BackgroundTransparency = 0.750
    self.Middle.BorderSizePixel = 0
    self.Middle.Position = UDim2.new(0.499773651, 0, 0.499783069, 0)
    self.Middle.Size = UDim2.new(0.420099586, 0, 0.598438859, 0)

    local UICorner_8 = Instance.new("UICorner")
    UICorner_8.CornerRadius = UDim.new(0.02, 0)
    UICorner_8.Parent = self.Middle

    local PinkTheme_9 = Instance.new("UIGradient")
    PinkTheme_9.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 251)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 148, 255))}
    PinkTheme_9.Rotation = 90
    PinkTheme_9.Parent = self.Middle

    local Title_2 = Instance.new("Frame")
    Title_2.Name = "Title"
    Title_2.Parent = self.Middle
    Title_2.BackgroundColor3 = Color3.fromRGB(247, 0, 255)
    Title_2.BorderSizePixel = 0
    Title_2.Position = UDim2.new(0.0334051736, 0, 0.0318840593, 0)
    Title_2.Size = UDim2.new(0.933189631, 0, 0.0840579718, 0)

    self.SectionName = Instance.new("TextLabel")
    self.SectionName.Name = "SectionName"
    self.SectionName.Parent = Title_2
    self.SectionName.AnchorPoint = Vector2.new(0.5, 0.5)
    self.SectionName.BackgroundTransparency = 1.000
    self.SectionName.Position = UDim2.new(0.443969458, 0, 0.497315943, 0)
    self.SectionName.Size = UDim2.new(0.854840517, 0, 0.970888674, 0)
    self.SectionName.Font = Enum.Font.FredokaOne
    self.SectionName.Text = "Select Category"
    self.SectionName.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.SectionName.TextScaled = true
    self.SectionName.TextXAlignment = Enum.TextXAlignment.Left

    local UICorner_9 = Instance.new("UICorner")
    UICorner_9.CornerRadius = UDim.new(0.1, 0)
    UICorner_9.Parent = Title_2

    -- Hide / Show Global System Toggle Logic
    HideButton.MouseButton1Click:Connect(function()
        self.Toggled = not self.Toggled
        ArrowLabel.Text = self.Toggled and "Hide" or "Show"
        self.MainMenu.Visible = self.Toggled
        self.Middle.Visible = self.Toggled
    end)

    return self
end

function Library:CreateSection(sectionName)
    local sectionObject = setmetatable({}, Section)
    
    local SectionButton = Instance.new("TextButton")
    SectionButton.Name = "Template_" .. sectionName
    SectionButton.Parent = self.Sections
    SectionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SectionButton.BorderSizePixel = 0
    SectionButton.Size = UDim2.new(0.985850751, 0, 0.107314408, 0)
    SectionButton.Text = ""
    SectionButton.AutoButtonColor = false

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0.1, 0)
    UICorner.Parent = SectionButton

    local ButtonLabel = Instance.new("TextLabel")
    ButtonLabel.Name = "ButtonLabel"
    ButtonLabel.Parent = SectionButton
    ButtonLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    ButtonLabel.BackgroundTransparency = 1.000
    ButtonLabel.Position = UDim2.new(0.498774529, 0, 0.493243217, 0)
    ButtonLabel.Size = UDim2.new(0.874236941, 0, 0.655801773, 0)
    ButtonLabel.Font = Enum.Font.FredokaOne
    ButtonLabel.Text = sectionName
    ButtonLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ButtonLabel.TextScaled = true

    local PinkTheme = Instance.new("UIGradient")
    PinkTheme.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 251)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 148, 255))}
    PinkTheme.Rotation = 90
    PinkTheme.Parent = SectionButton

    -- Enabled Pure White Highlight Outline Stroke (No Yellow!)
    local SelectedStroke = Instance.new("UIStroke")
    SelectedStroke.Thickness = 2
    SelectedStroke.Color = Color3.fromRGB(255, 255, 255)
    SelectedStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    SelectedStroke.Enabled = false
    SelectedStroke.Parent = SectionButton

    local UIAspectRatio = Instance.new("UIAspectRatioConstraint")
    UIAspectRatio.Parent = SectionButton
    UIAspectRatio.AspectRatio = 4.162

    -- Interactive Category Canvas View Window Container
    local Container = Instance.new("ScrollingFrame")
    Container.Name = "Container_" .. sectionName
    Container.Parent = self.Middle
    Container.Active = true
    Container.BackgroundTransparency = 1.000
    Container.BorderSizePixel = 0
    Container.Position = UDim2.new(0.0334051736, 0, 0.160869569, 0)
    Container.Size = UDim2.new(0.933189631, 0, 0.802898526, 0)
    Container.CanvasSize = UDim2.new(0, 0, 0, 0)
    Container.ScrollBarThickness = 3
    Container.ScrollBarImageColor3 = Color3.fromRGB(255, 148, 255)
    Container.Visible = false

    local ElementListLayout = Instance.new("UIListLayout")
    ElementListLayout.Parent = Container
    ElementListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ElementListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ElementListLayout.Padding = UDim.new(0, 6)

    local ElementPadding = Instance.new("UIPadding")
    ElementPadding.PaddingTop = UDim.new(0, 4)
    ElementPadding.PaddingBottom = UDim.new(0, 4)
    ElementPadding.Parent = Container

    ElementListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Container.CanvasSize = UDim2.new(0, 0, 0, ElementListLayout.AbsoluteContentSize.Y + 16)
    end)

    sectionObject.Container = Container
    sectionObject.Button = SectionButton
    sectionObject.Stroke = SelectedStroke

    SectionButton.MouseButton1Click:Connect(function()
        if not self.Toggled then return end
        if self.CurrentSection then
            self.CurrentSection.Container.Visible = false
            self.CurrentSection.Stroke.Enabled = false
        end
        self.SectionName.Text = sectionName
        Container.Visible = true
        SelectedStroke.Enabled = true
        self.CurrentSection = sectionObject
    end)

    if #self.SectionsList == 0 then
        task.spawn(function()
            sectionObject.Container.Visible = true
            sectionObject.Stroke.Enabled = true
            self.SectionName.Text = sectionName
            self.CurrentSection = sectionObject
        end)
    end

    table.insert(self.SectionsList, sectionObject)
    return sectionObject
end

-- ==================== MODERN IN-TAB COMPONENT NODE FACTORY ====================
local function CreateScriptHubElement(parent, labelText)
    local BaseFrame = Instance.new("Frame")
    BaseFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    BaseFrame.BackgroundTransparency = 0.55 
    BaseFrame.Size = UDim2.new(0.96, 0, 0, 38) 

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = BaseFrame

    local NeonBorder = Instance.new("UIStroke")
    NeonBorder.Thickness = 1
    NeonBorder.Color = Color3.fromRGB(255, 100, 255)
    NeonBorder.Transparency = 0.5
    NeonBorder.Parent = BaseFrame

    local Padding = Instance.new("UIPadding")
    Padding.PaddingLeft = UDim.new(0, 10)
    Padding.PaddingRight = UDim.new(0, 10)
    Padding.Parent = BaseFrame

    local Label = Instance.new("TextLabel")
    Label.Parent = BaseFrame
    Label.BackgroundTransparency = 1.000
    Label.Size = UDim2.new(0.5, 0, 1, 0)
    Label.Font = Enum.Font.FredokaOne
    Label.Text = labelText
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left

    BaseFrame.Parent = parent
    return BaseFrame, Label
end

-- ==================== REDESIGNED SCRIPT HUB MODULES ====================

-- 1. PREMIUM BUTTON ELEMENT (Fixed unpack error)
function Section:CreateButton(text, callback)
    local BaseFrame, Label = CreateScriptHubElement(self.Container, text)
    Label.Size = UDim2.new(1, 0, 1, 0) 

    local Trigger = Instance.new("TextButton")
    Trigger.Size = UDim2.new(1, 20, 1, 0)
    Trigger.Position = UDim2.new(0, -10, 0, 0)
    Trigger.BackgroundTransparency = 1.000
    Trigger.Text = ""
    Trigger.Parent = BaseFrame

    Trigger.MouseButton1Click:Connect(function()
        TweenService:Create(BaseFrame, TweenInfo.new(0.05), {BackgroundTransparency = 0.35}):Play()
        task.wait(0.05)
        TweenService:Create(BaseFrame, TweenInfo.new(0.1), {BackgroundTransparency = 0.55}):Play()
        callback()
    end)
end

-- 2. TRANSITIONAL PARAMETER STATE TOGGLE SWITCH
function Section:CreateToggle(text, default, callback)
    local BaseFrame, Label = CreateScriptHubElement(self.Container, text)
    local ActiveState = default or false

    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.AnchorPoint = Vector2.new(1, 0.5)
    ToggleFrame.Position = UDim2.new(1, 0, 0.5, 0)
    ToggleFrame.Size = UDim2.new(0, 36, 0, 18)
    ToggleFrame.BackgroundColor3 = ActiveState and Color3.fromRGB(255, 0, 251) or Color3.fromRGB(45, 45, 45)
    ToggleFrame.Parent = BaseFrame

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = ToggleFrame

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 14, 0, 14)
    Knob.AnchorPoint = Vector2.new(0, 0.5)
    Knob.Position = ActiveState and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.Parent = ToggleFrame

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob

    local SwitchButton = Instance.new("TextButton")
    SwitchButton.Size = UDim2.new(1, 0, 1, 0)
    SwitchButton.BackgroundTransparency = 1.000
    SwitchButton.Text = ""
    SwitchButton.Parent = ToggleFrame

    SwitchButton.MouseButton1Click:Connect(function()
        ActiveState = not ActiveState
        local targetColor = ActiveState and Color3.fromRGB(255, 0, 251) or Color3.fromRGB(45, 45, 45)
        local targetPos = ActiveState and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
        
        TweenService:Create(ToggleFrame, TweenInfo.new(0.12), {BackgroundColor3 = targetColor}):Play()
        TweenService:Create(Knob, TweenInfo.new(0.12), {Position = targetPos}):Play()
        callback(ActiveState)
    end)
end

-- 3. PREMIUM SLIDER MODULE
function Section:CreateSlider(text, min, max, default, callback)
    local BaseFrame, Label = CreateScriptHubElement(self.Container, text)
    Label.Size = UDim2.new(0.4, 0, 1, 0)

    local SliderBar = Instance.new("Frame")
    SliderBar.AnchorPoint = Vector2.new(1, 0.5)
    SliderBar.Position = UDim2.new(0.9, -35, 0.5, 0)
    SliderBar.Size = UDim2.new(0.45, 0, 0, 4)
    SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    SliderBar.Parent = BaseFrame

    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(255, 100, 255)
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBar

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.AnchorPoint = Vector2.new(1, 0.5)
    ValueLabel.Position = UDim2.new(1, 0, 0.5, 0)
    ValueLabel.Size = UDim2.new(0, 30, 1, 0)
    ValueLabel.BackgroundTransparency = 1.000
    ValueLabel.Font = Enum.Font.FredokaOne
    ValueLabel.Text = tostring(default)
    ValueLabel.TextColor3 = Color3.fromRGB(255, 148, 255)
    ValueLabel.TextSize = 13
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = BaseFrame

    local SliderBtn = Instance.new("TextButton")
    SliderBtn.Size = UDim2.new(1, 0, 3, 0)
    SliderBtn.AnchorPoint = Vector2.new(0, 0.5)
    SliderBtn.Position = UDim2.new(0, 0, 0.5, 0)
    SliderBtn.BackgroundTransparency = 1.000
    SliderBtn.Text = ""
    SliderBtn.Parent = SliderBar

    local function UpdateSliderValue(input)
        local percentage = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * percentage)
        SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        ValueLabel.Text = tostring(val)
        callback(val)
    end

    local IsDragging = false
    SliderBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            IsDragging = true
            UpdateSliderValue(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if IsDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSliderValue(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            IsDragging = false
        end
    end)
end

-- 4. INTERACTIVE STRING CONTEXT DATA TEXTBOX
function Section:CreateTextBox(text, placeholder, callback)
    local BaseFrame, Label = CreateScriptHubElement(self.Container, text)
    Label.Size = UDim2.new(0.5, 0, 1, 0)

    local InputBox = Instance.new("TextBox")
    InputBox.AnchorPoint = Vector2.new(1, 0.5)
    InputBox.Position = UDim2.new(1, 0, 0.5, 0)
    InputBox.Size = UDim2.new(0.42, 0, 0, 24)
    InputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    InputBox.Font = Enum.Font.FredokaOne
    InputBox.PlaceholderText = placeholder or "Value..."
    InputBox.Text = ""
    InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    InputBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    InputBox.TextSize = 12
    InputBox.Parent = BaseFrame

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = InputBox

    local TextBoxStroke = Instance.new("UIStroke")
    TextBoxStroke.Thickness = 1
    TextBoxStroke.Color = Color3.fromRGB(255, 100, 255)
    TextBoxStroke.Transparency = 0.4
    TextBoxStroke.Parent = InputBox

    InputBox.FocusLost:Connect(function(enterPressed)
        callback(InputBox.Text, enterPressed)
    end)
end

-- 5. MULTI-OPTION CONFIGURATION DROPDOWN HUB WINDOW
function Section:CreateDropdown(text, listOptions, callback)
    local BaseFrame, Label = CreateScriptHubElement(self.Container, text)
    local ActiveStatus = false
    
    local DropdownBtn = Instance.new("TextButton")
    DropdownBtn.AnchorPoint = Vector2.new(1, 0.5)
    DropdownBtn.Position = UDim2.new(1, 0, 0.5, 0)
    DropdownBtn.Size = UDim2.new(0.42, 0, 0, 24)
    DropdownBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    DropdownBtn.Font = Enum.Font.FredokaOne
    DropdownBtn.Text = "Select v"
    DropdownBtn.TextColor3 = Color3.fromRGB(255, 148, 255)
    DropdownBtn.TextSize = 12
    DropdownBtn.Parent = BaseFrame

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = DropdownBtn
    
    local DropdownBtnStroke = Instance.new("UIStroke")
    DropdownBtnStroke.Thickness = 1
    DropdownBtnStroke.Color = Color3.fromRGB(255, 100, 255)
    DropdownBtnStroke.Transparency = 0.4
    DropdownBtnStroke.Parent = DropdownBtn

    local ListFrame = Instance.new("Frame")
    ListFrame.Name = "ListFrame"
    ListFrame.ZIndex = 8
    ListFrame.Position = UDim2.new(0, 0, 1, 4)
    ListFrame.Size = UDim2.new(1, 0, 0, 0)
    ListFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    ListFrame.Visible = false
    ListFrame.ClipsDescendants = true
    ListFrame.Parent = DropdownBtn

    local ListCorner = Instance.new("UICorner")
    ListCorner.CornerRadius = UDim.new(0, 6)
    ListCorner.Parent = ListFrame

    local ListStroke = Instance.new("UIStroke")
    ListStroke.Thickness = 1
    ListStroke.Color = Color3.fromRGB(255, 100, 255)
    ListStroke.Parent = ListFrame

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Parent = ListFrame
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local function ToggleDropdownWindow()
        ActiveStatus = not ActiveStatus
        if ActiveStatus then
            ListFrame.Visible = true
            local targetSizeHeight = math.clamp(#listOptions * 24, 24, 120)
            TweenService:Create(ListFrame, TweenInfo.new(0.12), {Size = UDim2.new(1, 0, 0, targetSizeHeight)}):Play()
        else
            local hideTween = TweenService:Create(ListFrame, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 0)})
            hideTween:Play()
            hideTween.Completed:Connect(function()
                if not ActiveStatus then ListFrame.Visible = false end
            end)
        end
    end

    DropdownBtn.MouseButton1Click:Connect(ToggleDropdownWindow)

    for _, choice in pairs(listOptions) do
        local OptBtn = Instance.new("TextButton")
        OptBtn.Size = UDim2.new(1, 0, 0, 24)
        OptBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        OptBtn.BackgroundTransparency = 1
        OptBtn.ZIndex = 9
        OptBtn.Font = Enum.Font.FredokaOne
        OptBtn.Text = tostring(choice)
        OptBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        OptBtn.TextSize = 12
        OptBtn.Parent = ListFrame

        OptBtn.MouseEnter:Connect(function()
            OptBtn.BackgroundTransparency = 0.9
            OptBtn.TextColor3 = Color3.fromRGB(255, 100, 255)
        end)
        OptBtn.MouseLeave:Connect(function()
            OptBtn.BackgroundTransparency = 1
            OptBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        OptBtn.MouseButton1Click:Connect(function()
            DropdownBtn.Text = tostring(choice)
            ToggleDropdownWindow()
            callback(choice)
        end)
    end
end

return Library
