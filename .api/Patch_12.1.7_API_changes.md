# Patch 12.1.7/API changes
========================

< [Patch 12.1.7](https://warcraft.wiki.gg/wiki/Patch_12.1.7 "Patch 12.1.7")

**This article documents [API changes](https://warcraft.wiki.gg/wiki/API_change_summaries "API change summaries") made in [Patch 12.1.7](https://warcraft.wiki.gg/wiki/Patch_12.1.7 "Patch 12.1.7").**

*   Previous patch: [Patch 12.1.5](https://warcraft.wiki.gg/wiki/Patch_12.1.5/API_changes "Patch 12.1.5/API changes").
*   Next patch: [Patch 12.2.0](https://warcraft.wiki.gg/wiki/Patch_12.2.0/API_changes?action=edit&redlink=1 "Patch 12.2.0/API changes (page does not exist)").

Contents
--------

*   [1 Summary](https://warcraft.wiki.gg/wiki/Patch_12.1.7/API_changes#Summary)
*   [2 Resources](https://warcraft.wiki.gg/wiki/Patch_12.1.7/API_changes#Resources)
*   [3 Blue posts](https://warcraft.wiki.gg/wiki/Patch_12.1.7/API_changes#Blue_posts)

Summary
-------

*   Includes API changes from [Patch 1.60.1](https://warcraft.wiki.gg/wiki/Patch_1.60.1/API_changes "Patch 1.60.1/API changes").
*   The server ID and spawn ID portions of cast, creature, vehicle, pet, and game object GUIDs have been replaced with obfuscated values.
    *   Obfuscated values are stable and unique within the current client session, but cannot be compared between clients or persisted beyond restarts.
    *   The GUID string format is otherwise unchanged.
    *   _This change will be available for testing in a future build of 12.1.7._
*   TOC directives no longer expand variables such as \[Game\] or \[Family\]. Instead, these lines are entirely skipped.
    *   Directives containing conditional expressions such as \[AllowLoadGameType ...\] continue to function normally.

Resources
---------

*   TOC: `120107`
*   Official API patch notes: [Midnight 12.1.7 PTR Changes](https://warcraft.wiki.gg/wiki/Patch_12.1.7/API_changes/notes?action=edit&redlink=1 "Patch 12.1.7/API changes/notes (page does not exist)")
*   Official development notes: [Midnight: 12.1.7 PTR Development Notes](https://us.forums.blizzard.com/en/wow/t/midnight-echoes-of-the-worldcore-ptr-development-notes/2383391)
*   Diffs: [wow-ui-source](https://github.com/Gethe/wow-ui-source/compare/12.1.5..12.1.7), [BlizzardInterfaceResources](https://github.com/Ketho/BlizzardInterfaceResources/compare/12.1.5...12.1.7)

Blue posts
----------

🔽  **Hidden Section**

Please click the below header to expand the section.

Official patch notes [Patch 12.1.7/API changes/notes](https://warcraft.wiki.gg/wiki/Patch_12.1.7/API_changes/notes?action=edit&redlink=1 "Patch 12.1.7/API changes/notes (page does not exist)")

Retrieved from "[https://warcraft.wiki.gg/wiki/Patch\_12.1.7/API\_changes?oldid=6919765](https://warcraft.wiki.gg/wiki/Patch_12.1.7/API_changes?oldid=6919765)"

[Category](https://warcraft.wiki.gg/wiki/Special:Categories "Special:Categories"):

*   [API patch changes](https://warcraft.wiki.gg/wiki/Category:API_patch_changes "Category:API patch changes")

[Report bad advertisement](https://www.wiki.gg/t/bad-ad)

Cookies help us deliver our services. By using our services, you agree to our use of cookies.
