-- ============================================================
-- HAWK HUB ARSENAL – LOADER
-- Baixa todos os módulos do GitHub e executa
-- ============================================================

local BASE = "https://raw.githubusercontent.com/qualquerumapessoa913-ops/HawkHubArsenal/main/"

-- Cria tabela global de módulos
getgenv().HAWK_MODULES = {}
local M = getgenv().HAWK_MODULES

-- Lista de módulos para baixar
local moduleFiles = {
    ["ui"]        = "src/ui/init.lua",
    ["helpers"]   = "src/utils/helpers.lua",
    ["aimbot"]    = "src/features/aimbot.lua",
    ["silentaim"] = "src/features/silentaim.lua",
    ["hitbox"]    = "src/features/hitbox.lua",
    ["esp"]       = "src/features/esp.lua",
    ["autokill"]  = "src/features/autokill.lua",
    ["gunmods"]   = "src/features/gunmods.lua",
    ["backstab"]  = "src/features/backstab.lua",
}

print("[Hawk Hub] Baixando módulos...")

for name, path in pairs(moduleFiles) do
    local ok, code = pcall(game.HttpGet, game, BASE .. path)
    if ok and code then
        local fn = loadstring(code)
        if fn then
            local success, result = pcall(fn)
            if success then
                M[name] = result
                print("  ✅ " .. name)
            else
                warn("  ❌ Erro em " .. name .. ": " .. tostring(result))
            end
        else
            warn("  ❌ Falha no loadstring: " .. name)
        end
    else
        warn("  ❌ Falha no download: " .. name)
    end
end

print("[Hawk Hub] Carregando main.lua...")

-- Baixa main.lua
local mainCode = game:HttpGet(BASE .. "src/main.lua")

-- Substitui os require(script.Parent.xxx) por acesso direto à tabela
mainCode = mainCode:gsub("require%s*%(script%.Parent%.ui%)", "HAWK_MODULES.ui")
mainCode = mainCode:gsub("require%s*%(script%.Parent%.utils%.helpers%)", "HAWK_MODULES.helpers")
mainCode = mainCode:gsub("require%s*%(script%.Parent%.features%.aimbot%)", "HAWK_MODULES.aimbot")
mainCode = mainCode:gsub("require%s*%(script%.Parent%.features%.silentaim%)", "HAWK_MODULES.silentaim")
mainCode = mainCode:gsub("require%s*%(script%.Parent%.features%.hitbox%)", "HAWK_MODULES.hitbox")
mainCode = mainCode:gsub("require%s*%(script%.Parent%.features%.esp%)", "HAWK_MODULES.esp")
mainCode = mainCode:gsub("require%s*%(script%.Parent%.features%.autokill%)", "HAWK_MODULES.autokill")
mainCode = mainCode:gsub("require%s*%(script%.Parent%.features%.gunmods%)", "HAWK_MODULES.gunmods")
mainCode = mainCode:gsub("require%s*%(script%.Parent%.features%.backstab%)", "HAWK_MODULES.backstab")

-- Executa
local mainFn = loadstring(mainCode)
if mainFn then
    mainFn()
else
    warn("[Hawk Hub] ❌ Falha ao compilar main.lua")
end

print("[Hawk Hub] ✅ Arsenal Edition carregado com sucesso!")