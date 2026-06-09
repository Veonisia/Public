local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Library = {}
Library.__index = Library

local Section = {}
Section.__index = Section

-- Utility function to handle dragging for frames
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

    -- Base ScreenGui
    self.FlyGui = Instance.new("ScreenGui")
    self.FlyGui.Name = "FlyGui_Runtime"
    self.FlyGui.Parent = CoreGui
    self.FlyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Main Transparent Canvas Container
    self.Canvas = Instance.new("Frame")
    self.Canvas.Name = "Canvas"
    self.Canvas.Parent = self.FlyGui
    self.Canvas.AnchorPoint = Vector2.new(0.5, 0.5)
    self.Canvas.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    self.Canvas.BackgroundTransparency = 1.000
    self.Canvas.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.Canvas.Size = UDim2.new(1, 0, 1, 0)

    -- Sidebar Container
    self.Left = Instance.new("Frame")
    self.Left.Name = "Left"
    self.Left.Parent = self.Canvas
    self.Left.AnchorPoint = Vector2.new(0, 0.5)
    self.Left.BackgroundColor3 = Color3.fromRGB(255, 0, 4)
    self.Left.BackgroundTransparency = 1.000
    self.Left.Position = UDim2.new(0.15, 0, 0.5, 0) -- Adjusted from 0 to center grouping nicely
    self.Left.Size = UDim2.new(0.257, 0, 1, 0)
    MakeDraggable(self.Left)

    local UIAspectRatioConstraint_4 = Instance.new("UIAspectRatioConstraint")
    UIAspectRatioConstraint_4.Parent = self.Left
    UIAspectRatioConstraint_4.AspectRatio = 0.493

    -- Header Banner Frame
    local Title = Instance.new("ImageLabel")
    Title.Name = "Title"
    Title.Parent = self.Left
    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1.000
    Title.Position = UDim2.new(0.019, 0, 0.085, 0)
    Title.Size = UDim2.new(0.883, 0, 0.064, 0)
    Title.ZIndex = 2
    Title.Image = "rbxassetid://93575451903318"

    local PinkTheme = Instance.new("UIGradient")
    PinkTheme.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 251)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 148, 255))}
    PinkTheme.Rotation = 90
    PinkTheme.Parent = Title

    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
    UIAspectRatioConstraint.Parent = Title
    UIAspectRatioConstraint.AspectRatio = 6.784

    -- Hub Title Label
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Parent = Title
    TitleLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    TitleLabel.BackgroundTransparency = 1.000
    TitleLabel.Position = UDim2.new(0.376, 0, 0.493, 0)
    TitleLabel.Size = UDim2.new(0.464, 0, 0.824, 0)
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
    VersionLabel.Position = UDim2.new(0.585, 0, 0.668, 0)
    VersionLabel.Size = UDim2.new(0.464, 0, 0.472, 0)
    VersionLabel.Font = Enum.Font.Cartoon
    VersionLabel.Text = hubVersion or "v1.1"
    VersionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    VersionLabel.TextScaled = true
    VersionLabel.TextXAlignment = Enum.TextXAlignment.Right

    -- Main Navigation Menu Frame
    self.MainMenu = Instance.new("Frame")
    self.MainMenu.Name = "MainMenu"
    self.MainMenu.Parent = self.Left
    self.MainMenu.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    self.MainMenu.BorderSizePixel = 0
    self.MainMenu.Position = UDim2.new(0.082, 0, 0.143, 0)
    self.MainMenu.Size = UDim2.new(0.658, 0, 0.780, 0)

    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(30, 30, 30)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(48, 48, 48))}
    UIGradient.Rotation = 90
    UIGradient.Parent = self.MainMenu

    self.Sections = Instance.new("Frame")
    self.Sections.Name = "Sections"
    self.Sections.Parent = self.MainMenu
    self.Sections.BackgroundTransparency = 1.000
    self.Sections.Position = UDim2.new(0.047, 0, 0.024, 0)
    self.Sections.Size = UDim2.new(0.903, 0, 0.828, 0)

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = self.Sections
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0.02, 0)

    local DiscordInviteLabel = Instance.new("TextLabel")
    DiscordInviteLabel.Name = "DiscordInviteLabel"
    DiscordInviteLabel.Parent = self.MainMenu
    DiscordInviteLabel.BackgroundTransparency = 1.000
    DiscordInviteLabel.Position = UDim2.new(0, 0, 0.953, 0)
    DiscordInviteLabel.Size = UDim2.new(1, 0, 0.034, 0)
    DiscordInviteLabel.Font = Enum.Font.Highway
    DiscordInviteLabel.Text = "discord.gg/WFyhpUvBRU"
    DiscordInviteLabel.TextColor3 = Color3.fromRGB(200, 0, 255)
    DiscordInviteLabel.TextScaled = true

    -- Hide/Minimize Control Action
    local HideButton = Instance.new("ImageButton")
    HideButton.Name = "HideButton"
    HideButton.Parent = self.Left
    HideButton.BackgroundTransparency = 1.000
    HideButton.Position = UDim2.new(0.878, 0, 0.103, 0)
    HideButton.Size = UDim2.new(0.176, 0, 0.046, 0)
    HideButton.ZIndex = 2
    HideButton.Image = "rbxassetid://93575451903318"
    HideButton.ImageTransparency = 0.500

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
    UIGradient_2.Parent = HideButton

    -- Right Content Window View
    self.Middle = Instance.new("Frame")
    self.Middle.Name = "Middle"
    self.Middle.Parent = self.Canvas
    self.Middle.AnchorPoint = Vector2.new(0.5, 0.5)
    self.Middle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    self.Middle.BackgroundTransparency = 0.750
    self.Middle.BorderSizePixel = 0
    self.Middle.Position = UDim2.new(0.52, 0, 0.5, 0)
    self.Middle.Size = UDim2.new(0.420, 0, 0.598, 0)

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
    Title_2.Position = UDim2.new(0.033, 0, 0.031, 0)
    Title_2.Size = UDim2.new(0.933, 0, 0.084, 0)

    self.SectionName = Instance.new("TextLabel")
    self.SectionName.Name = "SectionName"
    self.SectionName.Parent = Title_2
    self.SectionName.AnchorPoint = Vector2.new(0.5, 0.5)
    self.SectionName.BackgroundTransparency = 1.000
    self.SectionName.Position = UDim2.new(0.443, 0, 0.497, 0)
    self.SectionName.Size = UDim2.new(0.854, 0, 0.970, 0)
    self.SectionName.Font = Enum.Font.FredokaOne
    self.SectionName.Text = "Select a Section"
    self.SectionName.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.SectionName.TextScaled = true
    self.SectionName.TextXAlignment = Enum.TextXAlignment.Left

    local UICorner_9 = Instance.new("UICorner")
    UICorner_9.CornerRadius = UDim.new(0.1, 0)
    UICorner_9.Parent = Title_2

    -- Toggle View Interaction Action Handler
    HideButton.MouseButton1Click:Connect(function()
        self.Toggled = not self.Toggled
        local targetTransparency = self.Toggled and 0 or 1
        local targetTransparencyTranslucent = self.Toggled and 0.75 or 1
        
        ArrowLabel.Text = self.Toggled and "Hide" or "Show"

        TweenService:Create(self.MainMenu, TweenInfo.new(0.25), {BackgroundTransparency = targetTransparency}):Play()
        TweenService:Create(self.Middle, TweenInfo.new(0.25), {BackgroundTransparency = targetTransparencyTranslucent}):Play()
        Title_2.Visible = self.Toggled

        for _, child in pairs(self.MainMenu:GetDescendants()) do
            if child:IsA("TextLabel") or child:IsA("Frame") or child:IsA("UIStroke") then
                TweenService:Create(child, TweenInfo.new(0.2), {
                    BackgroundTransparency = (child:IsA("Frame") and targetTransparency) or child.BackgroundTransparency,
                    TextTransparency = (child:IsA("TextLabel") and targetTransparency) or child.TextTransparency
                }):Play()
            end
        end

        if self.CurrentSection then
            self.CurrentSection.Container.Visible = self.Toggled
        end
    end)

    return self
