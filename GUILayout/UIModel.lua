UIModel = {}

-- 默认内观缩放比例
local PLAYER_LOOKS_SCALE          = 1.44
-- 默认女性模型X轴偏移
local PLAYER_OFFSET_X_FEMALE      = 2

-- 内观层级
local Order = {
    MODEL_LAYER_Z_BASE                = 1,  -- 裸模
    MODEL_LAYER_Z_WING                = 3,  -- 翅膀
    MODEL_LAYER_Z_CLOTH               = 6,  -- 衣服
    MODEL_LAYER_Z_WEAPON              = 9,  -- 武器
    MODEL_LAYER_Z_HAIR                = 11, -- 头发
    MODEL_LAYER_Z_VEIL                = 13, -- 面纱
    MODEL_LAYER_Z_HEAD                = 16, -- 头盔
    MODEL_LAYER_Z_SHIELD              = 19, -- 盾牌
}

local EquipOffset = SL:GetMetaValue("UIMODEL_EQUIP_OFFSET")
local IsPCMode = SL:IsWinMode()


local GetFileFunc = function (looks)
    return string.format("%06d", looks % 10000), math.floor(looks / 10000)
end

-- 解析特效配置
local ParseEffect = function (effect)
    if not effect then
        return { }
    end

    if type(effect) == "number" then
        effect = effect .. "#0"
    end

    local effectSet = {}

    local effectArry = SL:Split(effect or "", "&")
    local effectList = SL:Split(effectArry[1] or "", "|")
    local isShowLook = tonumber(effectArry[2]) ~= 0
    for i = 1, #effectList do
        local params = SL:Split(effectList[i] or "", "#")
        local data = {
            effectID = tonumber(params[1] or 0),
            order    = tonumber(params[2] or 0),
            offX     = tonumber(params[3] or 0),
            offY     = tonumber(params[4] or 0),
            scale    = tonumber(params[6] or 1) -- "PC缩放#手机缩放"
        }

        if IsPCMode then
            data.scale = tonumber(params[5] or 1)
            data.offX  = tonumber(params[7] or data.offX)
            data.offY  = tonumber(params[8] or data.offY)
        end
        table.insert(effectSet, data)
    end

    return effectSet, isShowLook
end

