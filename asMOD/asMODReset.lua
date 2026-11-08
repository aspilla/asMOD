local _, ns = ...;

function ns.show_resetpopup()
    if StaticPopupDialogs["asMOD_Reload"] then
        StaticPopup_Show("asMOD_Reload")
    end
end

local function init_resetpopup()
    if not StaticPopupDialogs["asMOD_Reload"] then
        if GetLocale() == "koKR" then
            StaticPopupDialogs["asMOD_Reload"] = {
                text = "애드온 재실행이 필요 합니다.",
                button1 = "재실행",
                button2 = "나중에",
                OnAccept = function()
                    ReloadUI();
                end,
                OnCancel = function(_, reason)
                end,
                timeout = 0,
                whileDead = true,
                hideOnEscape = true,
                enterClicksFirstButton = true,
            }
        else
            StaticPopupDialogs["asMOD_Reload"] = {
                text = "Addon reload is required.",
                button1 = "Reload",
                button2 = "Later",
                OnAccept = function()
                    ReloadUI();
                end,
                OnCancel = function(_, reason)
                end,
                timeout = 0,
                whileDead = true,
                hideOnEscape = true,
                enterClicksFirstButton = true,
            }
        end
    end
end

init_resetpopup();
