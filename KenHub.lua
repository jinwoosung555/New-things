do
    local environment = getgenv()

    environment._premTag = function(name)
        return tostring(name)
    end
    environment._isPremiumUser = function()
        return true
    end
end
do
    local environment = getgenv()
    local runtime = environment.__KenHubUIRuntime or {}

    function runtime.corner(radius, parent)
        if typeof(parent) ~= 'Instance' then
            return nil
        end

        local object = Instance.new('UICorner')

        object.CornerRadius = UDim.new(0, tonumber(radius) or 8)
        object.Parent = parent

        return object
    end
    function runtime.stroke(color, thickness, parent)
        if typeof(parent) ~= 'Instance' then
            return nil
        end

        local object = Instance.new('UIStroke')

        object.Color = color or Color3.fromRGB(85, 213, 254)
        object.Thickness = tonumber(thickness) or 1
        object.Parent = parent

        return object
    end
    function runtime.gradient(parent, firstColor, secondColor, rotation)
        if typeof(parent) ~= 'Instance' then
            return nil
        end

        local object = Instance.new('UIGradient')

        object.Color = ColorSequence.new(firstColor or Color3.fromRGB(18, 24, 64), secondColor or firstColor or Color3.fromRGB(24, 32, 85))
        object.Rotation = tonumber(rotation) or 0
        object.Parent = parent

        return object
    end
    function runtime.shadow(parent)
        if typeof(parent) ~= 'Instance' then
            return nil
        end

        local object = Instance.new('ImageLabel')

        object.Name = 'KenHubShadow'
        object.BackgroundTransparency = 1
        object.Position = UDim2.new(0, -18, 0, -18)
        object.Size = UDim2.new(1, 36, 1, 36)
        object.Image = 'rbxassetid://6015897843'
        object.ImageColor3 = Color3.new(0, 0, 0)
        object.ImageTransparency = 0.42
        object.ScaleType = Enum.ScaleType.Slice
        object.SliceCenter = Rect.new(49, 49, 450, 450)
        object.ZIndex = 0
        object.Parent = parent

        return object
    end
    function runtime.tw(instance, properties, duration, easingStyle, easingDirection)
        if typeof(instance) ~= 'Instance' or type(properties) ~= 'table' then
            return nil
        end

        local tween = game:GetService('TweenService'):Create(instance, TweenInfo.new(tonumber(duration) or 0.2, easingStyle or Enum.EasingStyle.Quad, easingDirection or Enum.EasingDirection.Out), properties)

        tween:Play()

        return tween
    end

    environment.__KenHubUIRuntime = runtime
    environment.corner = runtime.corner
    environment.stroke = runtime.stroke
    environment.gradient = runtime.gradient
    environment.shadow = runtime.shadow
    environment.tw = runtime.tw
end

if not getgenv()._nagPremium then
    local function _nagPremium() end

    getgenv()._nagPremium = _nagPremium
end

local TweenService = game:GetService('TweenService')
local UserInputService = game:GetService('UserInputService')
local RunService = game:GetService('RunService')
local Players = game:GetService('Players')
local HttpService = game:GetService('HttpService')
local CoreGui = game:GetService('CoreGui')
local LocalPlayer = Players.LocalPlayer

do
    local function safeGetGlobal(name)
        local ok, v = pcall(function()
            return _G[name]
        end)

        if ok and v then
            return v
        end

        local ok2, v2 = pcall(function()
            return getgenv()[name]
        end)

        if ok2 and v2 then
            return v2
        end

        return rawget(_ENV or _G, name)
    end
    local function safeSetGlobal(name, value)
        pcall(function()
            getgenv()[name] = value
        end)
    end

    pcall(function()
        getgenv().__realGetRawMT = getgenv().__realGetRawMT or safeGetGlobal('getrawmetatable')
        getgenv().__realHookNamecall = getgenv().__realHookNamecall or safeGetGlobal('hookmetamethod')
        getgenv().__realNewCClosure = getgenv().__realNewCClosure or safeGetGlobal('newcclosure')
    end)

    local function stubGetRaw(_obj)
        return setmetatable({}, {
            __index = function()
                return function() end
            end,
            __newindex = function() end,
        })
    end
    local function stubHookNC(_obj, _method, _fn)
        return function()
            return nil
        end
    end

    safeSetGlobal('getrawmetatable', stubGetRaw)
    safeSetGlobal('hookmetamethod', stubHookNC)
    safeSetGlobal('setreadonly', function() end)
    safeSetGlobal('setrawmetatable', function(t, _mt)
        return t
    end)
    warn('[KenHub] Anti-detect stub installed (Delta-compatible).')
end

pcall(function()
    if not setclipboard then
        if toclipboard then
            setclipboard = toclipboard
        elseif Clipboard and Clipboard.set then
            setclipboard = function(s)
                Clipboard:set(s)
            end
        else
            setclipboard = function() end
        end
    end
    if not mouse1press then
        local VIM = game:GetService('VirtualInputManager')

        getgenv().mouse1press = function()
            pcall(function()
                VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
            end)
        end
        getgenv().mouse1release = function()
            pcall(function()
                VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1)
            end)
        end
    end
    if not getgenv().Drawing or type(getgenv().Drawing) ~= 'table' or not getgenv().Drawing.new then
        local DrawingObj = {
            new = function(_kind)
                local fake = setmetatable({
                    Visible = false,
                    Remove = function(self) end,
                    Destroy = function(self) end,
                }, {
                    __newindex = function() end,
                    __index = function()
                        return function() end
                    end,
                })

                return fake
            end,
            Fonts = {
                UI = 0,
                System = 1,
                Plex = 2,
                Monospace = 3,
            },
        }

        pcall(function()
            getgenv().Drawing = DrawingObj
        end)
    end
    if not request then
        if syn and syn.request then
            request = syn.request
        elseif http and http.request then
            request = http.request
        elseif http_request then
            request = http_request
        end
    end

    pcall(function()
        if request then
            getgenv().request = request
        end
    end)

    if not queue_on_teleport then
        getgenv().queue_on_teleport = function() end
    end
    if not gethui then
        getgenv().gethui = function()
            return game:GetService('CoreGui')
        end
    end
    if not identifyexecutor then
        getgenv().identifyexecutor = function()
            return 'Unknown', '0.0.0'
        end
    end
end)

local Theme = {
    WindowWidth = 720,
    WindowHeight = 520,
    HeaderHeight = 48,
    TabBarHeight = 44,
    BannerHeight = 62,
    Radius = 24,
    RadiusSm = 16,
    RadiusXs = 12,
    RadiusPill = 999,
    BgPrimary = Color3.fromRGB(18, 24, 64),
    BgSecondary = Color3.fromRGB(24, 32, 85),
    BgCard = Color3.fromRGB(35, 45, 110),
    BgCardHover = Color3.fromRGB(45, 60, 140),
    BgCardActive = Color3.fromRGB(40, 65, 160),
    BgHeader = Color3.fromRGB(14, 18, 50),
    BgInput = Color3.fromRGB(20, 28, 70),
    BgTabBar = Color3.fromRGB(20, 28, 70),
    Accent = Color3.fromRGB(85, 213, 254),
    AccentBright = Color3.fromRGB(135, 235, 255),
    AccentDark = Color3.fromRGB(50, 170, 220),
    AccentDim = Color3.fromRGB(30, 90, 130),
    AccentGlow = Color3.fromRGB(180, 240, 255),
    AccentSoft = Color3.fromRGB(100, 200, 255),
    Premium = Color3.fromRGB(255, 200, 50),
    PremiumDark = Color3.fromRGB(180, 130, 20),
    PremiumDim = Color3.fromRGB(50, 40, 10),
    BannerBg = Color3.fromRGB(15, 45, 100),
    BannerActive = Color3.fromRGB(25, 70, 150),
    TextPrimary = Color3.fromRGB(230, 245, 255),
    TextSecondary = Color3.fromRGB(160, 190, 230),
    TextMuted = Color3.fromRGB(80, 110, 160),
    TextDim = Color3.fromRGB(50, 70, 110),
    Border = Color3.fromRGB(30, 45, 100),
    BorderHi = Color3.fromRGB(60, 100, 220),
    Success = Color3.fromRGB(50, 220, 120),
    Error = Color3.fromRGB(255, 55, 75),
    Warning = Color3.fromRGB(255, 180, 50),
}
local SUPPORTED_GAMES = {
    {
        name = 'BedWars',
        icon = utf8.char(0x1f6cf),
        aliases = {
            'bedwars',
            'bed wars',
        },
        placeIds = {6872265039, 6872274481},
        features = 69,
        img = 'rbxassetid://6034281798',
    },
    {
        name = 'BedWars',
        icon = utf8.char(0x1f6cf),
        aliases = {
            'bedwars',
            'bed wars',
        },
        placeIds = {6872265039, 6872274481},
        features = 69,
        img = 'rbxassetid://6034281798',
    },
    {
        name = 'Taxi Boss',
        icon = utf8.char(0x1f695),
        aliases = {
            'taxi boss',
            'taxiboss',
            'taxi',
        },
        placeIds = {7305309231},
        features = 40,
        img = 'rbxassetid://6034281798',
    },
    {
        name = 'BloxStrike',
        icon = utf8.char(0x1f3af),
        aliases = {
            'bloxstrike',
            'blox strike',
        },
        placeIds = {114234929420007},
        features = 45,
        img = 'rbxassetid://6034281798',
    },
    {
        name = 'Anime Expeditions',
        icon = utf8.char(0x26a1),
        aliases = {
            'anime expeditions',
            'expeditions',
            'anime expedition',
        },
        placeIds = {84515722934860},
        features = 40,
        img = 'rbxassetid://6034281798',
    },
    {
        name = 'Arsenal',
        icon = utf8.char(0x1f3af),
        placeIds = {286090429, 2133507413},
        features = 20,
        img = 'rbxassetid://6034281798',
    },
    {
        name = 'Jujutsu Shenanigans',
        icon = utf8.char(0x26a1),
        aliases = {
            'jujutsu shenanigans',
            'jujutsu',
            'shenanigans',
        },
        placeIds = {9391468976},
        universeIds = {3508322461},
        features = 15,
        img = 'rbxassetid://6034281798',
    },
    {
        name = 'Abyss',
        icon = utf8.char(0x1f30a),
        placeIds = {8841631016, 6499213745},
        features = 22,
        img = 'rbxassetid://6034281798',
    },
    {
        name = 'Jailbreak',
        icon = utf8.char(0x1f6a8),
        placeIds = {606849621},
        features = 50,
        img = 'rbxassetid://6034281798',
    },
    {
        name = 'Sniper Duels',
        icon = utf8.char(0x1f3af),
        placeIds = {2957674229, 3519873232, 109397169461300},
        features = 12,
        img = 'rbxassetid://6034281798',
    },
    {
        name = 'Swing Obby',
        icon = utf8.char(0x1f3a2),
        placeIds = {5334680521},
        features = 10,
        img = 'rbxassetid://6034281798',
    },
    {
        name = 'Brookhaven',
        icon = utf8.char(0x1f3e0),
        placeIds = {4924922222},
        features = 15,
        img = 'rbxassetid://6034281798',
    },
    {
        name = '99 Nights',
        icon = utf8.char(0x1f319),
        placeIds = {13271790403, 14502339080},
        features = 28,
        img = 'rbxassetid://6034281798',
    },
    {
        name = 'Blox Fruits',
        icon = utf8.char(0x1f34e),
        aliases = {
            'blox fruits',
            'blox fruit',
            'bloxfruits',
        },
        placeIds = {2753915549, 4442272183, 7449423635},
        features = 18,
        img = 'rbxassetid://6034281798',
    },
    {
        name = 'Pet Sim 99',
        icon = utf8.char(0x1f43e),
        aliases = {
            'pet simulator 99',
            'pet sim 99',
            'petsim99',
        },
        placeIds = {8737899170, 15532244896, 15588347101},
        universeIds = {3317771874},
        features = 15,
        img = 'rbxassetid://6034281798',
    },
    {
        name = 'Bee Swarm',
        icon = utf8.char(0x1f41d),
        placeIds = {1537690962},
        features = 12,
        img = 'rbxassetid://6034281798',
    },
    {
        name = 'SAB',
        icon = utf8.char(0x1f916),
        aliases = {
            'steal a brainrot',
            'sab',
        },
        placeIds = {
            18668065096,
            1234567890,
            10495922230,
            109983668079237,
        },
        universeIds = {109983668079237},
        features = 24,
        img = 'rbxassetid://6034281798',
    },
    {
        name = 'Ultimate Battlegrounds',
        icon = utf8.char(0x1f52a),
        placeIds = {11815767793},
        features = 18,
        img = 'rbxassetid://6034281798',
    },
    {
        name = 'Strongest Battlegrounds',
        icon = utf8.char(0x1f525),
        placeIds = {10495922230},
        features = 15,
        img = 'rbxassetid://6034281798',
    },
    {
        name = 'Heroes Battlegrounds',
        icon = utf8.char(0x1f9b8),
        placeIds = {13076380114},
        features = 16,
        img = 'rbxassetid://6034281798',
    },
    {
        name = 'Legend Battlegrounds',
        icon = utf8.char(0x1f5e1),
        placeIds = {15269951959},
        features = 18,
        img = 'rbxassetid://6034281798',
    },
    {
        name = 'Jump for Brainrots',
        icon = utf8.char(0x1f9e0),
        placeIds = {139299356663913},
        features = 12,
        img = 'rbxassetid://6034281798',
    },
    {
        name = '+1 Jump Brainrot',
        icon = utf8.char(0x1f45f),
        placeIds = {121192350097093},
        features = 15,
        img = 'rbxassetid://6034281798',
    },
    {
        name = 'Grab Ores!',
        icon = utf8.char(0x26cf),
        placeIds = {82806856224736},
        features = 45,
        img = 'rbxassetid://6034281798',
    },
    {
        name = 'Murderers VS Sheriffs',
        icon = utf8.char(0x1f52a),
        placeIds = {135856908115931},
        features = 22,
        img = 'rbxassetid://6034281798',
    },
    {
        name = 'Sailor Piece',
        icon = utf8.char(0x2693),
        aliases = {
            'sailor piece',
            'sailor peace',
        },
        placeIds = {77747658251236},
        features = 38,
        img = 'rbxassetid://6034281798',
    },
    {
        name = 'MM2',
        icon = utf8.char(0x1f5e1),
        aliases = {
            'murder mystery 2',
            'mm2',
        },
        placeIds = {142823291, 80005698042109},
        features = 40,
        img = 'rbxassetid://6034281798',
    },
    {
        name = 'Kick a Lucky Block',
        icon = utf8.char(0x1f340),
        aliases = {
            'kick a lucky block',
            'lucky block',
            'kick lucky',
        },
        placeIds = {16955097151, 89469502395769},
        universeIds = {89469502395769},
        features = 30,
        img = 'rbxassetid://6034281798',
    },
    {
        name = 'Rivals',
        icon = utf8.char(0x1f52b),
        aliases = {
            'rivals',
            'rivals fps',
            'matchmaking',
        },
        placeIds = {17625359962, 14721849686, 117398147513099},
        universeIds = {6035872082},
        features = 22,
        img = 'rbxassetid://6034281798',
    },
    {
        name = 'Speed Keyboard Escape',
        icon = utf8.char(0x2328),
        aliases = {
            'speed keyboard escape',
            'keyboard escape',
            '1 speed keyboard escape',
            'escape candy chocolate',
            '1-speed-keyboard-escape',
            'keyboard',
        },
        placeIds = {95082159892680},
        features = 16,
        img = 'rbxassetid://6034281798',
    },
    {
        name = 'Speed Monkey Escape',
        icon = utf8.char(0x1f412),
        aliases = {
            'speed monkey escape',
            'monkey escape',
            '1 speed monkey escape',
            'monkey',
        },
        placeIds = {114697347887839},
        features = 20,
        img = 'rbxassetid://6034281798',
    },
    {
        name = 'Sell Lemons',
        icon = utf8.char(0x1f34b),
        aliases = {
            'sell lemons',
            'lemon tycoon',
            'lemons',
        },
        placeIds = {79268393072444},
        features = 14,
        img = 'rbxassetid://6034281798',
    },
    {
        name = 'Demonology',
        icon = utf8.char(0x1f47b),
        aliases = {
            'demonology',
            'ghost hunter',
            'demon',
        },
        placeIds = {18199615050},
        features = 12,
        img = 'rbxassetid://6034281798',
    },
    {
        name = 'Grow a Garden 2',
        icon = utf8.char(0x1f331),
        aliases = {
            'grow a garden 2',
            'grow a garden',
            'gag2',
            'gag 2',
        },
        placeIds = {97598239454123, 1588579651, 126884695634066},
        universeIds = {7436755782},
        features = 25,
        img = 'rbxassetid://6034281798',
    },
    {
        name = 'Welcome to Bloxburg',
        icon = utf8.char(0x1f3e0),
        aliases = {
            'welcome to bloxburg',
            'bloxburg',
        },
        placeIds = {185655149},
        features = 16,
        img = 'rbxassetid://6034281798',
    },
    {
        name = 'Adopt Me',
        icon = utf8.char(0x1f436),
        aliases = {
            'adopt me',
            'adoptme',
        },
        placeIds = {920587237},
        features = 12,
        img = 'rbxassetid://6034281798',
    },
    {
        name = "Dandy's World",
        icon = utf8.char(0x1f3a8),
        aliases = {
            'dandys world',
            'dandy',
            'dandys',
        },
        placeIds = {16267229903},
        features = 10,
        img = 'rbxassetid://6034281798',
    },
    {
        name = 'Blade Ball',
        icon = utf8.char(0x1f52a),
        aliases = {
            'blade ball',
            'bladeball',
            'bb',
        },
        placeIds = {13772394625, 14777999650, 15182888200},
        features = 25,
        img = 'rbxassetid://6034281798',
    },
    {
        name = 'KAT',
        icon = utf8.char(0x1f52a),
        placeIds = {621129760},
        universeIds = {228028122},
        features = 11,
        img = 'rbxassetid://6034281798',
    },
    {
        name = 'One Scope',
        icon = utf8.char(0x1f3af),
        placeIds = {135648408848758},
        features = 7,
        img = 'rbxassetid://6034281798',
    },
    {
        name = 'Da Hood',
        icon = utf8.char(0x1f3e0),
        aliases = {
            'da hood',
            'dahood',
            'dh',
        },
        placeIds = {
            2788229376,
            105305881594005,
            98343466176190,
            93778920465645,
            129449254792324,
            122120252103378,
            110917236678062,
            130879446158509,
        },
        features = 120,
        img = 'rbxassetid://6034281798',
    },
    {
        name = 'Evade',
        icon = utf8.char(0x1f3c3),
        aliases = {
            'evade',
            'rise',
        },
        placeIds = {9872472334},
        features = 45,
        img = 'rbxassetid://6034281798',
    },
    {
        name = 'Bridge Duel',
        icon = utf8.char(0x1f5e1),
        aliases = {
            'bridge duel',
            'bridge duels',
            'uoro',
        },
        placeIds = {139566161526375},
        features = 35,
        img = 'rbxassetid://6034281798',
    },
    {
        name = 'Drain the Lake',
        icon = utf8.char(0x1f4a7),
        aliases = {
            'drain the lake',
            'drain lake',
        },
        placeIds = {138381251771774},
        universeIds = {10267363348},
        features = 9,
        img = 'rbxassetid://6034281798',
    },
    {
        name = 'Prison Life',
        icon = utf8.char(0x1f6a8),
        aliases = {
            'prison life',
            'prison',
        },
        placeIds = {155615604},
        universeIds = {73885730},
        features = 9,
        img = 'rbxassetid://6034281798',
    },
    {
        name = 'Fish It',
        icon = utf8.char(0x1f41f),
        aliases = {
            'fish it',
            'fisch',
            'fishit',
        },
        placeIds = {121864768012064, 16732694052, 17445763782},
        features = 25,
        img = 'rbxassetid://6034281798',
    },
    {
        name = 'Volleyball Legends',
        icon = utf8.char(0x1f3d0),
        aliases = {
            'volley ball legends',
            'volleyball legends',
            'volleyball',
            'volley ball',
        },
        placeIds = {85395484560711},
        universeIds = {6931042565},
        features = 20,
        img = 'rbxassetid://6034281798',
    },
    {
        name = 'Flee the Facility',
        icon = utf8.char(0x1f3c3),
        aliases = {
            'flee city',
            'flee the facility',
            'flee',
        },
        placeIds = {893973440},
        universeIds = {372226183},
        features = 30,
        img = 'rbxassetid://6034281798',
    },
}

