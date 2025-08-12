-- Roblox Key System Client Script
-- This script handles key validation and provides a user-friendly GUI for key input
-- Updated version with improved error handling and visual design

local HttpService = game:GetService("HttpService")
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

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

-- Create GUI with improved styling to match the web design
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
    mainFrame.Size = UDim2.new(0, 450, 0, 350)
    mainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
    mainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = backgroundFrame

    -- Add corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame

    -- Add drop shadow effect
    local shadow = Instance.new("Frame")
    shadow.Size = UDim2.new(1, 8, 1, 8)
    shadow.Position = UDim2.new(0, -4, 0, -4)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.85
    shadow.BorderSizePixel = 0
    shadow.ZIndex = mainFrame.ZIndex - 1
    shadow.Parent = backgroundFrame

    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 16)
    shadowCorner.Parent = shadow

    -- Header
    local headerFrame = Instance.new("Frame")
    headerFrame.Size = UDim2.new(1, 0, 0, 80)
    headerFrame.Position = UDim2.new(0, 0, 0, 0)
    headerFrame.BackgroundColor3 = Color3.fromRGB(25, 118, 210) -- Primary blue color
    headerFrame.BorderSizePixel = 0
    headerFrame.Parent = mainFrame

    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 12)
    headerCorner.Parent = headerFrame

    -- Fix header corners (only top corners should be rounded)
    local headerBottomFix = Instance.new("Frame")
    headerBottomFix.Size = UDim2.new(1, 0, 0, 12)
    headerBottomFix.Position = UDim2.new(0, 0, 1, -12)
    headerBottomFix.BackgroundColor3 = Color3.fromRGB(25, 118, 210)
    headerBottomFix.BorderSizePixel = 0
    headerBottomFix.Parent = headerFrame

    -- Header Icon (Key icon placeholder)
    local headerIcon = Instance.new("Frame")
    headerIcon.Size = UDim2.new(0, 32, 0, 32)
    headerIcon.Position = UDim2.new(0, 20, 0.5, -16)
    headerIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    headerIcon.BackgroundTransparency = 0.8
    headerIcon.Parent = headerFrame

    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(0, 6)
    iconCorner.Parent = headerIcon

    -- Header Title
    local headerTitle = Instance.new("TextLabel")
    headerTitle.Size = UDim2.new(1, -70, 0, 25)
    headerTitle.Position = UDim2.new(0, 60, 0, 15)
    headerTitle.BackgroundTransparency = 1
    headerTitle.Text = "Roblox Key System"
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
    headerSubtitle.Text = "24-Hour Access Verification"
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

    -- Welcome Message
    local welcomeLabel = Instance.new("TextLabel")
    welcomeLabel.Size = UDim2.new(1, -40, 0, 40)
    welcomeLabel.Position = UDim2.new(0, 20, 0, 15)
    welcomeLabel.BackgroundTransparency = 1
    welcomeLabel.Text = "Enter your 24-hour access key to continue"
    welcomeLabel.TextColor3 = Color3.fromRGB(117, 117, 117)
    welcomeLabel.TextScaled = true
    welcomeLabel.Font = Enum.Font.Gotham
    welcomeLabel.TextXAlignment = Enum.TextXAlignment.Center
    welcomeLabel.TextWrapped = true
    welcomeLabel.Parent = contentFrame

    -- Input Label
    local inputLabel = Instance.new("TextLabel")
    inputLabel.Size = UDim2.new(1, -40, 0, 25)
    inputLabel.Position = UDim2.new(0, 20, 0, 65)
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
    keyInput.Position = UDim2.new(0, 20, 0, 95)
    keyInput.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
    keyInput.BorderSizePixel = 1
    keyInput.BorderColor3 = Color3.fromRGB(224, 224, 224)
    keyInput.Text = ""
    keyInput.PlaceholderText = "Enter your 16-character key here..."
    keyInput.TextColor3 = Color3.fromRGB(33, 33, 33)
    keyInput.PlaceholderColor3 = Color3.fromRGB(158, 158, 158)
    keyInput.TextScaled = true
    keyInput.Font = Enum.Font.RobotoMono
    keyInput.TextXAlignment = Enum.TextXAlignment.Center
    keyInput.ClearTextOnFocus = false
    keyInput.Parent = contentFrame

    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 8)
    inputCorner.Parent = keyInput

    -- Submit Button
    local submitButton = Instance.new("TextButton")
    submitButton.Size = UDim2.new(1, -40, 0, 50)
    submitButton.Position = UDim2.new(0, 20, 0, 160)
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
    statusLabel.Size = UDim2.new(1, -40, 0, 35)
    statusLabel.Position = UDim2.new(0, 20, 0, 220)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = ""
    statusLabel.TextColor3 = Color3.fromRGB(244, 67, 54)
    statusLabel.TextScaled = true
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextXAlignment = Enum.TextXAlignment.Center
    statusLabel.TextWrapped = true
    statusLabel.Parent = contentFrame

    -- Instructions Label
    local instructionsLabel = Instance.new("TextLabel")
    instructionsLabel.Size = UDim2.new(1, -40, 0, 25)
    instructionsLabel.Position = UDim2.new(0, 20, 0, 260)
    instructionsLabel.BackgroundTransparency = 1
    instructionsLabel.Text = "Get your key from the verification website"
    instructionsLabel.TextColor3 = Color3.fromRGB(117, 117, 117)
    instructionsLabel.TextScaled = true
    instructionsLabel.Font = Enum.Font.Gotham
    instructionsLabel.TextXAlignment = Enum.TextXAlignment.Center
    instructionsLabel.Parent = contentFrame

    return {
        screenGui = screenGui,
        keyInput = keyInput,
        submitButton = submitButton,
        statusLabel = statusLabel,
        mainFrame = mainFrame
    }
