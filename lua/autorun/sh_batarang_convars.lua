if engine.ActiveGamemode() ~= "terrortown" then return end
-- convars added with default values
CreateConVar("ttt_batarang_primary_sound", "1", {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Sound of the primary attack")
CreateConVar("ttt_batarang_hit_sound", "1", {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Sound of the hit")
CreateConVar("ttt_batarang_automaticFire", "0", {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Enable automatic fire")
CreateConVar("ttt_batarang_damage", "150", {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Damage dealt on impact")
CreateConVar("ttt_batarang_ammo", "3", {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Default ammo the batarang has when bought")
CreateConVar("ttt_batarang_clipSize", "3", {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Clipsize of the batarang")
CreateConVar("ttt_batarang_rps", "0.4", {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Shots per second")
hook.Add("TTTUlxInitCustomCVar", "TTTBatarangInitRWCVar", function(name)
    ULib.replicatedWritableCvar("ttt_batarang_primary_sound", "rep_ttt_batarang_primary_sound", GetConVar("ttt_batarang_primary_sound"):GetBool(), true, false, name)
    ULib.replicatedWritableCvar("ttt_batarang_hit_sound", "rep_ttt_batarang_hit_sound", GetConVar("ttt_batarang_hit_sound"):GetBool(), true, false, name)
    ULib.replicatedWritableCvar("ttt_batarang_automaticFire", "rep_ttt_batarang_automaticFire", GetConVar("ttt_batarang_automaticFire"):GetBool(), true, false, name)
    ULib.replicatedWritableCvar("ttt_batarang_damage", "rep_ttt_batarang_damage", GetConVar("ttt_batarang_damage"):GetInt(), true, false, name)
    ULib.replicatedWritableCvar("ttt_batarang_ammo", "rep_ttt_batarang_ammo", GetConVar("ttt_batarang_ammo"):GetInt(), true, false, name)
    ULib.replicatedWritableCvar("ttt_batarang_clipSize", "rep_ttt_batarang_clipSize", GetConVar("ttt_batarang_clipSize"):GetInt(), true, false, name)
    ULib.replicatedWritableCvar("ttt_batarang_rps", "rep_ttt_batarang_rps", GetConVar("ttt_batarang_rps"):GetFloat(), true, false, name)
end)

if CLIENT then
    -- Use string or string.format("%.f",<steamid64>) 
    -- addon dev emblem in scoreboard
    hook.Add("TTT2FinishedLoading", "TTT2RegistermexikoediAddonDev", function() AddTTT2AddonDev("76561198279816989") end)
    hook.Add("TTTUlxModifyAddonSettings", "TTTBatarangModifySettings", function(name)
        local tttrspnl = xlib.makelistlayout{
            w = 415,
            h = 318,
            parent = xgui.null
        }

        -- General Settings
        local tttrsclp1 = vgui.Create("DCollapsibleCategory", tttrspnl)
        tttrsclp1:SetSize(390, 180)
        tttrsclp1:SetExpanded(1)
        tttrsclp1:SetLabel("General Settings")
        local tttrslst1 = vgui.Create("DPanelList", tttrsclp1)
        tttrslst1:SetPos(5, 25)
        tttrslst1:SetSize(390, 180)
        tttrslst1:SetSpacing(5)
        tttrslst1:AddItem(xlib.makecheckbox{
            label = "ttt_batarang_primary_sound (Def. 1)",
            repconvar = "rep_ttt_batarang_primary_sound",
            parent = tttrslst1
        })

        tttrslst1:AddItem(xlib.makecheckbox{
            label = "ttt_batarang_hit_sound (Def. 1)",
            repconvar = "rep_ttt_batarang_hit_sound",
            parent = tttrslst1
        })

        tttrslst1:AddItem(xlib.makecheckbox{
            label = "ttt_batarang_automaticFire (Def. 0)",
            repconvar = "rep_ttt_batarang_automaticFire",
            parent = tttrslst1
        })

        tttrslst1:AddItem(xlib.makeslider{
            label = "ttt_batarang_damage (Def. 150)",
            repconvar = "rep_ttt_batarang_damage",
            min = 0,
            max = 200,
            decimal = 0,
            parent = tttrslst1
        })

        tttrslst1:AddItem(xlib.makeslider{
            label = "ttt_batarang_ammo (Def. 3)",
            repconvar = "rep_ttt_batarang_ammo",
            min = 0,
            max = 10,
            decimal = 0,
            parent = tttrslst1
        })

        tttrslst1:AddItem(xlib.makeslider{
            label = "ttt_batarang_clipSize (Def. 3)",
            repconvar = "rep_ttt_batarang_clipSize",
            min = 0,
            max = 10,
            decimal = 0,
            parent = tttrslst1
        })

        tttrslst1:AddItem(xlib.makeslider{
            label = "ttt_batarang_rps (Def. 0.4)",
            repconvar = "rep_ttt_batarang_rps",
            min = 0,
            max = 10,
            decimal = 1,
            parent = tttrslst1
        })

        -- add to ULX
        xgui.hookEvent("onProcessModules", nil, tttrspnl.processModules)
        xgui.addSubModule("Batarang", tttrspnl, nil, name)
    end)
end