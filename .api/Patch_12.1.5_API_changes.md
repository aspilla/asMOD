# Patch 12.1.5/API changes
========================

**This article documents [API changes](https://warcraft.wiki.gg/wiki/API_change_summaries "API change summaries") made in [Patch 12.1.5](https://warcraft.wiki.gg/wiki/Patch_12.1.5 "Patch 12.1.5").**

*   Previous patch: [Patch 12.1.0](https://warcraft.wiki.gg/wiki/Patch_12.1.0/API_changes "Patch 12.1.0/API changes").
*   Next patch: [Patch 12.1.7](https://warcraft.wiki.gg/wiki/Patch_12.1.7/API_changes "Patch 12.1.7/API changes").

Contents
--------

*   [1 Resources](https://warcraft.wiki.gg/wiki/Patch_12.1.5/API_changes#Resources)
*   [2 Blue posts](https://warcraft.wiki.gg/wiki/Patch_12.1.5/API_changes#Blue_posts)
    *   [2.1 2026-09-03](https://warcraft.wiki.gg/wiki/Patch_12.1.5/API_changes#2026-09-03)
    *   [2.2 2026-09-16](https://warcraft.wiki.gg/wiki/Patch_12.1.5/API_changes#2026-09-16)
    *   [2.3 2026-09-22](https://warcraft.wiki.gg/wiki/Patch_12.1.5/API_changes#2026-09-22)
    *   [2.4 2026-09-29](https://warcraft.wiki.gg/wiki/Patch_12.1.5/API_changes#2026-09-29)
*   [3 Consolidated changes](https://warcraft.wiki.gg/wiki/Patch_12.1.5/API_changes#Consolidated_changes)
    *   [3.1 Global API](https://warcraft.wiki.gg/wiki/Patch_12.1.5/API_changes#Global_API)
    *   [3.2 FrameXML](https://warcraft.wiki.gg/wiki/Patch_12.1.5/API_changes#FrameXML)
    *   [3.3 ScriptObjects](https://warcraft.wiki.gg/wiki/Patch_12.1.5/API_changes#ScriptObjects)
    *   [3.4 Widgets](https://warcraft.wiki.gg/wiki/Patch_12.1.5/API_changes#Widgets)
    *   [3.5 Events](https://warcraft.wiki.gg/wiki/Patch_12.1.5/API_changes#Events)
    *   [3.6 CVars](https://warcraft.wiki.gg/wiki/Patch_12.1.5/API_changes#CVars)
*   [4 Deprecated API](https://warcraft.wiki.gg/wiki/Patch_12.1.5/API_changes#Deprecated_API)

Resources
---------

*   TOC: `120105`
*   Official API patch notes: [Midnight 12.1.5 PTR Changes](https://warcraft.wiki.gg/wiki/Patch_12.1.5/API_changes/notes "Patch 12.1.5/API changes/notes")
*   Official development notes: [Midnight: 12.1.5 PTR Development Notes](https://us.forums.blizzard.com/en/wow/t/midnight-1215-ptr-development-notes/2344395)
*   Diffs: [wow-ui-source](https://github.com/Gethe/wow-ui-source/compare/12.1.0..12.1.5), [BlizzardInterfaceResources](https://github.com/Ketho/BlizzardInterfaceResources/compare/12.1.0...12.1.5)

Blue posts
----------

🔽  **Hidden Section**

Please click the below header to expand the section.

Official patch notes

> DISCLAIMER: These notes are for addon authors and as such are focused specifically on addon-facing API and security changes only. Changes planned for other parts of the game (UI or otherwise) are not included here.

### 2026-09-03

[_Midnight 12.1.5 PTR Changes 1_](https://discord.com/channels/327414731654692866/1545113129736871966) (Build 69594)

Coming in 12.1.5 PTR 1

**Aura Pandemic Animations**  

*   [CustomAuraButton](https://warcraft.wiki.gg/wiki/INTRINSIC_AuraButton "INTRINSIC AuraButton") now supports Pandemic-triggered animations via new APIs.
    *   Three Pandemic triggers are supported: **Enter** and **Active** (both triggered when entering Pandemic), and **Leave** (triggered when leaving Pandemic).
        *   **Enter** is intended for one-shot animations, while Active is intended for looping animations.
    *   Each trigger type has a set of APIs for adding and removing individual animation groups, or clearing all animation groups for that trigger.
    *   Two new [forbidden aspects](https://warcraft.wiki.gg/wiki/Secret_Values#Forbidden_aspects "Secret Values") were added to support this:
        *   `QueryAnimationProgress`: prevents querying the progress of an animation or whether it is running.
        *   `AddAnimations`: prevents animations from being added or reparented.
    *   Animations used by Pandemic triggers also gain the existing `ChangeAnimationTarget` forbidden aspect.

local glow \= auraButton:CreateTexture(nil, "OVERLAY");
glow:SetColorTexture(1, 0, 0);
glow:SetAllPoints(auraButton);

local animGroup \= glow:CreateAnimationGroup();
animGroup:SetLooping("BOUNCE");

local animAlpha \= animGroup:CreateAnimation("Alpha");
animAlpha:SetFromAlpha(0);
animAlpha:SetToAlpha(1);
animAlpha:SetDuration(0.5);

auraButton:AddPandemicActiveAnimation(animGroup);

Copy

**Aura Containers**  

*   `CustomAuraButton` now supports showing the aura's caster in a fontstring via the new [SetCasterName](https://warcraft.wiki.gg/wiki/API:AuraButton_SetCasterName "API:AuraButton SetCasterName") API.
*   [AddDispelTypeTexture](https://warcraft.wiki.gg/wiki/API:AuraButton_AddDispelTypeTexture "API:AuraButton AddDispelTypeTexture") and [AddPandemicRegion](https://warcraft.wiki.gg/wiki/API:AuraButton_AddPandemicRegion "API:AuraButton AddPandemicRegion") no longer return an index. The corresponding [RemoveDispelTypeTexture](https://warcraft.wiki.gg/wiki/API:AuraButton_RemoveDispelTypeTexture "API:AuraButton RemoveDispelTypeTexture") and [RemovePandemicRegion](https://warcraft.wiki.gg/wiki/API:AuraButton_RemovePandemicRegion "API:AuraButton RemovePandemicRegion") APIs now take a region reference instead of an index.
*   `AddDispelTypeTexture` and `AddPandemicRegion` now raise an error if the same region is added multiple times.
*   Aura tooltips now support displaying the aura's caster, colorized by reaction or class color. This functionality is controlled by the new tooltipShowAuraCasterNamesCVar: tooltipShowAuraCasterNames (Game)  
    Default: `0`, Scope: Account  
    Show caster unit names in tooltips for unit auras. CVar.
*   New [CustomAuraContainer](https://warcraft.wiki.gg/wiki/INTRINSIC_AuraContainer "INTRINSIC AuraContainer") APIs allow individual items to be **disabled** via [SetAuraGroupEnabled](https://warcraft.wiki.gg/wiki/API:AuraContainer_SetAuraGroupEnabled "API:AuraContainer SetAuraGroupEnabled"), [SetAuraSlotEnabled](https://warcraft.wiki.gg/wiki/API:AuraContainer_SetAuraSlotEnabled "API:AuraContainer SetAuraSlotEnabled"), and [SetItemEnchantmentEnabled](https://warcraft.wiki.gg/wiki/API:AuraContainer_SetItemEnchantmentEnabled "API:AuraContainer SetItemEnchantmentEnabled").
*   `CustomAuraButton` now supports a `minApplications` option in [SetApplicationBar](https://warcraft.wiki.gg/wiki/API:AuraButton_SetApplicationBar "API:AuraButton SetApplicationBar"), which prevents the application bar from being shown unless the number of applications exceeds the specified value.
*   A new [SetEditModePreviewEnabled](https://warcraft.wiki.gg/wiki/API:AuraContainer_SetEditModePreviewEnabled "API:AuraContainer SetEditModePreviewEnabled") API has been added to `CustomAuraContainer` to control whether preview auras are shown while the player is in Edit Mode.
*   `CustomAuraContainer` now correctly refreshes in response to [UNIT\_FLAGS](https://warcraft.wiki.gg/wiki/Event:UNIT_FLAGS "Event:UNIT FLAGS") and [UNIT\_FACTION](https://warcraft.wiki.gg/wiki/Event:UNIT_FACTION "Event:UNIT FACTION") events.

**AddOn Security**  

*   The [SetCooldown](https://warcraft.wiki.gg/wiki/API:Cooldown_SetCooldown "API:Cooldown SetCooldown") and [Clear](https://warcraft.wiki.gg/wiki/API:Cooldown_Clear "API:Cooldown Clear") cooldown APIs can no longer be called from tainted code when the cooldown frame itself is protected.
*   Castbar IDs are now **unique per unit token**, preventing addons from using them to compare units.
    *   **Note:** Unit token casing matters when querying castbar IDs; a [UnitCastingInfo](https://warcraft.wiki.gg/wiki/API:UnitCastingInfo "API:UnitCastingInfo") query for `"PLAYER"` returns a different castbar ID than one for `"player"`. Events always use **lowercase unit tokens**.

**Script Object APIs**  

*   A new [TimedSignalMap](https://warcraft.wiki.gg/wiki/ScriptObject_TimedSignalMap "ScriptObject TimedSignalMap") script object has been added for scheduling a **single callback** which is invoked with **user-defined keys** at specified times.
    *   Keys can be dynamically **rescheduled without requiring cancellation**, unlike timer objects, making `TimedSignalMap` useful as a lower-level scheduling primitive.
    *   The [CreateTimedSignalCallbackMap](https://www.townlong-yak.com/framexml/ptr/go/TimerUtil.CreateTimedSignalCallbackMap) API (in `TimerUtil`) is a convenience wrapper that generates keys and associates each key with a callback.
*   A new [CreateFrameWithOptions](https://warcraft.wiki.gg/wiki/API:CreateFrameWithOptions "API:CreateFrameWithOptions") API has been added, which takes a table with named options as its only parameter.
    *   The options currently supported mirror those accepted by [CreateFrame](https://warcraft.wiki.gg/wiki/API:CreateFrame "API:CreateFrame"): `frameType` (required), `name`, `parent`, `inherits` (as an _array_ of template names), `id`, and `hidden` (new; hides the frame by default).
*   Added a new `roundLayoutToNearestPixel` XML attribute and [SetRoundLayoutToNearestPixel](https://warcraft.wiki.gg/wiki/API:ScriptRegion_SetRoundLayoutToNearestPixel "API:ScriptRegion SetRoundLayoutToNearestPixel") API to all Regions. When enabled, layout changes are automatically **rounded to the nearest pixel**.
    *   These provide a **native-code replacement** for the Lua `PixelUtil` functions; [PixelUtil.SetRoundLayoutToNearestPixelRecursively](https://www.townlong-yak.com/framexml/ptr/go/PixelUtil.SetRoundLayoutToNearestPixelRecursively) can be used to apply the setting to a region and all its children.

**Lua Utility Functions**  

*   A suite of math, string, and table utility functions has been added. Some were previously implemented in Lua and have now been moved to native code; aliases for the existing names have been retained to prevent addon breakage.
    *   Math functions: [math.clamp](https://warcraft.wiki.gg/wiki/API:math.clamp "API:math.clamp"), [math.saturate](https://warcraft.wiki.gg/wiki/API:math.saturate "API:math.saturate"), [math.round](https://warcraft.wiki.gg/wiki/API:math.round "API:math.round"), [math.lerp](https://warcraft.wiki.gg/wiki/API:math.lerp "API:math.lerp"), [math.normalize](https://warcraft.wiki.gg/wiki/API:math.normalize "API:math.normalize"), [math.sign](https://warcraft.wiki.gg/wiki/API:math.sign "API:math.sign"), [math.remap](https://warcraft.wiki.gg/wiki/API:math.remap "API:math.remap"), [math.wrap](https://warcraft.wiki.gg/wiki/API:math.wrap "API:math.wrap"), [math.isfinite](https://warcraft.wiki.gg/wiki/API:math.isfinite "API:math.isfinite"), [math.isnan](https://warcraft.wiki.gg/wiki/API:math.isnan "API:math.isnan"), and [math.isinf](https://warcraft.wiki.gg/wiki/API:math.isinf "API:math.isinf").
    *   String functions: [string.contains](https://warcraft.wiki.gg/wiki/API:string.contains "API:string.contains"), [string.ltrim](https://warcraft.wiki.gg/wiki/API:string.ltrim "API:string.ltrim"), [string.rtrim](https://warcraft.wiki.gg/wiki/API:string.rtrim "API:string.rtrim"), [string.startswith](https://warcraft.wiki.gg/wiki/API:string.startswith "API:string.startswith"), and [string.endswith](https://warcraft.wiki.gg/wiki/API:string.endswith "API:string.endswith").
    *   Table functions: [table.isempty](https://warcraft.wiki.gg/wiki/API:table.isempty "API:table.isempty"), [table.contains](https://warcraft.wiki.gg/wiki/API:table.contains "API:table.contains"), [table.indexof](https://warcraft.wiki.gg/wiki/API:table.indexof "API:table.indexof"), [table.removeunordered](https://warcraft.wiki.gg/wiki/API:table.removeunordered "API:table.removeunordered"), [table.removevalue](https://warcraft.wiki.gg/wiki/API:table.removevalue "API:table.removevalue"), [table.keys](https://warcraft.wiki.gg/wiki/API:table.keys "API:table.keys"), and [table.values](https://warcraft.wiki.gg/wiki/API:table.values "API:table.values").

**Deprecations**  

*   The following deprecated addons have been removed. Update your code to no longer use the deprecated APIs they contained:
    *   [Blizzard\_DeprecatedCurrencyScript](https://github.com/Gethe/wow-ui-source/blob/12.1.0/Interface/AddOns/Blizzard_DeprecatedCurrencyScript/Deprecated_CurrencyScript.lua)
    *   [Blizzard\_DeprecatedGlue](https://github.com/Gethe/wow-ui-source/blob/12.1.0/Interface/AddOns/Blizzard_DeprecatedGlue/Deprecated_Glue.lua)
    *   [Blizzard\_DeprecatedItemScript](https://github.com/Gethe/wow-ui-source/blob/12.1.0/Interface/AddOns/Blizzard_DeprecatedItemScript/Deprecated_ItemScript.lua)
    *   [Blizzard\_DeprecatedItemSocketInfo](https://github.com/Gethe/wow-ui-source/blob/12.1.0/Interface/AddOns/Blizzard_DeprecatedItemSocketInfo/Deprecated_ItemSocketInfo.lua)
    *   [Blizzard\_DeprecatedLFG](https://github.com/Gethe/wow-ui-source/blob/12.1.0/Interface/AddOns/Blizzard_DeprecatedLFG/Deprecated_LFG.lua)
    *   [Blizzard\_DeprecatedPetInfo](https://github.com/Gethe/wow-ui-source/blob/12.1.0/Interface/AddOns/Blizzard_DeprecatedPetInfo/Deprecated_PetInfo.lua)
    *   [Blizzard\_DeprecatedPvpScript](https://github.com/Gethe/wow-ui-source/blob/12.1.0/Interface/AddOns/Blizzard_DeprecatedPvpScript/Deprecated_PvpScript.lua)
    *   [Blizzard\_DeprecatedSoundScript](https://github.com/Gethe/wow-ui-source/blob/12.1.0/Interface/AddOns/Blizzard_DeprecatedSoundScript/Deprecated_SoundScript.lua)
    *   [Blizzard\_DeprecatedTradeInfo](https://github.com/Gethe/wow-ui-source/blob/12.1.0/Interface/AddOns/Blizzard_DeprecatedTradeInfo/Deprecated_TradeInfo.lua)
    *   [Blizzard\_DeprecatedWorldElapsedTimerTypes](https://github.com/Gethe/wow-ui-source/blob/12.1.0/Interface/AddOns/Blizzard_DeprecatedWorldElapsedTimerTypes/Deprecated_WorldElapsedTimerTypes.lua)

**Miscellaneous**  

*   A new [C\_Weather](https://warcraft.wiki.gg/wiki/Category:API_systems/WeatherScript "Category:API systems/WeatherScript") namespace blows in, providing access to current weather conditions and an event when they change.
*   A new [C\_Intl](https://warcraft.wiki.gg/wiki/Category:API_systems/Intl "Category:API systems/Intl") namespace provides functions for working with Unicode and internationalization.
*   The spell ID line shown in spell tooltips via the tooltipShowAuraSpellIDsCVar: tooltipShowAuraSpellIDs (Game)  
    Default: `0`  
    Show spell IDs in tooltips for unit auras. CVar is now correctly localized, and no longer uses the same color as spell description text.
*   Mythic+ enemy forces lines in tooltips now use a distinct line type: `Enum.TooltipDataLineType.UnitCriteriaProgress`.
*   Pinging a macro containing a `#showtooltip` line now pings the corresponding spell.
*   Fixed an issue that could prevent duration objects from rendering for long-duration auras in some cases.
*   Fixed a performance issue with the [EnumerateFrames](https://warcraft.wiki.gg/wiki/API:EnumerateFrames "API:EnumerateFrames") API.
*   Fixed an issue where calling [Hide](https://warcraft.wiki.gg/wiki/API:Frame_Hide "API:Frame Hide") directly on a panel, rather than [HideUIPanel](https://www.townlong-yak.com/framexml/ptr/go/HideUIPanel), could prevent the Game Menu from being shown.

* * *

  

### 2026-09-16

[_Midnight 12.1.5 PTR Changes 2_](https://discord.com/channels/327414731654692866/1549542072816635984) (Build 69848)

Coming in 12.1.5 PTR 2

**Aura Containers**  

*   Fixed an issue where using `includeSpellIDs` to show only specific never-secret auras, such as Sated, could also allow unrelated auras through.
*   Fixed an issue where the `ProcessAura` policy did not correctly filter out auras that returned `ProcessAuraType.None`.
*   [CustomAuraButton](https://warcraft.wiki.gg/wiki/INTRINSIC_AuraButton "INTRINSIC AuraButton") now supports two additional animation triggers.
    *   **Shown** animations play the first time an aura becomes visible on the button, and stop when the aura is no longer shown, using [AddAuraShownAnimation](https://www.townlong-yak.com/framexml/ptr/go/CustomAuraButtonSharedMixin:AddAuraShownAnimation).
    *   **Assigned** animations play whenever a new aura is assigned to the button, independent of visibility, using [AddAuraAssignedAnimation](https://www.townlong-yak.com/framexml/ptr/go/CustomAuraButtonSharedMixin:AddAuraAssignedAnimation).
*   `CustomAuraButton` animations now apply [secret aspects](https://warcraft.wiki.gg/wiki/Secret_aspects "Secret aspects") for `VertexColor` and `TexCoords` to target objects.

**AddOn Security**  

*   The `sourceGUID` field returned by Damage Meter APIs is now secret when the unit's identity is secret.
*   Added a new [UnitFrameUtil](https://github.com/Gethe/wow-ui-source/blob/12.1.5/Interface/AddOns/Blizzard_UnitFrame/Shared/UnitFrameUtil.lua) Lua library, focused on providing addon-safe APIs for unit frame addons to set textures based on now-secret APIs.
    *   The first new API is [UpdateUnitPvPIndicator](https://github.com/Gethe/wow-ui-source/blob/12.1.5/Interface/AddOns/Blizzard_UnitFrame/Shared/UnitFrameUtil.lua#L145), with more APIs coming in future PTR builds.
*   [C\_Intl](https://warcraft.wiki.gg/wiki/C_Intl "C Intl") functions now accept **secret string arguments from tainted code**.
    *   The [C\_Intl.Transliterate](https://warcraft.wiki.gg/wiki/API:C_Intl.Transliterate "API:C Intl.Transliterate") API does not allow `Null` or `Remove` transliterators for secret text from tainted code.
*   The [C\_Intl.FindStringMatches](https://warcraft.wiki.gg/wiki/API:C_Intl.FindStringMatches "API:C Intl.FindStringMatches") and [C\_Intl.FindBreaks](https://warcraft.wiki.gg/wiki/API:C_Intl.FindBreaks "API:C Intl.FindBreaks") APIs now return **1-based indices**.
*   Fixed a bug where RaidWarning frames could retain secret aspects on their fontstrings after being returned to the pool.
*   Addons now get an **additional one-frame window** to adjust the hitbox of an enemy nameplate if a [UNIT\_CLASSIFICATION\_CHANGED](https://warcraft.wiki.gg/wiki/Event:UNIT_CLASSIFICATION_CHANGED "Event:UNIT CLASSIFICATION CHANGED") event arrives after the nameplate was already created.

**Miscellaneous**  

*   A new optional `throttleSeconds` parameter was added to the [C\_UnitAuras.AddAuraSound](https://warcraft.wiki.gg/wiki/API:C_UnitAuras.AddAuraSound "API:C UnitAuras.AddAuraSound") API, allowing addons to specify **how often the sound should be allowed to play**.
*   Fixed an issue that could cause some APIs, like tostring and dumpobject, to crash when passed secret objects.
*   Chat tabs no longer use [UIFrameFlash](https://www.townlong-yak.com/framexml/ptr/go/UIFrameFlash) for their flash animations, hopefully **reducing chat tab taint issues** caused by unrelated systems.
*   [C\_ClassColor.GetClassColor](https://warcraft.wiki.gg/wiki/API:C_ClassColor.GetClassColor "API:C ClassColor.GetClassColor") now accepts an **optional tint color**, which is multiplied by the class color before it is returned.
*   [GetPlayerInfoByGUID](https://warcraft.wiki.gg/wiki/API:GetPlayerInfoByGUID "API:GetPlayerInfoByGUID") now also returns the unit's level, if known.
*   The following CVars, removed in Midnight, have been restored: nameplateMotionSpeedCVar: nameplateMotionSpeed (Game)  
    Default: `0.025000`  
    Controls the rate at which nameplate animates into their target locations \[0.0-1.0\], nameplateBottomInsetCVar: nameplateBottomInset (Game)  
    Default: `0.100000`  
    The inset from the bottom (in screen percent) that nameplates are clamped to., and nameplateTopInsetCVar: nameplateTopInset (Game)  
    Default: `0.080000`  
    The inset from the top (in screen percent) that nameplates are clamped to..
*   [RadialProgress](https://warcraft.wiki.gg/wiki/UIOBJECT_RadialProgress "UIOBJECT RadialProgress") animations can now be created from XML.
*   Fixed a texture masking bug affecting frames using more than one mask texture with different wrap modes.
*   Fixed a bug that could cause the right-click unit menu to incorrectly show battle-pet options for a distant player. This is **pending a hotfix to 12.1.0** as well.

* * *

  

### 2026-09-22

[_Midnight 12.1.5 PTR Changes 3_](https://discord.com/channels/327414731654692866/1552068745374081104) (Build 69952)

Coming in 12.1.5 PTR 3

**Addon Security**  

*   The [GetArenaOpponentSpec](https://warcraft.wiki.gg/wiki/API:GetArenaOpponentSpec "API:GetArenaOpponentSpec") API now returns secrets.
*   `UnitFrameUtil` library introduced in the last PTR build has been expanded with APIs for raid role icons and arena opponent specs. It has also been moved to shared code, making it available in Classic.
    *   New APIs [GetArenaOpponentSpecDisplayInfo](https://github.com/Gethe/wow-ui-source/blob/12.1.5/Interface/AddOns/Blizzard_UnitFrame/Shared/UnitFrameUtil.lua#L343), [UpdateArenaOpponentSpecDisplay](https://github.com/Gethe/wow-ui-source/blob/12.1.5/Interface/AddOns/Blizzard_UnitFrame/Shared/UnitFrameUtil.lua#L357), and [UpdateArenaOpponentSpecDisplayName](https://github.com/Gethe/wow-ui-source/blob/12.1.5/Interface/AddOns/Blizzard_UnitFrame/Shared/UnitFrameUtil.lua#L406) give addons secret-safe access to an arena opponent's spec name, class name, spec icon, role icon, and class-color bar tint.
    *   New APIs [GetUnitRoleIconDisplayInfo](https://github.com/Gethe/wow-ui-source/blob/12.1.5/Interface/AddOns/Blizzard_UnitFrame/Shared/UnitFrameUtil.lua#L248) and [UpdateUnitFrameRoleIcon](https://github.com/Gethe/wow-ui-source/blob/12.1.5/Interface/AddOns/Blizzard_UnitFrame/Shared/UnitFrameUtil.lua#L262) let addons set up raid role icons (including vehicle and main tank/assist icons) for raid members even when their identities are secret.
    *   All `UnitFrameUtil` display APIs now accept an optional `textureMap` table so addons can override the default textures/atlases used.
*   Added [C\_UnitAuras.GetRefreshCarryOverDuration](https://warcraft.wiki.gg/wiki/API:C_UnitAuras.GetRefreshCarryOverDuration "API:C UnitAuras.GetRefreshCarryOverDuration"), a secret-aware API returning how much of an aura's remaining duration would carry over on refresh. [AuraContainerUtil.GetPandemicWindow](https://www.townlong-yak.com/framexml/ptr/go/AuraContainerUtil.GetPandemicWindow) now uses this internally, fixing incorrect pandemic-window timing for auras that can extend past the normal refresh cap (e.g.  ![](https://warcraft.wiki.gg/images/thumb/Inv_misc_herb_felblossom.png/16px-Inv_misc_herb_felblossom.png?b83774)[\[Lifebloom\]](https://warcraft.wiki.gg/wiki/Lifebloom) +  ![](https://warcraft.wiki.gg/images/thumb/Spell_nature_tranquility.png/16px-Spell_nature_tranquility.png?f85d20)[\[Tranquility\]](https://warcraft.wiki.gg/wiki/Tranquility)).

* * *

  

### 2026-09-29

[_Midnight 12.1.5 PTR Changes 4_](https://discord.com/channels/327414731654692866/1554549117261324472) (Build 70077)

Coming in 12.1.5 PTR 4

**Addon Security**  

*   [C\_UnitAuras.AddAuraSound](https://warcraft.wiki.gg/wiki/API:C_UnitAuras.AddAuraSound "API:C UnitAuras.AddAuraSound") now limits any sound it plays to 5 seconds and rejects throttleSeconds values greater than 5 seconds.

**Miscellaneous**  

*   [C\_Intl.GetSortKey](https://warcraft.wiki.gg/wiki/API:C_Intl.GetSortKey "API:C Intl.GetSortKey") no longer returns nil when passed an empty string and `Enum.CollationStrength.Primary`.

Consolidated changes
--------------------

12.1.0 (69587) → 12.1.5 (69952) Sep 21 2026

### Global API

Added (82)

Removed (4)

[C\_ActionBar.IsMacroActionWithShowTooltip](https://warcraft.wiki.gg/wiki/API:C_ActionBar.IsMacroActionWithShowTooltip "API:C ActionBar.IsMacroActionWithShowTooltip")

[C\_AuraContainerUtil.ProcessCustomAuraButtonCasterNameOptions](https://warcraft.wiki.gg/wiki/API:C_AuraContainerUtil.ProcessCustomAuraButtonCasterNameOptions "API:C AuraContainerUtil.ProcessCustomAuraButtonCasterNameOptions")

[C\_Intl.CompareStrings](https://warcraft.wiki.gg/wiki/API:C_Intl.CompareStrings "API:C Intl.CompareStrings")

[C\_Intl.CreateLocaleContext](https://warcraft.wiki.gg/wiki/API:C_Intl.CreateLocaleContext "API:C Intl.CreateLocaleContext")

[C\_Intl.FindBreaks](https://warcraft.wiki.gg/wiki/API:C_Intl.FindBreaks "API:C Intl.FindBreaks")

[C\_Intl.FindStringMatches](https://warcraft.wiki.gg/wiki/API:C_Intl.FindStringMatches "API:C Intl.FindStringMatches")

[C\_Intl.FoldCase](https://warcraft.wiki.gg/wiki/API:C_Intl.FoldCase "API:C Intl.FoldCase")

[C\_Intl.FormatCurrency](https://warcraft.wiki.gg/wiki/API:C_Intl.FormatCurrency "API:C Intl.FormatCurrency")

[C\_Intl.FormatDateTime](https://warcraft.wiki.gg/wiki/API:C_Intl.FormatDateTime "API:C Intl.FormatDateTime")

[C\_Intl.FormatDate](https://warcraft.wiki.gg/wiki/API:C_Intl.FormatDate "API:C Intl.FormatDate")

[C\_Intl.FormatNumber](https://warcraft.wiki.gg/wiki/API:C_Intl.FormatNumber "API:C Intl.FormatNumber")

[C\_Intl.FormatTime](https://warcraft.wiki.gg/wiki/API:C_Intl.FormatTime "API:C Intl.FormatTime")

[C\_Intl.GetCharacterProperties](https://warcraft.wiki.gg/wiki/API:C_Intl.GetCharacterProperties "API:C Intl.GetCharacterProperties")

[C\_Intl.GetCurrencyFractionDigits](https://warcraft.wiki.gg/wiki/API:C_Intl.GetCurrencyFractionDigits "API:C Intl.GetCurrencyFractionDigits")

[C\_Intl.GetCurrencyName](https://warcraft.wiki.gg/wiki/API:C_Intl.GetCurrencyName "API:C Intl.GetCurrencyName")

[C\_Intl.GetCurrentLocale](https://warcraft.wiki.gg/wiki/API:C_Intl.GetCurrentLocale "API:C Intl.GetCurrentLocale")

[C\_Intl.GetDisplayName](https://warcraft.wiki.gg/wiki/API:C_Intl.GetDisplayName "API:C Intl.GetDisplayName")

[C\_Intl.GetSortKey](https://warcraft.wiki.gg/wiki/API:C_Intl.GetSortKey "API:C Intl.GetSortKey")

[C\_Intl.IsNormalized](https://warcraft.wiki.gg/wiki/API:C_Intl.IsNormalized "API:C Intl.IsNormalized")

[C\_Intl.Length](https://warcraft.wiki.gg/wiki/API:C_Intl.Length "API:C Intl.Length")

[C\_Intl.Normalize](https://warcraft.wiki.gg/wiki/API:C_Intl.Normalize "API:C Intl.Normalize")

[C\_Intl.ParseCurrency](https://warcraft.wiki.gg/wiki/API:C_Intl.ParseCurrency "API:C Intl.ParseCurrency")

[C\_Intl.ParseNumber](https://warcraft.wiki.gg/wiki/API:C_Intl.ParseNumber "API:C Intl.ParseNumber")

[C\_Intl.SelectPlural](https://warcraft.wiki.gg/wiki/API:C_Intl.SelectPlural "API:C Intl.SelectPlural")

[C\_Intl.ToLower](https://warcraft.wiki.gg/wiki/API:C_Intl.ToLower "API:C Intl.ToLower")

[C\_Intl.ToTitle](https://warcraft.wiki.gg/wiki/API:C_Intl.ToTitle "API:C Intl.ToTitle")

[C\_Intl.ToUpper](https://warcraft.wiki.gg/wiki/API:C_Intl.ToUpper "API:C Intl.ToUpper")

[C\_Intl.TransformLocale](https://warcraft.wiki.gg/wiki/API:C_Intl.TransformLocale "API:C Intl.TransformLocale")

[C\_Intl.Transliterate](https://warcraft.wiki.gg/wiki/API:C_Intl.Transliterate "API:C Intl.Transliterate")

[C\_LFGInfo.GetActiveLFGDungeonName](https://warcraft.wiki.gg/wiki/API:C_LFGInfo.GetActiveLFGDungeonName "API:C LFGInfo.GetActiveLFGDungeonName")

[C\_PvP.GetRandomTrainingGroundArenaRewards](https://warcraft.wiki.gg/wiki/API:C_PvP.GetRandomTrainingGroundArenaRewards "API:C PvP.GetRandomTrainingGroundArenaRewards")

[C\_PvP.GetRandomTrainingGroundBGRewards](https://warcraft.wiki.gg/wiki/API:C_PvP.GetRandomTrainingGroundBGRewards "API:C PvP.GetRandomTrainingGroundBGRewards")

[C\_PvP.HasRandomTrainingGroundArenaWinToday](https://warcraft.wiki.gg/wiki/API:C_PvP.HasRandomTrainingGroundArenaWinToday "API:C PvP.HasRandomTrainingGroundArenaWinToday")

[C\_PvP.HasRandomTrainingGroundBGWinToday](https://warcraft.wiki.gg/wiki/API:C_PvP.HasRandomTrainingGroundBGWinToday "API:C PvP.HasRandomTrainingGroundBGWinToday")

[C\_PvP.IsTrainingGroundsArena](https://warcraft.wiki.gg/wiki/API:C_PvP.IsTrainingGroundsArena "API:C PvP.IsTrainingGroundsArena")

[C\_PvP.IsTrainingGroundsBG](https://warcraft.wiki.gg/wiki/API:C_PvP.IsTrainingGroundsBG "API:C PvP.IsTrainingGroundsBG")

[C\_PvP.JoinRandomTrainingGroundBG](https://warcraft.wiki.gg/wiki/API:C_PvP.JoinRandomTrainingGroundBG "API:C PvP.JoinRandomTrainingGroundBG")

[C\_Timer.NewTimedSignalMap](https://warcraft.wiki.gg/wiki/API:C_Timer.NewTimedSignalMap "API:C Timer.NewTimedSignalMap")

[C\_UnitAuras.GetAuraCasterGUID](https://warcraft.wiki.gg/wiki/API:C_UnitAuras.GetAuraCasterGUID "API:C UnitAuras.GetAuraCasterGUID")

[C\_UnitAuras.GetRefreshCarryOverDuration](https://warcraft.wiki.gg/wiki/API:C_UnitAuras.GetRefreshCarryOverDuration "API:C UnitAuras.GetRefreshCarryOverDuration") 🆕

[C\_Weather.GetCurrentWeather](https://warcraft.wiki.gg/wiki/API:C_Weather.GetCurrentWeather "API:C Weather.GetCurrentWeather")

[Clamp](https://warcraft.wiki.gg/wiki/API:Clamp "API:Clamp")

[CountTable](https://warcraft.wiki.gg/wiki/API:CountTable "API:CountTable")

[CreateFrameWithOptions](https://warcraft.wiki.gg/wiki/API:CreateFrameWithOptions "API:CreateFrameWithOptions")

[GetKeysArray](https://warcraft.wiki.gg/wiki/API:GetKeysArray "API:GetKeysArray")

[GetScriptBucketThrottleLimits](https://warcraft.wiki.gg/wiki/API:GetScriptBucketThrottleLimits "API:GetScriptBucketThrottleLimits")

GetTextureMetatable

[GetValuesArray](https://warcraft.wiki.gg/wiki/API:GetValuesArray "API:GetValuesArray")

[Lerp](https://warcraft.wiki.gg/wiki/API:Lerp "API:Lerp")

[RoundToSignificantDigits](https://warcraft.wiki.gg/wiki/API:RoundToSignificantDigits "API:RoundToSignificantDigits")

[Round](https://warcraft.wiki.gg/wiki/API:Round "API:Round")

[Saturate](https://warcraft.wiki.gg/wiki/API:Saturate "API:Saturate")

[Sign](https://warcraft.wiki.gg/wiki/API:Sign "API:Sign")

[TableIsEmpty](https://warcraft.wiki.gg/wiki/API:TableIsEmpty "API:TableIsEmpty")

[math.clamp](https://warcraft.wiki.gg/wiki/API:math.clamp "API:math.clamp")

[math.isfinite](https://warcraft.wiki.gg/wiki/API:math.isfinite "API:math.isfinite")

[math.isinf](https://warcraft.wiki.gg/wiki/API:math.isinf "API:math.isinf")

[math.isnan](https://warcraft.wiki.gg/wiki/API:math.isnan "API:math.isnan")

[math.lerp](https://warcraft.wiki.gg/wiki/API:math.lerp "API:math.lerp")

[math.normalize](https://warcraft.wiki.gg/wiki/API:math.normalize "API:math.normalize")

[math.remap](https://warcraft.wiki.gg/wiki/API:math.remap "API:math.remap")

[math.round](https://warcraft.wiki.gg/wiki/API:math.round "API:math.round")

[math.saturate](https://warcraft.wiki.gg/wiki/API:math.saturate "API:math.saturate")

[math.sign](https://warcraft.wiki.gg/wiki/API:math.sign "API:math.sign")

[math.wrap](https://warcraft.wiki.gg/wiki/API:math.wrap "API:math.wrap")

[string.contains](https://warcraft.wiki.gg/wiki/API:string.contains "API:string.contains")

[string.endswith](https://warcraft.wiki.gg/wiki/API:string.endswith "API:string.endswith")

[string.ltrim](https://warcraft.wiki.gg/wiki/API:string.ltrim "API:string.ltrim")

[string.rtrim](https://warcraft.wiki.gg/wiki/API:string.rtrim "API:string.rtrim")

[string.startswith](https://warcraft.wiki.gg/wiki/API:string.startswith "API:string.startswith")

[tContains](https://warcraft.wiki.gg/wiki/API:tContains "API:tContains")

[tDeleteItem](https://warcraft.wiki.gg/wiki/API:tDeleteItem "API:tDeleteItem")

[tIndexOf](https://warcraft.wiki.gg/wiki/API:tIndexOf "API:tIndexOf")

[tUnorderedRemove](https://warcraft.wiki.gg/wiki/API:tUnorderedRemove "API:tUnorderedRemove")

[table.contains](https://warcraft.wiki.gg/wiki/API:table.contains "API:table.contains")

[table.getcountinfo](https://warcraft.wiki.gg/wiki/API:table.getcountinfo "API:table.getcountinfo")

[table.indexof](https://warcraft.wiki.gg/wiki/API:table.indexof "API:table.indexof")

[table.isempty](https://warcraft.wiki.gg/wiki/API:table.isempty "API:table.isempty")

[table.keys](https://warcraft.wiki.gg/wiki/API:table.keys "API:table.keys")

[table.removeunordered](https://warcraft.wiki.gg/wiki/API:table.removeunordered "API:table.removeunordered")

[table.removevalue](https://warcraft.wiki.gg/wiki/API:table.removevalue "API:table.removevalue")

[table.values](https://warcraft.wiki.gg/wiki/API:table.values "API:table.values")

[C\_PvP.GetRandomTrainingGroundRewards](https://warcraft.wiki.gg/wiki/API:C_PvP.GetRandomTrainingGroundRewards "API:C PvP.GetRandomTrainingGroundRewards")

[C\_PvP.HasRandomTrainingGroundWinToday](https://warcraft.wiki.gg/wiki/API:C_PvP.HasRandomTrainingGroundWinToday "API:C PvP.HasRandomTrainingGroundWinToday")

[C\_PvP.JoinRandomTrainingGroundBattleground](https://warcraft.wiki.gg/wiki/API:C_PvP.JoinRandomTrainingGroundBattleground "API:C PvP.JoinRandomTrainingGroundBattleground")

[C\_TableUtil.FindIndexedMismatch](https://warcraft.wiki.gg/wiki/API:C_TableUtil.FindIndexedMismatch "API:C TableUtil.FindIndexedMismatch")

### FrameXML

Added (29)

Removed (15)

[ChatFrameUtil.GetTabAlphas](https://www.townlong-yak.com/framexml/ptr/go/ChatFrameUtil.GetTabAlphas)

[ChatFrameUtil.IsTabAlerting](https://www.townlong-yak.com/framexml/ptr/go/ChatFrameUtil.IsTabAlerting)

[ChatFrameUtil.SetTabAlerting](https://www.townlong-yak.com/framexml/ptr/go/ChatFrameUtil.SetTabAlerting)

[ChatFrameUtil.SetTabAlphas](https://www.townlong-yak.com/framexml/ptr/go/ChatFrameUtil.SetTabAlphas)

[ChatFrameUtil.StartFlash](https://www.townlong-yak.com/framexml/ptr/go/ChatFrameUtil.StartFlash)

[ChatFrameUtil.StartSyncedFlash](https://www.townlong-yak.com/framexml/ptr/go/ChatFrameUtil.StartSyncedFlash)

[ChatFrameUtil.StopFlash](https://www.townlong-yak.com/framexml/ptr/go/ChatFrameUtil.StopFlash)

[CombatAudioAlertUtil.EnumeratePulseHealthPercentInfo](https://www.townlong-yak.com/framexml/ptr/go/CombatAudioAlertUtil.EnumeratePulseHealthPercentInfo)

[CombatAudioAlertUtil.GetCurrentPulseHealthPercentInfo](https://www.townlong-yak.com/framexml/ptr/go/CombatAudioAlertUtil.GetCurrentPulseHealthPercentInfo)

[CombatAudioAlertUtil.GetPulseHealthPercentInfo](https://www.townlong-yak.com/framexml/ptr/go/CombatAudioAlertUtil.GetPulseHealthPercentInfo)

[CombatAudioAlertUtil.GetPulseHealthSoundKit](https://www.townlong-yak.com/framexml/ptr/go/CombatAudioAlertUtil.GetPulseHealthSoundKit)

[CombatAudioAlertUtil.SetPulseHealthSoundKit](https://www.townlong-yak.com/framexml/ptr/go/CombatAudioAlertUtil.SetPulseHealthSoundKit)

[CompactUnitFrame\_GetOptionDispelIndicatorAnimatedBorder](https://www.townlong-yak.com/framexml/ptr/go/CompactUnitFrame_GetOptionDispelIndicatorAnimatedBorder)

[GenericTraitUtil.GetKnownTreeIDs](https://www.townlong-yak.com/framexml/ptr/go/GenericTraitUtil.GetKnownTreeIDs)

[GetTimeSinceLastQuestProgress](https://www.townlong-yak.com/framexml/ptr/go/GetTimeSinceLastQuestProgress)

[HousingFramesUtil.MoveLayoutCameraFloor](https://www.townlong-yak.com/framexml/ptr/go/HousingFramesUtil.MoveLayoutCameraFloor)

[MarchingAnts\_CreateAsChildOf](https://www.townlong-yak.com/framexml/ptr/go/MarchingAnts_CreateAsChildOf)

[MarchingAnts\_CreateForTarget](https://www.townlong-yak.com/framexml/ptr/go/MarchingAnts_CreateForTarget)

[MarchingAnts\_Create](https://www.townlong-yak.com/framexml/ptr/go/MarchingAnts_Create)

[PixelUtil.SetRoundLayoutToNearestPixelRecursively](https://www.townlong-yak.com/framexml/ptr/go/PixelUtil.SetRoundLayoutToNearestPixelRecursively)

[QuestMapLog\_GetStoryTooltip](https://www.townlong-yak.com/framexml/ptr/go/QuestMapLog_GetStoryTooltip)

[TimerUtil.CreateTimedSignalCallbackMap](https://www.townlong-yak.com/framexml/ptr/go/TimerUtil.CreateTimedSignalCallbackMap)

[UnitFrameUtil.GetArenaOpponentSpecDisplayInfo](https://www.townlong-yak.com/framexml/ptr/go/UnitFrameUtil.GetArenaOpponentSpecDisplayInfo)

[UnitFrameUtil.GetUnitPvPIndicatorDisplayInfo](https://www.townlong-yak.com/framexml/ptr/go/UnitFrameUtil.GetUnitPvPIndicatorDisplayInfo)

[UnitFrameUtil.GetUnitRoleIconDisplayInfo](https://www.townlong-yak.com/framexml/ptr/go/UnitFrameUtil.GetUnitRoleIconDisplayInfo)

[UnitFrameUtil.UpdateArenaOpponentSpecDisplayName](https://www.townlong-yak.com/framexml/ptr/go/UnitFrameUtil.UpdateArenaOpponentSpecDisplayName)

[UnitFrameUtil.UpdateArenaOpponentSpecDisplay](https://www.townlong-yak.com/framexml/ptr/go/UnitFrameUtil.UpdateArenaOpponentSpecDisplay)

[UnitFrameUtil.UpdateUnitFrameRoleIcon](https://www.townlong-yak.com/framexml/ptr/go/UnitFrameUtil.UpdateUnitFrameRoleIcon)

[UnitFrameUtil.UpdateUnitPvPIndicator](https://www.townlong-yak.com/framexml/ptr/go/UnitFrameUtil.UpdateUnitPvPIndicator)

[Clamp](https://www.townlong-yak.com/framexml/12.1.0/go/Clamp)

[CountTable](https://www.townlong-yak.com/framexml/12.1.0/go/CountTable)

[GetKeysArray](https://www.townlong-yak.com/framexml/12.1.0/go/GetKeysArray)

[GetValuesArray](https://www.townlong-yak.com/framexml/12.1.0/go/GetValuesArray)

[Lerp](https://www.townlong-yak.com/framexml/12.1.0/go/Lerp)

[RoundToSignificantDigits](https://www.townlong-yak.com/framexml/12.1.0/go/RoundToSignificantDigits)

[Round](https://www.townlong-yak.com/framexml/12.1.0/go/Round)

[Saturate](https://www.townlong-yak.com/framexml/12.1.0/go/Saturate)

[Sign](https://www.townlong-yak.com/framexml/12.1.0/go/Sign)

[StringContains](https://www.townlong-yak.com/framexml/12.1.0/go/StringContains)

[TableIsEmpty](https://www.townlong-yak.com/framexml/12.1.0/go/TableIsEmpty)

[tContains](https://www.townlong-yak.com/framexml/12.1.0/go/tContains)

[tDeleteItem](https://www.townlong-yak.com/framexml/12.1.0/go/tDeleteItem)

[tIndexOf](https://www.townlong-yak.com/framexml/12.1.0/go/tIndexOf)

[tUnorderedRemove](https://www.townlong-yak.com/framexml/12.1.0/go/tUnorderedRemove)

### ScriptObjects

Added (30)

Removed (0)

[LocaleContext:CompareStrings](https://warcraft.wiki.gg/wiki/API:LocaleContext_CompareStrings "API:LocaleContext CompareStrings")

[LocaleContext:FindBreaks](https://warcraft.wiki.gg/wiki/API:LocaleContext_FindBreaks "API:LocaleContext FindBreaks")

[LocaleContext:FindStringMatches](https://warcraft.wiki.gg/wiki/API:LocaleContext_FindStringMatches "API:LocaleContext FindStringMatches")

[LocaleContext:FoldCase](https://warcraft.wiki.gg/wiki/API:LocaleContext_FoldCase "API:LocaleContext FoldCase")

[LocaleContext:FormatCurrency](https://warcraft.wiki.gg/wiki/API:LocaleContext_FormatCurrency "API:LocaleContext FormatCurrency")

[LocaleContext:FormatDate](https://warcraft.wiki.gg/wiki/API:LocaleContext_FormatDate "API:LocaleContext FormatDate")

[LocaleContext:FormatDateTime](https://warcraft.wiki.gg/wiki/API:LocaleContext_FormatDateTime "API:LocaleContext FormatDateTime")

[LocaleContext:FormatNumber](https://warcraft.wiki.gg/wiki/API:LocaleContext_FormatNumber "API:LocaleContext FormatNumber")

[LocaleContext:FormatTime](https://warcraft.wiki.gg/wiki/API:LocaleContext_FormatTime "API:LocaleContext FormatTime")

[LocaleContext:GetCurrencyName](https://warcraft.wiki.gg/wiki/API:LocaleContext_GetCurrencyName "API:LocaleContext GetCurrencyName")

[LocaleContext:GetDisplayName](https://warcraft.wiki.gg/wiki/API:LocaleContext_GetDisplayName "API:LocaleContext GetDisplayName")

[LocaleContext:GetLocale](https://warcraft.wiki.gg/wiki/API:LocaleContext_GetLocale "API:LocaleContext GetLocale")

[LocaleContext:GetSortKey](https://warcraft.wiki.gg/wiki/API:LocaleContext_GetSortKey "API:LocaleContext GetSortKey")

[LocaleContext:Length](https://warcraft.wiki.gg/wiki/API:LocaleContext_Length "API:LocaleContext Length")

[LocaleContext:ParseCurrency](https://warcraft.wiki.gg/wiki/API:LocaleContext_ParseCurrency "API:LocaleContext ParseCurrency")

[LocaleContext:ParseNumber](https://warcraft.wiki.gg/wiki/API:LocaleContext_ParseNumber "API:LocaleContext ParseNumber")

[LocaleContext:SelectPlural](https://warcraft.wiki.gg/wiki/API:LocaleContext_SelectPlural "API:LocaleContext SelectPlural")

[LocaleContext:SetLocale](https://warcraft.wiki.gg/wiki/API:LocaleContext_SetLocale "API:LocaleContext SetLocale")

[LocaleContext:ToLower](https://warcraft.wiki.gg/wiki/API:LocaleContext_ToLower "API:LocaleContext ToLower")

[LocaleContext:ToTitle](https://warcraft.wiki.gg/wiki/API:LocaleContext_ToTitle "API:LocaleContext ToTitle")

[LocaleContext:ToUpper](https://warcraft.wiki.gg/wiki/API:LocaleContext_ToUpper "API:LocaleContext ToUpper")

[LocaleContext:TransformLocale](https://warcraft.wiki.gg/wiki/API:LocaleContext_TransformLocale "API:LocaleContext TransformLocale")

[TimedSignalMap:CancelAllSignals](https://warcraft.wiki.gg/wiki/API:TimedSignalMap_CancelAllSignals "API:TimedSignalMap CancelAllSignals")

[TimedSignalMap:CancelSignal](https://warcraft.wiki.gg/wiki/API:TimedSignalMap_CancelSignal "API:TimedSignalMap CancelSignal")

[TimedSignalMap:GetNextSignal](https://warcraft.wiki.gg/wiki/API:TimedSignalMap_GetNextSignal "API:TimedSignalMap GetNextSignal")

[TimedSignalMap:GetSignalCount](https://warcraft.wiki.gg/wiki/API:TimedSignalMap_GetSignalCount "API:TimedSignalMap GetSignalCount")

[TimedSignalMap:GetSignalTime](https://warcraft.wiki.gg/wiki/API:TimedSignalMap_GetSignalTime "API:TimedSignalMap GetSignalTime")

[TimedSignalMap:HasSignal](https://warcraft.wiki.gg/wiki/API:TimedSignalMap_HasSignal "API:TimedSignalMap HasSignal")

[TimedSignalMap:SignalAfter](https://warcraft.wiki.gg/wiki/API:TimedSignalMap_SignalAfter "API:TimedSignalMap SignalAfter")

[TimedSignalMap:SignalAt](https://warcraft.wiki.gg/wiki/API:TimedSignalMap_SignalAt "API:TimedSignalMap SignalAt")

### Widgets

Added (2)

Removed (0)

[ScriptRegion:GetRoundLayoutToNearestPixel](https://warcraft.wiki.gg/wiki/API:ScriptRegion_GetRoundLayoutToNearestPixel "API:ScriptRegion GetRoundLayoutToNearestPixel")

[ScriptRegion:SetRoundLayoutToNearestPixel](https://warcraft.wiki.gg/wiki/API:ScriptRegion_SetRoundLayoutToNearestPixel "API:ScriptRegion SetRoundLayoutToNearestPixel")

### Events

Added (1)

Removed (0)

[WEATHER\_CHANGED](https://warcraft.wiki.gg/wiki/Event:WEATHER_CHANGED "Event:WEATHER CHANGED")

### CVars

Added (12)

Removed (0)

_dumpSmallAllocCommand: dumpSmallAlloc (Game)_

CAAPulsePlayerHealthPercentCVar: CAAPulsePlayerHealthPercent (Game)  
Default: `0`, Scope: Account  
Play a looping pulse sound once the player's health is below X percent. The pulse gets faster as health drops

CAAPulsePlayerHealthVolumeCVar: CAAPulsePlayerHealthVolume (Game)  
Default: `100`, Scope: Account  
Volume of the player health pulse combat audio alert (0 to 100)

coordsByTenthsCVar: coordsByTenths (Game)  
Default: `1`, Scope: Account  
Show coordinates by tenths

maximumConnectionAttemptsCVar: maximumConnectionAttempts (Net)  
Default: `2`  
Maximum number of times to try to connect to a server using QUIC before doing TCP

minimapShowPlayerCoordsCVar: minimapShowPlayerCoords (Game)  
Default: `1`, Scope: Account  
Show player coordinates on the minimap

nameplateBottomInsetCVar: nameplateBottomInset (Game)  
Default: `0.100000`  
The inset from the bottom (in screen percent) that nameplates are clamped to.

nameplateMotionSpeedCVar: nameplateMotionSpeed (Game)  
Default: `0.025000`  
Controls the rate at which nameplate animates into their target locations \[0.0-1.0\]

nameplateTopInsetCVar: nameplateTopInset (Game)  
Default: `0.080000`  
The inset from the top (in screen percent) that nameplates are clamped to.

raidFramesDispelIndicatorAnimatedBorderCVar: raidFramesDispelIndicatorAnimatedBorder (Game)  
Default: `0`, Scope: Character  
When showing dispel indicators, display an animated border

tooltipShowAuraCasterNamesCVar: tooltipShowAuraCasterNames (Game)  
Default: `0`, Scope: Account  
Show caster unit names in tooltips for unit auras.

winePlatformTTSCVar: winePlatformTTS (Game)  
Default: `0`  
Use Windows TTS on Wine. Disabled by default as it can cause crashes. 🆕

Deprecated API
--------------

![Spell holy borrowedtime.png](https://warcraft.wiki.gg/images/thumb/Spell_holy_borrowedtime.png/32px-Spell_holy_borrowedtime.png?695e57)

The following deprecation fallbacks have been removed.

_Please upgrade to the updated APIs as soon as possible._

**[Deprecated\_CurrencyScript.lua](https://github.com/Gethe/wow-ui-source/blob/12.1.0/Interface/AddOns/Blizzard_DeprecatedCurrencyScript/Deprecated_CurrencyScript.lua)**

*   [GetCoinIcon](https://warcraft.wiki.gg/wiki/API:GetCoinIcon "API:GetCoinIcon") = [C\_CurrencyInfo.GetCoinIcon](https://warcraft.wiki.gg/wiki/API:C_CurrencyInfo.GetCoinIcon "API:C CurrencyInfo.GetCoinIcon")
*   [GetCoinText](https://warcraft.wiki.gg/wiki/API:GetCoinText "API:GetCoinText") = [C\_CurrencyInfo.GetCoinText](https://warcraft.wiki.gg/wiki/API:C_CurrencyInfo.GetCoinText "API:C CurrencyInfo.GetCoinText")
*   [GetCoinTextureString](https://warcraft.wiki.gg/wiki/API:GetCoinTextureString "API:GetCoinTextureString") = [C\_CurrencyInfo.GetCoinTextureString](https://warcraft.wiki.gg/wiki/API:C_CurrencyInfo.GetCoinTextureString "API:C CurrencyInfo.GetCoinTextureString")

**[Blizzard\_DeprecatedGlue](https://github.com/Gethe/wow-ui-source/blob/12.1.0/Interface/AddOns/Blizzard_DeprecatedGlue/Deprecated_Glue.lua)**

*   [IsOnGlueScreen](https://warcraft.wiki.gg/wiki/API:IsOnGlueScreen "API:IsOnGlueScreen") = [C\_Glue.IsOnGlueScreen](https://warcraft.wiki.gg/wiki/API:C_Glue.IsOnGlueScreen "API:C Glue.IsOnGlueScreen")

**[Blizzard\_DeprecatedItemScript](https://github.com/Gethe/wow-ui-source/blob/12.1.0/Interface/AddOns/Blizzard_DeprecatedItemScript/Deprecated_ItemScript.lua)**

*   [GetItemQualityColor](https://warcraft.wiki.gg/wiki/API:GetItemQualityColor "API:GetItemQualityColor") = [C\_Item.GetItemQualityColor](https://warcraft.wiki.gg/wiki/API:C_Item.GetItemQualityColor "API:C Item.GetItemQualityColor")
*   [GetItemInfoInstant](https://warcraft.wiki.gg/wiki/API:GetItemInfoInstant "API:GetItemInfoInstant") = [C\_Item.GetItemInfoInstant](https://warcraft.wiki.gg/wiki/API:C_Item.GetItemInfoInstant "API:C Item.GetItemInfoInstant")
*   [GetItemSetInfo](https://warcraft.wiki.gg/wiki/API:GetItemSetInfo "API:GetItemSetInfo") = [C\_Item.GetItemSetInfo](https://warcraft.wiki.gg/wiki/API:C_Item.GetItemSetInfo "API:C Item.GetItemSetInfo")
*   [GetItemChildInfo](https://warcraft.wiki.gg/wiki/API:GetItemChildInfo "API:GetItemChildInfo") = [C\_Item.GetItemChildInfo](https://warcraft.wiki.gg/wiki/API:C_Item.GetItemChildInfo "API:C Item.GetItemChildInfo")
*   [DoesItemContainSpec](https://warcraft.wiki.gg/wiki/API:DoesItemContainSpec "API:DoesItemContainSpec") = [C\_Item.DoesItemContainSpec](https://warcraft.wiki.gg/wiki/API:C_Item.DoesItemContainSpec "API:C Item.DoesItemContainSpec")
*   [GetItemGem](https://warcraft.wiki.gg/wiki/API:GetItemGem "API:GetItemGem") = [C\_Item.GetItemGem](https://warcraft.wiki.gg/wiki/API:C_Item.GetItemGem "API:C Item.GetItemGem")
*   [GetItemCreationContext](https://warcraft.wiki.gg/wiki/API:GetItemCreationContext "API:GetItemCreationContext") = [C\_Item.GetItemCreationContext](https://warcraft.wiki.gg/wiki/API:C_Item.GetItemCreationContext "API:C Item.GetItemCreationContext")
*   [GetItemIcon](https://warcraft.wiki.gg/wiki/API:GetItemIcon "API:GetItemIcon") = [C\_Item.GetItemIconByID](https://warcraft.wiki.gg/wiki/API:C_Item.GetItemIconByID "API:C Item.GetItemIconByID")
*   [GetItemFamily](https://warcraft.wiki.gg/wiki/API:GetItemFamily "API:GetItemFamily") = [C\_Item.GetItemFamily](https://warcraft.wiki.gg/wiki/API:C_Item.GetItemFamily "API:C Item.GetItemFamily")
*   [GetItemSpell](https://warcraft.wiki.gg/wiki/API:GetItemSpell "API:GetItemSpell") = [C\_Item.GetItemSpell](https://warcraft.wiki.gg/wiki/API:C_Item.GetItemSpell "API:C Item.GetItemSpell")
*   [IsArtifactPowerItem](https://warcraft.wiki.gg/wiki/API:IsArtifactPowerItem "API:IsArtifactPowerItem") = [C\_Item.IsArtifactPowerItem](https://warcraft.wiki.gg/wiki/API:C_Item.IsArtifactPowerItem "API:C Item.IsArtifactPowerItem")
*   [IsCurrentItem](https://warcraft.wiki.gg/wiki/API:IsCurrentItem "API:IsCurrentItem") = [C\_Item.IsCurrentItem](https://warcraft.wiki.gg/wiki/API:C_Item.IsCurrentItem "API:C Item.IsCurrentItem")
*   [IsUsableItem](https://warcraft.wiki.gg/wiki/API:IsUsableItem "API:IsUsableItem") = [C\_Item.IsUsableItem](https://warcraft.wiki.gg/wiki/API:C_Item.IsUsableItem "API:C Item.IsUsableItem")
*   [IsHelpfulItem](https://warcraft.wiki.gg/wiki/API:IsHelpfulItem "API:IsHelpfulItem") = [C\_Item.IsHelpfulItem](https://warcraft.wiki.gg/wiki/API:C_Item.IsHelpfulItem "API:C Item.IsHelpfulItem")
*   [IsHarmfulItem](https://warcraft.wiki.gg/wiki/API:IsHarmfulItem "API:IsHarmfulItem") = [C\_Item.IsHarmfulItem](https://warcraft.wiki.gg/wiki/API:C_Item.IsHarmfulItem "API:C Item.IsHarmfulItem")
*   [IsConsumableItem](https://warcraft.wiki.gg/wiki/API:IsConsumableItem "API:IsConsumableItem") = [C\_Item.IsConsumableItem](https://warcraft.wiki.gg/wiki/API:C_Item.IsConsumableItem "API:C Item.IsConsumableItem")
*   [IsEquippableItem](https://warcraft.wiki.gg/wiki/API:IsEquippableItem "API:IsEquippableItem") = [C\_Item.IsEquippableItem](https://warcraft.wiki.gg/wiki/API:C_Item.IsEquippableItem "API:C Item.IsEquippableItem")
*   [IsEquippedItem](https://warcraft.wiki.gg/wiki/API:IsEquippedItem "API:IsEquippedItem") = [C\_Item.IsEquippedItem](https://warcraft.wiki.gg/wiki/API:C_Item.IsEquippedItem "API:C Item.IsEquippedItem")
*   [IsEquippedItemType](https://warcraft.wiki.gg/wiki/API:IsEquippedItemType "API:IsEquippedItemType") = [C\_Item.IsEquippedItemType](https://warcraft.wiki.gg/wiki/API:C_Item.IsEquippedItemType "API:C Item.IsEquippedItemType")
*   [ItemHasRange](https://warcraft.wiki.gg/wiki/API:ItemHasRange "API:ItemHasRange") = [C\_Item.ItemHasRange](https://warcraft.wiki.gg/wiki/API:C_Item.ItemHasRange "API:C Item.ItemHasRange")
*   [IsItemInRange](https://warcraft.wiki.gg/wiki/API:IsItemInRange "API:IsItemInRange") = [C\_Item.IsItemInRange](https://warcraft.wiki.gg/wiki/API:C_Item.IsItemInRange "API:C Item.IsItemInRange")
*   [GetItemClassInfo](https://warcraft.wiki.gg/wiki/API:GetItemClassInfo "API:GetItemClassInfo") = [C\_Item.GetItemClassInfo](https://warcraft.wiki.gg/wiki/API:C_Item.GetItemClassInfo "API:C Item.GetItemClassInfo")
*   [GetItemInventorySlotInfo](https://warcraft.wiki.gg/wiki/API:GetItemInventorySlotInfo "API:GetItemInventorySlotInfo") = [C\_Item.GetItemInventorySlotInfo](https://warcraft.wiki.gg/wiki/API:C_Item.GetItemInventorySlotInfo "API:C Item.GetItemInventorySlotInfo")
*   [BindEnchant](https://warcraft.wiki.gg/wiki/API:BindEnchant "API:BindEnchant") = [C\_Item.BindEnchant](https://warcraft.wiki.gg/wiki/API:C_Item.BindEnchant "API:C Item.BindEnchant")
*   [ActionBindsItem](https://warcraft.wiki.gg/wiki/API:ActionBindsItem "API:ActionBindsItem") = [C\_Item.ActionBindsItem](https://warcraft.wiki.gg/wiki/API:C_Item.ActionBindsItem "API:C Item.ActionBindsItem")
*   [ReplaceEnchant](https://warcraft.wiki.gg/wiki/API:ReplaceEnchant "API:ReplaceEnchant") = [C\_Item.ReplaceEnchant](https://warcraft.wiki.gg/wiki/API:C_Item.ReplaceEnchant "API:C Item.ReplaceEnchant")
*   [ReplaceTradeEnchant](https://warcraft.wiki.gg/wiki/API:ReplaceTradeEnchant "API:ReplaceTradeEnchant") = [C\_Item.ReplaceTradeEnchant](https://warcraft.wiki.gg/wiki/API:C_Item.ReplaceTradeEnchant "API:C Item.ReplaceTradeEnchant")
*   [ConfirmBindOnUse](https://warcraft.wiki.gg/wiki/API:ConfirmBindOnUse "API:ConfirmBindOnUse") = [C\_Item.ConfirmBindOnUse](https://warcraft.wiki.gg/wiki/API:C_Item.ConfirmBindOnUse "API:C Item.ConfirmBindOnUse")
*   [ConfirmOnUse](https://warcraft.wiki.gg/wiki/API:ConfirmOnUse "API:ConfirmOnUse") = [C\_Item.ConfirmOnUse](https://warcraft.wiki.gg/wiki/API:C_Item.ConfirmOnUse "API:C Item.ConfirmOnUse")
*   [ConfirmNoRefundOnUse](https://warcraft.wiki.gg/wiki/API:ConfirmNoRefundOnUse "API:ConfirmNoRefundOnUse") = [C\_Item.ConfirmNoRefundOnUse](https://warcraft.wiki.gg/wiki/API:C_Item.ConfirmNoRefundOnUse "API:C Item.ConfirmNoRefundOnUse")
*   [DropItemOnUnit](https://warcraft.wiki.gg/wiki/API:DropItemOnUnit "API:DropItemOnUnit") = [C\_Item.DropItemOnUnit](https://warcraft.wiki.gg/wiki/API:C_Item.DropItemOnUnit "API:C Item.DropItemOnUnit")
*   [EndBoundTradeable](https://warcraft.wiki.gg/wiki/API:EndBoundTradeable "API:EndBoundTradeable") = [C\_Item.EndBoundTradeable](https://warcraft.wiki.gg/wiki/API:C_Item.EndBoundTradeable "API:C Item.EndBoundTradeable")
*   [EndRefund](https://warcraft.wiki.gg/wiki/API:EndRefund "API:EndRefund") = [C\_Item.EndRefund](https://warcraft.wiki.gg/wiki/API:C_Item.EndRefund "API:C Item.EndRefund")
*   [GetItemInfo](https://warcraft.wiki.gg/wiki/API:GetItemInfo "API:GetItemInfo") = [C\_Item.GetItemInfo](https://warcraft.wiki.gg/wiki/API:C_Item.GetItemInfo "API:C Item.GetItemInfo")
*   [GetDetailedItemLevelInfo](https://warcraft.wiki.gg/wiki/API:GetDetailedItemLevelInfo "API:GetDetailedItemLevelInfo") = [C\_Item.GetDetailedItemLevelInfo](https://warcraft.wiki.gg/wiki/API:C_Item.GetDetailedItemLevelInfo "API:C Item.GetDetailedItemLevelInfo")
*   [GetItemSpecInfo](https://warcraft.wiki.gg/wiki/API:GetItemSpecInfo "API:GetItemSpecInfo") = [C\_Item.GetItemSpecInfo](https://warcraft.wiki.gg/wiki/API:C_Item.GetItemSpecInfo "API:C Item.GetItemSpecInfo")
*   [GetItemUniqueness](https://warcraft.wiki.gg/wiki/API:GetItemUniqueness "API:GetItemUniqueness") = [C\_Item.GetItemUniqueness](https://warcraft.wiki.gg/wiki/API:C_Item.GetItemUniqueness "API:C Item.GetItemUniqueness")
*   [GetItemCount](https://warcraft.wiki.gg/wiki/API:GetItemCount "API:GetItemCount") = [C\_Item.GetItemCount](https://warcraft.wiki.gg/wiki/API:C_Item.GetItemCount "API:C Item.GetItemCount")
*   [PickupItem](https://warcraft.wiki.gg/wiki/API:PickupItem "API:PickupItem") = [C\_Item.PickupItem](https://warcraft.wiki.gg/wiki/API:C_Item.PickupItem "API:C Item.PickupItem")
*   [GetItemSubClassInfo](https://warcraft.wiki.gg/wiki/API:GetItemSubClassInfo "API:GetItemSubClassInfo") = [C\_Item.GetItemSubClassInfo](https://warcraft.wiki.gg/wiki/API:C_Item.GetItemSubClassInfo "API:C Item.GetItemSubClassInfo")
*   [UseItemByName](https://warcraft.wiki.gg/wiki/API:UseItemByName "API:UseItemByName") = [C\_Item.UseItemByName](https://warcraft.wiki.gg/wiki/API:C_Item.UseItemByName "API:C Item.UseItemByName")
*   [EquipItemByName](https://warcraft.wiki.gg/wiki/API:EquipItemByName "API:EquipItemByName") = [C\_Item.EquipItemByName](https://warcraft.wiki.gg/wiki/API:C_Item.EquipItemByName "API:C Item.EquipItemByName")
*   [ReplaceTradeskillEnchant](https://warcraft.wiki.gg/wiki/API:ReplaceTradeskillEnchant "API:ReplaceTradeskillEnchant") = [C\_Item.ReplaceTradeskillEnchant](https://warcraft.wiki.gg/wiki/API:C_Item.ReplaceTradeskillEnchant "API:C Item.ReplaceTradeskillEnchant")
*   [GetItemCooldown](https://warcraft.wiki.gg/wiki/API:GetItemCooldown "API:GetItemCooldown") = [C\_Item.GetItemCooldown](https://warcraft.wiki.gg/wiki/API:C_Item.GetItemCooldown "API:C Item.GetItemCooldown")
*   [IsCorruptedItem](https://warcraft.wiki.gg/wiki/API:IsCorruptedItem "API:IsCorruptedItem") = [C\_Item.IsCorruptedItem](https://warcraft.wiki.gg/wiki/API:C_Item.IsCorruptedItem "API:C Item.IsCorruptedItem")
*   [IsCosmeticItem](https://warcraft.wiki.gg/wiki/API:IsCosmeticItem "API:IsCosmeticItem") = [C\_Item.IsCosmeticItem](https://warcraft.wiki.gg/wiki/API:C_Item.IsCosmeticItem "API:C Item.IsCosmeticItem")
*   [IsDressableItem](https://warcraft.wiki.gg/wiki/API:IsDressableItem "API:IsDressableItem") = [C\_Item.IsDressableItem](https://warcraft.wiki.gg/wiki/API:C_Item.IsDressableItem "API:C Item.IsDressableItem")

**[Blizzard\_DeprecatedItemSocketInfo](https://github.com/Gethe/wow-ui-source/blob/12.1.0/Interface/AddOns/Blizzard_DeprecatedItemSocketInfo/Deprecated_ItemSocketInfo.lua)**

*   [CloseSocketInfo](https://warcraft.wiki.gg/wiki/API:CloseSocketInfo "API:CloseSocketInfo") = [C\_ItemSocketInfo.CloseSocketInfo](https://warcraft.wiki.gg/wiki/API:C_ItemSocketInfo.CloseSocketInfo "API:C ItemSocketInfo.CloseSocketInfo")
*   [GetSocketItemInfo](https://warcraft.wiki.gg/wiki/API:GetSocketItemInfo "API:GetSocketItemInfo") = [C\_ItemSocketInfo.GetSocketItemInfo](https://warcraft.wiki.gg/wiki/API:C_ItemSocketInfo.GetSocketItemInfo "API:C ItemSocketInfo.GetSocketItemInfo")
*   [GetNumSockets](https://warcraft.wiki.gg/wiki/API:GetNumSockets "API:GetNumSockets") = [C\_ItemSocketInfo.GetNumSockets](https://warcraft.wiki.gg/wiki/API:C_ItemSocketInfo.GetNumSockets "API:C ItemSocketInfo.GetNumSockets")
*   [GetExistingSocketInfo](https://warcraft.wiki.gg/wiki/API:GetExistingSocketInfo "API:GetExistingSocketInfo") = [C\_ItemSocketInfo.GetExistingSocketInfo](https://warcraft.wiki.gg/wiki/API:C_ItemSocketInfo.GetExistingSocketInfo "API:C ItemSocketInfo.GetExistingSocketInfo")
*   [GetExistingSocketLink](https://warcraft.wiki.gg/wiki/API:GetExistingSocketLink "API:GetExistingSocketLink") = [C\_ItemSocketInfo.GetExistingSocketLink](https://warcraft.wiki.gg/wiki/API:C_ItemSocketInfo.GetExistingSocketLink "API:C ItemSocketInfo.GetExistingSocketLink")
*   [GetNewSocketInfo](https://warcraft.wiki.gg/wiki/API:GetNewSocketInfo "API:GetNewSocketInfo") = [C\_ItemSocketInfo.GetNewSocketInfo](https://warcraft.wiki.gg/wiki/API:C_ItemSocketInfo.GetNewSocketInfo "API:C ItemSocketInfo.GetNewSocketInfo")
*   [GetNewSocketLink](https://warcraft.wiki.gg/wiki/API:GetNewSocketLink "API:GetNewSocketLink") = [C\_ItemSocketInfo.GetNewSocketLink](https://warcraft.wiki.gg/wiki/API:C_ItemSocketInfo.GetNewSocketLink "API:C ItemSocketInfo.GetNewSocketLink")
*   [ClickSocketButton](https://warcraft.wiki.gg/wiki/API:ClickSocketButton "API:ClickSocketButton") = [C\_ItemSocketInfo.ClickSocketButton](https://warcraft.wiki.gg/wiki/API:C_ItemSocketInfo.ClickSocketButton "API:C ItemSocketInfo.ClickSocketButton")
*   [AcceptSockets](https://warcraft.wiki.gg/wiki/API:AcceptSockets "API:AcceptSockets") = [C\_ItemSocketInfo.AcceptSockets](https://warcraft.wiki.gg/wiki/API:C_ItemSocketInfo.AcceptSockets "API:C ItemSocketInfo.AcceptSockets")
*   [GetSocketTypes](https://warcraft.wiki.gg/wiki/API:GetSocketTypes "API:GetSocketTypes") = [C\_ItemSocketInfo.GetSocketTypes](https://warcraft.wiki.gg/wiki/API:C_ItemSocketInfo.GetSocketTypes "API:C ItemSocketInfo.GetSocketTypes")
*   [GetSocketItemRefundable](https://warcraft.wiki.gg/wiki/API:GetSocketItemRefundable "API:GetSocketItemRefundable") = [C\_ItemSocketInfo.GetSocketItemRefundable](https://warcraft.wiki.gg/wiki/API:C_ItemSocketInfo.GetSocketItemRefundable "API:C ItemSocketInfo.GetSocketItemRefundable")
*   [GetSocketItemBoundTradeable](https://warcraft.wiki.gg/wiki/API:GetSocketItemBoundTradeable "API:GetSocketItemBoundTradeable") = [C\_ItemSocketInfo.GetSocketItemBoundTradeable](https://warcraft.wiki.gg/wiki/API:C_ItemSocketInfo.GetSocketItemBoundTradeable "API:C ItemSocketInfo.GetSocketItemBoundTradeable")
*   [HasBoundGemProposed](https://warcraft.wiki.gg/wiki/API:HasBoundGemProposed "API:HasBoundGemProposed") = [C\_ItemSocketInfo.HasBoundGemProposed](https://warcraft.wiki.gg/wiki/API:C_ItemSocketInfo.HasBoundGemProposed "API:C ItemSocketInfo.HasBoundGemProposed")

**[Blizzard\_DeprecatedLFG](https://github.com/Gethe/wow-ui-source/blob/12.1.0/Interface/AddOns/Blizzard_DeprecatedLFG/Deprecated_LFG.lua)**

*   [C\_LFGInfo.IsPremadeGroupEnabled](https://warcraft.wiki.gg/wiki/API:C_LFGInfo.IsPremadeGroupEnabled "API:C LFGInfo.IsPremadeGroupEnabled") = [C\_LFGList.IsPremadeGroupFinderEnabled](https://warcraft.wiki.gg/wiki/API:C_LFGList.IsPremadeGroupFinderEnabled "API:C LFGList.IsPremadeGroupFinderEnabled")
*   [C\_LFGList.GetSearchResultMemberInfo](https://warcraft.wiki.gg/wiki/API:C_LFGList.GetSearchResultMemberInfo "API:C LFGList.GetSearchResultMemberInfo") = [C\_LFGList.GetSearchResultPlayerInfo](https://warcraft.wiki.gg/wiki/API:C_LFGList.GetSearchResultPlayerInfo "API:C LFGList.GetSearchResultPlayerInfo")

**[Blizzard\_DeprecatedPetInfo](https://github.com/Gethe/wow-ui-source/blob/12.1.0/Interface/AddOns/Blizzard_DeprecatedPetInfo/Deprecated_PetInfo.lua)**

*   [PetAssistMode](https://warcraft.wiki.gg/wiki/API:PetAssistMode "API:PetAssistMode") = [C\_PetInfo.PetAssistMode](https://warcraft.wiki.gg/wiki/API:C_PetInfo.PetAssistMode "API:C PetInfo.PetAssistMode")
*   [GetPetTalentTree](https://warcraft.wiki.gg/wiki/API:GetPetTalentTree "API:GetPetTalentTree") = [C\_PetInfo.GetPetTalentTree](https://warcraft.wiki.gg/wiki/API:C_PetInfo.GetPetTalentTree "API:C PetInfo.GetPetTalentTree")

**[Blizzard\_DeprecatedPvpScript](https://github.com/Gethe/wow-ui-source/blob/12.1.0/Interface/AddOns/Blizzard_DeprecatedPvpScript/Deprecated_PvpScript.lua)**

*   [IsSubZonePVPPOI](https://warcraft.wiki.gg/wiki/API:IsSubZonePVPPOI "API:IsSubZonePVPPOI") = [C\_PvP.IsSubZonePVPPOI](https://warcraft.wiki.gg/wiki/API:C_PvP.IsSubZonePVPPOI "API:C PvP.IsSubZonePVPPOI")
*   [GetZonePVPInfo](https://warcraft.wiki.gg/wiki/API:GetZonePVPInfo "API:GetZonePVPInfo") = [C\_PvP.GetZonePVPInfo](https://warcraft.wiki.gg/wiki/API:C_PvP.GetZonePVPInfo "API:C PvP.GetZonePVPInfo")
*   [TogglePVP](https://warcraft.wiki.gg/wiki/API:TogglePVP "API:TogglePVP") = [C\_PvP.TogglePVP](https://warcraft.wiki.gg/wiki/API:C_PvP.TogglePVP "API:C PvP.TogglePVP")
*   [SetPVP](https://warcraft.wiki.gg/wiki/API:SetPVP "API:SetPVP") = [C\_PvP.SetPVP](https://warcraft.wiki.gg/wiki/API:C_PvP.SetPVP "API:C PvP.SetPVP")

**[Blizzard\_DeprecatedSoundScript](https://github.com/Gethe/wow-ui-source/blob/12.1.0/Interface/AddOns/Blizzard_DeprecatedSoundScript/Deprecated_SoundScript.lua)**

*   [PlayVocalErrorSoundID](https://warcraft.wiki.gg/wiki/API:PlayVocalErrorSoundID "API:PlayVocalErrorSoundID") = [C\_Sound.PlayVocalErrorSound](https://warcraft.wiki.gg/wiki/API:C_Sound.PlayVocalErrorSound "API:C Sound.PlayVocalErrorSound")

**[Blizzard\_DeprecatedTradeInfo](https://github.com/Gethe/wow-ui-source/blob/12.1.0/Interface/AddOns/Blizzard_DeprecatedTradeInfo/Deprecated_TradeInfo.lua)**

*   [PickupTradeMoney](https://warcraft.wiki.gg/wiki/API:PickupTradeMoney "API:PickupTradeMoney") = [C\_TradeInfo.PickupTradeMoney](https://warcraft.wiki.gg/wiki/API:C_TradeInfo.PickupTradeMoney "API:C TradeInfo.PickupTradeMoney")

Retrieved from "[https://warcraft.wiki.gg/wiki/Patch\_12.1.5/API\_changes?oldid=6919763](https://warcraft.wiki.gg/wiki/Patch_12.1.5/API_changes?oldid=6919763)"
