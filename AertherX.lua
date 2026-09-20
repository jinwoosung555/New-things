-- This file was generated at discord.gg/syncrypt

local v1 = unpack or table.unpack
local PlaceId = game.PlaceId
local _ = game.JobId
local v4 = if PlaceId ~= 2753915549 then if PlaceId ~= 4442272183 then PlaceId ~= 7449423635 and "unknown sea" or "Sea 3" else "Sea 2" else "Sea 1"
game:GetService("Players")

local _ = #game:GetService("Players"):GetPlayers()
game:GetService("RbxAnalyticsService"):GetClientId()
local v6 = identifyexecutor()
local HttpService = game:GetService("HttpService")
local v8 = "https://www.roblox.com/users/" .. game.Players.LocalPlayer.UserId
local num = tonumber("0xf7c74b")
local _game = game
local t1 = {
	url = ""
}
local v12 = "```" .. _game.Players.LocalPlayer.DisplayName .. "```"
local t2 = {
	name = "Name:",
	value = v12,
	inline = true
}
local v14 = "```" .. game.Players.LocalPlayer.Name .. "```"
local v15 = "```" .. v6 .. "```"
local v16 = "```" .. v4 .. "```"
local t3 = {
	name = "Sea:",
	value = v16,
	inline = true
}
local t4 = {
	t2,
	{
		name = "Acc:",
		value = v14,
		inline = true
	},
	{
		name = "Execute:",
		value = v15,
		inline = true
	},
	t3
}
local v19 = os.date("!%Y-%m-%dT%H:%M:%S")
local t5 = {
	["Content-Type"] = "application/json"
}
local json = HttpService:JSONEncode({
	embeds = {{
		title = "AertherX Auto Fruit",
		url = v8,
		description = "",
		color = num,
		thumbnail = t1,
		fields = t4,
		timestamp = v19
	}}
})
local _http_request = http_request
if not _http_request then
	_http_request = request

	if not _http_request then
		_http_request = HttpPost or syn.request
	end
end
_http_request({
	Url = "https://discord.gg/dkMGExGJbH",
	Body = json,
	Method = "POST",
	Headers = t5
})
require(game.ReplicatedStorage:WaitForChild("Notification")).new("AertherX ~ Auto Fruit"):Display()
require(game.ReplicatedStorage:WaitForChild("Notification")).new("Loading..."):Display()
local v23 = math.random(1, 1000000)

local function v24(p1)
	return p1 == nil
end
function UpdateDevilChams()
	for _, child in pairs(game.Workspace:GetChildren()) do
		local v53 = child

		pcall(function()
			if string.find(v53.Name, "Fruit") and not v24(v53:FindFirstChild("Handle")) then
				if not v53.Handle:FindFirstChild("NameEsp" .. v23) then
					local BillboardGui = Instance.new("BillboardGui", v53.Handle)

					BillboardGui.Name = "NameEsp" .. v23
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = v53.Handle
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = Enum.Font.GothamSemibold
					TextLabel.FontSize = Enum.FontSize.Size14
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = Enum.TextYAlignment.Top
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.new(1, 0, 0)
					TextLabel.Text = "Fruit"

					return
				end

				v53.Handle["NameEsp" .. v23].TextLabel.Text = "Fruit"
			end
		end)
	end
end
spawn(function()
	while wait(1) do
		UpdateDevilChams()
	end
end)

if game.IsLoaded and (game.Players.LocalPlayer or game.Players.PlayerAdded:Wait()) and not game.Players.LocalPlayer.Character then
	game.Players.LocalPlayer.CharacterAdded:Wait()
end
repeat
	wait()

	local IsLoaded = game.IsLoaded

	if IsLoaded then
		IsLoaded = game.Players.LocalPlayer or game.Players.PlayerAdded:Wait()

		if IsLoaded then
			IsLoaded = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
		end
	end
until IsLoaded
game.Players.LocalPlayer.Idled:connect(function()
	while wait(3) do
		if l then
			game.VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
			wait(1)
			game.VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
		end
	end
end)

local LocalPlayer = game.Players.LocalPlayer
local Character = LocalPlayer.Character
local TweenService = game.TweenService
local BodyVelocity = Instance.new("BodyVelocity")

BodyVelocity.MaxForce = Vector3.new(1e999, 1e999, 1e999)
BodyVelocity.Velocity = Vector3.new()
BodyVelocity.Name = "bV"
local BodyAngularVelocity = Instance.new("BodyAngularVelocity")

