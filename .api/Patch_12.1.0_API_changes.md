# Patch 12.1.0/API changes

## Contents
1. [Resources](#resources)
2. [Notes](#notes)
3. [Blue posts](#blue-posts)
   - 3.1 2026-06-18
   - 3.2 2026-06-23
   - 3.3 2026-06-30
   - 3.4 2026-07-07
   - 3.5 2026-07-14
   - 3.6 2026-07-21
   - 3.7 2026-07-23
4. [Consolidated changes](#consolidated-changes)
   - 4.1 Global API
   - 4.2 FrameXML
   - 4.3 ScriptObjects
   - 4.4 Widgets
   - 4.5 Events
   - 4.6 CVars
   - 4.7 Enumerations
   - 4.8 Structures
5. [Deprecated API](#deprecated-api)

---

## Resources
- TOC: `120100`
- Official patch notes: Midnight: Curse of Ula’tek PTR Development Notes
- Diffs: wow-ui-source, BlizzardInterfaceResources

---

## Notes
- The Auto Loot setting (CVar `autoLootDefault`) is now account wide.
- SVG textures are now supported with the `VectorGraphics` object type.
- `UIParentLoadAddOn` has been renamed to `LoadAddOnWithErrorHandling`.
- Deprecated `getglobal` and `setglobal`.
- `CanAccessObject` has been replaced with `FrameScriptObject:CanBeAccessedInContext`.

---

## Blue posts

**Addons and Auras in Curse of Ula’tek** | 2026-06-18 17:00 | **JHemphill**

Since the launch of Midnight, we’ve continued to iterate on the addon-related changes introduced in the Midnight pre-patch. In the 12.1 Curse of Ula’tek update, we are pleased to be taking the next major step in that work. This work reflects the insights and feedback shared by our community, with a focus on auras, commonly referred to by players as buffs and debuffs.

These changes focus on preventing auras (whether on the player, enemies, or party and raid members) from leaking important combat information that can be used for combat automation. At the same time, we want addons to continue being able to show auras in a variety of custom ways.

To support that goal, Curse of Ula’tek will introduce new APIs that allow addons to display filtered sets of auras in customized ways, without exposing the underlying aura information that could be used for automation. Addons that currently display auras will need to be updated to support these new APIs, and we’ll be working directly with addon authors throughout the Curse of Ula’tek PTR to help them adapt to these changes and gather feedback during testing.

---

### 2026-06-18
**Midnight 12.1.0 PTR Changes 1 (Build 68209)**

Hello again from the World of Warcraft UI Engineering team! Today we’d like to talk about a significant set of Aura-related changes coming in 12.1. Most of these changes will be available when PTR launches, with the remaining pieces rolling out over the following few weeks.

**Why Auras?**  
Since the Addon Disarmament project went live with Midnight, Auras (aka buffs and debuffs) have consistently been one of the weakest areas for addon security, with numerous exploits discovered both before launch and since then. The core issue is that, in many cases, simply knowing that any aura is present on a unit (whether it be the player, an enemy, or a raid/party member) is enough to determine that some important combat event has occurred. Aura filters are vital for many legitimate addon use cases, but they also make this problem harder to contain by allowing even more ways to tell if “special aura X” is on a unit, even if the unit has multiple auras on them.

Up until now, our solution to this has been to lean on Private Auras. Unfortunately, Private Auras come with several downsides: they are invisible to addons, which prevents customization; they are not supported in every context, such as nameplates; and setting them up across every encounter adds significant setup work for our designers. Secret values were created specifically to protect against cases like this, providing passive protection by default.

**What is changing?**  
We’ll get to the changes to existing APIs shortly, but first, we’d like to introduce a couple of new constructs we are adding to Lua, along with two new object types (Aura Containers and Aura Buttons).

**New Tech: Private Script Objects & The Forbidden Partition**  
Private Script Objects are a new construct that lets us split the Lua representation of a script object across multiple Lua tables, or partitions. One of these partitions we call the Forbidden Partition, because it is inaccessible to addons. The Forbidden Partition can contain any kind of value, from mixins to key/value pairs, functions, script handlers, and child objects. This allows us to effectively hide portions of the object from addon code even when the object itself isn’t in the secure environment.

**New Tech: Forbidden Aspects**  
Forbidden Aspects are another new construct that works alongside Private Script Objects. Forbidden Aspects are similar in concept to the Secret Aspects we introduced in Midnight, but instead of causing certain object APIs to return secrets, they prevent addons from using certain functionality entirely. Where Secret Aspects obfuscate data, Forbidden Aspects restrict what addons are allowed to do with an object.

There are several Forbidden Aspects being added (details are in the docs), but let’s use the UntrustedScriptExecution Forbidden Aspect as an example. When a frame has the UntrustedScriptExecution Forbidden Aspect applied to it, any script binding handlers set on it (e.g. OnShow, OnLoad, OnSizeChanged) will not be run unless that handler lives in the object’s Forbidden Partition and execution is untainted. In other words, addons cannot install their own script bindings on the object, but our code can.

**New Object Types: Aura Containers & Aura Buttons**  
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

In the example above, we create an Aura Container, specify that it should track the first 5 helpful auras on the player’s target, and then add 5 Aura Buttons to it. For each Aura Button, we create a texture for the icon and a font string for the duration. The APIs shown here on the Aura Button are just a sample of the APIs provided (full details will be in the docs), but this should give you a sense of what is possible. Note that addon code still has a great deal of control over how the auras are presented, but it doesn’t interact with the underlying aura data at all. This separation is important for security, but it should also make custom aura displays easier to build and more performant. Aura Containers handle the tracking, filtering, and updating of aura assignments internally, so addons can focus more on presentation and less on repeatedly querying, diffing, and refreshing aura state themselves.

**Why Are Aura Containers Safer?**  
To answer that, let’s go back to Private Script Objects and Forbidden Aspects again. Aura Buttons and Aura Containers both have Forbidden Aspects applied to them on creation. When an Aura Button is added to an Aura Container using the `AddAuraFrame` API, it is added to the Forbidden Partition of that Aura Container. This means addon code cannot install script handlers on Aura Buttons to be notified when they show or hide. It also cannot hook functions called on the Aura Button’s mixins or register events on those buttons. While addons can still hold references to those individual Aura Buttons, calling certain APIs on them will be disallowed, and they cannot run logic based on whether those buttons are shown, because IsShown and similar APIs return secrets.

**Which current APIs are changing?**  
The main change to existing APIs is that, when auras are secret (during combat, encounters, M+, and PvP matches), all of the UnitAura APIs will now either return full secrets or nil when called by addons. That means that APIs like `GetUnitAuras` and `GetUnitAuraInstanceIDs` will return a secret vector, meaning addon code will not be able to determine how many auras it contains or iterate through it for display. Auras we explicitly flag as non-secret will still be returned as non-secret by UnitAura APIs, however.

**Is all this in place in PTR Week 1?**  
No, several pieces of this are not currently implemented in the first PTR build but will be coming over the next few weeks. The biggest pieces not in place yet are the changes to the UnitAura APIs. Some Aura Button protections are also not yet in place: their script handlers are protected, but script handlers on their child frames are not, and event registration is still currently allowed. Those protections, along with additional safeguards, will arrive over the next few weeks. In the meantime, though, feel free to start experimenting!

As always, we are actively seeking your feedback and will be monitoring the author-wishlist channel, so please share feedback, bugs, and any potential exploits there. Thanks as always for helping us test and improve this system!

**Interface Texture Filenames**  
Starting in 12.1, new interface texture filenames will no longer be published to the ManifestInterfaceData DB, and as a result will not be available via `exportinterfacefiles art`. **Existing filenames will remain in the DB.** You may notice that a few entries are still added in 12.1 and over the next few patches, but this is due to those assets already having been added prior to this change being made. We are making this change to prevent leaks caused by texture names containing hints about future content. We understand that this is going to be a somewhat disruptive change for some addon developers, so please let us know your largest pain points and we'll try to make accommodations where possible.

**Other changes in 12.1 PTR 1**  
- We now support showing SVG textures in our UI. They can be used on regular textures (e.g. `file="Path/To/Texture.svg"`) or with a new `VectorGraphics` object type, which renders them at higher quality.
  - Note that the VectorGraphics objects don't currently support all of the APIs on regular Textures (rotation, masking, tex coords, etc.)
- Load-on-Demand addons can now specify that specific files in the TOC should load on startup through a new per-file `[Bootstrap]` directive.
  - This still requires that the addon be enabled in order for these files to load.
- `UIParent.lua` has been heavily refactored, with all of the code that previously handled loading LoD addons moved into the addons themselves, taking advantage of the new `[Bootstrap]` directive.
- Added a new API `Frame:SetOnUpdateMode(mode)`, which lets you specify when the `OnUpdate` script on a frame should run.
- The options are `Disabled`, `RunWhenVisible` (default), `RunWhenVisibleOnce`, `RunOnce`, and `RunAlways`.
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
**Midnight 12.1.0 PTR Changes 2 (Build 68301)**

**Quick note:** the previously mentioned restrictions to UnitAura APIs are currently planned for PTR 3, so any addons using those APIs should expect significant changes next week.

**Coming in 12.1.0 PTR 2**
- Aura Buttons now support the following functionality:
  - Dispel borders: Using the `SetAuraBorder(texture, [options])` API (see `DefaultAuraBorderOptions` for available options).
  - Dispel type text: Using the `SetAuraSymbol(fontString, [options])` API (see `DefaultAuraSymbolOptions` for available options).
  - Aura tooltips: Automatically enabled but can be disabled via the `SetMouseMotionEnabled` API.
- Added the following new Forbidden Aspects:
  - `UntrustedScriptExecution`: When active, addon-installed script handlers on a frame and its children will never be run.
  - `UntrustedLayoutScriptExecution`: When active, addon-installed `OnSizeChanged` handlers will never be run for a frame, its children, or any frames anchored to either.
  - `EventRegistrations`: When active, addons cannot register a frame for events.
  - `AlwaysPropagateInput`: When active, a frame and its children will always propagate mouse and keyboard input.
  - `ScriptedInput`: When active, addons are not allowed to call input-related APIs (Click, SetFocus, etc.) on a frame or its children.
  - `QueryFocus`: When active, addons cannot query if a frame or its children are the current mouse or keyboard focus.
- Aura Buttons have had the following Forbidden Aspects applied to them: `UntrustedScriptExecution`, `UntrustedLayoutScriptExecution`, `AlwaysPropagateInput`, `ScriptedInput`, and `QueryFocus`.
- Aura Containers have had the `EventRegistrations` Forbidden Aspect applied to them.
- Editboxes will no longer auto-focus if they become visible while they have the `Shown` secret aspect applied.
- API calls such as `SetParent` and `SetPoint` will error if an object would implicitly gain any Forbidden Aspects that it does not already have.

---

### 2026-06-30
**Midnight 12.1.0 PTR Changes 3 (Build 68412)**

**Coming in 12.1.0 PTR 3**
- This week brings the majority of the UnitAura API restrictions (with a few small pieces still remaining). Broadly speaking you can consider APIs that return aura data are no longer safe for addon use while aura data is secret. More specifically:
  - `C_UnitAura` and `C_TooltipInfo` APIs that provide access to aura data via index, slot, or instance ID will Lua error when called by addons while auras are secret.
  - `C_UnitAura` APIs that provide access to aura data via spell ID or spell name can still be called by addons as before (non-secret spells still return non-secrets).
  - The `UNIT_AURA` event now delivers a fully secret payload while auras are secret. AuraData structs are now always fully secret.
- Added a new `ManagedAuraContainer` base type, which fully manages the display and layout of `AuraButtons`.
  - The Blizzard Target Frame now uses a `ManagedAuraContainer` for the display of its auras.
- Fixed a bug where only 14 of the 19 parameters were being passed to ChatFrame message event filter functions.

**Preview of PTR 4**
PTR 4 will add a whole swath of changes for AuraContainers and AuraButtons including:
- CustomAuraContainers will be converted to ManagedAuraContainers. As a result, AuraContainers will now handle the creation of AuraButtons entirely on their own.
- AuraContainer support for filtering by Spell ID, dispel type, stealable, and max duration. Some filters will have restrictions - more details to come.
- AuraContainer support for sorting (both sort rule and direction).

---

### 2026-07-07
**Midnight 12.1.0 PTR Changes 4 (Build 68569)**

**Coming in 12.1.0 PTR 4**  
This week brings some major changes to AuraContainers and AuraButtons.
- AuraContainers now handle the creation and anchoring of all AuraButtons inside of them entirely on their own.
  - Addons no longer create AuraButtons directly. The `AddAuraFrame` API has been removed.
- Added a new construct to AuraContainers: *AuraGroups*. Broadly speaking, you can think of an AuraGroup as a dynamic, self-managing collection of auras within an AuraContainer.
  - AuraContainers can have multiple AuraGroups, each with their own filters and settings.
  - Auras from each group are anchored sequentially in the order the groups were added.
- Addons add AuraGroups to AuraContainers using a new API `AddAuraGroup(groupKey, filterString, options)`.
  - The `groupKey` param is an arbitrary addon-defined string used to access the group after creation.
  - The `filterString` param is a standard aura filter string as used today (e.g. `"HELPFUL|RAID"`).
  - The `options` param is a table that can contain a number of optional settings:
    - `maxFrameCount`: The maximum number of aura frames to show in this group
    - `sortMethod` and `sortDirection`: Used to control how auras in this group are sorted (see new enum AuraContainerSortMethod for choices).
    - `initializeFrame`: A callback function that is called for each AuraButton created.
    - `templateNames`: A list of xml templates to apply to each AuraButton (in addition to `CustomAuraButtonTemplate`).
    - `candidateFilters`: A table of additional filter information to apply when determining if an aura should be displayed. See `ValidateCandidateFilters` for the full list of options, but some examples are:
      - Include/exclude maps for spell IDs and dispel types.
      - `maxDuration`
      - Various boolean values from AuraData (`isFromPlayerOrPlayerPet`, `isRoleAura`, `isPriorityAura`, `isStealable`, etc.).
- AuraGroups create and anchor AuraButtons in batches of 10 as needed.
- Anchoring of AuraButtons created by an AuraContainer can be adjusted via the `SetAuraGroupLayout` API (see `ValidateAuraGroupLayoutOptions` for available options).
- AuraContainers now automatically resize to fit group-based AuraButtons inside of them.
- AuraContainers now treat private auras just like regular auras, allowing them to be shown and sorted normally.
- Added a new construct to AuraContainers: *AuraSlots*. You can think of AuraSlots as AuraGroups with `maxFrameCount` set to 1 (they will only ever show a single aura).
  - Unlike AuraGroups, addons can manually anchor AuraSlots.
  - The `AddAuraSlot(slotKey, filterString, options)` API is used to add AuraSlots, and it supports most of the same options `AddAuraGroup` does.
- Added a new API, `AddItemEnchantment(itemEnchantmentSlot, options)`, to AuraContainers, which allows them to show temporary weapon enchants. See `ValidateAddItemEnchantmentOptions` for the list of options supported.
- Added a new API `SetCancelAuraButtons` to AuraButtons that can be used to specify which mouse clicks to use to cancel. This can be called on AuraButtons via the `initializeFrame` callback.

**Other changes**
- The `AddPrivateAuraAppliedSound` and `RemovePrivateAuraAppliedSound` APIs have been renamed to `AddAuraAppliedSound` and `RemoveAuraAppliedSound`, and now work on any auras (not just private auras).
- Added support for negating most aura filters using the `!` character. So for instance `!PLAYER` includes only auras NOT cast by the player.
- The `UNIT_AURA` event now delivers a fully secret payload while auras are secret. AuraData structs are now always fully secret.
- `SecureAuraHeaderTemplate` has been removed from Mainline (it will still exist for Classic). Addons still using `SecureAuraHeaderTemplate` should migrate over to using AuraContainers.
- Fixed a crash that happened when attempting to create an AuraContainer in combat.
  - Attempting to do so will still generate a Lua error, however (as intended).
  - Added a new `SecureGroupHeaderTemplate` xml template that can be used to safely create a single AuraContainer on UnitFrame creation.
- Resolved an issue where the `SetApplicationCount` function on CustomAuraButtons would error if not supplied an options table.
- Resolved an issue where `ApplyAuraSymbol` on CustomAuraButtons was consulting the wrong region (AuraButton) for dispel type validation.

---

### 2026-07-14
**Midnight 12.1.0 PTR Changes 5 (Build 68675)**

**Coming in 12.1.0 PTR 5**
- Added a new aura filter, `DISPELLABLE`, which returns auras that have a dispel type of any kind, regardless of whether anyone in the player's raid can dispel it.
- Added back the `IMPORTANT` aura filter now that it is no longer abusable.
- The `RAID_PLAYER_DISPELLABLE` aura filter now also returns helpful auras on enemies that are dispellable/stealable by a raid member.
- AuraButtons are now forbidden (meaning APIs called on them via tainted code will Lua error) **whenever auras are secret**.
  - This forbidden state is not applied until after the `initializeFrame` callback has been called, and AuraButtons return to a non-forbidden state when auras become non-secret again (outside combat, encounters, etc.).
  - This change was necessary in order to prevent various exploits.
- It is no longer possible for addons to create new WorldFrame instances via `CreateFrame` (preventing a crash).
- Made improvements to the error messaging displayed when attempting to call forbidden script APIs on script objects.

---

### 2026-07-21
**Midnight 12.1.0 PTR Changes 6 (Build 68824)**

**Coming in 12.1.0 PTR 6**
- Added a new `GetAuraGroupFrame` API to aura containers, which can be used to retrieve a child aura group frame by index.
- Added new `ApplicationBar` APIs to custom aura buttons that allow addons to show a status bar that tracks their number of applications.
- Added a new `SetAuraGroupFilterString` API to aura containers, which allows addons to set the filter string after creation.
- Added support for color curves and color maps to the `AuraButton:SetAuraBorder` API (see `CustomAuraButtonBorderOptions` in the documentation files for details).
- Addons can now specify custom ordering for the aura groups within an aura container, using the new `layoutIndex` option in the layout options table.
- Added a new CVar `tooltipShowAuraSpellIDs` (Game, Default: 0) which causes spell IDs to show in aura tooltips. This CVar will not persist between sessions.
- The `AddAuraAppliedSound` API has been renamed `AddAuraSound` and now supports specifying whether the sound should play when an aura is first added, gains an application or removed.
  - The `RemoveAuraAppliedSound` API has been renamed `RemoveAuraSound` to match.
- Auras flagged as non-secret can now be filtered using `excludeSpellIDs` and `includeSpellIDs` without restrictions on any unit.
- Added new APIs `FrameScriptObject:HasAccessConstraints` and `FrameScriptObject:CanBeAccessedInContext` to script objects.
- Fixed a bug that was causing the cooldown swipe to show incorrectly in some cases.
- Fixed a bug where calling some APIs (like `FormatNumber`) with secrets would cause objects to be marked as secret incorrectly (and result in Lua Errors).
- Addons are no longer allowed to reparent aura buttons.
- Temporary Weapon Enchants now support click-to-cancel.
- Boolean candidate filters now support negation by setting the boolean as false (e.g. `isStealable = false`). Leaving the option as nil will continue to mean "ignore".
- Added new `GetActiveBlockedRolesets` and `GetActiveAllowedRolesets` APIs to `C_Roleset`, which return the list of currently blocked and allowed rolesets.
- Added a new `IsRolesetFiltered` API on frames, which returns whether the frame is currently filtered by roleset.
- Added a new `"alwaysBlocked"` roleset, which can be applied to frames to cause them to never show.

**Preview of PTR 7**
- A number of Unit APIs are being changed to return secret values when the unit's identity is secret. This is being done to prevent various methods of combining these API calls to compare secret units to each other in combat.
  - APIs affected: `UnitClass`, `UnitClassBase`, `UnitIsOwnerOrControllerOfUnit`, `UnitSex`, `UnitSexBase`, `UnitPhaseReason`, `UnitGroupRolesAssigned`, `UnitGroupRolesAssignedEnum`, `UnitIsRaidOfficer`, `UnitInRaid`, `UnitIsPVP`, `UnitRace`, `UnitIsGroupLeader`, `UnitIsGroupAssistant`, `UnitLeadsAnyGroup`, `UnitGetAvailableRoles`, `GetInspectSpecialization`.
- The `GetGuildInfo` API is being changed to no longer accept compound unit tokens.
- The following APIs are being changed to return secret values when auras are secret: `UnitIsCharmed`, `UnitIsPossessed`.

**Aura Classifications**  
Now that custom aura containers can be used to filter and position helpful auras on raid members, we have removed the following healer buffs and HoTs from the "never secret" list:

| Class / Spec | Spell IDs & Names |
| :--- | :--- |
| **Preservation Evoker** | 355941 Dream Breath, 363502 Dream Flight, 364343 Echo, 366155 Reversion, 367364 Echo Reversion, 373267 Lifebind, 376788 Echo Dream Breath, 409895 Verdant Embrace |
| **Augmentation Evoker** | 360827 Blistering Scales, 395152 / 395296 Ebon Might, 410089 Prescience, 410263 Inferno's Blessing, 410686 Symbiotic Bloom, 413984 Shifting Sands |
| **Resto Druid** | 774 Rejuv, 8936 Regrowth, 33763 Lifebloom, 48438 Wild Growth, 155777 Germination, 439530 Symbiotic Blooms |
| **Disc Priest** | 17 Power Word: Shield, 194384 Atonement, 1253593 Void Shield, 1300008 Power Word: Shield (Unfolding Vision), 1300009 Void Shield (Unfolding Vision) |
| **Holy Priest** | 139 Renew, 41635 Prayer of Mending, 77489 Echo of Light |
| **Mistweaver Monk** | 115175 Soothing Mist, 119611 Renewing Mist, 124682 Enveloping Mist, 450769 Aspect of Harmony, 1292922 Coalescence |
| **Restoration Shaman** | 974 / 383648 Earth Shield, 61295 Riptide, 382024 Earthliving Weapon, 207400 Ancestral Vigor, 444490 Hydrobubble |
| **Holy Paladin** | 53563 Beacon of Light, 156322 Eternal Flame, 156910 Beacon of Faith, 1244893 Beacon of the Savior, 200025 Beacon of the Virtue, 431381 Dawnlight |

---

### 2026-07-23
**Midnight 12.1.0 PTR Changes 7 (Build 68914)**

**Coming in 12.1.0 PTR 7**
- Added support for laying out aura groups in columns.
- Aura containers can now be created by addons during combat.
- Added support for adjusting aura button tooltip anchors.
- Added support for hiding aura button tooltips while in combat.
- Added a new aura instance ID-only sort method for aura containers, which sorts the auras by aura instance ID.
- Added support for showing multiple dispel textures on an aura button.
- Added new APIs to configure custom nineslice, backdrop, or background texture slice assets to use for all aura button tooltips. Note that these are global APIs that apply to all aura buttons (not to individual aura containers).
- Aura buttons now permit native script object API calls - such as `SetPoint`, `SetSize` - during UI (re)load, until execution of `PLAYER_LOGIN`.
- Added a new addon-safe API, `ResizeToBoundsRect`, which can be used to resize a frame to match the bounds of its children.
- Resolved an issue that was causing addons to not be able to call aura button APIs outside of the `initializeFrame` callback.
- Resolved an issue where a Lua error would occur when toggling visibility of an aura container while the mouse was over a visible aura button.
- Resolved an issue involving the `CastingBarTypeInfo` table which was causing taint issues in nameplates.
- Resolved an issue causing Lua errors when addons used `PingableUnitFrameTemplate`.
- Child components of aura buttons can no longer be re-parented once configured.
- Aura containers that are configured to show aura groups will no longer receive `OnSizeChanged` updates. Note that this restriction also applies to frames anchored to aura containers (but only after the aura container has an aura group added).
- A number of Unit APIs have been changed to return secret values when the unit's identity is secret. This is being done to prevent various methods of combining these API calls to compare secret units to each other in combat.
  - APIs affected: `UnitClass`, `UnitClassBase`, `UnitIsOwnerOrControllerOfUnit`, `UnitSex`, `UnitSexBase`, `UnitPhaseReason`, `UnitGroupRolesAssigned`, `UnitGroupRolesAssignedEnum`, `UnitIsRaidOfficer`, `UnitInRaid`, `UnitIsPVP`, `UnitRace`, `UnitIsGroupLeader`, `UnitIsGroupAssistant`, `UnitLeadsAnyGroup`, `UnitGetAvailableRoles`, `GetInspectSpecialization`.
  - The following APIs now return secret values when auras are secret: `UnitIsCharmed`, `UnitIsPossessed`.
  - The `GetGuildInfo` API no longer accepts compound unit tokens.
  - The `UnitName` API will no longer return secrets while in an active PvP match.

---

## Consolidated changes
12.0.7 (68256) → PTR 12.1.0 (68824) Jul 20 2026

### Global API
**Added (128):**
`C_AuraContainerUtil.ProcessCustomAuraButtonBorderOptions`, `C_BattleNet.AreFriendTagsEnabled`, `C_BattleNet.AreTitleFriendCustomNamesEnabled`, `C_BattleNet.AreTitleFriendsEnabled`, `C_BattleNet.BNCheckTitleFriendInviteToUnit`, `C_BattleNet.CanToggleHighResTexturesWithoutClientReload`, `C_BattleNet.GetCustomTitleFriendName`, `C_BattleNet.GetFriendInviteInfo`, `C_BattleNet.IsBattleNetFriendsListEnabled`, `C_BattleNet.IsBattleNetFriendsListSupported`, `C_BattleNet.SearchFriends`, `C_BattleNet.SendTitleFriendInviteByName`, `C_BattleNet.SendVerifiedBattleNetFriendInvite`, `C_BattleNet.SetAppearOffline`, `C_BattleNet.SetCustomTitleFriendName`, `C_BattleNet.SetFriendTags`, `C_CVar.AreCVarsLoaded`, `C_ClientScene.IsSceneTypeActive`, `C_Club.SendTitleFriendRequest`, `C_CooldownViewer.GetGroupBuffItems`, `C_DelvesUI.GetFlavorNodeForCompanion`, `C_DelvesUI.GetFlavorNodeNameForCompanion`, `C_DelvesUI.HasActiveLair`, `C_Discord.Authorize`, `C_Discord.GetDiscordChannelName`, `C_Discord.GetDiscordUserID`, `C_Discord.GetDisplayNameType`, `C_Discord.GetGuildLinkStatus`, `C_Discord.GetNumDiscordChannels`, `C_Discord.GetNumDiscordServers`, `C_Discord.GetServerLinkableChannels`, `C_Discord.GetServerName`, `C_Discord.GuildLink`, `C_Discord.GuildUnlink`, `C_Discord.IsEnabled`, `C_Discord.IsGuildChannelLinked`, `C_Discord.IsGuildSettingSet`, `C_Discord.IsUserOAuthed`, `C_Discord.RefreshAuth`, `C_Discord.SetGuildSetting`, `C_Discord.UpdateDiscordServers`, `C_Discord.UpdateGuildLobby`, `C_DyeColor.GetDyeColorsForItemLocation`, `C_DyeColor.GetDyeColorsForItem`, `C_EncounterJournal.GetBaseDifficultyID`, `C_EncounterJournal.InstanceHasDifficultyID`, `C_FriendList.IsLegacyFriendSystemEnabled`, `C_GuildInfo.IsDiscordStreamSeparate`, `C_HouseEditor.GetHouseEditorPlayerType`, `C_Housing.HouseFinderIgnoreNeighborhood`, `C_Housing.IsInsideOwnedHouseOrPlot`, `C_Housing.IsInsideOwnedHouse`, `C_Housing.IsInsideOwnedPlot`, `C_Housing.ResetHouse`, `C_HousingBlueprint.CanImportTypeFromCurrentLocation`, `C_HousingBlueprint.DeleteBlueprint`, `C_HousingBlueprint.ExportBlueprint`, `C_HousingBlueprint.ExportRoomBlueprint`, `C_HousingBlueprint.GetBlueprintHyperlink`, `C_HousingBlueprint.GetBlueprintTypeForCode`, `C_HousingBlueprint.GetExportAvailability`, `C_HousingBlueprint.GetFeatureAvailability`, `C_HousingBlueprint.GetImportAvailability`, `C_HousingBlueprint.ImportBlueprint`, `C_HousingBlueprint.IsShareCodeValid`, `C_HousingBlueprint.RenameBlueprint`, `C_HousingBlueprint.RequestBlueprintCollection`, `C_HousingBlueprint.RequestBlueprintContentsForContext`, `C_HousingBlueprint.RequestBlueprintContents`, `C_HousingBlueprint.StartImportRoomBlueprint`, `C_HousingCustomizeMode.ApplyPetToSelectedDecor`, `C_HousingCustomizeMode.GetSelectedDecorPetInfo`, `C_HousingDecor.AnyDecorPlacedInRoom`, `C_HousingDecor.GetAllMaxPlacementBudgets`, `C_HousingDecor.GetAllSpentPlacementBudgets`, `C_HousingDecor.GetDecorAssignedPetName`, `C_HousingDecor.GetDecorCanAttachPet`, `C_HousingDecor.GetMaxPetPlacementBudget`, `C_HousingDecor.GetSpentPetPlacementBudget`, `C_HousingLayout.GetBaseRoomFloor`, `C_HousingLayout.GetHighestOccupiedFloorIndex`, `C_HousingLayout.GetLowestOccupiedFloorIndex`, `C_HousingLayout.GetRoomPlayerIsIn`, `C_HousingLayout.GetSelectedBlueprintFloorplan`, `C_HousingLayout.HasSelectedBlueprintFloorplan`, `C_Item.DoesItemMatchSpellItemCondition`, `C_LFGList.ConfirmCensoredActiveEntry`, `C_LFGList.DoesCensoredTextMatch`, `C_LFGList.IsCensoredActiveEntryUnresolved`, `C_LFGList.RevealCensoredActiveEntry`, `C_LFGList.RevealCensoredSearchResult`, `C_Navigation.GetNextWaypointForMap`, `C_NeighborhoodInitiative.GetInitiativeTaskRewardScaling`, `C_PaperDollInfo.CancelTemporaryEnchantment`, `C_PaperDollInfo.GetInventorySlotInfoForInvSlot`, `C_PaperDollInfo.GetInventorySlotInfo`, `C_PaperDollInfo.GetTemporaryEnchantmentInfo`, `C_PetJournal.GetPetInfoTableBySpeciesID`, `C_PvP.CanSurrenderArena`, `C_PvP.JoinRandomTrainingGroundArena`, `C_PvP.JoinRandomTrainingGroundBattleground`, `C_QuestHub.IsAreaPOICurrentlyRelatedToHub`, `C_RecentAllies.SearchRecentAllies`, `C_RecruitAFriend.IsSystemEnabled`, `C_RecruitAFriend.IsSystemSupported`, `C_Roleset.ApplyRolesetFilters`, `C_Roleset.GetActiveAllowedRolesets`, `C_Roleset.GetActiveBlockedRolesets`, `C_SocialQueue.IsSystemEnabled`, `C_SocialQueue.IsSystemSupported`, `C_SocialRestrictions.IsFriendsDisabled`, `C_SocialUI.IsSystemEnabled`, `C_Sound.PlaySoundWithOptions`, `C_Spell.GetLastCategoryCooldownSource`, `C_Spell.GetSpellDescriptionForItemLocation`, `C_Spell.TargetSpellChecksItemCondition`, `C_TransmogOutfitInfo.CanPlayerTransmogSlot`, `C_TransmogOutfitInfo.IsTransmogEnabled`, `C_UnitAuras.AddAuraSound`, `C_UnitAuras.CancelAuraByInstanceID`, `C_UnitAuras.GetGroupBuffVisualAlerts`, `C_UnitAuras.GetHiddenGroupBuffs`, `C_UnitAuras.RemoveAuraSound`, `C_UnitAuras.SetGroupBuffVisualAlerts`, `C_UnitAuras.SetHiddenGroupBuffs`, `GetSpecializationSystem`, `securecopy`, `settablesecurity`.

**Removed (18):**
`BNGetFriendInviteInfo`, `BNSendVerifiedBattleTagInvite`, `C_DyeColor.GetDyeColorForItemLocation`, `C_DyeColor.GetDyeColorForItem`, `C_Housing.IsInsideOwnHouse`, `C_HousingLayout.GetNumFloors`, `C_Ping.GetContextualPingTypeForUnit`, `C_PvP.JoinRandomTrainingGround`, `C_RecruitAFriend.IsEnabled`, `C_SuperTrack.GetNextWaypointForMap`, `C_UnitAuras.AddPrivateAuraAppliedSound`, `C_UnitAuras.RemovePrivateAuraAppliedSound`, `C_UnitAuras.TriggerPrivateAuraShowDispelType`, `CanSurrenderArena`, `CancelItemTempEnchantment`, `GetInventorySlotInfo`, `GetWeaponEnchantInfo`, `SetTableSecurityOption`.

**Changed:**
- `C_ActionBar.ForceUpdateAction`: added `arg2 = suppressEvents`
- `C_CombatAudioAlert.SpeakText`: added `ret1 = utteranceID`, MayReturnNothing
- `C_HousingDecor.GetMaxPlacementBudget`: ret1.Nilable changed false -> true
- `C_HousingDecor.GetSpentPlacementBudget`: ret1.Nilable changed false -> true
- `C_HousingLayout.GetRoomPlacementBudget`: ret1.Nilable changed false -> true
- `C_HousingLayout.GetSpentPlacementBudget`: ret1.Nilable changed false -> true
- `C_Ping.SendMacroPing`: arg1 changed from PingSubjectType to PingMacroInfo, removed `arg2 = targetToken`
- `C_QuestHub.IsQuestCurrentlyRelatedToHub`: arg2 areaPoiID -> hubAreaPoiID
- `C_RecruitAFriend.CanSummonFriend`: ret1 result -> canSummon, added `ret2 = reason`, MayReturnNothing
- `C_Sound.PlaySound`: added `arg6 = volumeOverride`
- `C_Spell.GetSpellTexture`: added `ret3 = conditionalIconID`
- `CreateSecureDelegate`: added `arg2 = options`

### FrameXML
**Added (Summary of 332 entries):**
Includes functions such as `AchievementFrame_RefreshBackButton`, `AchievementFrame_SetComparisonMode`, `AddBehavioralMessagingTrayToStatusFrames`, `AddFriendFrame_Show`, `AuraUtil.GetUnitAuras`, `ChatFrameUtil.FormatDiscordMessage`, `CombatAudioAlertUtil.GetInterruptCastInfo`, `CooldownViewer_MarkAuraCacheDirty`, `LoadAddOnWithErrorHandling`, `NarrationUtil.NarrateCurrentScreen`, `SocialUIUtil.SetBattleNetPresenceFromSocialUIPresence`, `UIModeUtil.RegisterMode`, `VisualAlerts_RegisterAll`, and many others.

**Removed (Summary of 123 entries):**
Includes `getglobal`, `setglobal`, `CanAccessObject`, `SecureAuraHeader_Update`, `UIParentLoadAddOn`, `GetSmoothProgressChange`, `AnimateTexCoords`, `ButtonPulse_OnUpdate`, `SmartShow`, `SmartHide`, etc.

### ScriptObjects
**Added (8):**
- `RadialProgress:GetFromPercent`
- `RadialProgress:GetToPercent`
- `RadialProgress:SetFromPercent`
- `RadialProgress:SetToPercent`
- `DurationTextBinding:ClearTextColorCurve`
- `DurationTextBinding:GetFormattedTextColor`
- `DurationTextBinding:GetTextColorCurve`
- `DurationTextBinding:SetTextColorCurve`

### Widgets
**Added (38):**
Includes `FrameScriptObject:AddAccessRestrictions`, `FrameScriptObject:AddForbiddenAspects`, `FrameScriptObject:AddSecretAspect`, `FrameScriptObject:CanBeAccessedInContext`, `FrameScriptObject:HasAccessConstraints`, `FontString:SetDesaturateEmbeddedTextures`, `TextureBase:SetRadialProgressBarPercent`, `Frame:AddRoleset`, `Frame:SetOnUpdateMode`, `Frame:IsRolesetFiltered`, `VectorGraphics:SetSVG`, `StatusBar:SetRenderMode`, etc.

**Changed:**
`Animation:GetScript`, `Animation:HookScript`, `Animation:SetScript`, `AnimationGroup:GetScript`, `AnimationGroup:HookScript`, `AnimationGroup:SetScript`, `FrameScriptObject:SetToDefaults`, `ScriptRegion:ClearScripts`, `ScriptRegion:GetScript`, `ScriptRegion:HookScript`, `ScriptRegion:SetScript`.

### Events
**Added (41):**
`BATTLE_NET_FRIEND_TAG_ENABLED_STATUS_UPDATED`, `BATTLE_NET_TITLE_FRIEND_CUSTOM_NAME_ENABLED_STATUS_UPDATED`, `CHAT_MSG_GUILD_DISCORD`, `CONFIRM_BATTLE_NET_FRIEND_INVITE_SHOW`, `DISCORD_GUILD_ACHIEVEMENT`, `DISCORD_GUILD_LOBBY_UPDATE`, `DISCORD_GUILD_SETTINGS_UPDATE`, `DISCORD_LINK_UPDATE`, `DISCORD_SERVER_LIST_UPDATE`, `DISCORD_STATUS_UPDATE`, `EXTERNAL_EVENT_LAUNCH_URL_FAILED`, `GROUP_BUFF_VISUAL_ALERTS_CHANGED`, `GUILD_RANKS_UPDATE_ACTIVE_PLAYER`, `HIDDEN_GROUP_BUFFS_CHANGED`, `HOUSE_RESET_COMPLETED`, `HOUSE_RESET_FAILED`, `HOUSING_BLUEPRINT_COLLECTION_FAILURE`, `HOUSING_BLUEPRINT_COLLECTION_RECEIVED`, `HOUSING_BLUEPRINT_CONTENTS_FAILURE`, `HOUSING_BLUEPRINT_CONTENTS_RECEIVED`, `HOUSING_BLUEPRINT_DELETE_FAILURE`, `HOUSING_BLUEPRINT_DELETE_SUCCESS`, `HOUSING_BLUEPRINT_EXPORT_FAILURE`, `HOUSING_BLUEPRINT_EXPORT_SUCCESS`, `HOUSING_BLUEPRINT_IMPORT_FAILURE`, `HOUSING_BLUEPRINT_IMPORT_STARTED`, `HOUSING_BLUEPRINT_IMPORT_SUCCESS`, `HOUSING_BLUEPRINT_RENAME_FAILURE`, `HOUSING_BLUEPRINT_RENAME_SUCCESS`, `HOUSING_BLUEPRINTS_AVAILABILITY_CHANGED`, `HOUSING_LAYOUT_OCCUPIED_FLOOR_RANGE_CHANGED`, `HOUSING_NEW_DECOR_PLACE_COMPLETE`, `IGNORE_NEIGHBORHOOD_RESPONSE`, `LEGACY_FRIEND_SYSTEM_STATUS_UPDATED`, `LFG_LIST_CENSORED_ACTIVE_ENTRY_UPDATE`, `LFG_LIST_REVEALED_CENSORED_ACTIVE_ENTRY`, `SOCIAL_UI_FRIENDS_LIST_SYSTEM_STATUS_UPDATED`, `SOCIAL_UI_SOCIAL_QUEUE_SYSTEM_STATUS_UPDATED`, `SOCIAL_UI_SYSTEM_STATUS_UPDATED`, `UNIT_PING_PIN_ADDED`, `UNIT_PING_PIN_REMOVED`.

**Removed (2):**
`BATTLETAG_INVITE_SHOW`, `HOUSING_LAYOUT_NUM_FLOORS_CHANGED`.

**Changed:**
- `CHAT_MSG_*`: added `discordInfo`
- `SPELL_UPDATE_COOLDOWN`: added `itemID`

### CVars
**Added (23):**
`accessibilityScreenNarrationEnabled`, `accessibilityScreenNarrationSpeechRate`, `accessibilityScreenNarrationSpeechVolume`, `accessibilityScreenNarrationVoice`, `AftermathShaderDebug`, `discordClientEnabled`, `discordDisplayName`, `nameplateCheckDistanceForTarget`, `nameplateForceShowUnitName`, `nameplateNotSelectedAlpha`, `nameplatePlayRemovalAnimation`, `nameplateShowAllPersonalAuras`, `nameplateShowFriendlyRealmName`, `nameplateShowFriends`, `pingTarget`, `raidFramesDispelIndicatorOverlayAnimation`, `showPingsOnRaidFrames`, `showScreenNarrationDialog`, `taintLogObjectSecrets`, `tooltipShowAuraSpellIDs`, `userFontScaleGlue`, `worldMapShowCursorCoords`, `worldMapShowPlayerCoords`.

**Removed (5):**
`auctionDisplayOnCharacter`, `auctionSortByBuyoutPrice`, `auctionSortByUnitPrice`, `lastLockedDelvesCompanionAbilities`, `SlugSupersampling`.

### Enumerations
- `Enum.ClubStreamType`: added `Discord`
- `Enum.CompanionConfigSlotTypes`: added `Flavor`
- `Enum.CooldownViewerCategory`: added `GroupBuff`, `SpecAgnosticEssential`, `SpecAgnosticTracked`, `EquipSlotEssential`, `EquipSlotTracked`
- `Enum.EditModeAccountSetting`: added `ShowRaidWarning`
- `Enum.EditModeMinimapSetting`: added `IconScale`
- `Enum.EditModeSystem`: added `RaidWarning`
- `Enum.EditModeUnitFrameSetting`: removed `IconSize`, added `BuffIconSize`, `DebuffIconSize`
- `Enum.FragmentID`: added `FMapObject`, `FWorldStateListenerData`
- `Enum.FrameTutorialAccount`: added `HousingPetBeds`
- `Enum.HouseFinderSuggestionReason`: added `Relinquished`
- `Enum.HousingResult`: added Blueprint and Room error codes
- `Enum.NamePlateStyle`: added `Classic`
- `Enum.PingResult`: added `FailedSilent`
- `Enum.PingSubjectType`: added `ActionReady`, `ActionOnCooldown`, `ActionUnavailable`
- `Enum.SecretAspect`: added `RadialProgress`
- `Enum.TieredEntranceType`: added `Lairs`
- `Enum.TooltipDataLineType`: added `ItemSpellTriggerOnUse`, `ItemSpellTriggerOnEquip`, `ItemSpellTriggerOnProc`

### Structures
- `AddPrivateAuraAnchorArgs`: removed `showCountdownFrame`, added `showDispelIcon`, `showCooldownEdge`, `showCooldownFrame`
- `BNetAccountInfo`: added `friendLevel`, `friendTags`
- `BNetGameAccountInfo`: added `classFilename`
- `ChatMessageEventParams`: added `discordInfo`
- `ClubMemberInfo`: added `discordInfo`
- `CooldownViewerCooldown`: added `spellCategoryID`, `equipSlot`, `isInvisible`
- `HousingDecorInstanceInfo`: added `canAttachPet`
- `LfgEntryData`: added `censored`
- `LfgSearchResultData`: added `censored`
- `PetJournalPetInfo`: added `canAttachToDecor`, `creatureModelScale`
- `PlaySoundParams`: added `volumeOverride`
- `PlayerChoiceInfo`: added `hideAnswerArt`
- `TieredEntranceTierInfo`: added `overrideTooltipSpellID`, `isLFG`
- `UnitPrivateAuraAnchorInfo`: removed `showCountdownFrame`, added `showDispelIcon`, `showCooldownEdge`, `showCooldownFrame`

---

## Deprecated API

### Blizzard_Deprecated/Deprecated_12_1_0.lua
- `getglobal`
- `setglobal`

```lua
function getglobal(var)
	return _G[var];
end

local forceinsecure = forceinsecure;
function setglobal(var, val)
	if forceinsecure then
		forceinsecure();
	end
	
	_G[var] = val;
end
```

### Blizzard_DeprecatedBattleNet/Deprecated_BattleNet.lua
- `BNSendVerifiedBattleTagInvite` -> `C_BattleNet.SendVerifiedBattleNetFriendInvite`
- `BNGetFriendInviteInfo` -> `C_BattleNet.GetFriendInviteInfo`

```lua
BNSendVerifiedBattleTagInvite = function()
	C_BattleNet.SendVerifiedBattleNetFriendInvite();
end

BNGetFriendInviteInfo = function(inviteIndex)
	local inviteInfo = C_BattleNet.GetFriendInviteInfo(inviteIndex);
	if not inviteInfo then
		return;
	end
	
	local isBattleTag = inviteInfo.friendLevel == Enum.BattleNetFriendLevel.BattleTag;
	return inviteInfo.inviteID, inviteInfo.accountName, isBattleTag, nil, inviteInfo.creationTimestamp;
end
```

### Blizzard_DeprecatedHousing/Deprecated_Housing.lua
- `C_DyeColor.GetDyeColorForItem` -> `C_DyeColor.GetDyeColorsForItem`
- `C_DyeColor.GetDyeColorForItemLocation` -> `C_DyeColor.GetDyeColorsForItemLocation`

```lua
-- Old: Returned an arbitrary default int value when not in an owned house or plot
-- New: Returns nil when not in an owned house or plot
local originalGetSpentPlacementBudget = C_HousingDecor.GetSpentPlacementBudget;
C_HousingDecor.GetSpentPlacementBudget = function()
	return originalGetSpentPlacementBudget() or 0;
end

-- Old: Returned an arbitrary default int value when not in an owned house or plot
-- New: Returns nil when not in an owned house or plot
local originalGetMaxPlacementBudget = C_HousingDecor.GetMaxPlacementBudget;
C_HousingDecor.GetMaxPlacementBudget = function()
	return originalGetMaxPlacementBudget() or 0;
end

-- Old: Returned an arbitrary default int value when not in an owned house
-- New: Returns nil when not in an owned house
local originalGetSpentRoomPlacementBudget = C_HousingLayout.GetSpentPlacementBudget;
C_HousingLayout.GetSpentPlacementBudget = function()
	return originalGetSpentRoomPlacementBudget() or 0;
end

-- Old: Returned an arbitrary default int value when not in an owned house
-- New: Returns nil when not in an owned house or plot
local originalGetRoomPlacementBudget = C_HousingLayout.GetRoomPlacementBudget;
C_HousingLayout.GetRoomPlacementBudget = function()
	return originalGetRoomPlacementBudget() or 0;
end

-- API was updated to be plural, to account for one dye item being usable for multiple Dye Colors
C_DyeColor.GetDyeColorForItem = function(itemLinkOrID)
	local dyeColors = C_DyeColor.GetDyeColorsForItem(itemLinkOrID);
	if dyeColors and #dyeColors > 0 then
		return dyeColors[1];
	end

	return nil;
end

-- API was updated to be plural, to account for one dye item being usable for multiple Dye Colors
C_DyeColor.GetDyeColorForItemLocation = function(itemLocation)
	local dyeColors = C_DyeColor.GetDyeColorsForItemLocation(itemLocation);
	if dyeColors and #dyeColors > 0 then
		return dyeColors[1];
	end

	return nil;
end

-- API was renamed to be consistent with other similar APIs
C_Housing.IsInsideOwnHouse = C_Housing.IsInsideOwnedHouse;
```

### Blizzard_DeprecatedRaidWarning/Deprecated_RaidWarning.lua
- `RaidNotice_AddMessage` -> `RaidWarningUtil.AddMessage`
- `RaidNotice_Clear` -> `RaidWarningFrameMixin:ClearMessages`

```lua
RaidNotice_AddMessage = function(_noticeFrame, textString, colorInfo, displayTime)
	RaidWarningUtil.AddMessage(textString, colorInfo, displayTime);
end;

RaidNotice_Clear = function(noticeFrame)
	noticeFrame:ClearMessages();
end;

RaidNotice_UpdateSlot = function(slotFrame, timings, elapsedTime, hasFading)
	if not slotFrame.textScalingMinHeight then
		local minHeight = timings["RAID_NOTICE_MIN_HEIGHT"] or timings.minHeight;
		local maxHeight = timings["RAID_NOTICE_MAX_HEIGHT"] or timings.maxHeight;
		local scaleUp = timings["RAID_NOTICE_SCALE_UP_TIME"] or timings.scaleUpTime;
		local scaleDown = timings["RAID_NOTICE_SCALE_DOWN_TIME"] or timings.scaleDownTime;
		FadingFrame_SetTextScaling(slotFrame, minHeight, maxHeight, scaleUp, scaleDown);
	end
	FadingFrame_UpdateTextScaling(slotFrame, elapsedTime);
	if hasFading then
		FadingFrame_OnUpdate(slotFrame);
	end
end;

RaidNotice_FadeInit = function(slotFrame)
	FadingFrame_OnLoad(slotFrame);
	FadingFrame_SetFadeInTime(slotFrame, 0.2);
	FadingFrame_SetHoldTime(slotFrame, 0.2);
	FadingFrame_SetFadeOutTime(slotFrame, 3.0);
end;
```