function UIModel.main(sex, feature, scale, useStaticScale)
    local parent = GUI:Attach_LeftBottom()
    if not parent then
        return
    end

    if useStaticScale then
        local newScale = SL:GetGameData("staticSacle")
        if newScale and newScale ~= "" then
            local scaleSplit = SL:Split(newScale, "|")
            if IsPCMode and scaleSplit[2] then
                scale = tonumber(scaleSplit[2])
            else
                if scaleSplit[1] then
                    scale = tonumber(scaleSplit[1])
                end
            end
        end
    end

    local baseNode = GUI:Node_Create(parent, "baseNode", 0, 0)
    GUI:removeFromParent(baseNode)

    local equipOff = {
        x = -136,
        y = 110
    }

    local baseUIOff = {
        x = -9,
        y = 3
    }

    local baseModel = GUI:Node_Create(baseNode, "baseModel", baseUIOff.x, baseUIOff.y)

    -- 内观缩放比例
    local showModelScale = PLAYER_LOOKS_SCALE
    if IsPCMode then
        showModelScale = 1

        equipOff = {
            x = -97.5,
            y = 77
        }
    end
    
    GUI:setScale(baseModel, showModelScale)

    -- 展示节点
    local node = GUI:Node_Create(baseNode, "node", equipOff.x, equipOff.y)
    GUI:setScale(node, showModelScale)

    local modelScale = scale or 1
    GUI:setScale(baseNode, modelScale)

    -- 裸模
    local offx = sex == 1 and PLAYER_OFFSET_X_FEMALE or 0
    local imgName = string.format("%08d", sex == 1 and 470 or 460)
    local base = GUI:Image_Create(baseModel, "baseImg", offx, 0, "res/private/player_model/".. imgName .. ".png")
    GUI:setAnchorPoint(base, 0.5, 0.5)
    GUI:setVisible(base, feature and feature.showNodeModel)

    if not feature or not next(feature) then
        return baseNode
    end

    local clothID       = feature.clothID
    local weaponID      = feature.weaponID
    local headID        = feature.headID
    local headEffect    = feature.headEffectID
    local weaponEffect  = feature.weaponEffectID
    local clothEffect   = feature.clothEffectID
    local capID         = feature.capID
    local shieldID      = feature.shieldID
    local shieldEffect  = feature.shieldEffectID
    local tDressID      = feature.tDressID
    local tDressEffect  = feature.tDressEffectID
    local tweaponID     = feature.tweaponID
    local tWeaponEffect = feature.tWeaponEffectID
    local capEffect     = feature.capEffectID
    local veilID        = feature.veilID
    local veilEffect    = feature.veilEffectID
    local wingsID       = feature.wingsID
    local wingEffect    = feature.wingEffectID
    
    local showHelmet    = feature.showHelmet

    if sex then
        local hairID = feature.hairID or 0
        if hairID == 1 then
            hairID = sex == 1 and 2 or 1
        elseif hairID == 2 then
            hairID = sex == 1 and 3 or 0
        elseif hairID == 3 then
            hairID = sex == 1 and 4 or 0
        end
        
        local hairSetId = hairID
        local hairFileName = nil
        if hairID > 0 then
            hairFileName = string.format("%08d", hairID)
        end

        if feature.showHair and hairFileName then
            local hairFilePath = "res/private/player_model/" .. hairFileName .. ".png"
            if SL:IsFileExist(hairFilePath) then
                local hairOffset = SL:GetMetaValue("UIMODEL_HAIR_OFFSET")
                local x = hairOffset[hairSetId] and hairOffset[hairSetId].x or 0
                local y = hairOffset[hairSetId] and - hairOffset[hairSetId].y or 0
                local hair = GUI:Image_Create(node, "hairIMG", x, y, hairFilePath)
                GUI:setAnchorPoint(hair, 0, 1)
                GUI:setLocalZOrder(hair, Order.MODEL_LAYER_Z_HAIR)
            end
        end
    end

    --readme:这里所有的纵坐标值取反 坐标系转换
    -- 衣服
    UIModel.CreateModel(node, tDressID or clothID, tDressEffect or clothEffect, "Cloth", Order.MODEL_LAYER_Z_CLOTH)

    -- 武器
    UIModel.CreateModel(node, tweaponID or weaponID, tWeaponEffect or weaponEffect, "Weapon", Order.MODEL_LAYER_Z_WEAPON)

    -- 翅膀
    UIModel.CreateModel(node, wingsID, wingEffect, "Wing", Order.MODEL_LAYER_Z_WING)

    -- 面巾
    UIModel.CreateModel(node, veilID, veilEffect, "Veil", Order.MODEL_LAYER_Z_VEIL)

    -- 盾牌
    UIModel.CreateModel(node, shieldID, shieldEffect, "Shield", Order.MODEL_LAYER_Z_SHIELD)

    -- 头盔、斗笠
    local topLooks = {
        [1] = capID
    }
    if not topLooks[1] or showHelmet then
        topLooks[2] = headID
    end

    local topEffects = { 
        [1] = capEffect 
    }
    if not topEffects[1] or showHelmet then
        topEffects[2] = headEffect
    end

    for i = 2, 1, -1 do
        UIModel.CreateModel(node, topLooks[i], topEffects[i], "Head"..i, Order.MODEL_LAYER_Z_HEAD)
    end

    return baseNode
end

function UIModel.CreateModel(node, id, effect, name, order)
    if not id then
        return false
    end

    -- 图片
    local fileName, pathIndex = GetFileFunc(id)
    local offset = EquipOffset[id] or {x = 0, y = 0}
    if offset and fileName then
        local path = string.format("res/player_show/player_show_%s/%s.png", pathIndex, fileName)
        local pic  = GUI:Image_Create(node, "Image_"..name, offset.x, -offset.y, path)
        GUI:setAnchorPoint(pic, 0, 1)
        GUI:setLocalZOrder(pic, order)
    end

    -- 特效
    if effect and effect ~= "0" and effect ~= "" then
        local effectList = ParseEffect(effect)
        for i, v in ipairs(effectList) do
            local anim = GUI:Effect_Create(node, "Effect_" .. name, v.offX, - v.offY, 0, v.effectID)
            if anim then
                local scale = v.scale or 1
                GUI:setScale(anim,  GUI:getScale(anim) * scale)
                GUI:setLocalZOrder(anim, v.order == 0 and order + 1 or order - 1)
            end
        end
    end
end