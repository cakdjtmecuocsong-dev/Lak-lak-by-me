# Lak-lak-by-me
Good
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 1. Tạo ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpinbotGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- 2. Tạo Nút chính (Khung hình chữ nhật nằm ngang)
local mainButton = Instance.new("TextButton")
mainButton.Name = "MainButton"
mainButton.Size = UDim2.new(0, 100, 0, 30) -- Kích thước nhỏ, nằm ngang
mainButton.Position = UDim2.new(0.5, -50, 0.4, 0)
mainButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Nền màu đen
mainButton.BorderSizePixel = 0
mainButton.Text = "US "
mainButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- Chữ US màu trắng
mainButton.TextSize = 14
mainButton.Font = Enum.Font.SourceSansBold
mainButton.TextXAlignment = Enum.TextXAlignment.Left
mainButton.Parent = screenGui

-- Bo góc cho nút chính
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 6)
mainCorner.Parent = mainButton

-- Viền padding cho chữ US
local padding = Instance.new("UIPadding")
padding.PaddingLeft = UDim.new(0, 10)
padding.Parent = mainButton

-- 3. Tạo Nút trạng thái nhỏ bên trong (OFF / ON)
local statusButton = Instance.new("TextLabel")
statusButton.Name = "StatusLabel"
statusButton.Size = UDim2.new(0, 40, 0, 20)
statusButton.Position = UDim2.new(1, -45, 0.5, -10)
statusButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Nền đỏ khi OFF
statusButton.Text = "OFF"
statusButton.TextColor3 = Color3.fromRGB(255, 255, 255)
statusButton.TextSize = 12
statusButton.Font = Enum.Font.SourceSansBold
statusButton.Parent = mainButton

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 4)
statusCorner.Parent = statusButton

-- 4. Tính năng Kéo Thả (Drag)
local dragging = false
local dragInput, dragStart, startPos

local function updateDrag(input)
	local delta = input.Position - dragStart
	mainButton.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

mainButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainButton.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

mainButton.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		updateDrag(input)
	end
end)

-- 5. Logic Spinbot & Bật/Tắt
local spinActive = false
local spinSpeed = 120 -- Tốc độ xoay
local spinConnection = nil

local function toggleSpinbot()
	spinActive = not spinActive
	
	if spinActive then
		-- Cập nhật giao diện ON (Màu xanh lá)
		statusButton.Text = "ON"
		statusButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
		
		-- Kích hoạt xoay nhân vật
		spinConnection = RunService.RenderStepped:Connect(function(deltaTime)
			local character = player.Character
			if character and character:FindFirstChild("HumanoidRootPart") then
				local hrp = character.HumanoidRootPart
				hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
			end
		end)
	else
		-- Cập nhật giao diện OFF (Màu đỏ)
		statusButton.Text = "OFF"
		statusButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
		
		-- Hủy xoay
		if spinConnection then
			spinConnection:Disconnect()
			spinConnection = nil
		end
	end
end

-- Bắt sự kiện click
mainButton.MouseButton1Click:Connect(function()
	toggleSpinbot()
end)