end

function Library:CreateSection(sectionName)
    local sectionObject = setmetatable({}, Section)
    
    -- Creation of Navigation Category Row Button
    local TemplateButton = Instance.new("TextButton")
    TemplateButton.Name = "Template_" .. sectionName
    TemplateButton.Parent = self.Sections
    TemplateButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TemplateButton.BorderSizePixel = 0
    TemplateButton.Size = UDim2.new(0.985, 0, 0.107, 0)
    TemplateButton.Text = ""
    TemplateButton.AutoButtonColor = false

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0.1, 0)
    UICorner.Parent = TemplateButton

    local ButtonLabel = Instance.new("TextLabel")
    ButtonLabel.Name = "ButtonLabel"
    ButtonLabel.Parent = TemplateButton
    ButtonLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    ButtonLabel.BackgroundTransparency = 1.000
    ButtonLabel.Position = UDim2.new(0.498, 0, 0.493, 0)
    ButtonLabel.Size = UDim2.new(0.874, 0, 0.655, 0)
    ButtonLabel.Font = Enum.Font.FredokaOne
    ButtonLabel.Text = sectionName
    ButtonLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ButtonLabel.TextScaled = true

    local ThemeGradient = Instance.new("UIGradient")
    ThemeGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 251)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 148, 255))}
    ThemeGradient.Rotation = 90
    ThemeGradient.Parent = TemplateButton

    -- Custom Selection Highlight Feature 
    local SelectionStroke = Instance.new("UIStroke")
    SelectionStroke.Thickness = 2.5
    SelectionStroke.Color = Color3.fromRGB(255, 225, 0) -- Vibrant Yellow
    SelectionStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    SelectionStroke.Enabled = false
    SelectionStroke.Parent = TemplateButton

    local UIAspectRatio = Instance.new("UIAspectRatioConstraint")
    UIAspectRatio.Parent = TemplateButton
    UIAspectRatio.AspectRatio = 4.162

    -- Elements Content Container Scrolling Canvas Frame Layout Setup
    local Container = Instance.new("ScrollingFrame")
    Container.Name = "Container_" .. sectionName
    Container.Parent = self.Middle
    Container.Active = true
    Container.BackgroundTransparency = 1.000
    Container.BorderSizePixel = 0
    Container.Position = UDim2.new(0.033, 0, 0.160, 0)
    Container.Size = UDim2.new(0.933, 0, 0.802, 0)
    Container.CanvasSize = UDim2.new(0, 0, 0, 0)
    Container.ScrollBarThickness = 4
    Container.ScrollBarImageColor3 = Color3.fromRGB(255, 148, 255)
    Container.Visible = false

    local ElementListLayout = Instance.new("UIListLayout")
    ElementListLayout.Parent = Container
    ElementListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ElementListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ElementListLayout.Padding = UDim.new(0.03, 0)

    ElementListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Container.CanvasSize = UDim2.new(0, 0, 0, ElementListLayout.AbsoluteContentSize.Y + 10)
    end)

    sectionObject.Container = Container
    sectionObject.Button = TemplateButton
    sectionObject.Stroke = SelectionStroke

    -- Interactive Category Switch Action Loop Process Configuration
    TemplateButton.MouseButton1Click:Connect(function()
        if not self.Toggled then return end
        
        if self.CurrentSection then
            self.CurrentSection.Container.Visible = false
            self.CurrentSection.Stroke.Enabled = false
            self.CurrentSection.Button.UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 251)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 148, 255))}
        end

        self.SectionName.Text = sectionName
        Container.Visible = true
        SelectionStroke.Enabled = true
        
        -- Apply the active yellow gradient theme transformation to the tab button selection state
        TemplateButton.UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 180, 5)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 225, 0))}
        
        self.CurrentSection = sectionObject
    end)

    -- Auto-select the first section added
    if #self.SectionsList == 0 then
        task.spawn(function()
            sectionObject.Container.Visible = true
            sectionObject.Stroke.Enabled = true
            TemplateButton.UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 180, 5)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 225, 0))}
            self.SectionName.Text = sectionName
            self.CurrentSection = sectionObject
        end)
    end

    table.insert(self.SectionsList, sectionObject)
    return sectionObject