end

-- API Functions with improved error handling
local function verifyKeyWithAPI(key)
    local success, response = pcall(function()
        local url = API_BASE_URL .. "/api/verify?key=" .. HttpService:UrlEncode(key)
        local httpResponse = HttpService:GetAsync(url, false, {
            ["Content-Type"] = "application/json"
        })
        return httpResponse
    end)
    
    if success then
        local parseSuccess, data = pcall(function()
            return HttpService:JSONDecode(response)
        end)
        
        if parseSuccess then
            return data
        else
            warn("Failed to parse API response: " .. tostring(response))
            return { status = "invalid", message = "Invalid server response" }
        end
    else
        warn("Failed to verify key with API: " .. tostring(response))
        if string.find(tostring(response), "HTTP 404") then
            return { status = "invalid", message = "API endpoint not found" }
        elseif string.find(tostring(response), "HTTP 500") then
            return { status = "invalid", message = "Server error" }
        else
            return { status = "invalid", message = "Network error" }
        end
    end
end

-- DataStore Functions with improved error handling
local function saveKeyToDataStore(key)
    local success, error = pcall(function()
        keyDataStore:SetAsync(tostring(player.UserId), {
            key = key,
            savedAt = os.time()
        })
    end)
    
    if not success then
        warn("Failed to save key to DataStore: " .. tostring(error))
    end
    
    return success
end

local function getKeyFromDataStore()
    local success, keyData = pcall(function()
        return keyDataStore:GetAsync(tostring(player.UserId))
    end)
    
    if success and keyData then
        if type(keyData) == "string" then
            -- Legacy format - just the key string
            return keyData
        elseif type(keyData) == "table" and keyData.key then
            -- New format - table with key and metadata
            return keyData.key
        end
    end
    
    return nil
end

local function removeKeyFromDataStore()
    local success, error = pcall(function()
        keyDataStore:RemoveAsync(tostring(player.UserId))
    end)
    
    if not success then
        warn("Failed to remove key from DataStore: " .. tostring(error))
    end
    
    return success
end

-- Animation Functions
local function animateButton(button, scale)
    local originalSize = button.Size
    local tween = TweenService:Create(
        button,
        TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = originalSize * scale}
    )
    tween:Play()
    
    tween.Completed:Connect(function()
        local backTween = TweenService:Create(
            button,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = originalSize}
        )
        backTween:Play()
    end)
end

local function showLoadingState(gui, loading)
    if loading then
        gui.submitButton.Text = "Verifying..."
        gui.submitButton.BackgroundColor3 = Color3.fromRGB(158, 158, 158)
        gui.keyInput.TextEditable = false
    else
        gui.submitButton.Text = "Verify Key"
        gui.submitButton.BackgroundColor3 = Color3.fromRGB(25, 118, 210)
        gui.keyInput.TextEditable = true
    end
