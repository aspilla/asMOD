local _, ns = ...;

local function update_speed()

    if not ns.ready then
        return;
    end

    if not IsFlying("player") then
        ns.frame:Hide();
        return;
    end

    ns.frame:Show();

    local isGliding, canGlide, forwardSpeed = C_PlayerInfo.GetGlidingInfo()
	local base = isGliding and forwardSpeed or GetUnitSpeed("player")
	local movespeed = Round(base / BASE_MOVEMENT_SPEED * 100);

    ns.bar:SetMinMaxValues(0, 1100)
    ns.bar:SetValue(movespeed, Enum.StatusBarInterpolation.ExponentialEaseOut);

    local durationinfo = C_Spell.GetSpellCooldownDuration(361584)

    if durationinfo then
        ns.bar.text:SetText(string.format("%2d", durationinfo:GetRemainingDuration(0)));
    end
end

C_Timer.NewTicker(0.2, update_speed);
