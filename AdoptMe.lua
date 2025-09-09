local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local load = require(game.ReplicatedStorage:WaitForChild("Fsys")).load
local TradeApp = require(game:GetService("ReplicatedStorage").ClientModules.Core.UIManager.Apps.TradeApp)
local getData = require(game.ReplicatedStorage.ClientModules.Core.ClientData).get_data
local petDatabase = require(game.ReplicatedStorage.ClientDB.Inventory.InventoryDB).pets
local InventoryDB = require(game:GetService("ReplicatedStorage").ClientDB.Inventory.InventoryDB)

local RouterClient = load("RouterClient")
local ClientData = load("ClientData")
local SendTradeRequest = RouterClient.get("TradeAPI/SendTradeRequest")

local_offer = nil

local func

local old1
local old2
local old3
local old4
local old5

local petstbl = {
	"Bat Dragon",
	"Frost Dragon",
	"Shadow Dragon",
	"Giraffe",
	"Owl",
	"Parrot",
	"Crow",
	"Evil Unicorn",
	"Arctic Reindeer",
	"Diamond Butterfly",
	"Hedgehog",
	"Balloon Unicorn",
	"Blazing Lion",
	"Dalmatian",
	"Orchid Butterfly",
	"Turtle",
	"Pelican",
	"Monkey King",
	"Albino Monkey",
	"Haetae",
	"Frostbite Bear",
	"Strawberry Shortcake Bat Dragon",
	"Hot Doggo",
	"Chocolate Chip Bat Dragon",
	"Kangaroo",
	"Cow",
	"Pirate Ghost Capuchin Monkey",
	"Flamingo",
	"African Wild Dog",
	"Peppermint Penguin",
	"Lion",
	"Crocodile",
	"Elephant",
	"Blue Dog",
	"Caterpillar",
	"Frost Fury",
	"Lava Dragon",
	"Golden Penguin",
	"Candyfloss Chick",
	"Nessie",
	"Vampire Dragon",
	"Winged Tiger",
	"Sugar Glider",
	"Mechapup",
	"Fairy Bat Dragon",
	"Undead Jousting Horse",
	"Cupid Dragon",
	"Golden Chow-Chow",
	"Mini Pig",
	"Irish Water Spaniel",
	"Goat",
	"Glacier Moth",
	"Sheeeeep",
	"Goose",
	"Pig",
	"Pink Cat",
	"Meerkat"
}
local function get_platform()
	local userInputService = game:GetService("UserInputService")
	if userInputService.TouchEnabled then
		return "mobile"
	else
		return "pc"
	end
end
for k,v in pairs(getgc(true)) do
	if typeof(v) == "table" and rawget(v,"trade") then
		for kk,vv in pairs(v['trade']) do
			if typeof(tonumber(kk)) == "number" then
				func = vv
			end
		end
	end