getgenv().SUPPORTED_GAMES = SUPPORTED_GAMES

local _detectedGame = nil
local _currentPlaceId = tonumber(game.PlaceId) or 0
local _currentGameId = tonumber(game.GameId) or 0
local _gameName = ''

pcall(function()
    local info = game:GetService('MarketplaceService'):GetProductInfo(_currentPlaceId)

    if info and info.Name then
        _gameName = info.Name:lower()
    end
end)

for _, gd in ipairs(SUPPORTED_GAMES)do
    if gd.placeIds then
        for _, pid in ipairs(gd.placeIds)do
            if _currentPlaceId == tonumber(pid) then
                _detectedGame = gd

                break
            end
        end
    end
    if not _detectedGame and gd.universeIds then
        for _, uid in ipairs(gd.universeIds)do
            if _currentGameId == tonumber(uid) then
                _detectedGame = gd

                break
            end
        end
    end
    if _detectedGame then
        break
    end
end

if not _detectedGame and _gameName ~= '' then
    for _, gd in ipairs(SUPPORTED_GAMES)do
        local gNameLower = gd.name:lower()

        if _gameName:find(gNameLower, 1, true) then
            _detectedGame = gd

            break
        end
        if gd.aliases then
            for _, alias in ipairs(gd.aliases)do
                local aLower = alias:lower()

                if #aLower >= 3 and _gameName:find(aLower, 1, true) then
                    _detectedGame = gd

                    break
                end
            end
        end
        if _detectedGame then
            break
        end
    end
end
if not _detectedGame then
    if _gameName:find('bedwars') or _gameName:find('bed wars') then
        for _, gd in ipairs(SUPPORTED_GAMES)do
            if gd.name == 'BedWars' then
                _detectedGame = gd

                break
            end
        end
    elseif _gameName:find('bedwars') or _gameName:find('bed wars') then
        for _, gd in ipairs(SUPPORTED_GAMES)do
            if gd.name == 'BedWars' then
                _detectedGame = gd

                break
            end
        end
    elseif _gameName:find('blox fruit') or _gameName:find('bloxfruit') then
        for _, gd in ipairs(SUPPORTED_GAMES)do
            if gd.name == 'Blox Fruits' then
                _detectedGame = gd

                break
            end
        end
    elseif _gameName:find('fish it') or _gameName:find('fisch') or _gameName:find('fishit') then
        for _, gd in ipairs(SUPPORTED_GAMES)do
            if gd.name == 'Fish It' then
                _detectedGame = gd

                break
            end
        end
    elseif _gameName:find('steal a brainrot') or _gameName:find('sab') then
        for _, gd in ipairs(SUPPORTED_GAMES)do
            if gd.name == 'SAB' then
                _detectedGame = gd

                break
            end
        end
    elseif _gameName:find('volley') then
        for _, gd in ipairs(SUPPORTED_GAMES)do
            if gd.name == 'Volleyball Legends' then
                _detectedGame = gd

                break
            end
        end
    elseif _gameName:find('speed keyboard') or _gameName:find('keyboard escape') then
        for _, gd in ipairs(SUPPORTED_GAMES)do
            if gd.name == 'Speed Keyboard Escape' then
                _detectedGame = gd

                break
            end
        end
    elseif _gameName:find('speed monkey') or _gameName:find('monkey escape') or _gameName:find('monkey') then
        for _, gd in ipairs(SUPPORTED_GAMES)do
            if gd.name == 'Speed Monkey Escape' then
                _detectedGame = gd

                break
            end
        end
    elseif _gameName:find('anime expedition') or _gameName:find('expedition') then
        for _, gd in ipairs(SUPPORTED_GAMES)do
            if gd.name == 'Anime Expeditions' then
                _detectedGame = gd

                break
            end
        end
    elseif _gameName:find('grow a garden') or _gameName:find('gag2') then
        for _, gd in ipairs(SUPPORTED_GAMES)do
            if gd.name == 'Grow a Garden 2' then
                _detectedGame = gd

                break
            end
        end
    elseif _gameName:find('prison life') or _gameName:find('prison') then
        for _, gd in ipairs(SUPPORTED_GAMES)do
            if gd.name == 'Prison Life' then
                _detectedGame = gd

                break
            end
        end
    elseif _gameName:find('da hood') or _gameName:find('dahood') then
        for _, gd in ipairs(SUPPORTED_GAMES)do
            if gd.name == 'Da Hood' then
                _detectedGame = gd

                break
            end
        end
    elseif _gameName:find('bloxstrike') or _gameName:find('blox strike') then
        for _, gd in ipairs(SUPPORTED_GAMES)do
            if gd.name == 'BloxStrike' then
                _detectedGame = gd

                break
            end
        end
    elseif _gameName:find('taxi boss') or _gameName:find('taxiboss') then
        for _, gd in ipairs(SUPPORTED_GAMES)do
            if gd.name == 'Taxi Boss' then
                _detectedGame = gd

                break
            end
        end
    elseif _gameName:find('evade') then
        for _, gd in ipairs(SUPPORTED_GAMES)do
            if gd.name == 'Evade' then
                _detectedGame = gd

                break
            end
        end
    elseif _gameName:find('flee the facility') or _gameName:find('flee city') or _gameName:find('flee') then
        for _, gd in ipairs(SUPPORTED_GAMES)do
            if gd.name == 'Flee the Facility' then
                _detectedGame = gd

                break
            end
        end
    end
end
if not _detectedGame then
    pcall(function()
        local RS = game:GetService('ReplicatedStorage')

        if RS:FindFirstChild('TS') or lplr.PlayerScripts:FindFirstChild('TS') then
            for _, gd in ipairs(SUPPORTED_GAMES)do
                if gd.name == 'BedWars' then
                    _detectedGame = gd

                    break
                end
            end
        elseif RS:FindFirstChild('TS') or lplr.PlayerScripts:FindFirstChild('TS') then
            for _, gd in ipairs(SUPPORTED_GAMES)do
                if gd.name == 'BedWars' then
                    _detectedGame = gd

                    break
                end
            end
        elseif RS:FindFirstChild('Remotes') and RS.Remotes:FindFirstChild('CommF_') then
            for _, gd in ipairs(SUPPORTED_GAMES)do
                if gd.name == 'Blox Fruits' then
                    _detectedGame = gd

                    break
                end
            end
        elseif RS:FindFirstChild('events') and RS.events:FindFirstChild('reels') then
            for _, gd in ipairs(SUPPORTED_GAMES)do
                if gd.name == 'Fish It' then
                    _detectedGame = gd

                    break
                end
            end
        elseif RS:FindFirstChild('Volleyball') or workspace:FindFirstChild('Volleyball') or RS:FindFirstChild('Volley') then
            for _, gd in ipairs(SUPPORTED_GAMES)do
                if gd.name == 'Volleyball Legends' then
                    _detectedGame = gd

                    break
                end
            end
        elseif RS:FindFirstChild('Brainrots') or workspace:FindFirstChild('Brainrots') then
            for _, gd in ipairs(SUPPORTED_GAMES)do
                if gd.name == 'SAB' then
                    _detectedGame = gd

                    break
                end
            end
        elseif workspace:FindFirstChild('ComputerTrigger', true) or workspace:FindFirstChild('FreezePod', true) then
            for _, gd in ipairs(SUPPORTED_GAMES)do
                if gd.name == 'Flee the Facility' then
                    _detectedGame = gd

                    break
                end
            end
        end
    end)
end

_detectedGame = {
    name = 'MM2',
    features = 0,
}

local KenHubLib = {}
local _notifHolder = nil

local function _pushNotif(title, text, dur, gold)
    dur = dur or 4

    if not _notifHolder then
        local scr = Instance.new('ScreenGui', CoreGui)

        scr.Name = 'KenHubNotifs'
        scr.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        _notifHolder = scr
    end

    local f = Instance.new('Frame', _notifHolder)

    f.Size = UDim2.new(0, 340, 0, 80)
    f.Position = UDim2.new(1, 360, 1, -100)
    f.BackgroundColor3 = Theme.BgCard
    f.ZIndex = 500

    corner(Theme.RadiusSm, f)
    stroke(gold and Theme.Premium or Theme.Accent, 1.5, f)
    gradient(f, Theme.BgSecondary, Theme.BgCard, 90)

    local accent = Instance.new('Frame', f)

    accent.Size = UDim2.new(0, 5, 0.6, 0)
    accent.Position = UDim2.new(0, 10, 0.2, 0)
    accent.BackgroundColor3 = gold and Theme.Premium or Theme.Accent
    accent.BorderSizePixel = 0
    accent.ZIndex = 501

    corner(Theme.RadiusPill, accent)

    local tl = Instance.new('TextLabel', f)

    tl.Size = UDim2.new(1, -40, 0, 22)
    tl.Position = UDim2.new(0, 24, 0, 10)
    tl.BackgroundTransparency = 1
    tl.Text = title
    tl.TextColor3 = gold and Theme.Premium or Theme.AccentBright
    tl.Font = Enum.Font.GothamBlack
    tl.TextSize = 14
    tl.ZIndex = 501
    tl.TextXAlignment = Enum.TextXAlignment.Left

    local dl = Instance.new('TextLabel', f)

    dl.Size = UDim2.new(1, -40, 0, 36)
    dl.Position = UDim2.new(0, 24, 0, 34)
    dl.BackgroundTransparency = 1
    dl.Text = text
    dl.TextColor3 = Theme.TextSecondary
    dl.Font = Enum.Font.Gotham
    dl.TextSize = 12
    dl.TextWrapped = true
    dl.ZIndex = 501
    dl.TextXAlignment = Enum.TextXAlignment.Left

    local prog = Instance.new('Frame', f)

    prog.Size = UDim2.new(1, -20, 0, 3)
    prog.Position = UDim2.new(0, 10, 1, -8)
    prog.BackgroundColor3 = gold and Theme.Premium or Theme.Accent
    prog.ZIndex = 501

    corner(Theme.RadiusPill, prog)
    tw(prog, {
        Size = UDim2.new(0, 0, 0, 3),
    }, dur, Enum.EasingStyle.Linear)
    tw(f, {
        Position = UDim2.new(1, -360, 1, -100),
    }, 0.5, Enum.EasingStyle.Back)
    task.delay(dur, function()
        tw(f, {
            Position = UDim2.new(1, 380, 1, -100),
            BackgroundTransparency = 0.5,
        }, 0.4)
        task.wait(0.45)
        pcall(function()
            f:Destroy()
        end)
    end)
end

function KenHubLib:Notify(title, text, dur, gold)
    task.spawn(_pushNotif, title, text, dur, gold)
end

local _lastPremNag = 0
local _activePremModal = nil
local PREM_SITE = 'getsnowy.xyz/pricing'
local PREM_SITE_URL = 'https://getsnowy.xyz/pricing'