end

-- Main Key Verification Logic
local function handleKeyVerification(key, gui)
    if not key or key == "" then
        gui.statusLabel.Text = "Please enter a key"
        gui.statusLabel.TextColor3 = Color3.fromRGB(244, 67, 54)
        return false
    end
    
    -- Clean up the key (remove spaces, convert to uppercase)
    key = string.upper(string.gsub(key, "%s+", ""))
    
    if #key ~= 16 then
        gui.statusLabel.Text = "Key must be exactly 16 characters"
        gui.statusLabel.TextColor3 = Color3.fromRGB(244, 67, 54)
        return false
    end
    
    -- Check if key contains only valid characters
    if not string.match(key, "^[A-Z0-9]+$") then
        gui.statusLabel.Text = "Key contains invalid characters"
        gui.statusLabel.TextColor3 = Color3.fromRGB(244, 67, 54)
        return false
    end
    
    -- Show loading state
    showLoadingState(gui, true)
    gui.statusLabel.Text = "Checking key with server..."
    gui.statusLabel.TextColor3 = Color3.fromRGB(25, 118, 210)
    
    -- Verify with API
    local result = verifyKeyWithAPI(key)
    
    if result.status == "valid" then
        -- Key is valid, save to DataStore and close GUI
        gui.statusLabel.Text = "Key verified successfully!"
        gui.statusLabel.TextColor3 = Color3.fromRGB(76, 175, 80)
        
        local saveSuccess = saveKeyToDataStore(key)
        if not saveSuccess then
            gui.statusLabel.Text = "Warning: Key verified but not saved locally"
            gui.statusLabel.TextColor3 = Color3.fromRGB(255, 152, 0)
        end
        
        wait(1.5)
        keyVerified = true
        
        -- Animate GUI out
        local closeTween = TweenService:Create(
            gui.mainFrame,
            TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In),
            {Size = UDim2.new(0, 0, 0, 0)}
        )
        closeTween:Play()
        
        closeTween.Completed:Connect(function()
            gui.screenGui:Destroy()
            onKeyVerified()
        end)
        
        return true
    elseif result.status == "expired" then
        gui.statusLabel.Text = "Key has expired. Please get a new key."
        gui.statusLabel.TextColor3 = Color3.fromRGB(255, 152, 0)
        removeKeyFromDataStore()
    elseif result.status == "invalid" then
        gui.statusLabel.Text = result.message or "Invalid key. Please check and try again."
        gui.statusLabel.TextColor3 = Color3.fromRGB(244, 67, 54)
    else
        gui.statusLabel.Text = result.message or "Server error. Please try again later."
        gui.statusLabel.TextColor3 = Color3.fromRGB(244, 67, 54)
    end
    
    -- Reset button state
    showLoadingState(gui, false)
    
    return false
end

-- Main function that runs when key is verified
function onKeyVerified()
    print("Key verified! Running main script...")
    
    -- ADD YOUR MAIN SCRIPT FUNCTIONALITY HERE
    -- This is where you put the code that should run after key verification
    
    -- Create success notification
    local notification = Instance.new("ScreenGui")
    notification.Name = "VerificationNotification"
    notification.Parent = playerGui
    
    local notifFrame = Instance.new("Frame")
    notifFrame.Size = UDim2.new(0, 350, 0, 100)
    notifFrame.Position = UDim2.new(1, -20, 0, 20) -- Start off-screen
    notifFrame.BackgroundColor3 = Color3.fromRGB(76, 175, 80)
    notifFrame.BorderSizePixel = 0
    notifFrame.Parent = notification
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 12)
    notifCorner.Parent = notifFrame
    
    -- Success icon
    local iconFrame = Instance.new("Frame")
    iconFrame.Size = UDim2.new(0, 40, 0, 40)
    iconFrame.Position = UDim2.new(0, 15, 0.5, -20)
    iconFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    iconFrame.BackgroundTransparency = 0.8
    iconFrame.Parent = notifFrame
    
    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(1, 0)
    iconCorner.Parent = iconFrame
    
    -- Notification text
    local notifText = Instance.new("TextLabel")
    notifText.Size = UDim2.new(1, -70, 1, 0)
    notifText.Position = UDim2.new(0, 65, 0, 0)
    notifText.BackgroundTransparency = 1
    notifText.Text = "✓ Access Granted!\nScript is now active and ready to use."
    notifText.TextColor3 = Color3.fromRGB(255, 255, 255)
    notifText.TextScaled = true
    notifText.Font = Enum.Font.GothamBold
    notifText.TextXAlignment = Enum.TextXAlignment.Left
    notifText.Parent = notifFrame
    
    -- Animate notification in
    local slideInTween = TweenService:Create(
        notifFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = UDim2.new(1, -370, 0, 20)}
    )
    slideInTween:Play()
    
    -- Remove notification after 4 seconds
    game:GetService("Debris"):AddItem(notification, 4)
    
    -- Slide notification out after 3 seconds
    wait(3)
    local slideOutTween = TweenService:Create(
        notifFrame,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
        {Position = UDim2.new(1, -20, 0, 20)}
    )
    slideOutTween:Play()
