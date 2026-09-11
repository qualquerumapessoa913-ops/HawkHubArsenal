-- ============================================================
-- HAWK HUB ARSENAL – LOADER (jsDelivr + cache-bust)
-- ============================================================

-- jsDelivr atualiza em segundos, raw.githubusercontent tem cache de 5 min
local BASE = "https://cdn.jsdelivr.net/gh/qualquerumapessoa913-ops/HawkHubArsenal@main/"
local CACHE_BUST = "?v=" .. tostring(tick())

getgenv().HAWK_MODULES = {}
local M = getgenv().HAWK_MODULES

local moduleFiles = {
    ["helpers"]   = "src/utils/helpers.lua",
    ["ui"]        = "src/ui/init.lua",
    ["aimbot"]    = "src/features/aimbot.lua",
    ["hitbox"]    = "src/features/hitbox.lua",
    ["esp"]       = "src/features/esp.lua",
    ["autokill"]  = "src/features/autokill.lua",
    ["gunmods"]   = "src/features/gunmods.lua",
    ["backstab"]  = "src/features/backstab.lua",
}

print("[Hawk Hub] Baixando módulos (via jsDelivr)...")

for name, path in pairs(moduleFiles) do
    local url = BASE .. path .. CACHE_BUST
    local ok, code = pcall(function()
        return game:HttpGet(url)
    end)

    if ok and code and #code > 0 then
        local fn, err = loadstring(code)
        if fn then
            local success, result = pcall(fn)
            if success then
                M[name] = result
                print("  ✅ " .. name)
            else
                warn("  ❌ Erro ao executar " .. name .. ": " .. tostring(result))
            end
        else
            warn("  ❌ Erro de sintaxe em " .. name .. ": " .. tostring(err))
        end
    else
        warn("  ❌ Falha no download: " .. name)
    end
end

-- Verifica se todos os módulos essenciais foram carregados
if not M.ui or not M.aimbot then
    warn("[Hawk Hub] ❌ Módulos essenciais não carregaram. Abortando.")
    return
end

print("[Hawk Hub] Carregando main.lua...")

local mainCode = game:HttpGet(BASE .. "src/main.lua" .. CACHE_BUST)

-- Substitui require() pela tabela global
mainCode = mainCode:gsub("require%s*%(script%.Parent%.ui%)", "HAWK_MODULES.ui")
mainCode = mainCode:gsub("require%s*%(script%.Parent%.utils%.helpers%)", "HAWK_MODULES.helpers")
mainCode = mainCode:gsub("require%s*%(script%.Parent%.features%.aimbot%)", "HAWK_MODULES.aimbot")
mainCode = mainCode:gsub("require%s*%(script%.Parent%.features%.hitbox%)", "HAWK_MODULES.hitbox")
mainCode = mainCode:gsub("require%s*%(script%.Parent%.features%.esp%)", "HAWK_MODULES.esp")
mainCode = mainCode:gsub("require%s*%(script%.Parent%.features%.autokill%)", "HAWK_MODULES.autokill")
mainCode = mainCode:gsub("require%s*%(script%.Parent%.features%.gunmods%)", "HAWK_MODULES.gunmods")
mainCode = mainCode:gsub("require%s*%(script%.Parent%.features%.backstab%)", "HAWK_MODULES.backstab")

local mainFn, mainErr = loadstring(mainCode)
if mainFn then
    local ok, err = pcall(mainFn)
    if ok then
        print("[Hawk Hub] ✅ Arsenal Edition carregado!")
    else
        warn("[Hawk Hub] ❌ Erro no main: " .. tostring(err))
    end
else
    warn("[Hawk Hub] ❌ Erro de sintaxe no main: " .. tostring(mainErr))
end