local function _nagPremium(featureName)
    local now = tick()

    if now - _lastPremNag < 1.2 then
        return
    end

    _lastPremNag = now

    if _activePremModal then
        pcall(function()
            _activePremModal:Destroy()
        end)

        _activePremModal = nil
    end

    local ok, err = pcall(function()
        local label = featureName and tostring(featureName) or 'That feature'
        local scr = Instance.new('ScreenGui')

        scr.Name = 'KenHubPremiumModal'
        scr.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        scr.IgnoreGuiInset = true
        scr.ResetOnSpawn = false
        scr.DisplayOrder = 2147483647

        local _parented = false

        if not RunService:IsStudio() then
            if syn and syn.protect_gui then
                pcall(function()
                    syn.protect_gui(scr)

                    scr.Parent = CoreGui
                    _parented = true
                end)
            end
            if not _parented and gethui then
                pcall(function()
                    scr.Parent = gethui()
                    _parented = true
                end)
            end
            if not _parented and get_hidden_gui then
                pcall(function()
                    scr.Parent = get_hidden_gui()
                    _parented = true
                end)
            end
        end
        if not _parented then
            pcall(function()
                scr.Parent = (RunService:IsStudio() and LocalPlayer.PlayerGui) or CoreGui
            end)
        end

        _activePremModal = scr

        local back = Instance.new('TextButton', scr)

        back.Name = 'Backdrop'
        back.Size = UDim2.fromScale(1, 1)
        back.BackgroundColor3 = Color3.new(0, 0, 0)
        back.BackgroundTransparency = 1
        back.BorderSizePixel = 0
        back.AutoButtonColor = false
        back.Text = ''
        back.ZIndex = 9000

        tw(back, {BackgroundTransparency = 0.45}, 0.2)

        local card = Instance.new('Frame', scr)

        card.Name = 'Card'
        card.AnchorPoint = Vector2.new(0.5, 0.5)
        card.Position = UDim2.fromScale(0.5, 0.5)
        card.Size = UDim2.fromOffset(0, 0)
        card.BackgroundColor3 = Theme.BgCard
        card.BorderSizePixel = 0
        card.ZIndex = 9010
        card.ClipsDescendants = true

        corner(18, card)
        stroke(Theme.Premium, 2, card)
        gradient(card, Theme.BgSecondary, Theme.BgCard, 125)
        shadow(card)

        local bar = Instance.new('Frame', card)

        bar.Size = UDim2.new(1, 0, 0, 4)
        bar.BackgroundColor3 = Theme.Premium
        bar.BorderSizePixel = 0
        bar.ZIndex = 9011

        gradient(bar, Theme.PremiumDark, Theme.Premium, 0)

        local lockContainer = Instance.new('Frame', card)

        lockContainer.Name = 'LockContainer'
        lockContainer.Size = UDim2.new(0, 68, 0, 68)
        lockContainer.Position = UDim2.new(0.5, -34, 0, 28)
        lockContainer.BackgroundColor3 = Theme.PremiumDim
        lockContainer.BorderSizePixel = 0
        lockContainer.ZIndex = 9012

        corner(999, lockContainer)
        stroke(Theme.Premium, 2, lockContainer)

        local shackle = Instance.new('Frame', lockContainer)

        shackle.Name = 'Shackle'
        shackle.Size = UDim2.new(0, 26, 0, 26)
        shackle.Position = UDim2.new(0.5, -13, 0.5, -23)
        shackle.BackgroundTransparency = 1
        shackle.ZIndex = 9013

        local shackleCorner = Instance.new('UICorner', shackle)

        shackleCorner.CornerRadius = UDim.new(0.5, 0)

        local shackleStroke = Instance.new('UIStroke', shackle)

        shackleStroke.Color = Theme.Premium
        shackleStroke.Thickness = 3
        shackleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        local lockBody = Instance.new('Frame', lockContainer)

        lockBody.Name = 'Body'
        lockBody.Size = UDim2.new(0, 34, 0, 26)
        lockBody.Position = UDim2.new(0.5, -17, 0.5, -7)
        lockBody.BackgroundColor3 = Theme.Premium
        lockBody.BorderSizePixel = 0
        lockBody.ZIndex = 9014

        local bodyCorner = Instance.new('UICorner', lockBody)

        bodyCorner.CornerRadius = UDim.new(0, 4)

        local keyholeCircle = Instance.new('Frame', lockBody)

        keyholeCircle.Name = 'KeyholeCircle'
        keyholeCircle.Size = UDim2.new(0, 6, 0, 6)
        keyholeCircle.Position = UDim2.new(0.5, -3, 0.3, 0)
        keyholeCircle.BackgroundColor3 = Theme.BgCard
        keyholeCircle.BorderSizePixel = 0
        keyholeCircle.ZIndex = 9015

        local kcCorner = Instance.new('UICorner', keyholeCircle)

        kcCorner.CornerRadius = UDim.new(1, 0)

        local keyholeLine = Instance.new('Frame', lockBody)

        keyholeLine.Name = 'KeyholeLine'
        keyholeLine.Size = UDim2.new(0, 3, 0, 8)
        keyholeLine.Position = UDim2.new(0.5, -1.5, 0.3, 4)
        keyholeLine.BackgroundColor3 = Theme.BgCard
        keyholeLine.BorderSizePixel = 0
        keyholeLine.ZIndex = 9015

        local klCorner = Instance.new('UICorner', keyholeLine)

        klCorner.CornerRadius = UDim.new(0, 1)

        local title = Instance.new('TextLabel', card)

        title.Size = UDim2.new(1, -30, 0, 28)
        title.Position = UDim2.new(0, 15, 0, 106)
        title.BackgroundTransparency = 1
        title.Text = 'PREMIUM FEATURE'
        title.TextColor3 = Theme.Premium
        title.Font = Enum.Font.GothamBlack
        title.TextSize = 20
        title.ZIndex = 9012

        local feat = Instance.new('TextLabel', card)

        feat.Size = UDim2.new(1, -30, 0, 22)
        feat.Position = UDim2.new(0, 15, 0, 136)
        feat.BackgroundTransparency = 1
        feat.Text = '\u{201c}' .. label .. '\u{201d} is locked.'
        feat.TextColor3 = Theme.TextPrimary
        feat.Font = Enum.Font.GothamSemibold
        feat.TextSize = 14
        feat.TextTruncate = Enum.TextTruncate.AtEnd
        feat.ZIndex = 9012

        local sub = Instance.new('TextLabel', card)

        sub.Size = UDim2.new(1, -30, 0, 20)
        sub.Position = UDim2.new(0, 15, 0, 160)
        sub.BackgroundTransparency = 1
        sub.Text = 'Unlock every KenHub Premium feature at'
        sub.TextColor3 = Theme.TextSecondary
        sub.Font = Enum.Font.Gotham
        sub.TextSize = 12
        sub.ZIndex = 9012

        local siteBtn = Instance.new('TextButton', card)

        siteBtn.Size = UDim2.new(1, -60, 0, 44)
        siteBtn.Position = UDim2.new(0, 30, 0, 188)
        siteBtn.BackgroundColor3 = Theme.Premium
        siteBtn.BorderSizePixel = 0
        siteBtn.AutoButtonColor = false
        siteBtn.Text = '\u{2726}  ' .. PREM_SITE .. '    \u{2022}  Click to copy'
        siteBtn.TextColor3 = Color3.fromRGB(20, 15, 0)
        siteBtn.Font = Enum.Font.GothamBlack
        siteBtn.TextSize = 15
        siteBtn.ZIndex = 9012

        corner(10, siteBtn)
        stroke(Theme.PremiumDark, 1, siteBtn)
        gradient(siteBtn, Theme.Premium, Theme.PremiumDark, 90)
        siteBtn.MouseEnter:Connect(function()
            tw(siteBtn, {
                Size = UDim2.new(1, -52, 0, 46),
            }, 0.15)
        end)
        siteBtn.MouseLeave:Connect(function()
            tw(siteBtn, {
                Size = UDim2.new(1, -60, 0, 44),
            }, 0.15)
        end)
        siteBtn.Activated:Connect(function()
            local copied = false

            pcall(function()
                if setclipboard then
                    setclipboard(PREM_SITE_URL)

                    copied = true
                end
            end)

            if not copied then
                pcall(function()
                    toclipboard(PREM_SITE_URL)

                    copied = true
                end)
            end

            siteBtn.Text = copied and ('\u{2714}  Copied  ' .. PREM_SITE_URL) or ('Visit ' .. PREM_SITE)

            tw(siteBtn, {
                BackgroundColor3 = Theme.Success,
            }, 0.15)
            task.delay(1.4, function()
                pcall(function()
                    siteBtn.Text = '\u{2726}  ' .. PREM_SITE .. '    \u{2022}  Click to copy'

                    tw(siteBtn, {
                        BackgroundColor3 = Theme.Premium,
                    }, 0.2)
                end)
            end)
        end)

        local closeBtn = Instance.new('TextButton', card)

        closeBtn.Size = UDim2.new(1, -60, 0, 32)
        closeBtn.Position = UDim2.new(0, 30, 0, 242)
        closeBtn.BackgroundColor3 = Theme.BgInput
        closeBtn.BorderSizePixel = 0
        closeBtn.AutoButtonColor = false
        closeBtn.Text = 'Maybe later'
        closeBtn.TextColor3 = Theme.TextSecondary
        closeBtn.Font = Enum.Font.GothamMedium
        closeBtn.TextSize = 13
        closeBtn.ZIndex = 9012

        corner(8, closeBtn)
        stroke(Theme.Border, 1, closeBtn)

        local function dismiss()
            if not scr.Parent then
                return
            end

            tw(back, {BackgroundTransparency = 1}, 0.2)
            tw(card, {
                Size = UDim2.fromOffset(0, 0),
            }, 0.18, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            task.delay(0.22, function()
                pcall(function()
                    scr:Destroy()
                end)

                if _activePremModal == scr then
                    _activePremModal = nil
                end
            end)
        end

        closeBtn.Activated:Connect(dismiss)
        back.Activated:Connect(dismiss)

        card.Size = UDim2.fromOffset(0, 0)

        tw(card, {
            Size = UDim2.fromOffset(400, 300),
        }, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        task.delay(7, function()
            if _activePremModal == scr then
                dismiss()
            end
        end)
    end)

    if not ok then
        local label = featureName and ("'" .. tostring(featureName) .. "'") or 'That feature'

        KenHubLib:Notify('\u{2726}  PREMIUM LOCKED', label .. ' is locked to KenHub Premium. Upgrade at ' .. PREM_SITE, 5, true)
    end
end

local InternalLib

do
    local KENHUB_UI_URL = 'https://pastefy.app/0XFsme6b/raw'

    local function loadKenHubUI()
        local ok, result = pcall(function()
            return loadstring(game:HttpGet(KENHUB_UI_URL, true))()
        end)

        if not ok or type(result) ~= 'table' or type(result.Window) ~= 'function' then
            error('[KenHub] KenHub UI v2 could not be loaded: ' .. tostring(result), 0)
        end

        return result
    end

    local KenHubUIV2 = loadKenHubUI()
    local activeNativeWindow
    local activeUsedIcons = {}

    InternalLib = {
        Toggled = true,
        Accent = Color3.fromRGB(85, 213, 254),
    }

    local ICON_POOL = {
        'house-bold',
        'crosshair-bold',
        'user-circle-bold',
        'eye-bold',
        'gear-six-bold',
        'sliders-horizontal-bold',
        'sword-bold',
        'shield-check-bold',
        'lightning-bold',
        'globe-hemisphere-west-bold',
        'map-pin-bold',
        'chart-line-up-bold',
        'car-profile-bold',
        'leaf-bold',
        'fish-simple-bold',
        'coins-bold',
        'backpack-bold',
        'rocket-launch-bold',
        'game-controller-bold',
        'wrench-bold',
        'sparkle-bold',
        'skull-bold',
        'binoculars-bold',
        'person-simple-run-bold',
        'target-bold',
        'flame-bold',
        'cube-bold',
        'package-bold',
        'compass-bold',
        'magic-wand-bold',
        'crown-bold',
        'snowflake-bold',
    }
    local LEGACY_ICONS = {
        home = 'house-bold',
        target = 'crosshair-bold',
        account = 'user-circle-bold',
        user = 'user-circle-bold',
        eye = 'eye-bold',
        settings = 'gear-six-bold',
        sliders = 'sliders-horizontal-bold',
        swords = 'sword-bold',
        shield = 'shield-check-bold',
        zap = 'lightning-bold',
        globe = 'globe-hemisphere-west-bold',
        ['map-pin'] = 'map-pin-bold',
        ['bar-chart-2'] = 'chart-line-up-bold',
        layout = 'squares-four-bold',
        search = 'magnifying-glass-bold',
        save = 'floppy-disk-bold',
        flame = 'flame-bold',
    }

    local function semanticIcon(title)
        local value = string.lower(tostring(title or ''))

        if value:find('combat', 1, true) or value:find('aim', 1, true) or value:find('gun', 1, true) then
            return 'crosshair-bold'
        end
        if value:find('visual', 1, true) or value:find('esp', 1, true) then
            return 'eye-bold'
        end
        if value:find('move', 1, true) or value:find('speed', 1, true) or value:find('travel', 1, true) then
            return 'person-simple-run-bold'
        end
        if value:find('farm', 1, true) or value:find('collect', 1, true) then
            return 'leaf-bold'
        end
        if value:find('setting', 1, true) or value:find('config', 1, true) then
            return 'gear-six-bold'
        end
        if value:find('player', 1, true) or value:find('character', 1, true) then
            return 'user-circle-bold'
        end
        if value:find('money', 1, true) or value:find('economy', 1, true) then
            return 'coins-bold'
        end
        if value:find('teleport', 1, true) or value:find('world', 1, true) then
            return 'globe-hemisphere-west-bold'
        end
        if value:find('misc', 1, true) or value:find('utility', 1, true) then
            return 'wrench-bold'
        end

        return nil
    end
    local function wrapLabel(handle)
        local wrapped = {
            Instance = handle and handle.Instance,
        }

        function wrapped:Set(value)
            if self.Instance and self.Instance:IsA('TextLabel') then
                self.Instance.Text = tostring(value)
            end
        end
        function wrapped:Get()
            return self.Instance and self.Instance.Text or nil
        end

        return wrapped
    end
    local function wrapSection(nativeSection)
        local section = {}

        function section:CreateToggle(name, default, callback)
            return nativeSection:Toggle({
                Text = tostring(name),
                Default = default == true,
                Callback = callback,
            })
        end
        function section:CreateButton(name, callback)
            return nativeSection:Button({
                Text = tostring(name),
                ButtonText = 'Run',
                Callback = callback,
            })
        end
        function section:CreateSlider(name, minimum, maximum, default, callback)
            minimum, maximum = tonumber(minimum) or 0, tonumber(maximum) or 100

            if maximum < minimum then
                minimum, maximum = maximum, minimum
            end

            return nativeSection:Slider({
                Text = tostring(name),
                Min = minimum,
                Max = maximum,
                Default = math.clamp(tonumber(default) or minimum, minimum, maximum),
                Callback = callback,
            })
        end
        function section:CreateDropdown(name, items, default, callback)
            local options = type(items) == 'table' and items or {}
            local selected = default

            if selected == nil and #options > 0 then
                selected = options[1]
            end

            local current
            local wrapped = {}

            local function create(values, value)
                current = nativeSection:Dropdown({
                    Text = tostring(name),
                    Options = values,
                    Default = value,
                    Placeholder = 'Select an option',
                    Callback = callback,
                })
                wrapped.Instance = current.Instance
            end

            create(options, selected)

            function wrapped:Set(value)
                return current:Set(value)
            end
            function wrapped:Get()
                return current:Get()
            end
            function wrapped:Refresh(values)
                if current and current.Instance then
                    current.Instance.Visible = false
                end

                options = type(values) == 'table' and values or {}

                local value = #options > 0 and options[1] or nil

                create(options, value)
            end

            return wrapped
        end
        function section:CreateLabel(content)
            local clean = tostring(content or ''):gsub('^\u{2500}\u{2500}%s*', ''):gsub('%s*\u{2500}\u{2500}$', '')

            return wrapLabel(nativeSection:Label(clean))
        end
        function section:CreateInput(name, placeholder, callback)
            return nativeSection:Input({
                Text = tostring(name),
                Placeholder = tostring(placeholder or 'Type here...'),
                Default = '',
                Callback = callback,
            })
        end

        return section
    end

    function InternalLib:GetIcon(name)
        return LEGACY_ICONS[name] or 'house-bold'
    end
    function InternalLib:MakeDraggable()
        return function()
            return false
        end
    end
    function InternalLib:CreateWindow(title)
        if not (activeNativeWindow and activeNativeWindow.gui and activeNativeWindow.gui.Parent) then
            activeNativeWindow = KenHubUIV2:Window({
                Title = 'KenHub',
                Subtitle = tostring(title or (_detectedGame and _detectedGame.name) or 'KenHub'),
                IconPack = 'phosphor',
                Logo = 'rbxassetid://123802801726537',
                LogoRectOffset = Vector2.new(40, 256),
                LogoRectSize = Vector2.new(945, 457),
                Keybind = Enum.KeyCode.RightShift,
            })
            activeUsedIcons = {}
        end

        local nativeWindow = activeNativeWindow
        local usedIcons = activeUsedIcons

        local function claimIcon(requested, tabName)
            local legacyKey = string.lower(tostring(requested or ''))
            local candidate = semanticIcon(tabName) or LEGACY_ICONS[legacyKey]

            if type(candidate) == 'string' and candidate ~= '' and not usedIcons[candidate] then
                usedIcons[candidate] = true

                return candidate
            end

            for _, iconName in ipairs(ICON_POOL)do
                if not usedIcons[iconName] then
                    usedIcons[iconName] = true

                    return iconName
                end
            end

            local fallback = 'number-circle-' .. tostring(#nativeWindow.tabs + 1) .. '-bold'

            usedIcons[fallback] = true

            return fallback
        end

        local wind = {
            Current = nil,
            MainContainer = nativeWindow.gui,
            NativeWindow = nativeWindow,
            Tabs = {},
        }

        function wind:CreateTab(name, requestedIcon)
            local tabName = tostring(name or 'Main')
            local nativeTab = nativeWindow:Tab({
                Name = tabName,
                Icon = claimIcon(requestedIcon, tabName),
                Description = tabName .. ' features and controls',
            })
            local tab = {
                SubTabs = {},
                NativeTab = nativeTab,
                _sectionCount = 0,
            }

            function tab:CreateSubTab(subName)
                self._sectionCount = self._sectionCount + 1

                local subTab = {
                    Name = tostring(subName or 'Main'),
                    ParentTab = self,
                }

                function subTab:CreateSection(sectionName)
                    local titleText = tostring(sectionName or self.Name)
                    local nativeSection = nativeTab:Section({
                        Title = titleText,
                        Column = ((self.ParentTab._sectionCount - 1) % 2) + 1,
                    })

                    return wrapSection(nativeSection)
                end
                function subTab:Select()
                    nativeWindow:Select(nativeTab.index)
                end

                table.insert(self.SubTabs, subTab)

                return subTab
            end
            function tab:Select()
                nativeWindow:Select(nativeTab.index)

                wind.Current = {Tab = self}
            end
            function tab:SetVisible(state)
                nativeTab.button.Visible = state ~= false

                nativeWindow:LayoutRail()
            end

            self.Tabs[tabName] = tab

            if not self.Current then
                tab:Select()
            end

            return tab
        end
        function wind:Destroy()
            nativeWindow:Destroy()
        end

        return wind
    end
end

local function resolveDropdownArgs(d, list, cb)
    local items, def, callback

    if type(d) == 'table' then
        items = d
        def = type(list) == 'string' and list or nil
        callback = type(list) == 'function' and list or cb
    else
        items = list
        def = nil
        callback = cb
    end

    return items or {}, def, callback
end

local Kavo = {}

function Kavo.CreateLib(hubName, _)
    local Window = InternalLib:CreateWindow(hubName)
    local BridgeWindow = {
        Tabs = {},
        Window = Window,
    }

    function BridgeWindow:NewTab(tabName)
        local icon = 'home'
        local low = tabName:lower()

        if low:find('aim', 1, true) or low:find('combat', 1, true) or low:find('kill', 1, true) or low:find('gun', 1, true) then
            icon = 'target'
        elseif low:find('player', 1, true) or low:find('user', 1, true) or low:find('char', 1, true) or low:find('move', 1, true) then
            icon = 'user'
        elseif low:find('visual', 1, true) or low:find('esp', 1, true) or low:find('eye', 1, true) or low:find('render', 1, true) then
            icon = 'eye'
        elseif low:find('setting', 1, true) or low:find('config', 1, true) or low:find('ui', 1, true) then
            icon = 'settings'
        elseif low:find('util', 1, true) or low:find('misc', 1, true) or low:find('tool', 1, true) then
            icon = 'sliders'
        elseif low:find('game', 1, true) or low:find('hub', 1, true) or low:find('main', 1, true) then
            icon = 'layout'
        end

        local ActualTab = Window:CreateTab(tabName, icon)
        local BridgeTab = {ActualTab = ActualTab}

        function BridgeTab:NewSection(secName)
            local sIcon = 'layout'
            local slow = (secName or ''):lower()

            if slow:find('combat', 1, true) then
                sIcon = 'swords'
            elseif slow:find('visual', 1, true) then
                sIcon = 'eye'
            elseif slow:find('main', 1, true) or slow:find('home', 1, true) then
                sIcon = 'home'
            elseif slow:find('setting', 1, true) or slow:find('config', 1, true) then
                sIcon = 'settings'
            end

            local SubTab = self.ActualTab:CreateSubTab(secName or 'Main', sIcon)
            local Section = SubTab:CreateSection(secName or 'Main')
            local BridgeSec = {}

            function BridgeSec:NewToggle(n, d, cb)
                return Section:CreateToggle(n, false, cb)
            end
            function BridgeSec:NewSlider(n, d, max, min, cb)
                return Section:CreateSlider(n, min, max, min, cb)
            end
            function BridgeSec:NewButton(n, d, cb)
                return Section:CreateButton(n, cb)
            end
            function BridgeSec:NewDropdown(n, d, list, cb)
                local items, def, callback = resolveDropdownArgs(d, list, cb)

                return Section:CreateDropdown(n, items, def, callback)
            end
            function BridgeSec:NewLabel(txt)
                return Section:CreateLabel(txt)
            end
            function BridgeSec:NewInput(n, placeholder, cb)
                return Section:CreateInput(n, placeholder, cb)
            end
            function BridgeSec:NewTitle(txt)
                return Section:CreateLabel('\u{2726} ' .. txt)
            end
            function BridgeSec:NewSection()
                return Section
            end
            function BridgeSec:NewPremiumToggle(n, d, cb)
                local handle
                local suppressing = false

                handle = Section:CreateToggle(_premTag(n), false, function(state)
                    if suppressing then
                        return
                    end
                    if _isPremiumUser() then
                        if cb then
                            cb(state)
                        end
                    elseif state then
                        _nagPremium(n)

                        suppressing = true

                        task.defer(function()
                            pcall(function()
                                handle:Set(false)
                            end)
                            task.wait()

                            suppressing = false
                        end)
                    end
                end)

                return handle
            end
            function BridgeSec:NewPremiumButton(n, d, cb)
                return Section:CreateButton(_premTag(n), function()
                    if _isPremiumUser() then
                        if cb then
                            cb()
                        end
                    else
                        _nagPremium(n)
                    end
                end)
            end
            function BridgeSec:NewPremiumSlider(n, d, max, min, cb)
                return Section:CreateSlider(_premTag(n), min or 0, max or 100, min or 0, function(v)
                    if _isPremiumUser() then
                        if cb then
                            cb(v)
                        end
                    else
                        _nagPremium(n)
                    end
                end)
            end
            function BridgeSec:NewPremiumDropdown(n, d, list, cb)
                local items, def, callback = resolveDropdownArgs(d, list, cb)

                return Section:CreateDropdown(_premTag(n), items, def, function(v)
                    if _isPremiumUser() then
                        if callback then
                            callback(v)
                        end
                    else
                        _nagPremium(n)
                    end
                end)
            end

            return BridgeSec
        end
        function BridgeTab:HideTabButton()
            self.ActualTab:SetVisible(false)
        end
        function BridgeTab:Select()
            self.ActualTab:Select()
        end

        return BridgeTab
    end

    return BridgeWindow
end

local nnLocalPlayer = game:GetService('Players').LocalPlayer
local nnUIS = game:GetService('UserInputService')
local nnRep = game:GetService('ReplicatedStorage')
local bhRS = game:GetService('RunService')
local nnCam = workspace.CurrentCamera

local function nnChar()
    return nnLocalPlayer.Character
end
local function nnHum()
    local c = nnChar()

    return c and c:FindFirstChildWhichIsA('Humanoid')
end
local function nnHRP()
    local c = nnChar()

    return c and c:FindFirstChild('HumanoidRootPart')
end
local function nnFindValue(...)
    local args = {...}

    for _, obj in pairs(workspace:GetDescendants())do
        for _, name in pairs(args)do
            if obj.Name:lower() == name:lower() and (obj:IsA('IntValue') or obj:IsA('NumberValue')) then
                return obj
            end
        end
    end

    return nil
end

local Config = {
    HubName = 'KenHub',
    AccentColor = Color3.fromRGB(0, 162, 255),
}

local function notify(title, text, dur)
    KenHubLib:Notify(title, text, dur, false)
end

getgenv().Window = Kavo.CreateLib(Config.HubName, 'Midnight')

local Window = getgenv().Window

do
    local environment = getgenv()
    local gameName = (_detectedGame and _detectedGame.name) or 'Unknown'

    environment.__KenHubPayloadReady = {
        nonce = environment.__KenHubLaunchNonce,
        game = gameName,
        ui = true,
        at = os.clock(),
    }

    print('[KenHub] Payload UI ready: ' .. tostring(gameName))
end

getgenv().KenHubLib = KenHubLib
getgenv().Kavo = Kavo
getgenv().notify = notify

task.defer(function()
    pcall(function()
        local overlay = getgenv().__KenHubLoadingOverlay

        if overlay then
            overlay:Destroy()

            getgenv().__KenHubLoadingOverlay = nil
        end
    end)
end)

local _gameTabCreated = {}

local function gameTab(gameName, tabDisplayName)
    if not (_detectedGame and _detectedGame.name:lower() == gameName:lower()) then
        local noop = function() end
        local stubSec = {}

        stubSec.NewToggle = noop
        stubSec.NewButton = noop
        stubSec.NewSlider = noop
        stubSec.NewDropdown = noop
        stubSec.NewLabel = noop
        stubSec.NewPremiumToggle = noop
        stubSec.NewPremiumButton = noop
        stubSec.NewPremiumSlider = noop
        stubSec.NewPremiumDropdown = noop
        stubSec.NewSection = function()
            return stubSec
        end

        local stub = {}

        stub.NewSection = function()
            return stubSec
        end
        stub.NewToggle = noop
        stub.NewButton = noop
        stub.NewSlider = noop
        stub.NewDropdown = noop
        stub.NewPremiumToggle = noop
        stub.NewPremiumButton = noop
        stub.NewPremiumSlider = noop
        stub.NewPremiumDropdown = noop

        return stub
    end

    local categorySideTabs = {}
    local categorySections = {}

    local function getOrCreateCategory(categoryName, categoryIcon)
        if categorySideTabs[categoryName] then
            return categorySections[categoryName]
        end

        local st = Window.Window:CreateTab(categoryName, categoryIcon or 'layout')
        local sub = st:CreateSubTab('Main', 'layout')
        local sec = sub:CreateSection('Features')

        categorySideTabs[categoryName] = st
        categorySections[categoryName] = sec

        return sec
    end

    local Factory = {}

    function Factory:NewSection(secName)
        local rawName = secName or 'General'
        local slow = rawName:lower()
        local category, catIcon = 'General', 'globe'

        if slow:find('free feat') then
            category, catIcon = 'Free', 'home'
        elseif slow:find('premium feat') then
            category, catIcon = 'Premium', 'zap'
        elseif slow:find('combat') or slow:find('aimbot') or slow:find('aim') or slow:find('weapon') or slow:find('gun') or slow:find('silent') or slow:find('aura') then
            category, catIcon = 'Combat', 'swords'
        elseif slow:find('esp') or slow:find('visual') or slow:find('wallhack') or slow:find('radar') or slow:find('chams') or slow:find('render') then
            category, catIcon = 'Visuals', 'eye'
        elseif slow:find('move') or slow:find('fly') or slow:find('speed') or slow:find('noclip') or slow:find('jump') or slow:find('travel') or slow:find('tp') or slow:find('teleport') then
            category, catIcon = 'Movement', 'bar-chart-2'
        elseif slow:find('farm') or slow:find('auto') or slow:find('fish') or slow:find('chest') or slow:find('collect') or slow:find('resource') then
            category, catIcon = 'AutoFarm', 'zap'
        elseif slow:find('survival') or slow:find('god') or slow:find('oxygen') or slow:find('survive') or slow:find('anti') then
            category, catIcon = 'Survival', 'shield'
        elseif slow:find('troll') or slow:find('rage') or slow:find('hitbox') then
            category, catIcon = 'Rage', 'flame'
        elseif slow:find('misc') or slow:find('util') or slow:find('extra') or slow:find('general') or slow:find('server') then
            category, catIcon = 'Utility', 'sliders'
        elseif slow:find('economy') or slow:find('money') or slow:find('shop') then
            category, catIcon = 'Economy', 'bar-chart-2'
        elseif slow:find('belt') then
            category, catIcon = 'Belts', 'layout'
        elseif slow:find('tank') then
            category, catIcon = 'Tanks', 'layout'
        elseif slow:find('slot') then
            category, catIcon = 'Slots', 'layout'
        end

        local sec = getOrCreateCategory(category, catIcon)

        sec:CreateLabel('\u{2500}\u{2500} ' .. rawName .. ' \u{2500}\u{2500}')

        local Bridge = {}

        function Bridge:NewToggle(n, d, cb)
            return sec:CreateToggle(n, false, cb)
        end
        function Bridge:NewButton(n, d, cb)
            return sec:CreateButton(n, cb)
        end
        function Bridge:NewSlider(n, d, max, min, cb)
            return sec:CreateSlider(n, min or 0, max or 100, min or 0, cb)
        end
        function Bridge:NewDropdown(n, d, list, cb)
            local items, def, callback = resolveDropdownArgs(d, list, cb)

            return sec:CreateDropdown(n, items, def, callback)
        end
        function Bridge:NewLabel(txt)
            return sec:CreateLabel(txt)
        end
        function Bridge:NewInput(n, placeholder, cb)
            return sec:CreateInput(n, placeholder, cb)
        end
        function Bridge:NewTitle(txt)
            return sec:CreateLabel('\u{2726} ' .. txt)
        end
        function Bridge:NewSection()
            return sec
        end
        function Bridge:NewPremiumToggle(n, d, cb)
            local handle
            local suppressing = false

            handle = sec:CreateToggle(_premTag(n), false, function(state)
                if suppressing then
                    return
                end
                if _isPremiumUser() then
                    if cb then
                        cb(state)
                    end
                elseif state then
                    _nagPremium(n)

                    suppressing = true

                    task.defer(function()
                        pcall(function()
                            handle:Set(false)
                        end)
                        task.wait()

                        suppressing = false
                    end)
                end
            end)

            return handle
        end
        function Bridge:NewPremiumButton(n, d, cb)
            return sec:CreateButton(_premTag(n), function()
                if _isPremiumUser() then
                    if cb then
                        cb()
                    end
                else
                    _nagPremium(n)
                end
            end)
        end
        function Bridge:NewPremiumSlider(n, d, max, min, cb)
            return sec:CreateSlider(_premTag(n), min or 0, max or 100, min or 0, function(v)
                if _isPremiumUser() then
                    if cb then
                        cb(v)
                    end
                else
                    _nagPremium(n)
                end
            end)
        end
        function Bridge:NewPremiumDropdown(n, d, list, cb)
            local items, def, callback = resolveDropdownArgs(d, list, cb)

            return sec:CreateDropdown(_premTag(n), items, def, function(v)
                if _isPremiumUser() then
                    if callback then
                        callback(v)
                    end
                else
                    _nagPremium(n)
                end
            end)
        end

        return Bridge
    end

    local noop = function() end

    Factory.NewToggle = noop
    Factory.NewButton = noop
    Factory.NewSlider = noop

    return Factory
end

getgenv().gameTab = gameTab

local function createUIBridge(gameName)
    local tabFactory = gameTab(gameName, gameName)
    local Bridge = {}
    local freeSec = tabFactory:NewSection('Free Features')
    local premSec = tabFactory:NewSection('Premium Features')

    local function isFeaturePremium(title, desc)
        local t = (title or ''):lower()
        local d = (desc or ''):lower()
        local keywords = {
            'auto',
            'farm',
            'kill',
            'aura',
            'tp',
            'teleport',
            'fly',
            'speed',
            'click',
            'mansion',
            'oil',
            'ship',
            'airdrop',
            'rob',
            'npc',
            'turret',
            'glider',
            'items',
            'give',
        }

        for _, kw in ipairs(keywords)do
            if t:find(kw, 1, true) or d:find(kw, 1, true) then
                return true
            end
        end

        return false
    end

    function Bridge:CreateWindow(options)
        local win = {}

        function win:AddTab(tabOptions)
            local tabObj = {}

            function tabObj:AddSection(secName)
                return self
            end
            function tabObj:AddButton(opts)
                local isPrem = isFeaturePremium(opts.Title or opts.Name, opts.Description or opts.Desc)

                if isPrem then
                    premSec:NewPremiumButton(opts.Title or opts.Name or 'Button', opts.Description or opts.Desc or '', opts.Callback)
                else
                    freeSec:NewButton(opts.Title or opts.Name or 'Button', opts.Description or opts.Desc or '', opts.Callback)
                end
            end
            function tabObj:AddToggle(id, opts)
                local options = opts or id
                local title = options.Title or options.Name or 'Toggle'
                local desc = options.Description or options.Desc or ''
                local callback = options.Callback
                local default = options.Default or false
                local isPrem = isFeaturePremium(title, desc)
                local activeCallback = callback
                local handle

                if isPrem then
                    handle = premSec:NewPremiumToggle(title, desc, function(state)
                        if activeCallback then
                            pcall(function()
                                activeCallback(state)
                            end)
                        end
                    end)
                else
                    handle = freeSec:NewToggle(title, desc, function(state)
                        if activeCallback then
                            pcall(function()
                                activeCallback(state)
                            end)
                        end
                    end)
                end
                if default and handle and handle.Set then
                    pcall(function()
                        handle:Set(default)
                    end)
                end

                local toggleWrapper = {}

                function toggleWrapper:OnChanged(cb)
                    activeCallback = cb

                    return toggleWrapper
                end
                function toggleWrapper:SetValue(val)
                    pcall(function()
                        handle:Set(val)
                    end)
                end

                return toggleWrapper
            end
            function tabObj:AddSlider(id, opts)
                local options = opts or id
                local title = options.Title or options.Name or 'Slider'
                local desc = options.Description or options.Desc or ''
                local callback = options.Callback
                local min = options.Min or 0
                local max = options.Max or 100
                local default = options.Default or min
                local isPrem = isFeaturePremium(title, desc)
                local activeCallback = callback
                local handle

                if isPrem then
                    handle = premSec:NewPremiumSlider(title, desc, max, min, function(v)
                        if activeCallback then
                            pcall(function()
                                activeCallback(v)
                            end)
                        end
                    end)
                else
                    handle = freeSec:NewSlider(title, desc, max, min, function(v)
                        if activeCallback then
                            pcall(function()
                                activeCallback(v)
                            end)
                        end
                    end)
                end
                if default and handle and handle.Set then
                    pcall(function()
                        handle:Set(default)
                    end)
                end

                local sliderWrapper = {}

                function sliderWrapper:OnChanged(cb)
                    activeCallback = cb

                    return sliderWrapper
                end
                function sliderWrapper:SetValue(val)
                    pcall(function()
                        handle:Set(val)
                    end)
                end

                return sliderWrapper
            end
            function tabObj:AddDropdown(id, opts)
                local options = opts or id
                local title = options.Title or options.Name or 'Dropdown'
                local desc = options.Description or options.Desc or ''
                local callback = options.Callback
                local values = options.Values or options.List or {}
                local default = options.Default or nil
                local isPrem = isFeaturePremium(title, desc)
                local activeCallback = callback
                local handle

                if isPrem then
                    handle = premSec:NewPremiumDropdown(title, desc, values, function(v)
                        if activeCallback then
                            pcall(function()
                                activeCallback(v)
                            end)
                        end
                    end)
                else
                    handle = freeSec:NewDropdown(title, desc, values, function(v)
                        if activeCallback then
                            pcall(function()
                                activeCallback(v)
                            end)
                        end
                    end)
                end
                if default and handle and handle.Set then
                    pcall(function()
                        handle:Set(default)
                    end)
                end

                local ddWrapper = {}

                function ddWrapper:OnChanged(cb)
                    activeCallback = cb

                    return ddWrapper
                end
                function ddWrapper:SetValue(val)
                    pcall(function()
                        handle:Set(val)
                    end)
                end

                return ddWrapper
            end
            function tabObj:AddLabel(txt)
                freeSec:NewLabel(txt)
            end
            function tabObj:AddParagraph(opts)
                freeSec:NewLabel((opts.Title or '') .. ': ' .. (opts.Content or ''))
            end
            function tabObj:AddKeybind(id, opts)
                return {
                    OnChanged = function(self, cb)
                        return self
                    end,
                    SetValue = function(self, val) end,
                }
            end
            function tabObj:AddColorpicker(id, opts)
                return {
                    OnChanged = function(self, cb)
                        return self
                    end,
                    SetValue = function(self, val) end,
                }
            end

            return tabObj
        end
        function win:SelectTab(idx) end

        return win
    end
    function Bridge:Notify(opts)
        pcall(function()
            KenHubLib:Notify(opts.Title or 'Notification', opts.Content or opts.Text or '', opts.Duration or 3)
        end)
    end

    return Bridge
end

if not _detectedGame then
    getgenv().HomeTab = Window:NewTab('Home')
    getgenv().PlayerTab = Window:NewTab('Player')
    getgenv().VisualTab = Window:NewTab('Visuals')
    getgenv().UtilTab = Window:NewTab('Utility')
    getgenv().AimbotTab = Window:NewTab('Aimbot')
    getgenv().SettingsTab = Window:NewTab('Settings')
    getgenv().HomeSec = HomeTab:NewSection('Status')

    HomeSec:NewLabel(utf8.char(0x2744) .. ' KENHUB v6.0')

    getgenv().PlayerSection = PlayerTab:NewSection('General')
    getgenv().VisualSection = VisualTab:NewSection('ESP & Effects')
    getgenv().UtilSection = UtilTab:NewSection('General Tools')
    getgenv().AimbotSection = AimbotTab:NewSection('Combat Settings')
    getgenv().UISec = SettingsTab:NewSection('Interface')
    getgenv().InfoSec = SettingsTab:NewSection('Info')
    getgenv().WalkSpeedValue = 16
    getgenv().JumpPowerValue = 50
    getgenv().GodModeEnabled = false

    if getgenv().PlayerModifierLoop then
        pcall(function()
            getgenv().PlayerModifierLoop:Disconnect()
        end)

        getgenv().PlayerModifierLoop = nil
    end

    getgenv().PlayerModifierLoop = game:GetService('RunService').RenderStepped:Connect(function(deltaTime)
        pcall(function()
            local char = game.Players.LocalPlayer.Character

            if char and char:FindFirstChild('Humanoid') and char:FindFirstChild('HumanoidRootPart') then
                local hum = char.Humanoid

                if getgenv().GodModeEnabled then
                    if hum.MaxHealth ~= math.huge then
                        hum.MaxHealth = math.huge
                    end
                    if hum.Health ~= math.huge then
                        hum.Health = math.huge
                    end

                    pcall(function()
                        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                    end)
                end
            end
        end)
    end)

    PlayerSection:NewSlider('WalkSpeed', 'Changes player speed', 250, 16, function(value)
        getgenv().WalkSpeedValue = value

        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild('Humanoid') then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
    end)
    PlayerSection:NewSlider('JumpPower', 'Changes jump height', 250, 50, function(value)
        getgenv().JumpPowerValue = value

        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild('Humanoid') then
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
        end
    end)
    PlayerSection:NewSlider('Gravity', 'Changes world gravity', 196, 0, function(value)
        game.Workspace.Gravity = value
    end)
    PlayerSection:NewPremiumToggle('God Mode', 'Instantly regenerates health', function(state)
        getgenv().GodModeEnabled = state

        if not state then
            pcall(function()
                local char = game.Players.LocalPlayer.Character

                if char and char:FindFirstChild('Humanoid') then
                    char.Humanoid.MaxHealth = 100
                    char.Humanoid.Health = 100

                    char.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                end
            end)
        end
    end)

    local Noclip = nil
    local Clip = nil

    function noclip()
        Clip = false

        local function Nocl()
            if Clip == false and game.Players.LocalPlayer.Character ~= nil then
                for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants())do
                    if v:IsA('BasePart') and v.CanCollide and v.Name ~= floatName then
                        v.CanCollide = false
                    end
                end
            end

            wait(0.21)
        end

        Noclip = game:GetService('RunService').Stepped:Connect(Nocl)
    end
    function clip()
        if Noclip then
            Noclip:Disconnect()
        end

        Clip = true
    end

    PlayerSection:NewPremiumToggle('Noclip', 'Walk through objects and walls', function(state)
        if state then
            noclip()
        else
            clip()
        end
    end)

    local isInfJump = false

    PlayerSection:NewPremiumToggle('Infinite Jump', 'Jump in mid-air', function(state)
        isInfJump = state

        game:GetService('UserInputService').JumpRequest:Connect(function()
            if isInfJump and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild('Humanoid') then
                game.Players.LocalPlayer.Character.Humanoid:ChangeState('Jumping')
            end
        end)
    end)
    VisualSection:NewSlider('Field of View', 'Change camera FOV', 120, 70, function(value)
        game.Workspace.CurrentCamera.FieldOfView = value
    end)
    VisualSection:NewToggle('Fullbright', 'Removes shadows and darkness', function(state)
        if state then
            game.Lighting.Ambient = Color3.new(1, 1, 1)
            game.Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
            game.Lighting.ColorShift_Top = Color3.new(1, 1, 1)
            game.Lighting.GlobalShadows = false
        else
            game.Lighting.Ambient = Color3.fromRGB(128, 128, 128)
            game.Lighting.GlobalShadows = true
        end
    end)

    local espHighlights = {}

    VisualSection:NewPremiumToggle('Player ESP', 'Highlights all players through walls', function(state)
        if state then
            for _, player in pairs(game.Players:GetPlayers())do
                if player ~= game.Players.LocalPlayer and player.Character then
                    local highlight = Instance.new('Highlight')

                    highlight.Parent = player.Character
                    highlight.FillColor = Config.AccentColor
                    highlight.OutlineColor = Config.SecondaryColor
                    highlight.FillTransparency = 0.5

                    table.insert(espHighlights, highlight)
                end
            end
        else
            for _, highlight in pairs(espHighlights)do
                if highlight and highlight.Parent then
                    highlight:Destroy()
                end
            end

            espHighlights = {}
        end
    end)
    VisualSection:NewPremiumSlider('Hitbox Expander', 'Make enemies easier to hit', 20, 2, function(value)
        _G.HeadSize = value
        _G.Disabled = true

        game:GetService('RunService').RenderStepped:connect(function()
            if _G.Disabled then
                for i, v in next, game:GetService('Players'):GetPlayers()do
                    if v.Name ~= game:GetService('Players').LocalPlayer.Name then
                        pcall(function()
                            v.Character.HumanoidRootPart.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
                            v.Character.HumanoidRootPart.Transparency = 0.7
                            v.Character.HumanoidRootPart.BrickColor = BrickColor.new('Really blue')
                            v.Character.HumanoidRootPart.Material = 'Neon'
                            v.Character.HumanoidRootPart.CanCollide = false
                        end)
                    end
                end
            end
        end)
    end)
    UtilSection:NewButton('Give Btools', 'Gives building tools to inventory', function()
        local tool1 = Instance.new('HopperBin', game.Players.LocalPlayer.Backpack)

        tool1.BinType = 'Clone'

        local tool2 = Instance.new('HopperBin', game.Players.LocalPlayer.Backpack)

        tool2.BinType = 'Hammer'

        local tool3 = Instance.new('HopperBin', game.Players.LocalPlayer.Backpack)

        tool3.BinType = 'Grab'
    end)
    UtilSection:NewPremiumButton('Teleport to Random Player', 'TPs you to a random user', function()
        local players = game.Players:GetPlayers()

        if #players > 1 then
            local randomPlayer = players[math.random(1, #players)]

            repeat
                randomPlayer = players[math.random(1, #players)]
            until randomPlayer.Name ~= game.Players.LocalPlayer.Name

            if randomPlayer.Character and randomPlayer.Character:FindFirstChild('HumanoidRootPart') and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild('HumanoidRootPart') then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = randomPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            end
        end
    end)
    UtilSection:NewButton('Rejoin Server', 'Rejoins the same server', function()
        game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
    end)
    UtilSection:NewPremiumButton('Server Hop', 'Joins a random new server', function()
        local Http = game:GetService('HttpService')
        local TPS = game:GetService('TeleportService')
        local Api = 'https://games.roblox.com/v1/games/'
        local _place = game.PlaceId
        local _servers = Api .. tostring(_place) .. '/servers/Public?sortOrder=Asc&limit=100'

        local function ListServers(cursor)
            local Raw = game:HttpGet(_servers .. ((cursor and '&cursor=' .. cursor) or ''))

            return Http:JSONDecode(Raw)
        end

        local Server, Next

        repeat
            local Servers = ListServers(Next)

            Server = Servers.data[1]
            Next = Servers.nextPageCursor
        until Server

        TPS:TeleportToPlaceInstance(_place, Server.id, game.Players.LocalPlayer)
    end)
    UtilSection:NewToggle('Anti-AFK', 'Prevents Roblox disconnects', function(state)
        local gc = getconnections or get_signal_cons

        if state and gc then
            for i, v in pairs(gc(game.Players.LocalPlayer.Idled))do
                if v.Disable then
                    v.Disable(v)
                elseif v.Disconnect then
                    v.Disconnect(v)
                end
            end
        end
    end)

    local AimbotParams = {
        Enabled = false,
        ShowFOV = false,
        FOVRadius = 80,
        Smoothness = 0.5,
        TeamCheck = true,
        TargetPart = 'Head',
    }
    local FOVCircle = Drawing.new('Circle')

    FOVCircle.Position = Vector2.new(game.Workspace.CurrentCamera.ViewportSize.X / 2, game.Workspace.CurrentCamera.ViewportSize.Y / 2)
    FOVCircle.Radius = AimbotParams.FOVRadius
    FOVCircle.Filled = false
    FOVCircle.Color = Color3.fromRGB(255, 255, 255)
    FOVCircle.Visible = false
    FOVCircle.Thickness = 1

    local function getClosestPlayerToCursor()
        local closestDist = AimbotParams.FOVRadius
        local closestPlayer = nil
        local mousePos = game:GetService('UserInputService'):GetMouseLocation()

        for _, player in pairs(game.Players:GetPlayers())do
            if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild(AimbotParams.TargetPart) and player.Character:FindFirstChild('Humanoid') and player.Character.Humanoid.Health > 0 then
                if AimbotParams.TeamCheck and player.Team == game.Players.LocalPlayer.Team then
                end

                local screenPos, onScreen = game.Workspace.CurrentCamera:WorldToViewportPoint(player.Character[AimbotParams.TargetPart].Position)

                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude

                    if dist < closestDist then
                        closestDist = dist
                        closestPlayer = player
                    end
                end
            end
        end

        return closestPlayer
    end

    game:GetService('RunService').RenderStepped:Connect(function()
        if AimbotParams.ShowFOV then
            FOVCircle.Position = game:GetService('UserInputService'):GetMouseLocation()
            FOVCircle.Radius = AimbotParams.FOVRadius
            FOVCircle.Visible = true
        else
            FOVCircle.Visible = false
        end
        if AimbotParams.Enabled and game:GetService('UserInputService'):IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local target = getClosestPlayerToCursor()

            if target and target.Character and target.Character:FindFirstChild(AimbotParams.TargetPart) then
                local currentCam = game.Workspace.CurrentCamera
                local targetCFrame = CFrame.new(currentCam.CFrame.Position, target.Character[AimbotParams.TargetPart].Position)

                currentCam.CFrame = currentCam.CFrame:Lerp(targetCFrame, AimbotParams.Smoothness)
            end
        end
    end)
    AimbotSection:NewPremiumToggle('Enable Aimbot (Right Click)', 'Locks onto targets in FOV', function(state)
        AimbotParams.Enabled = state
    end)
    AimbotSection:NewToggle('Show FOV Circle', 'Displays the aimbot radius', function(state)
        AimbotParams.ShowFOV = state
    end)
    AimbotSection:NewSlider('FOV Size', 'Target area size', 300, 20, function(value)
        AimbotParams.FOVRadius = value
    end)
    AimbotSection:NewPremiumSlider('Aimbot Smoothness', '100=Instant, 1=Slow', 100, 1, function(value)
        AimbotParams.Smoothness = value / 100
    end)
    AimbotSection:NewToggle('Team Check', 'Ignores teammates', function(state)
        AimbotParams.TeamCheck = state
    end)
    UISec:NewButton('Test Notification', 'Test the notification system', function()
        KenHubLib:Notify('Test', 'Notifications are working!', 4, false)
    end)
    UISec:NewButton('Test Premium Alert', 'Premium-style notification', function()
        KenHubLib:Notify('Premium Alert', 'This is how premium alerts look!', 4, true)
    end)

    local uiTransparency = 0

    UISec:NewSlider('UI Opacity', 'Adjust hub transparency', 8, 0, function(v)
        uiTransparency = v / 10

        pcall(function()
            for k, v in pairs(getgenv())do
                if type(k) == 'string' and k:sub(1, 3) == '_h_' and typeof(v) == 'Instance' and v:IsA('ScreenGui') then
                    local m = v:FindFirstChild('Main')

                    if m then
                        m.BackgroundTransparency = uiTransparency
                    end
                end
            end
        end)
    end)
    InfoSec:NewLabel('Right-click = Hold to aim (Aimbot)')
    InfoSec:NewLabel('Drag title bar to move')
    InfoSec:NewLabel('discord.gg/getsnowy')
    InfoSec:NewButton('Copy Discord', 'Copy invite link', function()
        if setclipboard then
            setclipboard('https://discord.gg/getsnowy')
        end

        KenHubLib:Notify('Copied!', 'Discord link copied.', 3, false)
    end)
    ScriptSec:NewButton('Reload Hub', 'Destroys and reloads the UI', function()
        pcall(function()
            for k, v in pairs(getgenv())do
                if type(k) == 'string' and k:sub(1, 3) == '_h_' and typeof(v) == 'Instance' and v:IsA('ScreenGui') then
                    pcall(function()
                        v:Destroy()
                    end)

                    getgenv()[k] = nil
                end
            end
        end)
        task.wait(0.1)

        getgenv().Window = Kavo.CreateLib(Config.HubName, 'Midnight')

        notify('Reloaded', 'Hub UI restarted.', 3)
    end)
    ScriptSec:NewLabel('KENHUB v6.0 | Built by KenHub')
    ScriptSec:NewLabel(tostring(#SUPPORTED_GAMES) .. ' Games Supported')
else
    local function stubTab()
        local noop = function() end
        local stS = {}

        stS.NewToggle = noop
        stS.NewButton = noop
        stS.NewSlider = noop
        stS.NewDropdown = noop
        stS.NewLabel = noop
        stS.NewPremiumToggle = noop
        stS.NewPremiumButton = noop
        stS.NewPremiumSlider = noop
        stS.NewPremiumDropdown = noop
        stS.NewSection = function()
            return stS
        end

        return {
            NewSection = function()
                return stS
            end,
            HideTabButton = noop,
            Select = noop,
            ActualTab = {SetVisible = noop},
        }
    end

    getgenv().HomeTab = stubTab()
    getgenv().PlayerTab = stubTab()
    getgenv().VisualTab = stubTab()
    getgenv().UtilTab = stubTab()
    getgenv().AimbotTab = stubTab()
    getgenv().SettingsTab = stubTab()

    local stubS = HomeTab:NewSection()

    getgenv().HomeSec = stubS
    getgenv().PlayerSection = stubS
    getgenv().VisualSection = stubS
    getgenv().UtilSection = stubS
    getgenv().AimbotSection = stubS
    getgenv().UISec = stubS
    getgenv().InfoSec = stubS
    getgenv().ScriptSec = stubS
end
if _detectedGame and _detectedGame.name == 'MM2' then
    local MM2Tab = gameTab('MM2', 'Murder Mystery 2 ')

    do
        local MM2_Players = game:GetService('Players')
        local MM2_RS = game:GetService('ReplicatedStorage')
        local MM2_Run = game:GetService('RunService')
        local MM2_UIS = game:GetService('UserInputService')
        local MM2_TS = game:GetService('TweenService')
        local MM2_Light = game:GetService('Lighting')
        local MM2_WS = workspace
        local MM2_LP = MM2_Players.LocalPlayer
        local MM2_Flags = getgenv()._MM2Flags or {}

        getgenv()._MM2Flags = MM2_Flags

        local function MM2_char()
            return MM2_LP.Character
        end
        local function MM2_hum()
            local c = MM2_char()

            return c and c:FindFirstChildWhichIsA('Humanoid')
        end
        local function MM2_hrp()
            local c = MM2_char()

            return c and c:FindFirstChild('HumanoidRootPart')
        end
        local function MM2_hasTool(plr, needle)
            needle = needle:lower()

            local bp = plr:FindFirstChild('Backpack')
            local c = plr.Character
            local sources = {}

            if bp then
                table.insert(sources, bp)
            end
            if c then
                table.insert(sources, c)
            end

            for _, src in ipairs(sources)do
                for _, t in ipairs(src:GetChildren())do
                    if t:IsA('Tool') and t.Name:lower():find(needle) then
                        return t
                    end
                end
            end

            return nil
        end
        local function MM2_role(plr)
            if MM2_hasTool(plr, 'knife') then
                return 'Murderer'
            end
            if MM2_hasTool(plr, 'gun') then
                return 'Sheriff'
            end

            return 'Innocent'
        end
        local function MM2_findRole(role)
            for _, p in ipairs(MM2_Players:GetPlayers())do
                if p ~= MM2_LP and MM2_role(p) == role then
                    return p
                end
            end
        end
        local function MM2_dist(p1, p2)
            local a = p1:FindFirstChild('HumanoidRootPart')
            local b = p2:FindFirstChild('HumanoidRootPart')

            if a and b then
                return (a.Position - b.Position).Magnitude
            end

            return math.huge
        end
        local function MM2_tp(cf)
            local hrp = MM2_hrp()

            if hrp then
                pcall(function()
                    hrp.CFrame = cf
                end)

                return true
            end
        end
        local function MM2_tpTo(plr, offset)
            local char = plr.Character
            local hrp = char and char:FindFirstChild('HumanoidRootPart')

            if hrp then
                MM2_tp(hrp.CFrame * (offset or CFrame.new(0, 0, -3)))
            end
        end
        local function MM2_notify(t, m, d)
            pcall(function()
                KenHubLib:Notify(t, m, d or 3)
            end)
        end

        local RoleSec = MM2Tab:NewSection('Round Info')
        local myRoleLbl = RoleSec:NewLabel('Your Role: ?')
        local murdererLbl = RoleSec:NewLabel('Murderer: ?')
        local sheriffLbl = RoleSec:NewLabel('Sheriff: ?')

        task.spawn(function()
            while true do
                pcall(function()
                    myRoleLbl:Set('Your Role: ' .. MM2_role(MM2_LP))

                    local m = MM2_findRole('Murderer')
                    local s = MM2_findRole('Sheriff')

                    murdererLbl:Set('Murderer: ' .. (m and m.Name or 'Unknown / Innocent turn'))
                    sheriffLbl:Set('Sheriff: ' .. (s and s.Name or 'Unknown / Innocent turn'))
                end)
                task.wait(0.5)
            end
        end)
        RoleSec:NewButton('Copy Murderer Name', "Copy the current Murderer's username", function()
            local m = MM2_findRole('Murderer')

            if m then
                pcall(function()
                    setclipboard(m.Name)
                end)
                MM2_notify('MM2', 'Copied: ' .. m.Name, 2)
            else
                MM2_notify('MM2', 'No murderer found', 2)
            end
        end)

        local CombatSec = MM2Tab:NewSection('Combat')

        CombatSec:NewToggle('Kill Aura (as Murderer)', 'Stab any player that walks within 10 studs', function(state)
            MM2_Flags.KillAura = state

            if not state then
                return
            end

            task.spawn(function()
                while MM2_Flags.KillAura do
                    pcall(function()
                        local knife = MM2_hasTool(MM2_LP, 'knife')
                        local hrp = MM2_hrp()

                        if knife and hrp then
                            if knife.Parent ~= MM2_char() then
                                local h = MM2_hum()

                                if h then
                                    h:EquipTool(knife)
                                end
                            end

                            for _, p in ipairs(MM2_Players:GetPlayers())do
                                if p ~= MM2_LP and p.Character then
                                    local thrp = p.Character:FindFirstChild('HumanoidRootPart')
                                    local hh = p.Character:FindFirstChildWhichIsA('Humanoid')

                                    if thrp and hh and hh.Health > 0 and (thrp.Position - hrp.Position).Magnitude <= 12 then
                                        local orig = hrp.CFrame

                                        pcall(function()
                                            hrp.CFrame = thrp.CFrame
                                        end)
                                        task.wait()
                                        pcall(function()
                                            knife:Activate()
                                        end)
                                        task.wait(0.05)
                                        pcall(function()
                                            hrp.CFrame = orig
                                        end)
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(0.15)
                end
            end)
        end)
        CombatSec:NewButton('Auto-Kill Murderer (as Sheriff)', 'Teleport + shoot murderer once', function()
            local gun = MM2_hasTool(MM2_LP, 'gun')
            local m = MM2_findRole('Murderer')
            local hrp = MM2_hrp()

            if not gun then
                return MM2_notify('MM2', "You don't have a gun", 2)
            end
            if not m or not m.Character then
                return MM2_notify('MM2', 'No murderer', 2)
            end

            local thrp = m.Character:FindFirstChild('HumanoidRootPart')

            if not (thrp and hrp) then
                return
            end

            local orig = hrp.CFrame
            local h = MM2_hum()

            if h then
                h:EquipTool(gun)
            end

            task.wait(0.1)
            pcall(function()
                hrp.CFrame = thrp.CFrame * CFrame.new(0, 0, -3)
            end)
            task.wait(0.05)
            pcall(function()
                gun:Activate()
            end)
            task.wait(0.15)
            pcall(function()
                hrp.CFrame = orig
            end)
        end)
        CombatSec:NewPremiumToggle('Auto-Shoot Murderer', 'As Sheriff, auto-aim & shoot whenever murderer is visible', function(state)
            MM2_Flags.AutoShoot = state

            if not state then
                return
            end

            task.spawn(function()
                while MM2_Flags.AutoShoot do
                    pcall(function()
                        local gun = MM2_hasTool(MM2_LP, 'gun')
                        local m = MM2_findRole('Murderer')

                        if gun and m and m.Character then
                            local thrp = m.Character:FindFirstChild('HumanoidRootPart')
                            local hrp = MM2_hrp()

                            if thrp and hrp then
                                if gun.Parent ~= MM2_char() then
                                    local h = MM2_hum()

                                    if h then
                                        h:EquipTool(gun)
                                    end
                                end

                                pcall(function()
                                    workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, thrp.Position)
                                end)
                                pcall(function()
                                    gun:Activate()
                                end)
                            end
                        end
                    end)
                    task.wait(0.25)
                end
            end)
        end)
        CombatSec:NewPremiumToggle('Silent Aim (redirect shots)', "Overrides mouse hit to murderer's position", function(state)
            MM2_Flags.SilentAim = state

            if not state then
                if MM2_Flags._silentHook then
                    pcall(function()
                        hookmetamethod(game, '__namecall', MM2_Flags._origNC)
                    end)

                    MM2_Flags._silentHook = nil
                end

                return
            end

            pcall(function()
                if not hookmetamethod then
                    MM2_notify('MM2', 'Silent Aim needs hookmetamethod', 3)

                    return
                end

                local mt = getrawmetatable(game)
                local old = mt.__namecall

                setreadonly(mt, false)

                MM2_Flags._origNC = old
                mt.__namecall = newcclosure(function(self, ...)
                    local method = getnamecallmethod()

                    if MM2_Flags.SilentAim and (method == 'FindPartOnRay' or method == 'FindPartOnRayWithIgnoreList' or method == 'Raycast') then
                        local m = MM2_findRole('Murderer')

                        if m and m.Character then
                            local thrp = m.Character:FindFirstChild('HumanoidRootPart')

                            if thrp then
                                return thrp, thrp.Position, Vector3.new(0, 1, 0), Enum.Material.Plastic
                            end
                        end
                    end

                    return old(self, ...)
                end)

                setreadonly(mt, true)

                MM2_Flags._silentHook = true
            end)
        end)
        CombatSec:NewButton('Grab Dropped Gun', 'Teleport to any gun currently dropped in workspace', function()
            for _, d in ipairs(MM2_WS:GetChildren())do
                if d:IsA('Tool') and d.Name:lower():find('gun') then
                    local h = d:FindFirstChild('Handle')

                    if h then
                        MM2_tp(h.CFrame)
                        MM2_notify('MM2', 'Teleported to gun', 2)

                        return
                    end
                end
            end

            MM2_notify('MM2', 'No dropped gun found', 2)
        end)
        CombatSec:NewToggle('Auto-Grab Gun', 'Automatically TP to any dropped gun', function(state)
            MM2_Flags.AutoGrabGun = state

            if not state then
                return
            end

            task.spawn(function()
                while MM2_Flags.AutoGrabGun do
                    pcall(function()
                        for _, d in ipairs(MM2_WS:GetChildren())do
                            if d:IsA('Tool') and d.Name:lower():find('gun') then
                                local h = d:FindFirstChild('Handle')

                                if h then
                                    MM2_tp(h.CFrame)
                                end
                            end
                        end
                    end)
                    task.wait(0.5)
                end
            end)
        end)
        CombatSec:NewPremiumToggle('Auto-Grab Knife', 'Automatically TP to any dropped knife', function(state)
            MM2_Flags.AutoGrabKnife = state

            if not state then
                return
            end

            task.spawn(function()
                while MM2_Flags.AutoGrabKnife do
                    pcall(function()
                        for _, d in ipairs(MM2_WS:GetChildren())do
                            if d:IsA('Tool') and d.Name:lower():find('knife') then
                                local h = d:FindFirstChild('Handle')

                                if h then
                                    MM2_tp(h.CFrame)
                                end
                            end
                        end
                    end)
                    task.wait(0.5)
                end
            end)
        end)

        local MoveSec = MM2Tab:NewSection('Movement')

        MoveSec:NewSlider('Walk Speed', 'Your walk speed (default 16)', 200, 16, function(v)
            getgenv().MM2Walk = v

            local h = MM2_hum()

            if h then
                h.WalkSpeed = v
            end
        end)
        MoveSec:NewSlider('Jump Power', 'Your jump power (default 50)', 350, 50, function(v)
            getgenv().MM2Jump = v

            local h = MM2_hum()

            if h then
                h.JumpPower = v
                h.UseJumpPower = true
            end
        end)
        MM2_LP.CharacterAdded:Connect(function(c)
            task.wait(0.5)

            local h = c:FindFirstChildWhichIsA('Humanoid')

            if h then
                if getgenv().MM2Walk then
                    h.WalkSpeed = getgenv().MM2Walk
                end
                if getgenv().MM2Jump then
                    h.JumpPower = getgenv().MM2Jump
                    h.UseJumpPower = true
                end
            end
        end)
        MoveSec:NewToggle('Infinite Jump', 'Jump mid-air', function(state)
            MM2_Flags.InfJump = state

            if MM2_Flags._infJumpConn then
                MM2_Flags._infJumpConn:Disconnect()

                MM2_Flags._infJumpConn = nil
            end
            if state then
                MM2_Flags._infJumpConn = MM2_UIS.JumpRequest:Connect(function()
                    local h = MM2_hum()

                    if h then
                        h:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end)
            end
        end)
        MoveSec:NewPremiumToggle('No Clip', 'Walk through walls', function(state)
            MM2_Flags.NoClip = state

            if MM2_Flags._noClipConn then
                MM2_Flags._noClipConn:Disconnect()

                MM2_Flags._noClipConn = nil
            end
            if not state then
                return
            end

            MM2_Flags._noClipConn = MM2_Run.Stepped:Connect(function()
                local c = MM2_char()

                if not c then
                    return
                end

                for _, p in ipairs(c:GetDescendants())do
                    if p:IsA('BasePart') then
                        p.CanCollide = false
                    end
                end
            end)
        end)
        MoveSec:NewPremiumSlider('Fly Speed', 'Max velocity used by Fly', 500, 30, function(v)
            getgenv().MM2FlySpeed = v
        end)
        MoveSec:NewPremiumToggle('Fly (WASD+Space/Ctrl)', 'Free-cam style fly', function(state)
            MM2_Flags.Fly = state

            if MM2_Flags._flyBV then
                MM2_Flags._flyBV:Destroy()

                MM2_Flags._flyBV = nil
            end
            if MM2_Flags._flyBG then
                MM2_Flags._flyBG:Destroy()

                MM2_Flags._flyBG = nil
            end
            if not state then
                return
            end

            task.spawn(function()
                while MM2_Flags.Fly do
                    local hrp = MM2_hrp()

                    if hrp then
                        if not MM2_Flags._flyBV or MM2_Flags._flyBV.Parent ~= hrp then
                            if MM2_Flags._flyBV then
                                MM2_Flags._flyBV:Destroy()
                            end
                            if MM2_Flags._flyBG then
                                MM2_Flags._flyBG:Destroy()
                            end

                            local bv = Instance.new('BodyVelocity', hrp)

                            bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
                            bv.Velocity = Vector3.new()

                            local bg = Instance.new('BodyGyro', hrp)

                            bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
                            bg.P = 1e4
                            bg.D = 500
                            MM2_Flags._flyBV, MM2_Flags._flyBG = bv, bg
                        end

                        local cam = workspace.CurrentCamera
                        local dir = Vector3.new()

                        if MM2_UIS:IsKeyDown(Enum.KeyCode.W) then
                            dir = dir + cam.CFrame.LookVector
                        end
                        if MM2_UIS:IsKeyDown(Enum.KeyCode.S) then
                            dir = dir - cam.CFrame.LookVector
                        end
                        if MM2_UIS:IsKeyDown(Enum.KeyCode.A) then
                            dir = dir - cam.CFrame.RightVector
                        end
                        if MM2_UIS:IsKeyDown(Enum.KeyCode.D) then
                            dir = dir + cam.CFrame.RightVector
                        end
                        if MM2_UIS:IsKeyDown(Enum.KeyCode.Space) then
                            dir = dir + Vector3.new(0, 1, 0)
                        end
                        if MM2_UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
                            dir = dir - Vector3.new(0, 1, 0)
                        end

                        MM2_Flags._flyBV.Velocity = dir * (getgenv().MM2FlySpeed or 80)
                        MM2_Flags._flyBG.CFrame = cam.CFrame
                    end

                    MM2_Run.Heartbeat:Wait()
                end
            end)
        end)
        MoveSec:NewPremiumButton('Teleport to Murderer', 'TP behind the murderer', function()
            local m = MM2_findRole('Murderer')

            if m then
                MM2_tpTo(m)
            else
                MM2_notify('MM2', 'No murderer', 2)
            end
        end)
        MoveSec:NewPremiumButton('Teleport to Sheriff', 'TP next to the sheriff', function()
            local s = MM2_findRole('Sheriff')

            if s then
                MM2_tpTo(s)
            else
                MM2_notify('MM2', 'No sheriff', 2)
            end
        end)
        MoveSec:NewButton('Save Position', 'Save current position', function()
            local hrp = MM2_hrp()

            if hrp then
                getgenv().MM2SavedCF = hrp.CFrame

                MM2_notify('MM2', 'Position saved', 2)
            end
        end)
        MoveSec:NewButton('Load Position', 'Teleport back to saved position', function()
            if getgenv().MM2SavedCF then
                MM2_tp(getgenv().MM2SavedCF)
            else
                MM2_notify('MM2', 'No saved position', 2)
            end
        end)

        local CoinSec = MM2Tab:NewSection('Coin Farm')

        local function MM2_findCoins()
            local coins = {}

            for _, d in ipairs(MM2_WS:GetDescendants())do
                if d:IsA('BasePart') and d.Name:lower():find('coin') then
                    table.insert(coins, d)
                end
            end

            return coins
        end

        CoinSec:NewButton('Collect All Coins (instant)', 'Teleport through every coin on the map', function()
            local hrp = MM2_hrp()

            if not hrp then
                return
            end

            local saved = hrp.CFrame
            local coins = MM2_findCoins()

            MM2_notify('MM2', 'Collecting ' .. #coins .. ' coins...', 2)

            for _, c in ipairs(coins)do
                if c.Parent then
                    pcall(function()
                        hrp.CFrame = c.CFrame
                    end)
                    task.wait(0.08)
                end
            end

            pcall(function()
                hrp.CFrame = saved
            end)
            MM2_notify('MM2', 'Coin sweep complete', 2)
        end)
        CoinSec:NewPremiumToggle('Auto-Collect Coins (loop)', 'Keep collecting coins as they spawn', function(state)
            MM2_Flags.AutoCoin = state

            if not state then
                return
            end

            task.spawn(function()
                while MM2_Flags.AutoCoin do
                    local hrp = MM2_hrp()

                    if hrp then
                        for _, c in ipairs(MM2_findCoins())do
                            if not MM2_Flags.AutoCoin then
                                break
                            end
                            if c.Parent then
                                pcall(function()
                                    hrp.CFrame = c.CFrame
                                end)
                            end

                            task.wait(0.06)
                        end
                    end

                    task.wait(1)
                end
            end)
        end)
        CoinSec:NewButton('TP to Nearest Coin', 'One-off teleport to closest coin', function()
            local hrp = MM2_hrp()

            if not hrp then
                return
            end

            local best, bd

            for _, c in ipairs(MM2_findCoins())do
                local d = (c.Position - hrp.Position).Magnitude

                if not bd or d < bd then
                    best, bd = c, d
                end
            end

            if best then
                MM2_tp(best.CFrame)
            else
                MM2_notify('MM2', 'No coins found', 2)
            end
        end)

        local EspSec = MM2Tab:NewSection('ESP')
        local ESP_COLORS = {
            Murderer = Color3.fromRGB(255, 60, 60),
            Sheriff = Color3.fromRGB(60, 160, 255),
            Innocent = Color3.fromRGB(90, 220, 120),
        }

        local function MM2_clearESP()
            for _, p in ipairs(MM2_Players:GetPlayers())do
                if p.Character then
                    local h = p.Character:FindFirstChild('MM2ESP_Hl')

                    if h then
                        h:Destroy()
                    end

                    local n = p.Character:FindFirstChild('MM2ESP_Name')

                    if n then
                        n:Destroy()
                    end
                end
            end
        end
        local function MM2_applyESP()
            for _, p in ipairs(MM2_Players:GetPlayers())do
                if p ~= MM2_LP and p.Character then
                    local role = MM2_role(p)

                    if (role == 'Murderer' and MM2_Flags.ESPMurd) or (role == 'Sheriff' and MM2_Flags.ESPSher) or (role == 'Innocent' and MM2_Flags.ESPInno) then
                        local hl = p.Character:FindFirstChild('MM2ESP_Hl')

                        if not hl then
                            hl = Instance.new('Highlight')
                            hl.Name = 'MM2ESP_Hl'
                            hl.FillTransparency = 0.65
                            hl.OutlineTransparency = 0
                            hl.Parent = p.Character
                        end

                        hl.FillColor = ESP_COLORS[role]
                        hl.OutlineColor = ESP_COLORS[role]

                        local head = p.Character:FindFirstChild('Head')

                        if head then
                            local tag = p.Character:FindFirstChild('MM2ESP_Name')

                            if not tag then
                                tag = Instance.new('BillboardGui')
                                tag.Name = 'MM2ESP_Name'
                                tag.Size = UDim2.new(0, 180, 0, 40)
                                tag.StudsOffset = Vector3.new(0, 2.5, 0)
                                tag.AlwaysOnTop = true
                                tag.Adornee = head
                                tag.Parent = p.Character

                                local lbl = Instance.new('TextLabel', tag)

                                lbl.BackgroundTransparency = 1
                                lbl.Size = UDim2.new(1, 0, 1, 0)
                                lbl.Font = Enum.Font.GothamBlack
                                lbl.TextSize = 13
                                lbl.TextStrokeTransparency = 0
                            end

                            local lbl = tag:FindFirstChildWhichIsA('TextLabel')
                            local d = MM2_dist(p, MM2_LP)
                            local dstr = (d ~= math.huge) and string.format(' [%dm]', math.floor(d)) or ''

                            lbl.Text = '[' .. role .. '] ' .. p.Name .. dstr
                            lbl.TextColor3 = ESP_COLORS[role]
                        end
                    else
                        local h = p.Character:FindFirstChild('MM2ESP_Hl')

                        if h then
                            h:Destroy()
                        end

                        local n = p.Character:FindFirstChild('MM2ESP_Name')

                        if n then
                            n:Destroy()
                        end
                    end
                end
            end
        end
        local function MM2_startEspLoop()
            if MM2_Flags._espLoopRunning then
                return
            end

            MM2_Flags._espLoopRunning = true

            task.spawn(function()
                while MM2_Flags.ESPMurd or MM2_Flags.ESPSher or MM2_Flags.ESPInno do
                    pcall(MM2_applyESP)
                    task.wait(0.5)
                end

                MM2_clearESP()

                MM2_Flags._espLoopRunning = false
            end)
        end

        EspSec:NewPremiumToggle('ESP: Murderer', 'Red highlight + name', function(s)
            MM2_Flags.ESPMurd = s

            if s then
                MM2_startEspLoop()
            end
        end)
        EspSec:NewPremiumToggle('ESP: Sheriff', 'Blue highlight + name', function(s)
            MM2_Flags.ESPSher = s

            if s then
                MM2_startEspLoop()
            end
        end)
        EspSec:NewToggle('ESP: Innocents', 'Green highlight + name', function(s)
            MM2_Flags.ESPInno = s

            if s then
                MM2_startEspLoop()
            end
        end)
        EspSec:NewPremiumToggle('ESP: Gun Drop', 'Highlight any gun tool in workspace', function(state)
            MM2_Flags.ESPGun = state

            if not state then
                return
            end

            task.spawn(function()
                while MM2_Flags.ESPGun do
                    pcall(function()
                        for _, d in ipairs(MM2_WS:GetChildren())do
                            if d:IsA('Tool') and d.Name:lower():find('gun') and not d:FindFirstChild('MM2ESP_Hl') then
                                local hl = Instance.new('Highlight', d)

                                hl.Name = 'MM2ESP_Hl'
                                hl.FillColor = Color3.fromRGB(100, 200, 255)
                                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                            end
                        end
                    end)
                    task.wait(1)
                end
            end)
        end)
        EspSec:NewPremiumToggle('ESP: Knife Drop', 'Highlight any knife tool in workspace', function(state)
            MM2_Flags.ESPKnife = state

            if not state then
                return
            end

            task.spawn(function()
                while MM2_Flags.ESPKnife do
                    pcall(function()
                        for _, d in ipairs(MM2_WS:GetChildren())do
                            if d:IsA('Tool') and d.Name:lower():find('knife') and not d:FindFirstChild('MM2ESP_Hl') then
                                local hl = Instance.new('Highlight', d)

                                hl.Name = 'MM2ESP_Hl'
                                hl.FillColor = Color3.fromRGB(255, 60, 60)
                                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                            end
                        end
                    end)
                    task.wait(1)
                end
            end)
        end)
        EspSec:NewToggle('ESP: Coins', 'Highlight every coin on the map', function(state)
            MM2_Flags.ESPCoin = state

            if not state then
                for _, d in ipairs(MM2_WS:GetDescendants())do
                    if d:IsA('BasePart') and d.Name:lower():find('coin') then
                        local h = d:FindFirstChild('MM2ESP_Hl')

                        if h then
                            h:Destroy()
                        end
                    end
                end

                return
            end

            task.spawn(function()
                while MM2_Flags.ESPCoin do
                    pcall(function()
                        for _, c in ipairs(MM2_findCoins())do
                            if not c:FindFirstChild('MM2ESP_Hl') then
                                local hl = Instance.new('Highlight', c)

                                hl.Name = 'MM2ESP_Hl'
                                hl.FillColor = Color3.fromRGB(255, 215, 0)
                                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                                hl.FillTransparency = 0.5
                            end
                        end
                    end)
                    task.wait(2)
                end
            end)
        end)

        local VisSec = MM2Tab:NewSection('Visuals')

        VisSec:NewToggle('Fullbright', 'Remove ambient shadows', function(state)
            MM2_Flags.Fullbright = state

            if state then
                MM2_Flags._prevAmb = MM2_Light.Ambient
                MM2_Flags._prevBr = MM2_Light.Brightness
                MM2_Flags._prevOA = MM2_Light.OutdoorAmbient
                MM2_Light.Ambient = Color3.new(1, 1, 1)
                MM2_Light.Brightness = 2
                MM2_Light.OutdoorAmbient = Color3.new(1, 1, 1)
            else
                pcall(function()
                    if MM2_Flags._prevAmb then
                        MM2_Light.Ambient = MM2_Flags._prevAmb
                    end
                    if MM2_Flags._prevBr then
                        MM2_Light.Brightness = MM2_Flags._prevBr
                    end
                    if MM2_Flags._prevOA then
                        MM2_Light.OutdoorAmbient = MM2_Flags._prevOA
                    end
                end)
            end
        end)
        VisSec:NewToggle('No Fog', 'Push fog to max', function(state)
            MM2_Flags.NoFog = state

            if state then
                MM2_Flags._prevFog = MM2_Light.FogEnd
                MM2_Light.FogEnd = 1e6
            else
                pcall(function()
                    if MM2_Flags._prevFog then
                        MM2_Light.FogEnd = MM2_Flags._prevFog
                    end
                end)
            end
        end)
        VisSec:NewSlider('Camera FOV', 'Camera field of view (default 70)', 120, 40, function(v)
            getgenv().MM2FOV = v

            pcall(function()
                workspace.CurrentCamera.FieldOfView = v
            end)
        end)
        VisSec:NewToggle('Hide Own Name', 'Hide your own name-tag above head', function(state)
            MM2_Flags.HideName = state

            local c = MM2_char()

            if not c then
                return
            end

            local head = c:FindFirstChild('Head')

            if head then
                for _, g in ipairs(head:GetChildren())do
                    if g:IsA('BillboardGui') then
                        g.Enabled = not state
                    end
                end
            end
        end)

        local QoLSec = MM2Tab:NewSection('Anti-Detect / QoL')

        QoLSec:NewToggle('Anti-AFK (never kicked)', 'Blocks Roblox idle kick', function(state)
            MM2_Flags.AntiAFK = state

            if MM2_Flags._afkConn then
                MM2_Flags._afkConn:Disconnect()

                MM2_Flags._afkConn = nil
            end
            if not state then
                return
            end

            MM2_Flags._afkConn = MM2_LP.Idled:Connect(function()
                pcall(function()
                    local vim = game:GetService('VirtualUser')

                    vim:CaptureController()
                    vim:ClickButton2(Vector2.new())
                end)
            end)
        end)
        QoLSec:NewToggle('Anti-Slip (lock Y axis on ice)', 'Freezes Y velocity to 0 while standing still', function(state)
            MM2_Flags.AntiSlip = state

            if not state then
                return
            end

            task.spawn(function()
                while MM2_Flags.AntiSlip do
                    pcall(function()
                        local hrp = MM2_hrp()
                        local h = MM2_hum()

                        if hrp and h and h.MoveDirection.Magnitude < 0.1 then
                            hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        end)
        QoLSec:NewPremiumToggle('Anti-Fling / Anti-Void', 'Auto TP back to last safe position when flung', function(state)
            MM2_Flags.AntiFling = state

            if not state then
                return
            end

            task.spawn(function()
                local lastGood

                while MM2_Flags.AntiFling do
                    pcall(function()
                        local hrp = MM2_hrp()

                        if hrp then
                            if hrp.Position.Y > -100 and hrp.AssemblyLinearVelocity.Magnitude < 250 then
                                lastGood = hrp.CFrame
                            else
                                if lastGood then
                                    hrp.CFrame = lastGood
                                    hrp.AssemblyLinearVelocity = Vector3.new()
                                end
                            end
                        end
                    end)
                    task.wait(0.2)
                end
            end)
        end)
        QoLSec:NewButton('Rejoin Server', 'Rejoin the same server', function()
            pcall(function()
                game:GetService('TeleportService'):Teleport(game.PlaceId, MM2_LP)
            end)
        end)
        QoLSec:NewPremiumButton('Server Hop', 'Join a random other server', function()
            pcall(function()
                local ok, body = pcall(function()
                    return game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100')
                end)

                if not ok or not body then
                    MM2_notify('MM2', 'Server list failed', 3)

                    return
                end

                local HS = game:GetService('HttpService')
                local data = HS:JSONDecode(body)

                for _, s in ipairs(data.data or {})do
                    if s.playing and s.maxPlayers and s.playing < s.maxPlayers and s.id ~= game.JobId then
                        pcall(function()
                            game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, s.id, MM2_LP)
                        end)

                        return
                    end
                end

                MM2_notify('MM2', 'No joinable servers', 3)
            end)
        end)
        QoLSec:NewLabel('KenHub MM2 v1  60% premium / 40% free  \u{2022}  all features FREE during testing')
    end
end
if _detectedGame and _detectedGame.name == 'MM2' then
    local MM2Tab = gameTab('MM2', 'Murder Mystery 2')

    do
        local MM2Roles = MM2Tab:NewSection('Role ESP')
        local MM2Combat = MM2Tab:NewSection('Combat & Auto')
        local MM2Movement = MM2Tab:NewSection('Movement')
        local MM2Notify = MM2Tab:NewSection('Notifications')
        local MM2Teleport = MM2Tab:NewSection('Teleports')
        local Players = game:GetService('Players')
        local RunService = game:GetService('RunService')
        local Player = Players.LocalPlayer
        local Camera = workspace.CurrentCamera
        local UIS = game:GetService('UserInputService')
        local MM2Flags = {
            RoleESP = false,
            AutoGrab = false,
            AutoEvade = false,
            Noclip = false,
            Fly = false,
            FlySpeed = 50,
            NotifyGun = false,
        }

        local function UpdateRoleESP()
            pcall(function()
                for _, v in pairs(Players:GetPlayers())do
                    if v ~= Player and v.Character and v.Character:FindFirstChild('Head') then
                        local hl = v.Character:FindFirstChild('MM2_KenHubESP')

                        if not hl then
                            hl = Instance.new('Highlight')
                            hl.Name = 'MM2_KenHubESP'
                            hl.Parent = v.Character
                            hl.FillTransparency = 0.5
                            hl.OutlineTransparency = 0.2
                        end

                        local bp = v.Backpack
                        local chr = v.Character
                        local isMurderer = (bp:FindFirstChild('Knife') or chr:FindFirstChild('Knife')) ~= nil
                        local isSheriff = (bp:FindFirstChild('Gun') or chr:FindFirstChild('Gun')) ~= nil

                        if isMurderer then
                            hl.FillColor = Color3.fromRGB(255, 50, 50)
                            hl.OutlineColor = Color3.fromRGB(200, 0, 0)
                        elseif isSheriff then
                            hl.FillColor = Color3.fromRGB(50, 100, 255)
                            hl.OutlineColor = Color3.fromRGB(0, 50, 200)
                        else
                            hl.FillColor = Color3.fromRGB(50, 220, 80)
                            hl.OutlineColor = Color3.fromRGB(0, 180, 50)
                        end
                    end
                end
            end)
        end
        local function clearRoleESP()
            for _, v in pairs(Players:GetPlayers())do
                pcall(function()
                    if v.Character and v.Character:FindFirstChild('MM2_KenHubESP') then
                        v.Character.MM2_KenHubESP:Destroy()
                    end
                end)
            end
        end

        MM2Roles:NewToggle('Role ESP (Red=Murderer, Blue=Sheriff)', 'Highlight player roles with colored outlines', function(v)
            MM2Flags.RoleESP = v

            if v then
                if _G.MM2_ESP_Conn then
                    _G.MM2_ESP_Conn:Disconnect()
                end

                _G.MM2_ESP_Conn = RunService.RenderStepped:Connect(function()
                    if MM2Flags.RoleESP then
                        pcall(UpdateRoleESP)
                    end
                end)

                KenHubLib:Notify('ESP Active', 'Tracking roles: Red=Murderer, Blue=Sheriff, Green=Innocent', 3, false)
            else
                if _G.MM2_ESP_Conn then
                    _G.MM2_ESP_Conn:Disconnect()
                end

                clearRoleESP()
            end
        end)

        local function AttemptKill(targetPlayer)
            if not targetPlayer or not targetPlayer.Character then
                return
            end
            if not Player.Character or not Player.Character:FindFirstChild('Knife') then
                return
            end

            local knife = Player.Character.Knife
            local handle = knife:FindFirstChild('Handle')
            local targetHRP = targetPlayer.Character:FindFirstChild('HumanoidRootPart')
            local myHRP = Player.Character:FindFirstChild('HumanoidRootPart')

            if not targetHRP or not myHRP then
                return
            end

            local VIM = game:GetService('VirtualInputManager')
            local attempts = 0

            while targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild('Humanoid') and targetPlayer.Character.Humanoid.Health > 0 and attempts < 40 do
                attempts = attempts + 1

                local hrf = targetPlayer.Character:FindFirstChild('HumanoidRootPart')

                if not hrf then
                    break
                end

                myHRP.CFrame = hrf.CFrame

                pcall(function()
                    knife:Activate()
                end)

                local ctr = Camera.ViewportSize / 2

                VIM:SendMouseButtonEvent(ctr.X, ctr.Y, 0, true, game, 1)
                VIM:SendMouseButtonEvent(ctr.X, ctr.Y, 0, false, game, 1)

                if handle and firetouchinterest then
                    pcall(function()
                        firetouchinterest(handle, hrf, 0)
                        firetouchinterest(handle, hrf, 1)
                    end)
                end

                task.wait(0.05)
            end
        end
        local function AttemptShoot(targetPlayer)
            if not targetPlayer or not targetPlayer.Character then
                return
            end
            if not Player.Character or not Player.Character:FindFirstChild('Gun') then
                return
            end

            local gun = Player.Character.Gun
            local targetHRP = targetPlayer.Character:FindFirstChild('HumanoidRootPart')
            local myHRP = Player.Character:FindFirstChild('HumanoidRootPart')

            if not targetHRP or not myHRP then
                return
            end

            local VIM = game:GetService('VirtualInputManager')

            myHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 3)
            Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, targetHRP.Position)

            task.wait(0.1)
            pcall(function()
                gun:Activate()
            end)

            local ctr = Camera.ViewportSize / 2

            VIM:SendMouseButtonEvent(ctr.X, ctr.Y, 0, true, game, 1)
            task.wait(0.05)
            VIM:SendMouseButtonEvent(ctr.X, ctr.Y, 0, false, game, 1)
        end
        local function GrabDroppedGun()
            local gunDrop = workspace:FindFirstChild('GunDrop', true)

            if gunDrop and Player.Character and Player.Character:FindFirstChild('HumanoidRootPart') then
                local myHRP = Player.Character.HumanoidRootPart
                local oldCF = myHRP.CFrame

                myHRP.CFrame = gunDrop.CFrame

                task.wait(0.2)

                if firetouchinterest then
                    pcall(function()
                        firetouchinterest(myHRP, gunDrop, 0)
                        task.wait(0.1)
                        firetouchinterest(myHRP, gunDrop, 1)
                    end)
                end

                task.wait(0.2)

                myHRP.CFrame = oldCF

                KenHubLib:Notify('Gun Grabbed', 'Teleported to gun and returned!', 3, false)
            else
                KenHubLib:Notify('Not Found', 'No dropped gun exists in the map.', 3, false)
            end
        end

        MM2Combat:NewToggle('Auto Grab Dropped Gun', 'Instantly teleport to pick up the gun when it drops', function(v)
            MM2Flags.AutoGrab = v

            if v then
                if _G.MM2_AutoGrab_Conn then
                    _G.MM2_AutoGrab_Conn:Disconnect()
                end

                _G.MM2_AutoGrab_Conn = workspace.DescendantAdded:Connect(function(d)
                    if d.Name == 'GunDrop' and MM2Flags.AutoGrab then
                        task.wait(0.1)
                        GrabDroppedGun()
                    end
                end)
            else
                if _G.MM2_AutoGrab_Conn then
                    _G.MM2_AutoGrab_Conn:Disconnect()
                end
            end
        end)
        MM2Combat:NewPremiumToggle('Anti-Murderer (Auto Evade)', 'Teleport away when murderer gets too close (< 15 studs)', function(v)
            MM2Flags.AutoEvade = v

            if v then
                if _G.MM2_Evade_Conn then
                    _G.MM2_Evade_Conn:Disconnect()
                end

                _G.MM2_Evade_Conn = RunService.Heartbeat:Connect(function()
                    if not MM2Flags.AutoEvade then
                        return
                    end
                    if not Player.Character or not Player.Character:FindFirstChild('HumanoidRootPart') then
                        return
                    end

                    local murderer = nil

                    for _, p in pairs(Players:GetPlayers())do
                        if p ~= Player and p.Character and p.Character:FindFirstChild('HumanoidRootPart') then
                            if p.Character:FindFirstChild('Knife') or (p.Backpack and p.Backpack:FindFirstChild('Knife')) then
                                murderer = p

                                break
                            end
                        end
                    end

                    if murderer and murderer.Character and murderer.Character:FindFirstChild('HumanoidRootPart') then
                        local myPos = Player.Character.HumanoidRootPart.Position
                        local mPos = murderer.Character.HumanoidRootPart.Position
                        local dist = (myPos - mPos).Magnitude

                        if dist < 15 then
                            local dir = (myPos - mPos).Unit

                            if dir ~= dir then
                                dir = Vector3.new(0, 1, 0)
                            end

                            Player.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame + dir * 30
                        end
                    end
                end)
            else
                if _G.MM2_Evade_Conn then
                    _G.MM2_Evade_Conn:Disconnect()
                end
            end
        end)
        MM2Combat:NewButton('Grab Dropped Gun (Manual)', 'Teleport to the dropped gun right now', function()
            GrabDroppedGun()
        end)
        MM2Combat:NewPremiumButton('Kill All (Requires Murderer)', 'Teleport-kill all alive players with your knife', function()
            if Player.Character and Player.Character:FindFirstChild('Knife') then
                for _, p in pairs(Players:GetPlayers())do
                    if p ~= Player and p.Character and p.Character:FindFirstChild('Humanoid') and p.Character.Humanoid.Health > 0 then
                        AttemptKill(p)
                    end
                end
            else
                KenHubLib:Notify('Missing Knife', 'You must be the Murderer first!', 3, false)
            end
        end)
        MM2Combat:NewPremiumButton('Kill Sheriff (Requires Knife)', 'Teleport-kill the Sheriff with your knife', function()
            if Player.Character and Player.Character:FindFirstChild('Knife') then
                local sheriff = nil

                for _, p in pairs(Players:GetPlayers())do
                    if p ~= Player and p.Character and p.Backpack then
                        if p.Character:FindFirstChild('Gun') or p.Backpack:FindFirstChild('Gun') then
                            sheriff = p

                            break
                        end
                    end
                end

                if sheriff and sheriff.Character and sheriff.Character:FindFirstChild('Humanoid') and sheriff.Character.Humanoid.Health > 0 then
                    KenHubLib:Notify('Targeting', 'Teleporting to the Sheriff...', 2, false)
                    AttemptKill(sheriff)
                else
                    KenHubLib:Notify('Not Found', 'Could not find a living Sheriff.', 3, false)
                end
            else
                KenHubLib:Notify('Missing Knife', 'You must be the Murderer first!', 3, false)
            end
        end)
        MM2Combat:NewPremiumButton('Kill Murderer (Requires Gun)', 'Teleport-shoot the Murderer as Sheriff', function()
            if Player.Character and Player.Character:FindFirstChild('Gun') then
                local murderer = nil

                for _, p in pairs(Players:GetPlayers())do
                    if p ~= Player and p.Character and p.Backpack then
                        if p.Character:FindFirstChild('Knife') or p.Backpack:FindFirstChild('Knife') then
                            murderer = p

                            break
                        end
                    end
                end

                if murderer and murderer.Character and murderer.Character:FindFirstChild('Humanoid') and murderer.Character.Humanoid.Health > 0 then
                    KenHubLib:Notify('Targeting', 'Teleporting to the Murderer...', 2, false)
                    AttemptShoot(murderer)
                else
                    KenHubLib:Notify('Not Found', 'Could not find a living Murderer.', 3, false)
                end
            else
                KenHubLib:Notify('Missing Gun', 'You need to have the Sheriff gun equipped!', 3, false)
            end
        end)
        MM2Movement:NewToggle('Noclip (Walk Through Walls)', 'Disables collisions on your character every frame', function(v)
            if v then
                if _G.MM2_Noclip_Conn then
                    _G.MM2_Noclip_Conn:Disconnect()
                end

                _G.MM2_Noclip_Conn = RunService.Stepped:Connect(function()
                    if Player.Character then
                        for _, p in pairs(Player.Character:GetDescendants())do
                            if p:IsA('BasePart') and p.CanCollide then
                                p.CanCollide = false
                            end
                        end
                    end
                end)

                KenHubLib:Notify('Noclip', 'Walk through walls enabled.', 2, false)
            else
                if _G.MM2_Noclip_Conn then
                    _G.MM2_Noclip_Conn:Disconnect()
                end

                KenHubLib:Notify('Noclip', 'Collisions restored.', 2, false)
            end
        end)

        local MM2FlySpeed = 50

        MM2Movement:NewPremiumToggle('Realistic Player Fly', 'Fly freely with WASD + Space/Shift. Toggle to land.', function(v)
            local root = Player.Character and Player.Character:FindFirstChild('HumanoidRootPart')
            local hum = Player.Character and Player.Character:FindFirstChild('Humanoid')

            if not root then
                return
            end
            if v then
                local bv = Instance.new('BodyVelocity')

                bv.Name = 'MM2FlyBV'
                bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                bv.Velocity = Vector3.zero
                bv.Parent = root

                local bg = Instance.new('BodyGyro')

                bg.Name = 'MM2FlyBG'
                bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
                bg.CFrame = root.CFrame
                bg.Parent = root

                if hum then
                    hum.PlatformStand = true
                end

                task.spawn(function()
                    local UIS = game:GetService('UserInputService')

                    while v and Player.Character and Player.Character:FindFirstChild('HumanoidRootPart') do
                        local dir = Vector3.zero
                        local cam = workspace.CurrentCamera

                        if UIS:IsKeyDown(Enum.KeyCode.W) then
                            dir = dir + cam.CFrame.LookVector
                        end
                        if UIS:IsKeyDown(Enum.KeyCode.S) then
                            dir = dir - cam.CFrame.LookVector
                        end
                        if UIS:IsKeyDown(Enum.KeyCode.A) then
                            dir = dir - cam.CFrame.RightVector
                        end
                        if UIS:IsKeyDown(Enum.KeyCode.D) then
                            dir = dir + cam.CFrame.RightVector
                        end
                        if UIS:IsKeyDown(Enum.KeyCode.Space) then
                            dir = dir + Vector3.new(0, 1, 0)
                        end
                        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
                            dir = dir - Vector3.new(0, 1, 0)
                        end
                        if dir.Magnitude > 0 then
                            bv.Velocity = dir.Unit * MM2FlySpeed
                        else
                            bv.Velocity = Vector3.new(0, math.sin(tick() * 3) * 1.5, 0)
                        end

                        local look = cam.CFrame.LookVector

                        bg.CFrame = CFrame.new(root.Position, root.Position + Vector3.new(look.X, 0, look.Z))

                        if hum then
                            hum.PlatformStand = true

                            for _, t in pairs(hum:GetPlayingAnimationTracks())do
                                t:Stop()
                            end
                        end

                        task.wait()
                    end

                    pcall(function()
                        bv:Destroy()
                    end)
                    pcall(function()
                        bg:Destroy()
                    end)

                    if hum then
                        hum.PlatformStand = false
                    end
                end)
            else
                if hum then
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                end

                pcall(function()
                    root:FindFirstChild('MM2FlyBV'):Destroy()
                end)
                pcall(function()
                    root:FindFirstChild('MM2FlyBG'):Destroy()
                end)
            end
        end)
        MM2Movement:NewPremiumSlider('Fly Speed', 'Speed of player fly (studs/s)', 200, 10, function(v)
            MM2FlySpeed = v
        end)
        MM2Notify:NewToggle('Notify When Sheriff Dies (Gun Drop)', 'Shows a pop-up when the gun hits the ground', function(v)
            MM2Flags.NotifyGun = v

            if v then
                if _G.MM2_GunDrop_Conn then
                    _G.MM2_GunDrop_Conn:Disconnect()
                end

                _G.MM2_GunDrop_Conn = workspace.DescendantAdded:Connect(function(d)
                    if d.Name == 'GunDrop' and MM2Flags.NotifyGun then
                        KenHubLib:Notify('SHERIFF DIED!', 'The gun dropped! Go grab it from Combat tab.', 8, true)
                    end
                end)
            else
                if _G.MM2_GunDrop_Conn then
                    _G.MM2_GunDrop_Conn:Disconnect()
                end
            end
        end)
        MM2Teleport:NewButton('Teleport to Lobby', 'Teleport back to the lobby area', function()
            if Player.Character and Player.Character:FindFirstChild('HumanoidRootPart') then
                Player.Character.HumanoidRootPart.CFrame = CFrame.new(-109.5, 138, 38)

                KenHubLib:Notify('Teleported', 'Returned to Lobby.', 2, false)
            end
        end)
        MM2Teleport:NewButton('Copy Discord', 'Copies the KenHub discord link', function()
            pcall(function()
                if setclipboard then
                    setclipboard('https://discord.gg/getsnowy')
                end
            end)
            KenHubLib:Notify('Discord', 'discord.gg/getsnowy copied!', 3, false)
        end)
        MM2Teleport:NewLabel('Integrated by KenHub')
    end
end