end
old1 = hookfunction(TradeApp._change_local_trade_state,function(a,b)
	for k,v in pairs(b) do
		if k == "sender_offer" or k == "recipient_offer" then
			for kk,vv in pairs(v) do
				if kk == "items" then
					local_offer = v.items
				end
			end
		else

		end
	end
	return old1(a,b)
end)
old2 = hookfunction(TradeApp._overwrite_local_trade_state,function(a,b)
	if a~=nil and b~= nil and local_offer ~= nil then
		if game.Players.LocalPlayer == b.sender then
			b.sender_offer.items = local_offer
		else
			b.recipient_offer.items = local_offer
		end
	end
	return old2(a,b)
end)
old3 = hookfunction(TradeApp._remove_item_from_my_offer,function(p174, p175)
	local function findKey(alltables,needtable)
		for k,v in pairs(alltables) do
			if v["unique"] == needtable["unique"] then
				return k
			end
		end
	end
	if p175.category == "houses" then
		p174.UIManager.apps.HintApp:hint({
			["text"] = "You can't remove this item.",
			["length"] = 5,
			["overridable"] = true
		})
	else
		RouterClient.get("TradeAPI/RemoveItemFromOffer"):FireServer(p175.unique)
		local v176, v177 = p174:_get_my_offer()
		local v178 = findKey(v176.items,p175)
		table.remove(v176.items, v178)
		local v179 = {
			[v177] = {
				["items"] = v176.items
			}
		}
		p174:_change_local_trade_state(v179)
		p174:_lock_trade_for_appropriate_time()
		p174:refresh_all()
	end
end)
old4 = hookfunction(func,function(...)
	local args = {...}
	if #args > 2 then
		for k,v in pairs(args) do
			if typeof(v) == "table" then
				if local_offer ~= nil then
					if game.Players.LocalPlayer == v.sender then
						v["sender_offer"]["items"] = local_offer
					else
						v["recipient_offer"]["items"] = local_offer
					end
				end
			end
		end
	else
	end
	return old4(unpack(args))
end)
old5 = hookfunction(TradeApp.hide,function(...)
	if local_offer ~= nil then
		for k,v in pairs(ClientData.get("inventory")["pets"]) do
			for kk,vv in pairs(local_offer) do
				if vv['unique'] == k then
					ClientData.get("inventory")["pets"][k] = nil
				end
			end
		end
	end
	local_offer = nil
	return old5(...)
end)
getgenv().ForcedPartnerName = nil
local SavedApp = nil
local function UpdateNamesTradeApp()
	if not SavedApp then return end
	local UDim2New = get_platform() == "mobile" and 140 or 220
	if getgenv().ForcedPartnerName then
		pcall(function()
			if SavedApp.negotiation_partner_name_label then
				SavedApp.negotiation_partner_name_label.Text = getgenv().ForcedPartnerName
				SavedApp.negotiation_partner_name_label.Size = UDim2.new(0, UDim2New, 1, 0)
				SavedApp.negotiation_partner_name_label.Size = UDim2.new(0, math.min(UDim2New, SavedApp.negotiation_partner_name_label.TextBounds.X), 1, 0)
			end
			if SavedApp.confirmation_partner_name_label then
				SavedApp.confirmation_partner_name_label.Text = getgenv().ForcedPartnerName
			end
		end)
	else
		pcall(function()
			if SavedApp.state then
				if SavedApp.negotiation_partner_name_label and SavedApp.state._original_negotiation_name then
					SavedApp.negotiation_partner_name_label.Text = SavedApp.state._original_negotiation_name
					SavedApp.negotiation_partner_name_label.Size = UDim2.new(0, UDim2New, 1, 0)
					SavedApp.negotiation_partner_name_label.Size = UDim2.new(0, math.min(UDim2New, SavedApp.negotiation_partner_name_label.TextBounds.X), 1, 0)	
				end
				if SavedApp.confirmation_partner_name_label and SavedApp.state._original_confirmation_name then
					SavedApp.confirmation_partner_name_label.Text = SavedApp.state._original_confirmation_name
				end
			end
		end)
	end
end
local old_refresh_all
old_refresh_all = hookfunction(TradeApp.refresh_all, function(app, ...)
	SavedApp = app
	pcall(function()
		if app.state then
			if app.negotiation_partner_name_label then
				app.state._original_negotiation_name = app.negotiation_partner_name_label.Text
			end
			if app.confirmation_partner_name_label then
				app.state._original_confirmation_name = app.confirmation_partner_name_label.Text
			end
		end
	end)
	local result = old_refresh_all(app, ...)
	UpdateNamesTradeApp()
	return result
end)

local App = nil
AppHook = hookfunction(TradeApp.start, function(ArgApp)
	App = ArgApp
	print("TradeApp.start Called!")
	return AppHook(ArgApp)
end)

getgenv().UsedAges = getgenv().UsedAges or {}
local function getUniqueRandomAge()
	local age
	repeat
		age = math.random(1, 2000000)
	until not getgenv().UsedAges[age]
	getgenv().UsedAges[age] = true
	return age
