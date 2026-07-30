local _, ns = ...;

local configs = {
	polishedflush = 1261082,
	heartofice = 1247799,
	textureid = 7439203,
	maxshatter = 20,
	baseshatter = 4,
}

local gvalues = {
	updateframe = nil,
	cdid = nil,
	type = 0,
	colorcurve = C_CurveUtil.CreateColorCurve(),
};



local function on_cooldownupdate(frame)
	local aura = frame.auraDataCached;

	if aura and UnitExists("target") then
		ns.bar:SetValue(aura.applications, gvalues.type);
		ns.bar.text:SetText(aura.applications);
		--	local color = gvalues.colorcurve:Evaluate(aura.applications);
		ns.bar:SetStatusBarColor(CreateColor(1, 0, 1, 1):GetRGBA());
		gvalues.type = 1;
		return;
	end
	ns.bar:SetValue(0);
	ns.bar.text:SetText("0");
	gvalues.type = 0;
end



local function scan_viewer()
	local viewer = BuffIconCooldownViewer;
	if viewer and viewer.GetChildren then
		local childs = { viewer:GetChildren() };

		for _, frame in ipairs(childs) do
			if frame.cooldownID then
				if gvalues.cdid then
					if frame.cooldownID == gvalues.cdid then
						gvalues.updateframe = frame;
						return;
					end
				else
					local textureid = frame.Icon:GetTexture();

					if textureid and not issecretvalue(textureid) then
						if textureid == configs.textureid then
							gvalues.updateframe = frame;
							gvalues.cdid = frame.cooldownID;
							return;
						end
					end
				end
			end
		end
	end
end

local bhooked = false;
local function init()
	local viewer = BuffIconCooldownViewer;
	if viewer then
		if viewer.Layout then
			scan_viewer();

			if bhooked == false then
				hooksecurefunc(viewer, "Layout", scan_viewer);
				bhooked = true;
			end
		end
	end
end

local function on_event(_, event, arg)
	if event == "PLAYER_TARGET_CHANGED" then
		if gvalues.updateframe then
			gvalues.type = 0;
			on_cooldownupdate(gvalues.updateframe);
		end
	end
end

local function on_update()
	if gvalues.updateframe then
		on_cooldownupdate(gvalues.updateframe);
	end
end

local main_frame = CreateFrame("Frame");
main_frame:SetScript("OnEvent", on_event);
local timer;

local function setup_max_shatter(max, min)
	if issecretvalue(max) then
		return;
	end

	local frames = ns.bar.countframes;
	for i = 1, 20 do
		frames[i]:Hide();
	end

	if max == 0 then
		return;
	end

	local width = ((ns.options.BarWidth + 2) / max);
	for i = 1, max do
		local frame = frames[i];
		frame:SetWidth(width);
		frame:Show();
	end
end

function ns.setup_shatter()
	local shattercount = configs.baseshatter;

	if C_SpellBook.IsSpellKnown(configs.heartofice) then
		shattercount = shattercount + 1;
	end

	if C_SpellBook.IsSpellKnown(configs.polishedflush) then
		shattercount = shattercount + 1;
	end

	ns.bar:SetMinMaxValues(0, 20);
	setup_max_shatter(20, shattercount);
	init();
	scan_viewer();
	main_frame:RegisterEvent("PLAYER_TARGET_CHANGED");
	main_frame:RegisterEvent("PLAYER_REGEN_ENABLED");
	main_frame:RegisterEvent("PLAYER_ENTERING_WORLD");
	timer = C_Timer.NewTicker(0.2, on_update);
end

function ns.clear_shatter()
	if timer then
		timer:Cancel();
	end
	main_frame:UnregisterEvent("PLAYER_TARGET_CHANGED");
	main_frame:UnregisterEvent("PLAYER_REGEN_ENABLED");
	main_frame:UnregisterEvent("PLAYER_ENTERING_WORLD");
	setup_max_shatter(0);
	gvalues.updateframe = nil;
	gvalues.cid = nil;
end