end

-- Helper structure function for components layout alignment matching style design
local function CreateElementBase(parent, text)
    local BaseFrame = Instance.new("Frame")
    BaseFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    BaseFrame.Size = UDim2.new(0.95, 0, 0.14, 0)

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0.15, 0)
    UICorner.Parent = BaseFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Thickness = 1
    UIStroke.Color = Color3.fromRGB(255, 148, 255)
    UIStroke.Parent = BaseFrame

    local Label = Instance.new("TextLabel")
    Label.Parent = BaseFrame
    Label.BackgroundTransparency = 1.000
    Label.Position = UDim2.new(0.05, 0, 0, 0)
    Label.Size = UDim2.new(0.5, 0, 1, 0)
    Label.Font = Enum.Font.FredokaOne
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextScaled = true
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
    UIAspectRatioConstraint.Parent = BaseFrame
    UIAspectRatioConstraint.AspectRatio = 6.2

    BaseFrame.Parent = parent
    return BaseFrame, Label
end

-- SECTION CONTROLS METHODS DEFINITIONS

-- 1. BUTTON
function Section:CreateButton(text, callback)
    local BaseFrame, Label = CreateElementBase(self.Container, text)
    Label.Size = UDim2.new(0.9, 0, 1, 0) -- Fill out width space block

    local ActionButton = Instance.new("TextButton")
    ActionButton.Size = UDim2.new(1, 0, 1, 0)
    ActionButton.BackgroundTransparency = 1.000
    ActionButton.Text = ""
    ActionButton.Parent = BaseFrame

    ActionButton.MouseButton1Click:Connect(function()
        BaseFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        task.wait(0.1)
        BaseFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        callback()
    end)
