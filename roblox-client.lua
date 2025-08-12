-- Roblox Key System Client Script
-- This script handles key validation and provides a user-friendly GUI for key input

local HttpService = game:GetService("HttpService")
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

-- Configuration
local API_BASE_URL = "https://your-replit-project.replit.app" -- Replace with your actual Replit URL
local DATASTORE_NAME = "PlayerKeys"

-- Services
local keyDataStore = DataStoreService:GetDataStore(DATASTORE_NAME)
local player = Players.LocalPlayer

-- Variables
local playerGui = player:WaitForChild("PlayerGui")
local keyVerified = false
local keyGui = nil

-- Create GUI
local function createKeyInputGUI()
    -- Main ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "KeySystemGUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = playerGui

    -- Background Frame
    local backgroundFrame = Instance.new("Frame")
    backgroundFrame.Size = UDim2.new(1, 0, 1, 0)
    backgroundFrame.Position = UDim2.new(0, 0, 0, 0)
    backgroundFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    backgroundFrame.BackgroundTransparency = 0.5
    backgroundFrame.BorderSizePixel = 0
    backgroundFrame.Parent = screenGui

    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 400, 0, 300)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    mainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = backgroundFrame

    -- Add corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame

    -- Add drop shadow effect
    local shadow = Instance.new("Frame")
    shadow.Size = UDim2.new(1, 6, 1, 6)
    shadow.Position = UDim2.new(0, -3, 0, -3)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.8
    shadow.BorderSizePixel = 0
    shadow.ZIndex = mainFrame.ZIndex - 1
    shadow.Parent = backgroundFrame

    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 15)
    shadowCorner.Parent = shadow

    -- Header
    local headerFrame = Instance.new("Frame")
    headerFrame.Size = UDim2.new(1, 0, 0, 80)
    headerFrame.Position = UDim2.new(0, 0, 0, 0)
    headerFrame.BackgroundColor3 = Color3.fromRGB(25, 118, 210)
    headerFrame.BorderSizePixel = 0
    headerFrame.Parent = mainFrame

    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 12)
    headerCorner.Parent = headerFrame

    -- Fix header corners
    local headerBottomFix = Instance.new("Frame")
    headerBottomFix.Size = UDim2.new(1, 0, 0, 12)
    headerBottomFix.Position = UDim2.new(0, 0, 1, -12)
    headerBottomFix.BackgroundColor3 = Color3.fromRGB(25, 118, 210)
    headerBottomFix.BorderSizePixel = 0
    headerBottomFix.Parent = headerFrame

    -- Header Icon
    local headerIcon = Instance.new("ImageLabel")
    headerIcon.Size = UDim2.new(0, 32, 0, 32)
    headerIcon.Position = UDim2.new(0, 20, 0.5, -16)
    headerIcon.BackgroundTransparency = 1
    headerIcon.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png" -- Replace with key icon
    headerIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    headerIcon.Parent = headerFrame

    -- Header Title
    local headerTitle = Instance.new("TextLabel")
    headerTitle.Size = UDim2.new(1, -70, 0, 25)
    headerTitle.Position = UDim2.new(0, 60, 0, 15)
    headerTitle.BackgroundTransparency = 1
    headerTitle.Text = "Key System"
    headerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    headerTitle.TextScaled = true
    headerTitle.Font = Enum.Font.GothamBold
    headerTitle.TextXAlignment = Enum.TextXAlignment.Left
    headerTitle.Parent = headerFrame

    -- Header Subtitle
    local headerSubtitle = Instance.new("TextLabel")
    headerSubtitle.Size = UDim2.new(1, -70, 0, 20)
    headerSubtitle.Position = UDim2.new(0, 60, 0, 45)
    headerSubtitle.BackgroundTransparency = 1
    headerSubtitle.Text = "Enter your 24-hour access key"
    headerSubtitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    headerSubtitle.TextTransparency = 0.3
    headerSubtitle.TextScaled = true
    headerSubtitle.Font = Enum.Font.Gotham
    headerSubtitle.TextXAlignment = Enum.TextXAlignment.Left
    headerSubtitle.Parent = headerFrame

    -- Content Frame
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 1, -80)
    contentFrame.Position = UDim2.new(0, 0, 0, 80)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame

    -- Input Label
    local inputLabel = Instance.new("TextLabel")
    inputLabel.Size = UDim2.new(1, -40, 0, 30)
    inputLabel.Position = UDim2.new(0, 20, 0, 20)
    inputLabel.BackgroundTransparency = 1
    inputLabel.Text = "Access Key:"
    inputLabel.TextColor3 = Color3.fromRGB(66, 66, 66)
    inputLabel.TextScaled = true
    inputLabel.Font = Enum.Font.GothamMedium
    inputLabel.TextXAlignment = Enum.TextXAlignment.Left
    inputLabel.Parent = contentFrame

    -- Key Input TextBox
    local keyInput = Instance.new("TextBox")
    keyInput.Size = UDim2.new(1, -40, 0, 50)
    keyInput.Position = UDim2.new(0, 20, 0, 60)
    keyInput.BackgroundColor3 = Color3.fromRGB(248, 248, 248)
    keyInput.BorderSizePixel = 1
    keyInput.BorderColor3 = Color3.fromRGB(224, 224, 224)
    keyInput.Text = ""
    keyInput.PlaceholderText = "Enter your 16-character key here..."
    keyInput.TextColor3 = Color3.fromRGB(33, 33, 33)
    keyInput.PlaceholderColor3 = Color3.fromRGB(158, 158, 158)
    keyInput.TextScaled = true
    keyInput.Font = Enum.Font.RobotoMono
    keyInput.TextXAlignment = Enum.TextXAlignment.Center
    keyInput.Parent = contentFrame

    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 8)
    inputCorner.Parent = keyInput

    -- Submit Button
    local submitButton = Instance.new("TextButton")
    submitButton.Size = UDim2.new(1, -40, 0, 45)
    submitButton.Position = UDim2.new(0, 20, 0, 130)
    submitButton.BackgroundColor3 = Color3.fromRGB(25, 118, 210)
    submitButton.BorderSizePixel = 0
    submitButton.Text = "Verify Key"
    submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    submitButton.TextScaled = true
    submitButton.Font = Enum.Font.GothamBold
    submitButton.Parent = contentFrame

    local submitCorner = Instance.new("UICorner")
    submitCorner.CornerRadius = UDim.new(0, 8)
    submitCorner.Parent = submitButton

    -- Status Label
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, -40, 0, 30)
    statusLabel.Position = UDim2.new(0, 20, 0, 185)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = ""
    statusLabel.TextColor3 = Color3.fromRGB(244, 67, 54)
    statusLabel.TextScaled = true
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextXAlignment = Enum.TextXAlignment.Center
    statusLabel.Parent = contentFrame

    return {
        screenGui = screenGui,
        keyInput = keyInput,
        submitButton = submitButton,
        statusLabel = statusLabel
    }
