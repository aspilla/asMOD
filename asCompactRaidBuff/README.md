# asCompactRaidBuff: Enhanced Raid and Party Frames

This addon improves the default World of Warcraft raid and party frames, enhancing their functionality and providing crucial information for healers and other roles.  It offers a streamlined experience, allowing for better situational awareness and more efficient healing and raid management.

**Key Features:**

*   **Defensive CD Display (Center):**
    *   Clearly displays the use of defensive cooldowns directly in the center of the unit frame.
    *   Prioritizes shorter remaining durations, ensuring you're always aware of the most critical defenses.
    *   Supports a maximum of 2 defensive cooldowns displayed simultaneously.

*   **Maintained HoTs Tracking (Top Right, Center Right, Bottom Right):**
    *   Monitors essential Heal over Time (HoT) buffs that healers need to maintain.
    *   Displays HoTs in designated locations (Top Right, Center Right, Bottom Right) for quick and easy tracking.

*   **Private Aura Display (Top Left):**
    *   Shows private debuffs assigned to the unit in the top left corner.

*   **Healer-Only Mana Bar:**
    *   When the class resource display is disabled, a thin mana bar is displayed exclusively for healers.

*   **Raid Marker Display (Mid-Left):**
    *   Displays raid markers assigned to individual players in the mid-left portion of the unit frame.

*   **Incoming Enemy Casts (Top Center):**
    *   Displays hostile spells being cast on the unit at the top center of the frame.
    *   **Deadly Boss Mods (DBM) Integration:**
        *   Interruptible casts are highlighted with a distinct green border.
        *   Uninterruptible casts are marked with a gray border.

*   **Dispellable Debuff Alerts:**
    *   Highlights unit frame borders for dispellable debuffs.    
    * Fix the bug of the default raid/party frames, about Dispellable Debuff : detect all dispellable debuff types based on the player's specialization (e.g., a Holy Paladin only being alerted to Magic and Poison debuffs).

*   **Shield Display:**
    *   When a shield's absorption exceeds the unit's missing health, the excess shield amount is displayed dimly on the left side of the frame.

*   **HP Color Change on Healing Effects:**
    *   Changes the health bar color to gray when affected by specific healing spells, visually indicating the type of healing:
        *   Flash of Light (Holy Paladin)
        *   Atonement (Discipline Priest)
        *   Renew (Holy Priest)
        *   Lifebloom (Restoration Druid)
        *   Echo (Preservation Evoker)
        *   Healing Surge (Restoration Shaman)
        *   Renewing Mist (Mistweaver Monk)

*   **Buff Refresh Alert:**
    *   When a buff's remaining duration reaches 30% of its total duration (the typical refresh point), the unit frame border turns white, and the cooldown count turns red.

*   **Priest "Power Word: Life" Talent Interaction:**
    *   If a Priest has the "Power Word: Life" talent selected, alerts are displayed in red when a party member's health falls below 35%.

* **Show Cooldown count**
    * Hides cooldown timers but shows buff durations of 10 seconds or less.
    * When a buff is nearing its refresh point, the duration text turns red.

*   **Customization and Options:**
    *   All of these features can be individually toggled on or off via the in-game options menu (Esc > Options > Addons > asCompactRaidBuff).
    * you can remove/add some spell, then you need to edit "asCompactRaidBuffOptions.lua" file, yourself.

**Installation:**

1.  Download the addon files.
2.  Extract the files to your World of Warcraft `Interface/AddOns` directory.
3.  Enable the addon in the in-game AddOns menu.

**How to Use:**

Once installed, the addon will automatically enhance your raid and party frames.  Customize the features you wish to use through the in-game options menu.

**Support:**
If you have any questions, find a bug or want to suggest a feature, you can create an issue on GitHub.