end

-- 2. TOGGLE
function Section:CreateToggle(text, default, callback)
    local BaseFrame, Label = CreateElementBase(self.Container, text)
    local ToggledState = default or false

    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.AnchorPoint = Vector2.new(1, 0.5)
    ToggleFrame.Position = UDim2.new(0.95, 0, 0.5, 0)
    ToggleFrame.Size = UDim2.new(0.12, 0, 0.6, 0)
    ToggleFrame.BackgroundColor3 = ToggledState and Color3.fromRGB(255, 0, 251) or Color3.fromRGB(70, 70, 70)
    ToggleFrame.Parent = BaseFrame

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0.3, 0)
    UICorner.Parent = ToggleFrame

    local ClickButton = Instance.new("TextButton")
    ClickButton.Size = UDim2.new(1, 0, 1, 0)
    ClickButton.BackgroundTransparency = 1.000
    ClickButton.Text = ""
    ClickButton.Parent = ToggleFrame

    local function UpdateToggle()
        local targetColor = ToggledState and Color3.fromRGB(255, 0, 251) or Color3.fromRGB(70, 70, 70)
        TweenService:Create(ToggleFrame, TweenInfo.new(0.15), {BackgroundColor3 = targetColor}):Play()
        callback(ToggledState)
    end

    ClickButton.MouseButton1Click:Connect(function()
        ToggledState = not ToggledState
        UpdateToggle()
    end)
end

