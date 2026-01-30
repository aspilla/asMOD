local _, ns = ...;

local gvalues = {
	updateframe = nil,
	cdid = nil,
	textureid = 7439203,
	maxstack = 3.3,	
};

local function on_cooldownupdate(frame)
	local auraid = frame.auraInstanceID;

	if auraid and UnitExists("target") then
		local aura = C_UnitAuras.GetAuraDataByAuraInstanceID("target", auraid)
		if aura then
			ns.combocountbar:SetValue(aura.applications,
				Enum.StatusBarInterpolation.ExponentialEaseOut);
			ns.combotext:SetText(aura.applications);
			return;
		end
	end
	ns.combocountbar:SetValue(0);
	ns.combotext:SetText("0");
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
						if textureid == gvalues.textureid then
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

local function init()
	local viewer = BuffIconCooldownViewer;
	if viewer then
		if viewer.Layout then
			scan_viewer();

			hooksecurefunc(viewer, "Layout", function()
				scan_viewer();
			end)
		end
	end
end

local function on_event(_, event, arg)
	if event == "PLAYER_TARGET_CHANGED" then
		if gvalues.updateframe then
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

function ns.setup_shatter(spellid)
	if spellid then
		ns.setup_max_spell(gvalues.maxstack);
		ns.combocountbar:SetMinMaxValues(0, 20);
		ns.combocountbar:SetValue(0);
		ns.combotext:SetText("0");
		ns.combocountbar:SetStatusBarColor(ns.classcolor.r, ns.classcolor.g, ns.classcolor.b);
		ns.combocountbar.bg:SetVertexColor(0.3, 0.3, 0.3, 1);
		ns.combocountbar:Show();
		ns.combotext:Show();
		init();
		scan_viewer();
		main_frame:RegisterEvent("PLAYER_TARGET_CHANGED");
		main_frame:RegisterEvent("PLAYER_REGEN_ENABLED");
		main_frame:RegisterEvent("PLAYER_ENTERING_WORLD");
		timer = C_Timer.NewTicker(0.2, on_update);
	end
end

function ns.clear_shatter()
	if timer then
		timer:Cancel();
	end
	main_frame:UnregisterEvent("PLAYER_TARGET_CHANGED");
	main_frame:UnregisterEvent("PLAYER_REGEN_ENABLED");
	main_frame:UnregisterEvent("PLAYER_ENTERING_WORLD");
	gvalues.updateframe = nil;
end
