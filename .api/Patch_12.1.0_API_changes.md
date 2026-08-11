# Patch 12.1.0/API changes

> **Source**: Warcraft Wiki - Your wiki guide to the World of Warcraft  
> **TOC**: `120100`  
> **Patch**: 12.1.0 (Curse of Ula’tek)  

---

## Resources

- **TOC**: `120100`
- **Official Patch Notes**: [Curse of Ula'tek Content Update Notes](https://worldofwarcraft.blizzard.com/en-us/news/24293281/curse-of-ulatek-content-update-notes#item21)
- **Diffs**: [wow-ui-source](https://github.com/Gethe/wow-ui-source/compare/12.0.7..12.1.0), [BlizzardInterfaceResources](https://github.com/Ketho/BlizzardInterfaceResources/compare/12.0.7...12.1.0)

### Notes

- Added `AuraContainer` and `AuraButton` intrinsic frames.
- SVG textures are now supported with the `VectorGraphics` object type.
- `UIParentLoadAddOn` has been renamed to `LoadAddOnWithErrorHandling`.
- `CanAccessObject` has been replaced with `FrameScriptObject:CanBeAccessedInContext`.
- Deprecated `getglobal` and `setglobal`.
- The Auto Loot setting (CVar `autoLootDefault`) is now account wide.
- New UI texture filenames will no longer be published to the `ManifestInterfaceData` DB. Existing filenames will remain available, and this change will not affect players. Addons will still be able to use these textures.

---

## Blue posts

> **Addons and Auras in Curse of Ula’tek** | *2026-06-18 17:00* | **JHemphill** (Blizzard Entertainment)
> 
> Since the launch of Midnight, we’ve continued to iterate on the addon-related changes introduced in the Midnight pre-patch. In the 12.1 Curse of Ula’tek update, we are pleased to be taking the next major step in that work. This work reflects the insights and feedback shared by our community, with a focus on auras, commonly referred to by players as buffs and debuffs.
> 
> These changes focus on preventing auras (whether on the player, enemies, or party and raid members) from leaking important combat information that can be used for combat automation. At the same time, we want addons to continue being able to show auras in a variety of custom ways.
> 
> To support that goal, Curse of Ula’tek will introduce new APIs that allow addons to display filtered sets of auras in customized ways, without exposing the underlying aura information that could be used for automation. Addons that currently display auras will need to be updated to support these new APIs, and we’ll be working directly with addon authors throughout the Curse of Ula’tek PTR to help them adapt to these changes and gather feedback during testing.
> 
> [View original post](https://us.forums.blizzard.com/en/wow/t/addons-and-auras-in-curse-of-ula%E2%80%99tek/2317456)

---

### 2026-06-18
**Midnight 12.1.0 PTR Changes 1** (Build 68209)

> Hello again from the World of Warcraft UI Engineering team! Today we’d like to talk about a significant set of Aura-related changes coming in 12.1. Most of these changes will be available when PTR launches, with the remaining pieces rolling out over the following few weeks.

#### Why Auras?
Since the Addon Disarmament project went live with Midnight, Auras (aka buffs and debuffs) have consistently been one of the weakest areas for addon security, with numerous exploits discovered both before launch and since then. The core issue is that, in many cases, simply knowing that any aura is present on a unit (whether it be the player, an enemy, or a raid/party member) is enough to determine that some important combat event has occurred. Aura filters are vital for many legitimate addon use cases, but they also make this problem harder to contain by allowing even more ways to tell if “special aura X” is on a unit, even if the unit has multiple auras on them.

Up until now, our solution to this has been to lean on Private Auras. Unfortunately, Private Auras come with several downsides: they are invisible to addons, which prevents customization; they are not supported in every context, such as nameplates; and setting them up across every encounter adds significant setup work for our designers. Secret values were created specifically to protect against cases like this, providing passive protection by default.

#### What is changing?
We’ll get to the changes to existing APIs shortly, but first, we’d like to introduce a couple of new constructs we are adding to Lua, along with two new object types (Aura Containers and Aura Buttons).

#### New Tech: Private Script Objects & The Forbidden Partition
Private Script Objects are a new construct that lets us split the Lua representation of a script object across multiple Lua tables, or partitions. One of these partitions we call the Forbidden Partition, because it is inaccessible to addons. The Forbidden Partition can contain any kind of value, from mixins to key/value pairs, functions, script handlers, and child objects. This allows us to effectively hide portions of the object from addon code even when the object itself isn’t in the secure environment.

#### New Tech: Forbidden Aspects
Forbidden Aspects are another new construct that works alongside Private Script Objects. Forbidden Aspects are similar in concept to the Secret Aspects we introduced in Midnight, but instead of causing certain object APIs to return secrets, they prevent addons from using certain functionality entirely. Where Secret Aspects obfuscate data, Forbidden Aspects restrict what addons are allowed to do with an object.

There are several Forbidden Aspects being added (details are in the docs), but let’s use the `UntrustedScriptExecution` Forbidden Aspect as an example. When a frame has the `UntrustedScriptExecution` Forbidden Aspect applied to it, any script binding handlers set on it (e.g. `OnShow`, `OnLoad`, `OnSizeChanged`) will not be run unless that handler lives in the object’s Forbidden Partition and execution is untainted. In other words, addons cannot install their own script bindings on the object, but our code can.

#### New Object Types: Aura Containers & Aura Buttons
Aura Containers and Aura Buttons are new Lua object types that allow addons to display auras in custom ways. Here’s a small example showing how they can be used:

```lua
local container = CreateFrame("AuraContainer", nil, UIParent, "CustomAuraContainerTemplate");
container:SetSize(1, 1);
container:SetPoint("CENTER");
container:SetUnit("target");
container:AddAuraFilter("HELPFUL", { maxFrameCount = 5 });

for i = 1, 5 do
	local auraButton = CreateFrame("AuraButton", nil, container, "CustomAuraButtonTemplate");
	auraButton:SetSize(40, 40);
	auraButton:SetPoint("TOPLEFT", container, "TOPLEFT", (i - 1) * 42, 0);
	auraButton.Icon = auraButton:CreateTexture(nil, "OVERLAY");
	auraButton.Icon:SetAllPoints(auraButton);
	auraButton:SetIcon(auraButton.Icon);
	auraButton.Text = auraButton:CreateFontString(nil, "ARTWORK", "GameFontNormal");
	auraButton.Text:SetPoint("TOP", auraButton, "BOTTOM", 0, -5);
	auraButton:SetDurationText(auraButton.Text);
	container:AddAuraFrame(auraButton);
end
```

In the example above, we create an Aura Container, specify that it should track the first 5 helpful auras on the player’s target, and then add 5 Aura Buttons to it. For each Aura Button, we create a texture for the icon and a font string for the duration. The APIs shown here on the Aura Button are just a sample of the APIs provided, but this should give you a sense of what is possible. Note that addon code still has a great deal of control over how the auras are presented, but it doesn’t interact with the underlying aura data at all. This separation is important for security, but it should also make custom aura displays easier to build and more performant. Aura Containers handle the tracking, filtering, and updating of aura assignments internally, so addons can focus more on presentation and less on repeatedly querying, diffing, and refreshing aura state themselves.

#### Why Are Aura Containers Safer?
To answer that, let’s go back to Private Script Objects and Forbidden Aspects again. Aura Buttons and Aura Containers both have Forbidden Aspects applied to them on creation. When an Aura Button is added to an Aura Container using the `AddAuraFrame` API, it is added to the Forbidden Partition of that Aura Container. This means addon code cannot install script handlers on Aura Buttons to be notified when they show or hide. It also cannot hook functions called on the Aura Button’s mixins or register events on those buttons. While addons can still hold references to those individual Aura Buttons, calling certain APIs on them will be disallowed, and they cannot run logic based on whether those buttons are shown, because `IsShown` and similar APIs return secrets.

#### Which current APIs are changing?
The main change to existing APIs is that, when auras are secret (during combat, encounters, M+, and PvP matches), all of the UnitAura APIs will now either return full secrets or `nil` when called by addons. That means that APIs like `GetUnitAuras` and `GetUnitAuraInstanceIDs` will return a secret vector, meaning addon code will not be able to determine how many auras it contains or iterate through it for display. Auras we explicitly flag as non-secret will still be returned as non-secret by UnitAura APIs, however.

#### Is all this in place in PTR Week 1?
No, several pieces of this are not currently implemented in the first PTR build but will be coming over the next few weeks. The biggest pieces not in place yet are the changes to the UnitAura APIs. Some Aura Button protections are also not yet in place: their script handlers are protected, but script handlers on their child frames are not, and event registration is still currently allowed. Those protections, along with additional safeguards, will arrive over the next few weeks. In the meantime, though, feel free to start experimenting!

---

#### Interface Texture Filenames
Starting in 12.1, new interface texture filenames will no longer be published to the ManifestInterfaceData DB, and as a result will not be available via `exportinterfacefiles art`. **Existing filenames will remain in the DB.** You may notice that a few entries are still added in 12.1 and over the next few patches, but this is due to those assets already having been added prior to this change being made. We are making this change to prevent leaks caused by texture names containing hints about future content. We understand that this is going to be a somewhat disruptive change for some addon developers, so please let us know your largest pain points and we'll try to make accommodations where possible.

#### Other changes in 12.1 PTR 1
- We now support showing SVG textures in our UI. They can be used on regular textures (e.g. `file="Path/To/Texture.svg"`) or with a new `VectorGraphics` object type, which renders them at higher quality.
  - Note that the VectorGraphics objects don't currently support all of the APIs on regular Textures (rotation, masking, tex coords, etc.)
- Load-on-Demand addons can now specify that specific files in the TOC should load on startup through a new per-file `[Bootstrap]` directive.
  - This still requires that the addon be enabled in order for these files to load.
- `UIParent.lua` has been heavily refactored, with all of the code that previously handled loading LoD addons moved into the addons themselves, taking advantage of the new `[Bootstrap]` directive.
- Added a new API `Frame:SetOnUpdateMode(mode)`, which lets you specify when the `OnUpdate` script on a frame should run. The options are `Disabled`, `RunWhenVisible` (default), `RunWhenVisibleOnce`, `RunOnce`, and `RunAlways`.
- A new system has been added called the Roleset System, which allows you to tag a frame as being part of a "roleset". You can then use the new `C_Roleset.ApplyRolesetFilters` to specify which rolesets are currently active.
  - Frames in an inactive roleset will never be shown, regardless of their shown state. See `Blizzard_UIModeManager.lua` for more details and examples.
- Radial masking support has been added to textures and status bars, allowing them to have a radial mask applied to them without the need for hacky uses of cooldowns. Example usage on a texture:

```lua
texture:SetRadialProgressBarPercent(0.5);
texture:SetRadialProgressBarStartOffset(0.25);
texture:SetRadialProgressBarEndOffset(0.75);
texture:SetRadialProgressBarReverse(true);
texture:SetRadialProgressBarFeather(0.125);
```

- KeyValues can now specify that their value should be pulled directly from the private addon table. Example usage: `<KeyValue key="myKey" type="local"/>`
- Mixins can now be added on an object using a new `<Mixins>` element.
  - Using this element allows you to use the `source="local"` specifier to indicate the mixin lives in the private addon table.
  - Mixins added on an object (either through the Mixins element or the regular `mixin="myMixin"` attribute) can also now be nested within tables.

Example usage:

```lua
local _addonName, addonTbl = ...;

local CustomFrameMixin = {};
addonTbl.CustomFrameMixin = CustomFrameMixin;

local NestedMixin = {};
addonTbl.Mixins = {};
addonTbl.Mixins.NestedMixin = NestedMixin;
```

```xml
<Frame name="TestFrame">
    <Mixins>
        <Mixin key="CustomFrameMixin" source="local"/>
        <Mixin key="Mixins.NestedMixin" source="local"/>
    </Mixins>
</Frame>
```

---

### 2026-06-23
**Midnight 12.1.0 PTR Changes 2** (Build 68301)

*Quick note: the previously mentioned restrictions to UnitAura APIs are currently planned for PTR 3, so any addons using those APIs should expect significant changes next week.*

#### Coming in 12.1.0 PTR 2
- Aura Buttons now support the following functionality:
  - Dispel borders: Using the `SetAuraBorder(texture, [options])` API.
  - Dispel type text: Using the `SetAuraSymbol(fontString, [options])` API.
  - Aura tooltips: Automatically enabled but can be disabled via the `SetMouseMotionEnabled` API.
- Added the following new **Forbidden Aspects**:
  - `UntrustedScriptExecution`: When active, addon-installed script handlers on a frame and its children will never be run.
  - `UntrustedLayoutScriptExecution`: When active, addon-installed `OnSizeChanged` handlers will never be run for a frame, its children, or any frames anchored to either.
  - `EventRegistrations`: When active, addons cannot register a frame for events.
  - `AlwaysPropagateInput`: When active, a frame and its children will always propagate mouse and keyboard input.
  - `ScriptedInput`: When active, addons are not allowed to call input-related APIs (`Click`, `SetFocus`, etc.) on a frame or its children.
  - `QueryFocus`: When active, addons cannot query if a frame or its children are the current mouse or keyboard focus.
- Aura Buttons have had the following Forbidden Aspects applied to them: `UntrustedScriptExecution`, `UntrustedLayoutScriptExecution`, `AlwaysPropagateInput`, `ScriptedInput`, and `QueryFocus`.
- Aura Containers have had the `EventRegistrations` Forbidden Aspect applied to them.
- Editboxes will no longer auto-focus if they become visible while they have the Shown secret aspect applied.
- API calls such as `SetParent` and `SetPoint` will error if an object would implicitly gain any Forbidden Aspects that it does not already have.

---

### 2026-06-30
**Midnight 12.1.0 PTR Changes 3** (Build 68412)

#### Coming in 12.1.0 PTR 3
- This week brings the majority of the UnitAura API restrictions (with a few small pieces still remaining). Broadly speaking you can consider APIs that return aura data are no longer safe for addon use while aura data is secret. More specifically:
  - `C_UnitAura` and `C_TooltipInfo` APIs that provide access to aura data via index, slot, or instance ID will Lua error when called by addons while auras are secret.
  - `C_UnitAura` APIs that provide access to aura data via spell ID or spell name can still be called by addons as before (non-secret spells still return non-secrets).
  - The `UNIT_AURA` event now delivers a fully secret payload while auras are secret. AuraData structs are now always fully secret.
- Added a new `ManagedAuraContainer` base type, which fully manages the display and layout of `AuraButtons`.
  - The Blizzard Target Frame now uses a `ManagedAuraContainer` for the display of its auras.
- Fixed a bug where only 14 of the 19 parameters were being passed to ChatFrame message event filter functions.

#### Preview of PTR 4
- `CustomAuraContainers` will be converted to `ManagedAuraContainers`. As a result, `AuraContainers` will now handle the creation of `AuraButtons` entirely on their own.
- `AuraContainer` support for filtering by Spell ID, dispel type, stealable, and max duration.
- `AuraContainer` support for sorting (both sort rule and direction).

---

### 2026-07-07
**Midnight 12.1.0 PTR Changes 4** (Build 68569)

#### Coming in 12.1.0 PTR 4
This week brings some major changes to `AuraContainers` and `AuraButtons`.

- `AuraContainers` now handle the creation and anchoring of all `AuraButtons` inside of them entirely on their own. Addons no longer create `AuraButtons` directly. The `AddAuraFrame` API has been removed.
- Added a new construct to `AuraContainers`: **AuraGroups**. An AuraGroup is a dynamic, self-managing collection of auras within an `AuraContainer`.
  - `AuraContainers` can have multiple `AuraGroups`, each with their own filters and settings.
  - Auras from each group are anchored sequentially in the order the groups were added.
- Addons add `AuraGroups` to `AuraContainers` using a new API: `AddAuraGroup(groupKey, filterString, options)`.
  - `groupKey`: An arbitrary addon-defined string used to access the group after creation.
  - `filterString`: Standard aura filter string (e.g. `"HELPFUL|RAID"`).
  - `options`:
    - `maxFrameCount`: Maximum number of aura frames to show.
    - `sortMethod` and `sortDirection`: Controls aura sorting (`AuraContainerSortMethod`).
    - `initializeFrame`: Callback function called for each `AuraButton` created.
    - `templateNames`: List of XML templates to apply.
    - `candidateFilters`: Includes/excludes for spell IDs, dispel types, `maxDuration`, boolean flags (`isFromPlayerOrPlayerPet`, `isRoleAura`, `isPriorityAura`, `isStealable`, etc.).
- `AuraGroups` create and anchor `AuraButtons` in batches of 10 as needed.
- Anchoring can be adjusted via `SetAuraGroupLayout`.
- `AuraContainers` automatically resize to fit group-based `AuraButtons`.
- `AuraContainers` treat private auras just like regular auras, allowing them to be shown and sorted normally.
- Added **AuraSlots**: AuraGroups with `maxFrameCount` set to 1. Addons can manually anchor AuraSlots using `AddAuraSlot(slotKey, filterString, options)`.
- Added `AddItemEnchantment(itemEnchantmentSlot, options)` to `AuraContainers` for temporary weapon enchants.
- Added `SetCancelAuraButtons` to `AuraButtons` to specify click options for cancellation.

#### Other changes
- Renamed `AddPrivateAuraAppliedSound` and `RemovePrivateAuraAppliedSound` to `AddAuraAppliedSound` and `RemoveAuraAppliedSound` (works on all auras).
- Added support for negating aura filters with `!` (e.g. `!PLAYER` = not cast by player).
- `UNIT_AURA` delivers fully secret payloads when auras are secret.
- `SecureAuraHeaderTemplate` removed from Mainline (kept for Classic). Migration to `AuraContainers` recommended.
- Fixed combat creation crash for `AuraContainer`. Added `SecureGroupHeaderTemplate` for unit frame creation.

---

### 2026-07-14
**Midnight 12.1.0 PTR Changes 5** (Build 68675)

#### Coming in 12.1.0 PTR 5
- Added new aura filter `DISPELLABLE`: returns auras with any dispel type regardless of raid dispel abilities.
- Restored `IMPORTANT` aura filter.
- `RAID_PLAYER_DISPELLABLE` now returns helpful auras on enemies dispellable/stealable by raid members.
- `AuraButtons` are forbidden whenever auras are secret (outside `initializeFrame` callback).
- Addons can no longer create `WorldFrame` instances via `CreateFrame`.
- Improved error messaging for forbidden script API calls.

---

### 2026-07-21
**Midnight 12.1.0 PTR Changes 6** (Build 68824)

#### Coming in 12.1.0 PTR 6
- Added `GetAuraGroupFrame` to `AuraContainer` to retrieve child aura group frames by index.
- Added `ApplicationBar` APIs to `CustomAuraButton` to display application count status bars.
- Added `SetAuraGroupFilterString` to `AuraContainer`.
- Added color curve/map support for `AuraButton:SetAuraBorder`.
- Supported custom ordering of aura groups within a container via `layoutIndex`.
- Added CVar `tooltipShowAuraSpellIDs` (shows spell IDs in aura tooltips, non-persistent).
- Renamed `AddAuraAppliedSound` -> `AddAuraSound` and `RemoveAuraAppliedSound` -> `RemoveAuraSound` with timing options (add, stack change, remove).
- Non-secret auras can be filtered using `excludeSpellIDs` and `includeSpellIDs` without restrictions on any unit.
- Added `FrameScriptObject:HasAccessConstraints` and `FrameScriptObject:CanBeAccessedInContext`.
- Prevented reparenting of `AuraButton` objects by addons.
- Temporary Weapon Enchants now support click-to-cancel.
- Boolean candidate filters support negation via `false` (e.g. `isStealable = false`).
- Added `C_Roleset.GetActiveBlockedRolesets` and `C_Roleset.GetActiveAllowedRolesets`.
- Added `Frame:IsRolesetFiltered` and `"alwaysBlocked"` roleset.

#### Preview of PTR 7
- Unit APIs returning secret values when unit identity is secret: `UnitClass`, `UnitClassBase`, `UnitIsOwnerOrControllerOfUnit`, `UnitSex`, `UnitSexBase`, `UnitPhaseReason`, `UnitGroupRolesAssigned`, `UnitGroupRolesAssignedEnum`, `UnitIsRaidOfficer`, `UnitInRaid`, `UnitIsPVP`, `UnitRace`, `UnitIsGroupLeader`, `UnitIsGroupAssistant`, `UnitLeadsAnyGroup`, `UnitGetAvailableRoles`, `GetInspectSpecialization`.
- `GetGuildInfo` no longer accepts compound unit tokens.
- `UnitIsCharmed` and `UnitIsPossessed` return secrets when auras are secret.

#### Aura Classifications (Removed from "never secret" list)
- **Preservation Evoker**: Dream Breath (355941), Dream Flight (363502), Echo (364343), Reversion (366155), Echo Reversion (367364), Lifebind (373267), Echo Dream Breath (376788), Verdant Embrace (409895)
- **Augmentation Evoker**: Blistering Scales (360827), Ebon Might (395152, 395296), Prescience (410089), Inferno's Blessing (410263), Symbiotic Bloom (410686), Shifting Sands (413984)
- **Resto Druid**: Rejuv (774), Regrowth (8936), Lifebloom (33763), Wild Growth (48438), Germination (155777), Symbiotic Blooms (439530)
- **Disc Priest**: Power Word: Shield (17), Atonement (194384), Void Shield (1253593), PW:S Unfolding Vision (1300008), Void Shield Unfolding Vision (1300009)
- **Holy Priest**: Renew (139), Prayer of Mending (41635), Echo of Light (77489)
- **Mistweaver Monk**: Soothing Mist (115175), Renewing Mist (119611), Enveloping Mist (124682), Aspect of Harmony (450769), Coalescence (1292922)
- **Restoration Shaman**: Earth Shield (974, 383648), Riptide (61295), Earthliving Weapon (382024), Ancestral Vigor (207400), Hydrobubble (444490)
- **Holy Paladin**: Beacon of Light (53563), Eternal Flame (156322), Beacon of Faith (156910), Beacon of the Savior (1244893), Beacon of Virtue (200025), Dawnlight (431381)

---

### 2026-07-23
**Midnight 12.1.0 PTR Changes 7** (Build 68914)

#### Coming in 12.1.0 PTR 7
- Support for column layouts in aura groups.
- `AuraContainers` can be created by addons during combat.
- Support for adjusting aura button tooltip anchors and hiding tooltips in combat.
- Added instance ID-only sort method for `AuraContainer`.
- Support for showing multiple dispel textures on an `AuraButton`.
- Added global APIs for configuring custom nineslice, backdrop, or texture slice assets for aura button tooltips.
- Native script object API calls (`SetPoint`, `SetSize`) permitted on `AuraButton` during UI reload until `PLAYER_LOGIN`.
- Added `ResizeToBoundsRect` frame API.
- `AuraContainers` with aura groups no longer receive `OnSizeChanged` updates.
- Unit APIs (`UnitClass`, `UnitRace`, `UnitSex`, etc.) return secret values when unit identity is secret.
- `UnitName` no longer returns secrets while in an active PvP match.

---

### 2026-08-04
**Midnight 12.1.0 PTR 8: Rise of the mouse** (Build 69111)

#### Coming in 12.1.0 PTR 8
- Added `AuraButton` APIs to show pandemic state via texture.
- Added `stealable` and `showAlways` options for `AuraButton` borders.
- Throttled `AuraButton` tooltips to update once every 200ms.
- Disabling an `AuraContainer` clears all `AuraButtons` and `ItemEnchantments`.
- `UnitIsPossessed` and `UnitIsCharmed` do not return secret values for `"player"`, `"pet"`, or `"vehicle"`.
- Fixed SVG rendering bug and duration text displaying 0 on `AuraButtons`.
- Resolved exploit using `OnSizeChanged` to track aura counts in an `AuraContainer`.

---

## Consolidated changes

### Global API

#### Added (143)
- `C_AuraContainerUtil.ProcessAuraTooltipBackdropOptions`
- `C_AuraContainerUtil.ProcessAuraTooltipNineSliceOptions`
- `C_AuraContainerUtil.ProcessAuraTooltipTextureSliceOptions`
- `C_AuraContainerUtil.ProcessCustomAuraButtonApplicationBarOptions`
- `C_AuraContainerUtil.ProcessCustomAuraButtonApplicationCountOptions`
- `C_AuraContainerUtil.ProcessCustomAuraButtonDispelTypeTextOptions`
- `C_AuraContainerUtil.ProcessCustomAuraButtonDispelTypeTextureOptions`
- `C_AuraContainerUtil.ProcessCustomAuraButtonDurationBarOptions`
- `C_AuraContainerUtil.ProcessCustomAuraButtonDurationTextOptions`
- `C_BattleNet.AreFriendTagsEnabled`
- `C_BattleNet.AreTitleFriendCustomNamesEnabled`
- `C_BattleNet.AreTitleFriendsEnabled`
- `C_BattleNet.BNCheckTitleFriendInviteToUnit`
- `C_BattleNet.CanToggleHighResTexturesWithoutClientReload`
- `C_BattleNet.GetCustomTitleFriendName`
- `C_BattleNet.GetFriendInviteInfo`
- `C_BattleNet.IsBattleNetFriendsListEnabled`
- `C_BattleNet.IsBattleNetFriendsListSupported`
- `C_BattleNet.SearchFriends`
- `C_BattleNet.SendTitleFriendInviteByName`
- `C_BattleNet.SendVerifiedBattleNetFriendInvite`
- `C_BattleNet.SetAppearOffline`
- `C_BattleNet.SetCustomTitleFriendName`
- `C_BattleNet.SetFriendTags`
- 🆕 `C_Browser.CloseFullscreenBrowser`
- `C_CVar.AreCVarsLoaded`
- `C_ClientScene.IsSceneTypeActive`
- `C_Club.SendTitleFriendRequest`
- `C_CooldownViewer.GetGroupBuffItems`
- `C_DelvesUI.GetFlavorNodeForCompanion`
- `C_DelvesUI.GetFlavorNodeNameForCompanion`
- 🆕 `C_DelvesUI.HasActiveLFGLair`
- `C_DelvesUI.HasActiveLair`
- 🆕 `C_DelvesUI.IsInLair`
- `C_Discord.Authorize`
- `C_Discord.GetDiscordChannelName`
- `C_Discord.GetDiscordUserID`
- `C_Discord.GetDisplayNameType`
- `C_Discord.GetGuildLinkStatus`
- `C_Discord.GetNumDiscordChannels`
- `C_Discord.GetNumDiscordServers`
- `C_Discord.GetServerLinkableChannels`
- `C_Discord.GetServerName`
- `C_Discord.GuildLink`
- `C_Discord.GuildUnlink`
- `C_Discord.IsEnabled`
- `C_Discord.IsGuildChannelLinked`
- `C_Discord.IsGuildSettingSet`
- `C_Discord.IsUserOAuthed`
- `C_Discord.RefreshAuth`
- `C_Discord.SetGuildSetting`
- `C_Discord.UpdateDiscordServers`
- `C_Discord.UpdateGuildLobby`
- `C_DyeColor.GetDyeColorsForItemLocation`
- `C_DyeColor.GetDyeColorsForItem`
- `C_EncounterJournal.GetBaseDifficultyID`
- `C_EncounterJournal.InstanceHasDifficultyID`
- `C_FriendList.IsLegacyFriendSystemEnabled`
- `C_GuildInfo.IsDiscordStreamSeparate`
- `C_HouseEditor.GetHouseEditorPlayerType`
- `C_Housing.HouseFinderIgnoreNeighborhood`
- `C_UnitAuras.AddAuraSound`
- `C_UnitAuras.RemoveAuraSound`
- ... *(and remaining global API additions)*

#### Removed (19)
- `C_UnitAuras.AddPrivateAuraAppliedSound`
- `C_UnitAuras.RemovePrivateAuraAppliedSound`
- `C_UnitAuras.AddAuraAppliedSound`
- `C_UnitAuras.RemoveAuraAppliedSound`
- `UIParentLoadAddOn`
- `CanAccessObject`
- `getglobal`
- `setglobal`
- ... *(and remaining removed APIs)*

---

## Deprecated API

- `getglobal(name)` -> Use `_G[name]`
- `setglobal(name, value)` -> Use `_G[name] = value`
- `UIParentLoadAddOn(addonName)` -> Use `LoadAddOnWithErrorHandling(addonName)`
- `CanAccessObject(object)` -> Use `FrameScriptObject:CanBeAccessedInContext()`
- `SecureAuraHeaderTemplate` -> Migrate to `AuraContainer`