end

-- API Functions
local function verifyKeyWithAPI(key)
    local success, response = pcall(function()
        local url = API_BASE_URL .. "/api/verify?key=" .. HttpService:UrlEncode(key)
        return HttpService:GetAsync(url)
    end)
    
    if success then
        local data = HttpService:JSONDecode(response)
        return data
    else
        warn("Failed to verify key with API: " .. tostring(response))
        return { status = "invalid", message = "Network error" }
    end
end

-- DataStore Functions
local function saveKeyToDataStore(key)
    local success, error = pcall(function()
        keyDataStore:SetAsync(tostring(player.UserId), key)
    end)
    
    if not success then
        warn("Failed to save key to DataStore: " .. tostring(error))
    end
end

local function getKeyFromDataStore()
    local success, key = pcall(function()
        return keyDataStore:GetAsync(tostring(player.UserId))
    end)
    
    if success and key then
        return key
    else
        return nil
    end
end

local function removeKeyFromDataStore()
    local success, error = pcall(function()
        keyDataStore:RemoveAsync(tostring(player.UserId))
    end)
    
    if not success then
        warn("Failed to remove key from DataStore: " .. tostring(error))
    end
end

-- Animation Functions
local function animateButton(button, scale)
    local tween = TweenService:Create(
        button,
        TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = button.Size * scale}
    )
    tween:Play()
    
    tween.Completed:Connect(function()
        local backTween = TweenService:Create(
            button,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = button.Size / scale}
        )
        backTween:Play()
    end)
end

-- Main Key Verification Logic
local function handleKeyVerification(key, gui)
    if not key or key == "" then
        gui.statusLabel.Text = "Please enter a key"
        gui.statusLabel.TextColor3 = Color3.fromRGB(244, 67, 54)
        return false
    end
    
    if #key ~= 16 then
        gui.statusLabel.Text = "Key must be exactly 16 characters"
        gui.statusLabel.TextColor3 = Color3.fromRGB(244, 67, 54)
        return false
    end
    
    -- Show loading state
    gui.submitButton.Text = "Verifying..."
    gui.submitButton.BackgroundColor3 = Color3.fromRGB(158, 158, 158)
    gui.statusLabel.Text = "Checking key with server..."
    gui.statusLabel.TextColor3 = Color3.fromRGB(25, 118, 210)
    
    -- Verify with API
    local result = verifyKeyWithAPI(key)
    
    if result.status == "valid" then
        -- Key is valid, save to DataStore and close GUI
        saveKeyToDataStore(key)
        gui.statusLabel.Text = "Key verified successfully!"
        gui.statusLabel.TextColor3 = Color3.fromRGB(76, 175, 80)
        
        wait(1)
        keyVerified = true
        gui.screenGui:Destroy()
        
        -- Call your main script function here
        onKeyVerified()
        
        return true
    elseif result.status == "expired" then
        gui.statusLabel.Text = "Key has expired. Please get a new key."
        gui.statusLabel.TextColor3 = Color3.fromRGB(255, 152, 0)
        removeKeyFromDataStore()
    elseif result.status == "invalid" then
        gui.statusLabel.Text = "Invalid key. Please check and try again."
        gui.statusLabel.TextColor3 = Color3.fromRGB(244, 67, 54)
    else
        gui.statusLabel.Text = "Server error. Please try again later."
        gui.statusLabel.TextColor3 = Color3.fromRGB(244, 67, 54)
    end
    
    -- Reset button state
    gui.submitButton.Text = "Verify Key"
    gui.submitButton.BackgroundColor3 = Color3.fromRGB(25, 118, 210)
    
    return false