-- 3. TEXTBOX
function Section:CreateTextBox(text, placeholder, callback)
    local BaseFrame, Label = CreateElementBase(self.Container, text)
    Label.Size = UDim2.new(0.45, 0, 1, 0)

    local InputBox = Instance.new("TextBox")
    InputBox.AnchorPoint = Vector2.new(1, 0.5)
    InputBox.Position = UDim2.new(0.95, 0, 0.5, 0)
    InputBox.Size = UDim2.new(0.45, 0, 0.65, 0)
    InputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    InputBox.Font = Enum.Font.FredokaOne
    InputBox.PlaceholderText = placeholder or "Type here..."
    InputBox.Text = ""
    InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    InputBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    InputBox.TextScaled = true
    InputBox.Parent = BaseFrame

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0.2, 0)
    UICorner.Parent = InputBox

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Thickness = 1
    UIStroke.Color = Color3.fromRGB(255, 148, 255)
    UIStroke.Parent = InputBox

    InputBox.FocusLost:Connect(function(enterPressed)
        callback(InputBox.Text, enterPressed)
    end)
end

-- 4. DROPDOWN
function Section:CreateDropdown(text, listOptions, callback)
    local BaseFrame, Label = CreateElementBase(self.Container, text)
    
    local DropdownActive = false
    
    local SelectButton = Instance.new("TextButton")
    SelectButton.AnchorPoint = Vector2.new(1, 0.5)
    SelectButton.Position = UDim2.new(0.95, 0, 0.5, 0)
    SelectButton.Size = UDim2.new(0.4, 0, 0.65, 0)
    SelectButton.BackgroundColor3 = Color3.fromRGB(255, 0, 251)
    SelectButton.Font = Enum.Font.FredokaOne
    SelectButton.Text = "Select v"
    SelectButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SelectButton.TextScaled = true
    SelectButton.Parent = BaseFrame

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0.2, 0)
    UICorner.Parent = SelectButton

    -- Items Options Window Container Setup Frame Layout Structure
    local OptionsFrame = Instance.new("Frame")
    OptionsFrame.Name = "OptionsFrame"
    OptionsFrame.ZIndex = 5
    OptionsFrame.Position = UDim2.new(0, 0, 1.2, 0)
    OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
    OptionsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    OptionsFrame.Visible = false
    OptionsFrame.ClipsDescendants = true
    OptionsFrame.Parent = SelectButton

    local OptionsCorner = Instance.new("UICorner")
    OptionsCorner.CornerRadius = UDim.new(0.1, 0)
    OptionsCorner.Parent = OptionsFrame

    local OptionsStroke = Instance.new("UIStroke")
    OptionsStroke.Thickness = 1
    OptionsStroke.Color = Color3.fromRGB(255, 148, 255)
    OptionsStroke.Parent = OptionsFrame

    local OptionsLayout = Instance.new("UIListLayout")
    OptionsLayout.Parent = OptionsFrame
    OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local function ToggleDropdownState()
        DropdownActive = not DropdownActive
        if DropdownActive then
            OptionsFrame.Visible = true
            local computedHeight = #listOptions * 24
            TweenService:Create(OptionsFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, computedHeight)}):Play()
        else
            local closeTween = TweenService:Create(OptionsFrame, TweenInfo.new(0.15), {Size = UDim2.new(1, 0, 0, 0)})
            closeTween:Play()
            closeTween.Completed:Connect(function()
                if not DropdownActive then OptionsFrame.Visible = false end
            end)
        end
    end

    SelectButton.MouseButton1Click:Connect(ToggleDropdownState)

    for idx, selectionOption in pairs(listOptions) do
        local OptBtn = Instance.new("TextButton")
        OptBtn.Size = UDim2.new(1, 0, 0, 24)
        OptBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        OptBtn.BackgroundTransparency = 0
        OptBtn.ZIndex = 6
        OptBtn.Font = Enum.Font.FredokaOne
        OptBtn.Text = tostring(selectionOption)
        OptBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        OptBtn.TextSize = 14
        OptBtn.Parent = OptionsFrame

        OptBtn.MouseButton1Click:Connect(function()
            SelectButton.Text = tostring(selectionOption)
            ToggleDropdownState()
            callback(selectionOption)
        end)
    end
end

return Library