end

-- Initialize the key system with improved error handling
local function initializeKeySystem()
    print("Initializing Key System...")
    
    -- Check for HttpService availability
    if not HttpService.HttpEnabled then
        warn("HttpService is disabled! Key verification will not work.")
        local errorGui = createKeyInputGUI()
        errorGui.statusLabel.Text = "HttpService is disabled in this game"
        errorGui.statusLabel.TextColor3 = Color3.fromRGB(244, 67, 54)
        errorGui.submitButton.Text = "Cannot Verify"
        errorGui.submitButton.BackgroundColor3 = Color3.fromRGB(158, 158, 158)
        return
    end
    
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
    
    -- Animate GUI in
    keyGui.mainFrame.Size = UDim2.new(0, 0, 0, 0)
    keyGui.mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    local animateInTween = TweenService:Create(
        keyGui.mainFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {
            Size = UDim2.new(0, 450, 0, 350),
            Position = UDim2.new(0.5, -225, 0.5, -175)
        }
    )
    animateInTween:Play()
    
    -- Connect submit button
    keyGui.submitButton.MouseButton1Click:Connect(function()
        animateButton(keyGui.submitButton, 0.95)
        local key = keyGui.keyInput.Text
        handleKeyVerification(key, keyGui)
    end)
    
    -- Connect Enter key in TextBox
    keyGui.keyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            animateButton(keyGui.submitButton, 0.95)
            local key = keyGui.keyInput.Text
            handleKeyVerification(key, keyGui)
        end
    end)
    
    -- Auto-focus on TextBox after animation
    animateInTween.Completed:Connect(function()
        keyGui.keyInput:CaptureFocus()
    end)
    
    -- Add close button functionality (X button)
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.BackgroundTransparency = 1
    closeButton.Text = "×"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = keyGui.mainFrame:FindFirstChild("Frame") -- Header frame
    
    closeButton.MouseButton1Click:Connect(function()
        keyGui.screenGui:Destroy()
        print("Key verification cancelled by user")
    end)
end

-- Handle player joining with improved timing
local function onPlayerReady()
    -- Wait a bit for the character to fully load
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        wait(1)
    else
        player.CharacterAdded:Wait()
        wait(1)
    end
    
    if not keyVerified then
        initializeKeySystem()
    end
end

-- Initialize when player is ready
if player then
    spawn(onPlayerReady)
else
    -- Fallback if player service is not available yet
    spawn(function()
        while not player do
            wait(0.1)
            player = Players.LocalPlayer
        end
        onPlayerReady()
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

-- Optional: Add a function to check current key status
function checkKeyStatus()
    local savedKey = getKeyFromDataStore()
    if savedKey then
        local result = verifyKeyWithAPI(savedKey)
        print("Current key status:", result.status)
        return result
    else
        print("No key saved")
        return { status = "none" }
    end
end

print("Roblox Key System loaded successfully!")
print("Version: 2.0 - Updated with Replit Database integration")
print("Remember to replace 'your-replit-project.replit.app' with your actual Replit URL!")
print("Use resetKeySystem() to reset the key verification for testing")
print("Use checkKeyStatus() to check the current key status")