BodyAngularVelocity.AngularVelocity = Vector3.new()
BodyAngularVelocity.MaxTorque = Vector3.new(1e999, 1e999, 1e999)
BodyAngularVelocity.Name = "bAV"
local _next = next
local v32 = false
local v33, v34 = workspace:GetChildren()
while true do
	local v35

	v34, v35 = _next(v33, v34)

	if not v34 then
		break
	end

	local v36 = v35.Name:find("Fruit")

	if v36 then
		v36 = v35:IsA("Tool") or v35:IsA("Model")
	end

	if v36 then
		v32 = true
		game.StarterGui:SetCore("SendNotification", {
			Title = "AertherX",
			Text = "Picking Fruit",
			Duration = 10
		})

		if v35.Parent == workspace then
		end

		repeat
			local clone = BodyVelocity:Clone()

			clone.Parent = Character.HumanoidRootPart

			local clone2 = BodyAngularVelocity:Clone()

			clone2.Parent = Character.HumanoidRootPart

			local HumanoidRootPart = Character.HumanoidRootPart
			local new = TweenInfo.new
			local v41 = LocalPlayer:DistanceFromCharacter(v35.Handle.Position)
			local Linear = Enum.EasingStyle.Linear
			local tween = TweenService:Create(HumanoidRootPart, new((v41 - 150) / 300, Linear), {
				CFrame = v35.Handle.CFrame + Vector3.new(0, v35.Handle.Size.Y, 0)
			})

			tween:Play()
			tween.Completed:Wait()
			Character.HumanoidRootPart.CFrame = v35.Handle.CFrame
			clone:Destroy()
			clone2:Destroy()
			wait(1)
		until v35.Parent ~= workspace

		wait(1)

		local StarterGui = game.StarterGui
		local v45 = "Picked Fruit: " .. v35.Name

		StarterGui:SetCore("SendNotification", {
			Title = "AertherX",
			Text = v45,
			Duration = 10
		})

		local v46 = Character:FindFirstChildOfClass("Tool") and (not not Character:FindFirstChildOfClass("Tool").Name:find("Fruit") and Character:FindFirstChildOfClass("Tool")) or (function()
			for _, child in LocalPlayer.Backpack:GetChildren() do
				if child.Name:find("Fruit") then
					return child
				end
			end
		end)()

		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", v46:GetAttribute("OriginalName"), v46)
	end
end
if not v32 then
	game.StarterGui:SetCore("SendNotification", {
		Title = "AertherX",
		Text = "No Fruit Found",
		Duration = 5
	})
end
local u47 = false
local JobId = game.JobId
if JobId == game.JobId then
end
repeat
	task.spawn(pcall, function()
		Time = 0.1
		game:IsLoaded()

		repeat
			wait()
		until game:IsLoaded()

		wait(Time)

		local PlaceId2 = game.PlaceId
		local t6 = {}
		local s1 = ""
		local hour = os.date("!*t").hour

		function TPReturner()
			local data

			if s1 == "" then
				data = game.HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId2 .. "/servers/Public?sortOrder=Asc&limit=100"))
			else
				local HttpService2 = game.HttpService
				local t7 = { game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId2 .. "/servers/Public?sortOrder=Asc&limit=100&cursor=" .. s1) }

				data = HttpService2:JSONDecode(v1(t7))
			end

			local s2 = ""
			local nextPageCursor = data.nextPageCursor

			if nextPageCursor then
				nextPageCursor = data.nextPageCursor ~= "null" and data.nextPageCursor ~= nil
			end

			if nextPageCursor then
				s1 = data.nextPageCursor
			end

			local n1 = 0

			for _, v in pairs(data.data) do
				local v74 = true

				s2 = tostring(v.id)

				if tonumber(v.maxPlayers) > tonumber(v.playing) then
					for _, v2 in pairs(t6) do
						if n1 ~= 0 then
							if s2 == tostring(v2) then
								v74 = false
							end
						elseif tonumber(hour) ~= tonumber(v2) then
							pcall(function(...)
								delfile("NotSameServers.json")
								t6 = {}
								table.insert(t6, hour)
							end)
						end

						n1 += 1
					end

					if v74 == true then
						local insert = table.insert
						local v78 = s2

						insert(t6, v78)
						wait()
						pcall(function()
							writefile("NotSameServers.json", game:GetService("HttpService"):JSONEncode(t6))
							wait()

							local TeleportService = game:GetService("TeleportService")
							local LocalPlayer2 = game.Players.LocalPlayer

							TeleportService:TeleportToPlaceInstance(PlaceId2, s2, LocalPlayer2)
						end)
						wait(4)
					end
				end
			end
		end
		function Teleport()
			while wait() do
				pcall(function()
					TPReturner()

					if s1 ~= "" then
						TPReturner()
					end
				end)
			end
		end

		if not u47 then
			game.StarterGui:SetCore("SendNotification", {
				Title = "AertherX",
				Text = "Changing Server...",
				Duration = 10
			})
			u47 = true
		end

		Teleport()
	end)
	wait()
until JobId ~= game.JobId
function PostWebhook(p2, p3)
	local _http_request2 = http_request

	if not _http_request2 then
		_http_request2 = request

		if not _http_request2 then
			_http_request2 = HttpPost or syn.request
		end
	end

	local t8 = {
		["Content-Type"] = "application/json"
	}

	_http_request2({
		Url = p2,
		Method = "POST",
		Headers = t8,
		Body = game:GetService("HttpService"):JSONEncode(p3)
	})

	return ""
end