end

-- Main function that runs when key is verified
function onKeyVerified()
    print("Key verified! Running main script...")
    
    -- ADD YOUR MAIN SCRIPT FUNCTIONALITY HERE
    -- This is where you put the code that should run after key verification
    
    -- Example:
    local notification = Instance.new("ScreenGui")
    notification.Name = "VerificationNotification"
    notification.Parent = playerGui
    
    local notifFrame = Instance.new("Frame")
    notifFrame.Size = UDim2.new(0, 300, 0, 80)
    notifFrame.Position = UDim2.new(1, -320, 0, 20)
    notifFrame.BackgroundColor3 = Color3.fromRGB(76, 175, 80)
    notifFrame.BorderSizePixel = 0
    notifFrame.Parent = notification
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 8)
    notifCorner.Parent = notifFrame
    
    local notifText = Instance.new("TextLabel")
    notifText.Size = UDim2.new(1, -20, 1, 0)
    notifText.Position = UDim2.new(0, 10, 0, 0)
    notifText.BackgroundTransparency = 1
    notifText.Text = "✓ Access Granted!\nScript is now active."
    notifText.TextColor3 = Color3.fromRGB(255, 255, 255)
    notifText.TextScaled = true
    notifText.Font = Enum.Font.GothamBold
    notifText.Parent = notifFrame
    
    -- Animate notification in
    notifFrame:TweenPosition(UDim2.new(1, -320, 0, 20), "Out", "Quad", 0.5, true)
    
    -- Remove notification after 3 seconds
    game:GetService("Debris"):AddItem(notification, 3)
end

-- Initialize the key system
local function initializeKeySystem()
    print("Initializing Key System...")
    
    -- Check if we have a saved key
    local savedKey = getKeyFromDataStore()
    
    if savedKey then
        print("Found saved key, verifying...")
        local result = verifyKeyWithAPI(savedKey)
        
        if result.status == "valid" then
            print("Saved key is still valid!")
            keyVerified = true
            onKeyVerified()
            return
        else
            print("Saved key is invalid or expired, removing...")
            removeKeyFromDataStore()
        end
    end
    
    -- No valid key found, show GUI
    print("No valid key found, showing GUI...")
    keyGui = createKeyInputGUI()
    
    -- Connect submit button
    keyGui.submitButton.MouseButton1Click:Connect(function()
        animateButton(keyGui.submitButton, 0.95)
        local key = keyGui.keyInput.Text:upper():gsub("%s+", "") -- Remove whitespace and convert to uppercase
        handleKeyVerification(key, keyGui)
    end)
    
    -- Connect Enter key in TextBox
    keyGui.keyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            animateButton(keyGui.submitButton, 0.95)
            local key = keyGui.keyInput.Text:upper():gsub("%s+", "")
            handleKeyVerification(key, keyGui)
        end
    end)
    
    -- Auto-focus on TextBox
    keyGui.keyInput:CaptureFocus()
end

-- Handle player joining
if player then
    player.CharacterAdded:Connect(function()
        wait(2) -- Wait for character to fully load
        if not keyVerified then
            initializeKeySystem()
        end
    end)
    
    -- If character already exists
    if player.Character then
        wait(2)
        if not keyVerified then
            initializeKeySystem()
        end
    end
else
    -- Fallback if player service is not available yet
    spawn(function()
        while not player do
            wait(0.1)
            player = Players.LocalPlayer
        end
        wait(2)
        if not keyVerified then
            initializeKeySystem()
        end
    end)
end

-- Optional: Add a function to manually reset the key system (for testing)
function resetKeySystem()
    keyVerified = false
    removeKeyFromDataStore()
    if keyGui and keyGui.screenGui then
        keyGui.screenGui:Destroy()
    end
    initializeKeySystem()
end

print("Roblox Key System loaded successfully!")
print("Remember to replace 'your-replit-project.replit.app' with your actual Replit URL!")
