local _, ns = ...;

--configurations
ns.configs   = {
    font        = STANDARD_TEXT_FONT,
    fontSize    = 12,
    fontOutline = "OUTLINE",
    width       = 238,
    xpoint      = 0,
    ypoint      = -180,
    height      = 8,
    comboheight = 5,
    combatalpha = 1,
    normalalpha = 0.5,
};

ns.frame    = CreateFrame("FRAME", nil, UIParent);

local function init_addon()
    ns.frame:SetPoint("BOTTOM", UIParent, "CENTER", ns.configs.xpoint, ns.configs.ypoint)
    ns.frame:SetWidth(ns.configs.width)
    ns.frame:SetHeight(ns.configs.height)
    ns.frame:SetFrameLevel(9600);
    ns.frame:Show();

    ns.bar = CreateFrame("StatusBar", nil, ns.frame)
    ns.bar:SetStatusBarTexture("RaidFrame-Hp-Fill")
    ns.bar:GetStatusBarTexture():SetHorizTile(false)
    ns.bar:SetMinMaxValues(0, 100)
    ns.bar:SetValue(100)
    ns.bar:SetWidth(ns.configs.width)
    ns.bar:SetHeight(ns.configs.height)
    ns.bar:SetPoint("BOTTOM", ns.frame, "BOTTOM", 0, 0)
    ns.bar:Show();
    ns.bar:EnableMouse(false);

    ns.bar.bg = ns.bar:CreateTexture(nil, "BACKGROUND");
    ns.bar.bg:SetPoint("TOPLEFT", ns.bar, "TOPLEFT", -1, 1);
    ns.bar.bg:SetPoint("BOTTOMRIGHT", ns.bar, "BOTTOMRIGHT", 1, -1);

    ns.bar.bg:SetTexture("Interface\\Addons\\asSkyRide\\border.tga");
    ns.bar.bg:SetTexCoord(0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1);
    ns.bar.bg:SetVertexColor(0, 0, 0, 1);

    ns.bar.text = ns.bar:CreateFontString(nil, "ARTWORK");
    ns.bar.text:SetFont(ns.configs.font, ns.configs.fontSize, ns.configs.fontOutline);
    ns.bar.text:SetPoint("CENTER", ns.bar, "CENTER", 0, 0);
    ns.bar.text:SetTextColor(1, 1, 1, 1);

    ns.bar:SetStatusBarColor(1, 1, 0);
    ns.bar:Show();
    ns.combobars = {};
    ns.combobars[1] = {};
    local combobars = ns.combobars[1]

    for i = 1, 10 do
        combobars[i] = CreateFrame("StatusBar", nil, ns.frame);
        combobars[i]:SetStatusBarTexture("RaidFrame-Hp-Fill");
        combobars[i]:GetStatusBarTexture():SetHorizTile(false);
        combobars[i]:SetFrameLevel(9600);
        combobars[i]:SetMinMaxValues(0, 100);
        combobars[i]:SetValue(100);
        combobars[i]:SetHeight(ns.configs.comboheight);
        combobars[i]:SetWidth(20);

        combobars[i].bg = combobars[i]:CreateTexture(nil, "BACKGROUND");
        combobars[i].bg:SetPoint("TOPLEFT", combobars[i], "TOPLEFT", -1, 1);
        combobars[i].bg:SetPoint("BOTTOMRIGHT", combobars[i], "BOTTOMRIGHT", 1, -1);

        combobars[i].bg:SetTexture("Interface\\Addons\\asSkyRide\\border.tga");
        combobars[i].bg:SetTexCoord(0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1);
        combobars[i].bg:SetVertexColor(0, 0, 0, 1);

        if i == 1 then
            combobars[i]:SetPoint("BOTTOMLEFT", ns.bar, "TOPLEFT", 0, 1);
        else
            combobars[i]:SetPoint("LEFT", combobars[i - 1], "RIGHT", 1, 0);
        end

        combobars[i]:Hide();
        combobars[i]:SetStatusBarColor(0, 0.8, 0.8);
        combobars[i]:EnableMouse(false);
    end

    ns.combobars[2] = {};
    combobars = ns.combobars[2];

    for i = 1, 10 do
        combobars[i] = CreateFrame("StatusBar", nil, ns.frame);
        combobars[i]:SetStatusBarTexture("RaidFrame-Hp-Fill");
        combobars[i]:GetStatusBarTexture():SetHorizTile(false);
        combobars[i]:SetFrameLevel(9600);
        combobars[i]:SetMinMaxValues(0, 100);
        combobars[i]:SetValue(100);
        combobars[i]:SetHeight(ns.configs.comboheight);
        combobars[i]:SetWidth(20);

        combobars[i].bg = combobars[i]:CreateTexture(nil, "BACKGROUND");
        combobars[i].bg:SetPoint("TOPLEFT", combobars[i], "TOPLEFT", -1, 1);
        combobars[i].bg:SetPoint("BOTTOMRIGHT", combobars[i], "BOTTOMRIGHT", 1, -1);

        combobars[i].bg:SetTexture("Interface\\Addons\\asSkyRide\\border.tga");
        combobars[i].bg:SetTexCoord(0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1);        
        combobars[i].bg:SetVertexColor(0, 0, 0, 1);

        if i == 1 then
            combobars[i]:SetPoint("BOTTOMLEFT", ns.combobars[1][1], "TOPLEFT", 0, 1);
        else
            combobars[i]:SetPoint("LEFT", combobars[i - 1], "RIGHT", 1, 0);
        end

        combobars[i]:Hide();
        combobars[i]:SetStatusBarColor(0.8, 0.5, 0);
        combobars[i]:EnableMouse(false);
    end

    if ASKYR_Positions == nil then
        ASKYR_Positions = {};
    end

    local libasConfig = LibStub:GetLibrary("LibasConfig", true);

	if libasConfig then
		libasConfig.load_position(ns.frame, "asSkyRide", ASKYR_Positions);
	end
end

C_Timer.After(0.5, init_addon);
