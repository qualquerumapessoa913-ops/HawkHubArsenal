-- TEST HAWK ARSENAL - LOADER
-- Este loader baixa e executa o main.lua e todos os seus módulos.

local BASE_URL = "https://raw.githubusercontent.com/qualquerumapessoa913-ops/HawkHubArsenal/main/"

-- Função para carregar um módulo
local function loadModule(path)
    local url = BASE_URL .. path
    local source = game:HttpGet(url)
    local fn = loadstring(source)
    return fn()
end

-- Carrega a UI
local UI = loadModule("src/ui/init.lua")

-- Carrega os módulos de features
local Aimbot = loadModule("src/features/aimbot.lua")
local SilentAim = loadModule("src/features/silentaim.lua")
local Hitbox = loadModule("src/features/hitbox.lua")
local ESP = loadModule("src/features/esp.lua")
local AutoKill = loadModule("src/features/autokill.lua")
local GunMods = loadModule("src/features/gunmods.lua")
local Backstab = loadModule("src/features/backstab.lua")

-- Inicia as features
Aimbot:start()
SilentAim:start()
Hitbox:start()
ESP:start()
AutoKill:start()
GunMods:start()
Backstab:start()

-- Cria a Interface (o código da Main é executado aqui)
local Main = loadModule("src/main.lua")