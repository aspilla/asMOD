local _, ns = ...; -- ns will be the addon's namespace, specific to asFixCombatText if loaded as a separate addon.
                   -- If part of a larger addon (like asMOD), ns might be that addon's namespace.
                   -- For simplicity, we'll assume a local namespace for now.

-- If this file is meant to be loaded by asMOD, 'ns' might already be defined by asMOD.
-- If it's a standalone addon, 'ns' needs to be this addon's table.
-- Let's create a local table if ns is not passed, or use the passed one.
ns = ns or {}
_G["asFixCombatText"] = ns -- Make it globally accessible for other parts of the addon if needed under this name

ns.Options_Default = {
    Version = 240725, -- Version of the options structure

    -- Position and Size related defaults
    Position = {
        point = "CENTER",
        relativePoint = "CENTER",
        parent = "UIParent",
        xOfs = -250, -- Default X from original ASCT_X_POSITION
        yOfs = 550,  -- Default Y from original ASCT_Y_POSITION
    },
    Height = 30, -- Default height for the anchor / scroll area consideration
    ScrollDistance = 200, -- Default for ASCT_Y_POSITION_ADDER

    -- Behavior related defaults
    Staggered = false, -- Default for ASCT_STAGGERED
    ShowHeal = nil,    -- Default for ASCT_DEFAULT_SHOW_HEAL (nil means use game default, 1 to force show)

    -- Toggle for showing the anchor frame (useful for users not using asMOD's /asConfig)
    ShowAnchor = false,
};

-- Initialize current options
-- ASCT_FixCombatText_SavedVars will be the global table where WoW saves variables for this addon.
-- We check if it exists; if not, we're using defaults.
if _G["ASCT_FixCombatText_SavedVars"] == nil or _G["ASCT_FixCombatText_SavedVars"].Version ~= ns.Options_Default.Version then
    _G["ASCT_FixCombatText_SavedVars"] = CopyTable(ns.Options_Default);
else
    -- If versions match, ensure all new default keys are present in the saved vars
    -- This handles cases where new options are added in an update.
    for key, value in pairs(ns.Options_Default) do
        if _G["ASCT_FixCombatText_SavedVars"][key] == nil then
            if type(value) == "table" then
                _G["ASCT_FixCombatText_SavedVars"][key] = CopyTable(value);
            else
                _G["ASCT_FixCombatText_SavedVars"][key] = value;
            end
        -- Also handle nested tables like Position for new keys
        elseif type(value) == "table" and type(_G["ASCT_FixCombatText_SavedVars"][key]) == "table" then
            for subKey, subValue in pairs(value) do
                if _G["ASCT_FixCombatText_SavedVars"][key][subKey] == nil then
                     _G["ASCT_FixCombatText_SavedVars"][key][subKey] = subValue;
                end
            end
        end
    end
     _G["ASCT_FixCombatText_SavedVars"].Version = ns.Options_Default.Version; -- Update version in saved vars
end

-- ns.options will be the runtime copy of the settings.
ns.options = _G["ASCT_FixCombatText_SavedVars"];

--[[
-- Example of how to create an options panel if this were a standalone addon with LibDataBroker or similar.
-- For now, we're focusing on asMOD integration and direct variable saving.
-- If a full options panel is needed later, similar to asDBMCastingAlert, this would be expanded.

function ns.SetupOptionPanels()
    -- This function would be called to create the UI for changing options,
    -- for example, in the Interface Options > AddOns panel.
    -- It would register CVars or use a settings library.
    -- For now, positions are handled by dragging the anchor or by asMOD.
    -- Other settings like Staggered, ShowHeal could be added here.

    -- Placeholder for where you might create UI elements for options:
    -- print("asFixCombatText: SetupOptionPanels called. (Currently a placeholder)")

    -- Example: Create a checkbox for "Show Anchor"
    -- This would typically use WoW's settings API or an options panel library.
    -- local category = Settings.RegisterVerticalLayoutCategory("asFixCombatTextPanel", "asFixCombatText")
    -- local setting = Settings.RegisterAddOnSetting(category, "ASFT_ShowAnchor", "ShowAnchor", ns.options, "boolean", "Show Position Anchor", ns.Options_Default.ShowAnchor)
    -- Settings.CreateCheckbox(category, setting, nil, "Toggles the visibility of the draggable combat text anchor.")
    -- Settings.SetOnValueChangedCallback("ASFT_ShowAnchor", function(_, _, value)
    --     ns.options.ShowAnchor = value
    --     if _G.asFixCombatTextFrame then
    --         if ns.options.ShowAnchor then
    --             _G.asFixCombatTextFrame:Show()
    --         else
    --             -- Hide only if not in asMOD config mode
    --             if not (_G["asMOD_ConfigModeActive"] and _G["asMOD_ConfigModeActive"]["asFixCombatText"]) then
    --                _G.asFixCombatTextFrame:Hide()
    --             end
    --         end
    --     end
    -- end)
    -- Settings.RegisterAddOnCategory(category)
end

-- Add a slash command to toggle the anchor visibility if not using asMOD
SLASH_ASFIXCOMBATTEXTANCHOR1 = "/asfctanchor"
SlashCmdList["ASFIXCOMBATTEXTANCHOR"] = function()
    ns.options.ShowAnchor = not ns.options.ShowAnchor
    if _G.asFixCombatTextFrame then
        if ns.options.ShowAnchor then
            _G.asFixCombatTextFrame:Show()
            print("asFixCombatText Anchor: Shown")
        else
            _G.asFixCombatTextFrame:Hide()
            print("asFixCombatText Anchor: Hidden")
        end
    end
end
--]]

-- Make sure the main addon file can access these options via ns.options
-- e.g., local currentX = ns.options.Position.xOfs
--       local scrollDist = ns.options.ScrollDistance

-- The actual saving of ASCT_FixCombatText_SavedVars is handled by WoW automatically at logout/reload
-- when it's a global variable associated with the addon.
-- The main .lua file will need to ensure ASCT_FixCombatText_SavedVars is its SavedVariables table in the .toc.
