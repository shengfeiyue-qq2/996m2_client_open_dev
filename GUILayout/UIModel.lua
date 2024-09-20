UIModel = {}

-- 默认内观缩放比例
local PLAYER_LOOKS_SCALE     = 1.44
-- 默认女性模型X轴偏移
local PLAYER_OFFSET_X_FEMALE = 2

-- 内观层级
local NGOrders = {
	MODEL_LAYER_Z_BASE       = 1,  -- 裸模
	MODEL_LAYER_Z_CLOTH      = 3,  -- 衣服
	MODEL_LAYER_Z_WEAPON     = 6,  -- 武器
	MODEL_LAYER_Z_HAIR       = 8,  -- 头发
	MODEL_LAYER_Z_VEIL       = 10, -- 面纱
	MODEL_LAYER_Z_HEAD       = 13, -- 头盔
	MODEL_LAYER_Z_SHIELD     = 16, -- 盾牌
}

local equipOffset = EquipData.GetEquipModelOffSet()
local IsPcModel   = SL:GetValue("IS_PC_OPER_MODE")

local GetFileFunc = function (looks)
    return string.format("%06d", looks % 10000), math.floor(looks / 10000)
end

-- 解析特效配置
local function ParseModelEffect(effect)
    local effectSet = {}
    if not effect then
        return effectSet
    end

    if type(effect) == "number" then
        effect = effect .. "#0"
    end
    
    local effectArry = string.split(effect or "", "&")
    local effectList = string.split(effectArry[1] or "", "|")
    local isShowLook = tonumber(effectArry[2]) ~= 0
    for i = 1, #effectList do
        local effectParam = effectList[i]
        local effectParamPar = string.split(effectParam or "", "#")
        local effectData = {
            effectId = tonumber(effectParamPar[1]) or 0,
            zOrder   = tonumber(effectParamPar[2]) or 0,
            offX     = tonumber(effectParamPar[3]) or 0,
            offY     = tonumber(effectParamPar[4]) or 0,
            scale    = tonumber(effectParamPar[6]) or 1 --"PC缩放#手机缩放"
        }
        if IsPcModel then
            effectData.scale = tonumber(effectParamPar[5]) or 1
            effectData.offX  = tonumber(effectParamPar[7]) or effectData.offX or 0
            effectData.offY  = tonumber(effectParamPar[8]) or effectData.offY or 0
        end
        table.insert(effectSet, effectData)
    end
    return effectSet, isShowLook
end

function UIModel.main(sex, feature, scale, params)
    local parent = GUI:Attach_LeftBottom()
    if not parent then
        return
    end

    local newScale = SL:GetValue("GAME_DATA", "staticSacle")
    params = params or {}
    if not params.ignoreStaticScale then
        if newScale and newScale ~= "" then
            local scaleSplit = string.split(newScale, "|")
            if IsPcModel and scaleSplit[2] then
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

    local modelScale = scale or 1
    local baseModel = GUI:Node_Create(baseNode, "baseModel", baseUIOff.x, baseUIOff.y)

    -- 法阵
    if feature.embattlesID and next(feature.embattlesID) then
        local sfxX, sfxY = -30, -80
        if IsPcModel then
            sfxX = -30
            sfxY = -40
        end

        for k, id in pairs(feature.embattlesID) do
            local embattleAnim = GUI:Effect_Create(baseNode, "embattles_" .. k, sfxX, sfxY, 0, id, 0, 0, 0, 1)
            if embattleAnim then 
                GUI:setScale(embattleAnim, IsPcModel and modelScale or (modelScale * 1.3) )
                GUI:setLocalZOrder(embattleAnim,  k == 1 and -10 or 10)
            end
        end
    end

    -- 内观缩放比例
    local showModelScale = PLAYER_LOOKS_SCALE
    if IsPcModel then
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

    GUI:setScale(baseNode, modelScale)

    -- 裸模
    local job       = params.job
    local jobData   = job and SL:GetValue("GAME_DATA", "MultipleJobSetMap")[job]
    local isOpen    = jobData and jobData.isOpen
    local imgName   = isOpen and (sex == 1 and jobData.UIModelPicFeMaleID or jobData.UIModelPicMaleID)
    local offx      = sex == 1 and PLAYER_OFFSET_X_FEMALE or 0
    if not imgName then
        imgName = string.format("%08d", sex == 1 and 470 or 460)
    end

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
    
    local showHelmet    = feature.showHelmet


    if sex then
        local hairID = feature.hairID or 0
        if hairID == 1 then
            hairID = sex == 1 and 2 or 1
        elseif hairID == 2 then
            hairID = sex == 1 and 3 or 0
        elseif hairID == 3 then
            hairID = sex == 1 and 4 or 0
        else
            local value = sex == 1 and 2 or 1
            hairID = 10000 + hairID * 10 + value
        end

        local hairSetId = hairID
        local hairFileName = nil
        if hairID > 0 then
            hairFileName = string.format("%08d", hairID)
        end

        if feature.showHair and hairFileName then
            local hairFilePath = "res/private/player_model/" .. hairFileName .. ".png"
            if SL:IsFileExist(hairFilePath) then
                local hairOffset = EquipData.GetModelHairOffSet()
                local x = hairOffset[hairSetId] and hairOffset[hairSetId].x or 0
                local y = hairOffset[hairSetId] and - hairOffset[hairSetId].y or 0
                local hair = GUI:Image_Create(node, "hairIMG", x, y, hairFilePath)
                GUI:setAnchorPoint(hair, 0, 1)
                GUI:setLocalZOrder(hair, NGOrders.MODEL_LAYER_Z_HAIR)
            end
        end
    end

    -- 衣服
    UIModel.CreateModel(node, tDressID or clothID, tDressEffect or clothEffect, "Cloth", NGOrders.MODEL_LAYER_Z_CLOTH)

    -- 武器
    UIModel.CreateModel(node, tweaponID or weaponID, tWeaponEffect or weaponEffect, "Weapon", NGOrders.MODEL_LAYER_Z_WEAPON)

    -- 面巾
    UIModel.CreateModel(node, veilID, veilEffect, "Veil", NGOrders.MODEL_LAYER_Z_VEIL)

    -- 盾牌
    UIModel.CreateModel(node, shieldID, shieldEffect, "Shield", NGOrders.MODEL_LAYER_Z_SHIELD)
    

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
        UIModel.CreateModel(node, topLooks[i], topEffects[i], "Head"..i, NGOrders.MODEL_LAYER_Z_HEAD)
    end

    return baseNode
end

function UIModel.CreateModel(node, id, effect, name, order)
    if not id then
        return false
    end

    -- 图片
    local fileName, pathIndex = GetFileFunc(id)
    local offset = equipOffset[id] or {x = 0, y = 0}
    if offset and fileName then
        local path = string.format("res/player_show/player_show_%s/%s.png", pathIndex, fileName)
        local pic  = GUI:Image_Create(node, "Image_" .. name, offset.x, -offset.y, path)
        GUI:setAnchorPoint(pic, 0, 1)
        GUI:setLocalZOrder(pic, order)
    end

    -- 特效
    if effect and effect ~= "0" and effect ~= "" then
        local effectList = ParseModelEffect(effect)
        for i, v in ipairs(effectList) do
            local anim = GUI:Effect_Create(node, "Effect_" .. name, v.offX, - v.offY, 0, v.effectId)
            if anim then
                local scale = v.scale or 1
                GUI:setScale(anim,  GUI:getScale(anim) * scale)
                GUI:setLocalZOrder(anim, v.zOrder == 0 and order + 1 or order - 1)
            end
        end
    end
end