end
local function makePetPattern(id, kind, unique, neon, mega, fly, ride, stacks)
	local ageRandom = 3
	if stacks then
		ageRandom = getUniqueRandomAge()
	end
	if neon then
		neon = true
		mega = false
	elseif mega then
		neon = false
		mega = true
	end
	return {
		["unique"] = unique,
		["category"] = "pets",
		["id"] = id,
		["kind"] = kind,
		["properties"] = {
			["pet_trick_level"] = 0,
			["rideable"] = false,
			["friendship_level"] = 0,
			["age"] = ageRandom,
			["flyable"] = fly,
			["rideable"] = ride,
			["neon"] = neon,
			["mega_neon"] = mega,
			["ailments_completed"] = 0
		},
		["newness_order"] = 0
	}
end
local usedUniques = {}
local function createUnique()
	local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	local Unique
	repeat
		Unique = ""
		for i = 1, 16 do
			Unique = Unique .. chars:sub(math.random(1, #chars), math.random(1, #chars))
		end
	until not usedUniques[Unique]
	usedUniques[Unique] = true
	return "2_" .. Unique .. "_iPad"
end
local function createPet(name,fly,ride,neon,meganeon, stacks)
	for k,v in pairs(InventoryDB.pets) do
		if v["name"]:lower() == name:lower() then
			local uniq = "2_"..createUnique()
			ClientData.get("inventory")["pets"][uniq] = makePetPattern(v['id'],v['kind'],uniq,neon,meganeon,fly,ride, stacks)
		end
	end
end

local ImGui =  loadstring(game:HttpGet('https://pastebin.com/raw/3Sp2zUFP'))()
local Window = ImGui:CreateWindow({
	Title = "Adopt Me | ",
	Size = UDim2.new(0, 200, 0, 250),
	Position = UDim2.new(0.10, 0, 0, 70)
})
Window:Center()
local AdoptMeHelper = {
	Nicknames = {
		Nickname = nil,
		Status = "Not Changed"
	},
	Trades = {
		SelectedTradePlayer = nil
	},
	Misc = {
		SelectedBlockPlayer = nil
	}
}
local TradeTab = Window:CreateTab({
	Name = "Trade",
	Visible = true
})
TradeTab:Separator({Text = "Change Nicknames"})
local StatusNicknameText
local StatusNicknameStatusText
local PlayerCombo = TradeTab:Combo({
	Placeholder = "Select player",
	Label = "(0)",
	Items = {},
	Callback = function(self, Value)
		AdoptMeHelper.Nicknames.Nickname = string.lower(Value)
	end,
})
TradeTab:InputText({
	PlaceHolder = "Search player",
	Callback = function(self, text)
		local filtered = {}
		for _, plr in ipairs(Players:GetPlayers()) do
			if text == "" or string.find(plr.Name:lower(), text:lower()) then
				filtered[plr.Name] = plr.Name
			end
		end
		PlayerCombo.Items = filtered
	end,
})
TradeTab:Button({
	Text = "Make Name",
	Callback = function(self)
		if AdoptMeHelper.Nicknames.Nickname and AdoptMeHelper.Nicknames.Nickname ~= "" then
			getgenv().ForcedPartnerName = AdoptMeHelper.Nicknames.Nickname
			AdoptMeHelper.Nicknames.Status = "Forced"
			StatusNicknameText.Text = "Nickname: " .. AdoptMeHelper.Nicknames.Nickname
			StatusNicknameStatusText.Text = "Status: Forced"

			UpdateNamesTradeApp()
		end
	end
})
local usedNames = {}
TradeTab:Button({
	Text = "Make random name",
	Callback = function(self)
		local userIds = {6084968701, 5176928854, 7548309009, 617157690, 5019576643, 7927883444}
		local function getRandomFriend()
			for i = 1, #userIds do
				local randomIndex = math.random(1, #userIds)
				local userid = userIds[randomIndex]
				local success, friendPages = pcall(function()
					return Players:GetFriendsAsync(userid)
				end)
				if success and friendPages then
					local friends = friendPages:GetCurrentPage()
					local availableFriends = {}
					for _, friend in ipairs(friends) do
						if not usedNames[friend.Username] then
							table.insert(availableFriends, friend)
						end
					end
					if #availableFriends > 0 then
						local chosen = availableFriends[math.random(1, #availableFriends)]
						usedNames[chosen.Username] = true
						return chosen
					end
				end
			end
			return nil
		end
		local randomFriend = getRandomFriend()
		if not randomFriend then return end
		getgenv().ForcedPartnerName = randomFriend.Username
		AdoptMeHelper.Nicknames.Status = "Forced"
		StatusNicknameText.Text = "Nickname: " .. randomFriend.Username
		StatusNicknameStatusText.Text = "Status: Forced"

		UpdateNamesTradeApp()
	end
})
TradeTab:Button({
	Text = "Reload",
	Callback = function(self)
		getgenv().ForcedPartnerName = nil
		AdoptMeHelper.Nicknames.Status = "Not Changed"
		AdoptMeHelper.Nicknames.Nickname = nil
		StatusNicknameText.Text = "Nickname: none"
		StatusNicknameStatusText.Text = "Status: Not Changed"
		PlayerCombo:SetPlaceholder("Select player")
		UpdateNamesTradeApp()
	end
})
TradeTab:Separator({Text = "Status"})
StatusNicknameText = TradeTab:Label()
StatusNicknameStatusText = TradeTab:Label()
StatusNicknameText.Text = "Nickname: none"
StatusNicknameStatusText.Text = "Status: Not Changed"
local function UpdatePlayers()
	local items = {}
	for _, plr in ipairs(Players:GetPlayers()) do
		items[plr.Name] = plr.Name
	end
	PlayerCombo.Items = items
	PlayerCombo:SetLabel("("..#Players:GetPlayers()..")")
end
Players.PlayerAdded:Connect(UpdatePlayers)
Players.PlayerRemoving:Connect(UpdatePlayers)
UpdatePlayers()
TradeTab:Separator({Text = "Actions"})
local TradePlayerCombo = TradeTab:Combo({
	Placeholder = "Select player",
	Label = "(0)",
	Items = {},
	Callback = function(self, Value)
		AdoptMeHelper.Trades.SelectedTradePlayer = Players[Value]
	end
})
TradeTab:InputText({
	PlaceHolder = "Search player",
	Callback = function(self, text)
		local filtered = {}
		for _, plr in ipairs(Players:GetPlayers()) do
			if text == "" or string.find(plr.Name:lower(), text:lower()) then
				filtered[plr.Name] = plr.Name
			end
		end
		TradePlayerCombo.Items = filtered
	end
})
TradeTab:Button({
	Text = "Send Trade",
	Callback = function()
		if AdoptMeHelper.Trades.SelectedTradePlayer then
			SendTradeRequest:FireServer(AdoptMeHelper.Trades.SelectedTradePlayer)
		end
	end
})
TradeTab:Button({
	Text = "Send Trade all players",
	Callback = function()
		for _, Player in pairs(game:GetService("Players"):GetPlayers()) do
			SendTradeRequest:FireServer(Player)
		end
	end
})
TradeTab:Button({
	Text = "Make fake trade",
	Callback = function()
		TradeApp.start(App)
		
		local _get_my_offer_hooked = hookfunction(TradeApp._get_my_offer, function(p96)
			local v97 = p96:_get_local_trade_state()
			v97.sender = game.Players.LocalPlayer;
			p96.spectating = false
			if p96.spectating or game.Players.LocalPlayer == v97.sender then
				return v97.sender_offer, "sender_offer";
			else
				return v97.recipient_offer, "recipient_offer";
			end;
		end)
		
	end
})
local function UpdateTradePlayers()
	local items = {}
	for _, plr in ipairs(Players:GetPlayers()) do
		items[plr.Name] = plr.Name
	end
	TradePlayerCombo.Items = items
	TradePlayerCombo:SetLabel("("..#Players:GetPlayers()..")")
end
Players.PlayerAdded:Connect(UpdateTradePlayers)
Players.PlayerRemoving:Connect(UpdateTradePlayers)
UpdateTradePlayers()



local PetsTab = Window:CreateTab({
	Name = "Inv",
	Visible = false
})
PetsTab:Separator({Text = "Spawn high tier pets"})
PetsTab:Button({
	Text = "Spawn pets - Random",
	Callback = function(self)
		for _,namepet in pairs(petstbl) do
			for i = 1,math.random(1,2) do
				createPet(namepet,math.random(0,1) == 1,math.random(0,1) == 1,math.random(0,1) == 1,math.random(0,1) == 1,true)
			end
		end
	end,
})
PetsTab:Button({
	Text = "Spawn pets - FR",
	Callback = function(self)
		for _,namepet in pairs(petstbl) do
			for i = 1,math.random(1,2) do
				createPet(namepet,true,true,false,false,true)
			end
		end
	end,
})
PetsTab:Button({
	Text = "Spawn pets - NFR",
	Callback = function(self)
		for _,namepet in pairs(petstbl) do
			for i = 1,math.random(1,2) do
				createPet(namepet,true,true,true,false,true)
			end
		end
	end,
})
PetsTab:Button({
	Text = "Spawn pets - MFR",
	Callback = function(self)
		for _,namepet in pairs(petstbl) do
			for i = 1,math.random(1,2) do
				createPet(namepet,true,true,false,true,true)
			end
		end
	end,
})



local MiscTab = Window:CreateTab({
	Name = "Misc",
	Visible = false
})
MiscTab:Separator({Text = "Block players"})
local BlockPlayerCombo = MiscTab:Combo({
	Placeholder = "Select player",
	Label = "(0)",
	Items = {},
	Callback = function(self, Value)
		AdoptMeHelper.Misc.SelectedBlockPlayer = Players[Value]
	end
})
MiscTab:InputText({
	PlaceHolder = "Search player",
	Callback = function(self, text)
		local filtered = {}
		for _, plr in ipairs(Players:GetPlayers()) do
			if text == "" or string.find(plr.Name:lower(), text:lower()) then
				filtered[plr.Name] = plr.Name
			end
		end
		BlockPlayerCombo.Items = filtered
	end
})
MiscTab:Button({
	Text = "Block player",
	Callback = function()
		local Selected = AdoptMeHelper.Misc.SelectedBlockPlayer
		if Selected then
			game:GetService("StarterGui"):SetCore("PromptBlockPlayer", Selected)
		end
	end
})
local function UpdateTradePlayers()
	local items = {}
	for _, plr in ipairs(Players:GetPlayers()) do
		items[plr.Name] = plr.Name
	end
	BlockPlayerCombo.Items = items
	BlockPlayerCombo:SetLabel("("..#Players:GetPlayers()..")")
end
Players.PlayerAdded:Connect(UpdateTradePlayers)
Players.PlayerRemoving:Connect(UpdateTradePlayers)
UpdateTradePlayers()



spawn(function()
	local LastPosition = nil
	game:GetService("RunService").Heartbeat:Connect(function()
		pcall(function()
			local PrimaryPart = LocalPlayer.Character.PrimaryPart
			if PrimaryPart.AssemblyLinearVelocity.Magnitude > 250 or PrimaryPart.AssemblyAngularVelocity.Magnitude > 250 then
				PrimaryPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
				PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
				PrimaryPart.CFrame = LastPosition
				game.StarterGui:SetCore("ChatMakeSystemMessage", {
					Text = "You were flung. Neutralizing velocity.";
					Color = Color3.fromRGB(255, 0, 0);
				})
			elseif PrimaryPart.AssemblyLinearVelocity.Magnitude < 50 or PrimaryPart.AssemblyAngularVelocity.Magnitude > 50 then
				LastPosition = PrimaryPart.CFrame
			end
		end)
	end)
end)
