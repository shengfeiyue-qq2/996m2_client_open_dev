GUIDefine = {}

-- 双击时间
GUIDefine.CLICK_DOUBLE_TIME     = 0.3

-- pc tips 延迟时间
GUIDefine.PC_TIPS_DELAY_TIME    = 0.05 

-- private 目录
GUIDefine.PATH_RES_PRIVATE      = "res/private/"

-- 引导配置目录
GUIDefine.PATH_GUIDE_CONFIG     = "GUILayout/guide/GuideConfig"

-- 手机设计分辨率
GUIDefine.DESIGN_SIZE_MOBILE    = {width = 1136, height = 640}

-- 仓库单页可存数量
GUIDefine.STORAGE_PER_PAGE_MAX  = 48

GUIDefine.AUTO_FIND_TARGET_NONE = -1            -- 自动寻路目标 - 无

GUIDefine.MAX_COST              = 400           -- 0xFFFFFFFF

-- 属性类型
local attTypeTable = {
    LEVEL                           = 0,            -- 等级
    HP                              = 1,            -- 生命
    MP                              = 2,            -- 魔法
    Min_ATK                         = 3,            -- 物攻下限
    Max_ATK                         = 4,            -- 物攻上限
    Min_MAT                         = 5,            -- 魔攻下限
    Max_MAT                         = 6,            -- 魔攻上限
    Min_Daoshu                      = 7,            -- 道术下限
    Max_Daoshu                      = 8,            -- 道术上限
    Min_DEF                         = 9,            -- 物防下限
    Max_DEF                         = 10,           -- 物防上限
    Min_MDF                         = 11,           -- 魔防下限
    Max_MDF                         = 12,           -- 魔防上限
    Hit_Point                       = 13,           -- 准确
    Speed_Point                     = 14,           -- 敏捷
    Anti_Magic                      = 15,           -- 魔法躲避
    Anti_Posion                     = 16,           -- 毒物躲避
    Posion_Recover                  = 17,           -- 中毒恢复
    Health_Recover                  = 18,           -- 体力恢复
    Spell_Recover                   = 19,           -- 魔法恢复
    Hit_Speed                       = 20,           -- 攻速
    Double_Rate                     = 21,           -- 暴击
    Double_Damage                   = 22,           -- 爆伤
    Defence                         = 23,           -- 韧性
    Double_Defence                  = 24,           -- 暴击抵抗
    More_Damage                     = 25,           -- 增加伤害
    ATK_Defence                     = 26,           -- 物伤减免
    MAT_Defence                     = 27,           -- 魔伤减免
    Ignore_Defence                  = 28,           -- 忽视防御
    Bounce_Damage                   = 29,           -- 反弹伤害
    Health_Add                      = 30,           -- 体力增加
    Magice_Add                      = 31,           -- 魔力增加
    More_Item                       = 32,           -- 爆率增加
    Less_Item                       = 33,           -- 爆率降低
    Vampire                         = 34,           -- 吸血
    A_M_D_Add                       = 35,           -- 攻魔道加成
    Defence_Add                     = 36,           -- 防御加成
    MDefence_Add                    = 37,           -- 魔防加成
    God_Damage                      = 38,           -- 神圣伤害
    Lucky                           = 39,           -- 幸运
    Monster_Damage_Value            = 40,           -- 对怪增伤 固定值
    Monster_Damage_Per              = 41,           -- 对怪增伤
    Anger_Recover                   = 42,           -- 怒气恢复
    Combine_Skill_Damage            = 43,           -- 合击伤害
    Monster_DropItem                = 44,           -- 怪物爆率
    No_Palsy                        = 45,           -- 防止麻痹
    No_Protect                      = 46,           -- 防止护身
    No_Rebirth                      = 47,           -- 防止复活
    No_ALL                          = 48,           -- 防止全度
    No_Charm                        = 49,           -- 防止诱惑
    No_Fire                         = 50,           -- 防止火墙
    No_Ice                          = 51,           -- 防止冰冻
    No_Web                          = 52,           -- 防止蛛网

    Att_UnKonw                      = 53,           -- 没配 未知

    More_A_Damage                   = 54,           -- 对战士伤害增加
    Less_A_Damage                   = 55,           -- 受到战士伤害减免
    More_M_Damage                   = 56,           -- 对法师伤害增加
    Less_M_Damage                   = 57,           -- 受到法师伤害减免
    More_D_Damage                   = 58,           -- 对伤道士害增加
    Less_D_Damage                   = 59,           -- 受到道士伤害减免
    More_Health_Per                 = 60,           -- 生命加成
    HP_Recover                      = 61,           -- 生命恢复
    MP_Recover                      = 62,           -- 魔法恢复
    Block_Rate                      = 63,           -- 格挡概率
    Block_Value                     = 64,           -- 格挡概率
    Drop_Rate                       = 65,           -- 掉落概率
    Exp_Add_Rate                    = 66,           -- 经验倍率
    Damage_Rate_Add                 = 67,           -- 基础倍攻
    Damage_Human                    = 68,           -- 对人伤害
    Ice_Rate                        = 69,           -- 冰冻概率
    Defen_Ice                       = 70,           -- 防止冰冻
    Sec_Recovery_HP                 = 71,           -- 每秒回血,
    Mon_Bj_Power_Rate               = 72,           -- 对怪爆率,
    DC_Add_Rate                     = 73,           -- 击力倍数,
    Monster_Damage                  = 74,           -- 对怪伤害
    Monster_Damage_Percent          = 75,           -- 对怪增伤
    PK_Damage_Add_Percent           = 76,           -- PK增伤
    PK_Damage_Dec_Percent           = 77,           -- PK减伤
    Penetrate                       = 78,           -- 穿透
    Death_Hit_Percent               = 79,           -- 神圣一击
    Death_Hit_Value                 = 80,           -- 神圣伤害
    Monster_Vampire                 = 81,           -- 对怪物吸血
    Less_Monster_Damage             = 82,           -- 减少来自怪物的伤害
    Drug_Recover                    = 83,           -- 药品恢复
    Vampire_Dec                     = 84,           -- 吸血抵抗
    Defense_Dec                     = 85,           -- 破防抵抗
    Fire_Hit_Dec_Rate               = 86,           -- 烈火减免
    Ergum_Hit_Dec_Rate              = 87,           -- 刺杀减免
    Hit_Plus_Dec_Rate               = 88,           -- 攻杀减免
    Health_Add_WPer                 = 89,           -- 生命加成（万分比
    Death_Hit_Dec_Percent           = 90,           -- 神圣抵抗
    Sec_Recovery_MP                 = 91,           -- 每秒回蓝
    Strength                        = 92,           -- 强度
    Curse                           = 93,           -- 诅咒
    Weight                          = 94,           -- 负重
    Wear_Weight                     = 96,           -- 穿戴负重
    Hand_Weight                     = 98,           -- 腕力
    Internal_Value                  = 100,          -- 内力值
    Internal_AddPower               = 101,          -- 内功伤害增加
    Internal_DecPower               = 102,          -- 内功伤害减少
    HJ_DecPower                     = 103,          -- 合击伤害减少
    Internal_ForceRate              = 104,          -- 内力恢复速率
    Internal_DZValue                = 105,          -- 斗转星移值
    Min_Prick                       = 106,          -- 刺术下限
    Max_Prick                       = 107,          -- 刺术上限
    -- 108 - 129 自定义职业(5-15)新增对应属性
    Min_CustJobAttr_5               = 108,
    Max_CustJobAttr_5               = 109,
    Min_CustJobAttr_6               = 110,
    Max_CustJobAttr_6               = 111,
    Min_CustJobAttr_7               = 112,
    Max_CustJobAttr_7               = 113,
    Min_CustJobAttr_8               = 114,
    Max_CustJobAttr_8               = 115,
    Min_CustJobAttr_9               = 116,
    Max_CustJobAttr_9               = 117,
    Min_CustJobAttr_10              = 118,
    Max_CustJobAttr_10              = 119,
    Min_CustJobAttr_11              = 120,
    Max_CustJobAttr_11              = 121,
    Min_CustJobAttr_12              = 122,
    Max_CustJobAttr_12              = 123,
    Min_CustJobAttr_13              = 124,
    Max_CustJobAttr_13              = 125,
    Min_CustJobAttr_14              = 126,
    Max_CustJobAttr_14              = 127,
    Min_CustJobAttr_15              = 128,
    Max_CustJobAttr_15              = 129,
    All_Du_ADD                      = 130,          -- 全毒增加
    All_Du_Less                     = 131,          -- 全毒减弱
    EXP                             = 150,          -- 经验值
    Walk_StepTime                   = 151,          -- 走路间隔,毫秒
    Run_StepTime                    = 152,          -- 跑步间隔,毫秒
    Attack_StepTime                 = 153,          -- 攻击间隔,毫秒
    Magic_StepTime                  = 154,          -- 施法间隔,毫秒
    CD_Speed                        = 155,          -- CD加成,万分比 
    Internal_EXP                    = 156,          -- 内功经验
    Internal_LEVEL                  = 157,          -- 内功等级
    Rein_LEVEL                      = 158,          -- 转生
    BagMaxNum                       = 159,          -- 背包最大格子
    PKPoint                         = 160,          -- PK值
    SuperPower                      = 161,          -- 战力
}

GUIDefine.AttTypeTable = attTypeTable

local EquipPosUI = {
    -- 普通装备
    Equip_Type_Dress                = 0,            -- 衣服
    Equip_Type_Weapon               = 1,            -- 武器
    Equip_Type_RightHand            = 2,            -- 勋章
    Equip_Type_Necklace             = 3,            -- 项链
    Equip_Type_Helmet               = 4,            -- 头盔
    Equip_Type_ArmRingL             = 5,            -- 左手镯
    Equip_Type_ArmRingR             = 6,            -- 右手镯      左右以人物内观内的左右为标准
    Equip_Type_RingL                = 7,            -- 左戒指
    Equip_Type_RingR                = 8,            -- 右戒指
    Equip_Type_Bujuk                = 9,            -- 护身符位置 玉佩 宝珠
    Equip_Type_Belt                 = 10,           -- 腰带
    Equip_Type_Boots                = 11,           -- 鞋子
    Equip_Type_Charm                = 12,           -- 宝石        
    Equip_Type_Cap                  = 13,           -- 斗笠
    Equip_Type_LeftBottom           = 14,           -- 左下 军鼓
    Equip_Type_RightBottom          = 15,           -- 右下 马牌
    Equip_Type_Shield               = 16,           -- 盾牌
    
    Equip_Special_RingL             = 47,           -- 特戒左
    Equip_Special_RingR             = 48,           -- 特戒右
    Equip_Type_Veil                 = 55,           -- 面纱
    -- 时装
    Equip_Type_Super_Dress          = 17,           -- 神装衣服
    Equip_Type_Super_Weapon         = 18,           -- 神装武器
    Equip_Type_Super_Cap            = 19,           -- 时装斗笠
    Equip_Type_Super_Necklace       = 20,           -- 时装项链
    Equip_Type_Super_Helmet         = 21,           -- 时装头盔
    Equip_Type_Super_ArmRingL       = 22,           -- 时装左手镯
    Equip_Type_Super_ArmRingR       = 23,           -- 时装右手镯
    Equip_Type_Super_RingL          = 24,           -- 时装左戒指
    Equip_Type_Super_RingR          = 25,           -- 时装右戒指
    Equip_Type_Super_RightHand      = 26,           -- 时装勋章
    Equip_Type_Super_Belt           = 27,           -- 时装腰带
    Equip_Type_Super_Boots          = 28,           -- 时装靴子
    Equip_Type_Super_Charm          = 29,           -- 时装宝石
    Equip_Type_Super_RightBottom    = 42,           -- 时装马牌
    Equip_Type_Super_Bujuk          = 43,           -- 时装符印
    Equip_Type_Super_LeftBottom     = 44,           -- 时装军鼓
    Equip_Type_Super_Shield         = 45,           -- 时装盾牌
    Equip_Type_Super_Veil           = 46,           -- 时装面巾

    Equip_Fashion_Dress             = 49,           -- 时装衣服
    Equip_Fashion_Weapon            = 50,           -- 时装武器

    Equip_Type_BestRing1            = 30,           -- 极品首饰1
    Equip_Type_BestRing2            = 31,           -- 极品首饰2
    Equip_Type_BestRing3            = 32,           -- 极品首饰3
    Equip_Type_BestRing4            = 33,           -- 极品首饰4
    Equip_Type_BestRing5            = 34,           -- 极品首饰5
    Equip_Type_BestRing6            = 35,           -- 极品首饰6
    Equip_Type_BestRing7            = 36,           -- 极品首饰7
    Equip_Type_BestRing8            = 37,           -- 极品首饰8
    Equip_Type_BestRing9            = 38,           -- 极品首饰9
    Equip_Type_BestRing10           = 39,           -- 极品首饰10
    Equip_Type_BestRing11           = 40,           -- 极品首饰11
    Equip_Type_BestRing12           = 41,           -- 极品首饰12

    -- 71-100 后端发送，脚本自定义
}
GUIDefine.EquipPosUI = EquipPosUI

GUIDefine.EquipPosByStdModeOri = {
    [5]   = {EquipPosUI.Equip_Type_Weapon},
    [6]   = {EquipPosUI.Equip_Type_Weapon},
    [7]   = {EquipPosUI.Equip_Type_Charm},
    [10]  = {EquipPosUI.Equip_Type_Dress},
    [11]  = {EquipPosUI.Equip_Type_Dress},
    [14]  = {EquipPosUI.Equip_Type_Veil},
    [15]  = {EquipPosUI.Equip_Type_Helmet},
    [16]  = {EquipPosUI.Equip_Type_Cap}, -- 斗笠 要加位置
    [19]  = {EquipPosUI.Equip_Type_Necklace},
    [20]  = {EquipPosUI.Equip_Type_Necklace},
    [21]  = {EquipPosUI.Equip_Type_Necklace},
    [22]  = {EquipPosUI.Equip_Type_RingL, EquipPosUI.Equip_Type_RingR},
    [23]  = {EquipPosUI.Equip_Type_RingL, EquipPosUI.Equip_Type_RingR},
    [24]  = {EquipPosUI.Equip_Type_ArmRingL, EquipPosUI.Equip_Type_ArmRingR},
    [25]  = {EquipPosUI.Equip_Type_Bujuk,EquipPosUI.Equip_Type_ArmRingL},
    [26]  = {EquipPosUI.Equip_Type_ArmRingL,EquipPosUI.Equip_Type_ArmRingR},
    [28]  = {EquipPosUI.Equip_Type_RightBottom},
    [29]  = {EquipPosUI.Equip_Type_RightHand},
    [30]  = {EquipPosUI.Equip_Type_RightHand},
    [48]  = {EquipPosUI.Equip_Type_Shield},  -- 盾牌 加位置
    [51]  = {EquipPosUI.Equip_Type_Bujuk},
    [52]  = {EquipPosUI.Equip_Type_Boots},
    [53]  = {EquipPosUI.Equip_Type_Charm},
    [54]  = {EquipPosUI.Equip_Type_Belt},
    [62]  = {EquipPosUI.Equip_Type_Boots},
    [63]  = {EquipPosUI.Equip_Type_Charm},
    [64]  = {EquipPosUI.Equip_Type_Belt},
    [65]  = {EquipPosUI.Equip_Type_LeftBottom},
    [96]  = {EquipPosUI.Equip_Type_Bujuk},
    [100] = {EquipPosUI.Equip_Type_BestRing1},
    [101] = {EquipPosUI.Equip_Type_BestRing2},
    [102] = {EquipPosUI.Equip_Type_BestRing3},
    [103] = {EquipPosUI.Equip_Type_BestRing4},
    [104] = {EquipPosUI.Equip_Type_BestRing5},
    [105] = {EquipPosUI.Equip_Type_BestRing6},
    [106] = {EquipPosUI.Equip_Type_BestRing7},
    [107] = {EquipPosUI.Equip_Type_BestRing8},
    [108] = {EquipPosUI.Equip_Type_BestRing9},
    [109] = {EquipPosUI.Equip_Type_BestRing10},
    [110] = {EquipPosUI.Equip_Type_BestRing11},
    [111] = {EquipPosUI.Equip_Type_BestRing12},

    [66]  = {EquipPosUI.Equip_Type_Super_Dress},
    [67]  = {EquipPosUI.Equip_Type_Super_Dress},
    [68]  = {EquipPosUI.Equip_Type_Super_Weapon},
    [69]  = {EquipPosUI.Equip_Type_Super_Weapon},
    [75]  = {EquipPosUI.Equip_Type_Super_Necklace},
    [76]  = {EquipPosUI.Equip_Type_Super_Necklace},
    [77]  = {EquipPosUI.Equip_Type_Super_Necklace},
    [78]  = {EquipPosUI.Equip_Type_Super_Helmet},
    [79]  = {EquipPosUI.Equip_Type_Super_ArmRingL, EquipPosUI.Equip_Type_Super_ArmRingR},
    [80]  = {EquipPosUI.Equip_Type_Super_ArmRingL, EquipPosUI.Equip_Type_Super_ArmRingR},
    [81]  = {EquipPosUI.Equip_Type_Super_RingL, EquipPosUI.Equip_Type_Super_RingR},
    [82]  = {EquipPosUI.Equip_Type_Super_RingL, EquipPosUI.Equip_Type_Super_RingR},
    [83]  = {EquipPosUI.Equip_Type_Super_RightHand},
    [84]  = {EquipPosUI.Equip_Type_Super_Belt},
    [85]  = {EquipPosUI.Equip_Type_Super_Belt},
    [86]  = {EquipPosUI.Equip_Type_Super_Boots},
    [87]  = {EquipPosUI.Equip_Type_Super_Boots},
    [88]  = {EquipPosUI.Equip_Type_Super_Charm},
    [89]  = {EquipPosUI.Equip_Type_Super_Charm},
    [90]  = {EquipPosUI.Equip_Type_Super_RightBottom},
    [91]  = {EquipPosUI.Equip_Type_Super_Bujuk},
    [92]  = {EquipPosUI.Equip_Type_Super_LeftBottom},
    [93]  = {EquipPosUI.Equip_Type_Super_Shield},
    [94]  = {EquipPosUI.Equip_Type_Super_Veil},

    [50]  = {EquipPosUI.Equip_Type_Veil},
    [71]  = {EquipPosUI.Equip_Type_Super_Cap},

    [112] = {EquipPosUI.Equip_Special_RingL, EquipPosUI.Equip_Special_RingR},

    [166] = {EquipPosUI.Equip_Fashion_Dress},
    [167] = {EquipPosUI.Equip_Fashion_Dress},
    [168] = {EquipPosUI.Equip_Fashion_Weapon},
    [169] = {EquipPosUI.Equip_Fashion_Weapon},
}

GUIDefine.EquipPosByStdMode = clone(GUIDefine.EquipPosByStdModeOri)

GUIDefine.EquipMapByStdMode = {}
for StdMode,_ in pairs(GUIDefine.EquipPosByStdMode or {}) do
    GUIDefine.EquipMapByStdMode[StdMode] = true
end

-- 除了上述EquipMapByStdMode装备显示 5 6 武器 11 12 衣服 30照明物
GUIDefine.EquipMapExByStdmode = {
    [5]  = true,
    [6]  = true,
    [11] = true,
    [12] = true,
    [30] = true,
}

GUIDefine.EquipSexNeed = {
    [10] = 0,               -- 男
    [11] = 1,               -- 女
    [66] = 0,
    [67] = 1,
}

GUIDefine.EquipHandWeightType = {
    [5] = 1,
    [6] = 1
}

-- tips对比判断  首先找这里  没有再找EquipPosByStdMode
GUIDefine.TipsEquipPosByStdMode = {
    [25] = {EquipPosUI.Equip_Type_Bujuk}
}

-- 是否展示内观（玩家和英雄目前是通用的）
local showNaikanEquips = {
    [EquipPosUI.Equip_Type_Dress]           = true, -- 衣服
    [EquipPosUI.Equip_Type_Weapon]          = true, -- 武器
    [EquipPosUI.Equip_Type_Helmet]          = true, -- 头盔
    [EquipPosUI.Equip_Type_Cap]             = true, -- 斗笠
    [EquipPosUI.Equip_Type_Shield]          = true, -- 盾牌
    [EquipPosUI.Equip_Type_Veil]            = true, -- 面纱

    [EquipPosUI.Equip_Type_Super_Dress]     = true, -- 神装衣服
    [EquipPosUI.Equip_Type_Super_Weapon]    = true, -- 神装武器
    [EquipPosUI.Equip_Type_Super_Helmet]    = true, -- 神装头盔
    [EquipPosUI.Equip_Type_Super_Cap]       = true, -- 神装斗笠
    [EquipPosUI.Equip_Type_Super_Shield]    = true, -- 神装盾牌
    [EquipPosUI.Equip_Type_Super_Veil]      = true, -- 神装面巾

    [EquipPosUI.Equip_Fashion_Dress]        = true, -- 时装衣服
    [EquipPosUI.Equip_Fashion_Weapon]       = true, -- 时装武器
}
GUIDefine.IsNaikanEquip = function(equipPos)

    if equipPos == EquipPosUI.Equip_Type_Cap or equipPos == EquipPosUI.Equip_Type_Helmet then
        if SL:GetValue("GAME_DATA", "isSeparateHelmetAndCap") == 1 then
            showNaikanEquips[equipPos] = false
        else
            showNaikanEquips[equipPos] = true
        end
    end

    if equipPos == EquipPosUI.Equip_Type_Super_Cap or equipPos == EquipPosUI.Equip_Type_Super_Helmet then
        if SL:GetValue("GAME_DATA", "isSeparateSuperHelmetAndCap") == 1 then
            showNaikanEquips[equipPos] = false
        else
            showNaikanEquips[equipPos] = true
        end
    end

    return showNaikanEquips[equipPos or 0]
end


-- 剑甲分离配置
GUIDefine.EquipAllShow = {
    [EquipPosUI.Equip_Type_Dress]  = false,
    [EquipPosUI.Equip_Type_Weapon] = false,

    [EquipPosUI.Equip_Type_Super_Dress]  = false,
    [EquipPosUI.Equip_Type_Super_Weapon] = false
}

-- 用于装备界面中一个部位可以实现穿戴多个部位， 纯显示上
local Helmets = {
    EquipPosUI.Equip_Type_Cap, EquipPosUI.Equip_Type_Helmet, EquipPosUI.Equip_Type_Veil
}
local SuperHelmets = {
    EquipPosUI.Equip_Type_Super_Cap, EquipPosUI.Equip_Type_Super_Helmet, EquipPosUI.Equip_Type_Super_Veil
}
GUIDefine.EquipPosMappingEx = {
    [EquipPosUI.Equip_Type_Cap]          = Helmets,
    [EquipPosUI.Equip_Type_Veil]         = Helmets,
    [EquipPosUI.Equip_Type_Helmet]       = Helmets,
    
    [EquipPosUI.Equip_Type_Super_Cap]    = SuperHelmets,
    [EquipPosUI.Equip_Type_Super_Veil]   = SuperHelmets,
    [EquipPosUI.Equip_Type_Super_Helmet] = SuperHelmets
}

GUIDefine.EquipPosMapping = {
    [EquipPosUI.Equip_Type_Helmet]       = Helmets,
    [EquipPosUI.Equip_Type_Super_Helmet] = SuperHelmets
}

GUIDefine.ExAttType = {
    Max_DEF         = 0,
    Max_MDF         = 1,
    Max_ATK         = 2,
    Max_MAT         = 3,
    Max_Daoshu      = 4,
    Lucky           = 5,
    Hit_Point       = 6,
    Speed_Point     = 7,
    Hit_Speed       = 8,
    Anti_Magic      = 9,
    Anti_Posion     = 10,
    Health_Recover  = 11,
    Spell_Recover   = 12,
    Posion_Recover  = 13,

    Star            = 16,
    Fail_Star       = 17,
    Lian_hun        = 18,
    Refining        = 19,
    ATK_Defence     = 20,
    MAT_Defence     = 21,
    Ignore_Defence  = 22,
    Bounce_Damage   = 23,
    Health_Add      = 24,
    Magice_Add      = 25,
    More_Item       = 26,
    God_Damage      = 27,
    Strength        = 28,
    Curse           = 29,
    Double_Rate     = 30,
    Double_Damage   = 31,
    More_Damage     = 32,
}

-- 需要转换血量单位的属性
GUIDefine.HPUnitAttrs = {
    [attTypeTable.HP] = true,
    [attTypeTable.MP] = true,
    [attTypeTable.Min_ATK] = true,
    [attTypeTable.Max_ATK] = true,
    [attTypeTable.Min_ATK] = true,
    [attTypeTable.Max_ATK] = true,
    [attTypeTable.Min_MAT] = true,
    [attTypeTable.Max_MAT] = true,
    [attTypeTable.Min_Daoshu] = true,
    [attTypeTable.Max_Daoshu] = true,
    [attTypeTable.Min_DEF] = true,
    [attTypeTable.Max_DEF] = true,
    [attTypeTable.Min_MDF] = true,
    [attTypeTable.Max_MDF] = true
}

-- 合并属性
GUIDefine.MergeAttrConfig = {
    [attTypeTable.Min_ATK]      = {attTypeTable.Min_ATK, attTypeTable.Max_ATK},
    [attTypeTable.Max_ATK]      = {attTypeTable.Min_ATK, attTypeTable.Max_ATK},
    [attTypeTable.Min_MAT]      = {attTypeTable.Min_MAT, attTypeTable.Max_MAT},
    [attTypeTable.Max_MAT]      = {attTypeTable.Min_MAT, attTypeTable.Max_MAT},
    [attTypeTable.Min_Daoshu]   = {attTypeTable.Min_Daoshu, attTypeTable.Max_Daoshu},
    [attTypeTable.Max_Daoshu]   = {attTypeTable.Min_Daoshu, attTypeTable.Max_Daoshu},
    [attTypeTable.Min_DEF]      = {attTypeTable.Min_DEF, attTypeTable.Max_DEF},
    [attTypeTable.Max_DEF]      = {attTypeTable.Min_DEF, attTypeTable.Max_DEF},
    [attTypeTable.Min_MDF]      = {attTypeTable.Min_MDF, attTypeTable.Max_MDF},
    [attTypeTable.Max_MDF]      = {attTypeTable.Min_MDF, attTypeTable.Max_MDF},
}

for i = 5, 15 do
    local minKey = "Min_CustJobAttr_" .. i
    local maxKey = "Max_CustJobAttr_" .. i
    GUIDefine.MergeAttrConfig[attTypeTable[minKey]] = {attTypeTable[minKey], attTypeTable[maxKey]}
    GUIDefine.MergeAttrConfig[attTypeTable[maxKey]] = {attTypeTable[minKey], attTypeTable[maxKey]}
end

-- 物品来源
GUIDefine.ItemFrom = {
    BAG                 = 1,    -- 背包
    PLAYER_EQUIP        = 2,    -- 玩家身上
    QUICK_USE           = 3,    -- 快捷栏
    STORAGE             = 4,    -- 仓库
    BAG_GOLD            = 5,    -- 背包金币
    SELL                = 6,    -- 摆摊
    REPAIRE             = 7,    -- npc商店
    TRADE               = 8,    -- 面对面交易
    TRADE_GOLD          = 10,   -- 交易
    BEST_RINGS          = 11,   -- 极品首饰
    AUTO_TRADE          = 12,   -- 摆摊
    ITEMBOX             = 13,   -- 自定义UI ITEMBOX
    NPC_DO_SOMETHING    = 14,   -- NPC自定义放入框
    NEWTYPE             = 15,
    HERO_BAG            = 66,   --英雄背包
    HERO_EQUIP          = 67,   -- 英雄装备
    HERO_BEST_RINGS     = 68,   -- 英雄极品首饰
    GUI_ITEMBOX         = 77,   -- GUI ItemBox
    PETS_EQUIP          = 78,   -- 宠物装备
    SKILL_WIN           = 79,   -- PC 技能
    OTHER               = 99    -- 其他
}

GUIDefine.ItemGoTo = {
    BAG                 = 1,
    PLAYER_EQUIP        = 2,
    QUICK_USE           = 3,
    STORAGE             = 4,
    SELL                = 5,
    DROP                = 6,
    REPAIRE             = 7,
    TRADE               = 8,
    TRADE_GOLD          = 10,
    BAG_GOLD            = 11,   --背包金币
    BEST_RINGS          = 12,   -- 极品首饰
    AUTO_TRADE          = 13,   -- 摆摊
    ITEMBOX             = 14,   -- 自定义UI ITEMBOX
    NPC_DO_SOMETHING    = 15,   -- NPC自定义放入框
    TreasureBox         = 16,
    NEWTYPE             = 17,
    HERO_BAG            = 66,   --英雄背包
    HERO_EQUIP          = 67,   -- 英雄装备
    HERO_BEST_RINGS     = 68,   -- 英雄极品首饰
    GUI_ITEMBOX         = 77,   -- GUI ItemBox
    TOPUI               = 78,    
}

GUIDefine.ChatCDTime = {}

-- 寻路类型
GUIDefine.AutoMoveType = {
    TARGET              = 1,                -- 寻找目标   
	MINIMAP             = 2,                -- 小地图       
	CHAT                = 3,                -- 聊天框   
	SERVER              = 4,                -- 服务器通知  
}

-- 物品归属
GUIDefine.ItemBelong = {
    EQUIP               = 1,
    BAG                 = 2,
    QUICKUSE            = 3,
    STALL               = 4,
    STORAGE             = 5,
    HEROBAG             = 66,
    HEROEQUIP           = 67,
}

-- 物品规则
local itemArticleType = {
    TYPE_DROP                               = 1,    -- 禁止丢弃
    TYPE_TRADE                              = 2,    -- 禁止交易
    TYPE_STORAGE_STORE                      = 3,    -- 禁止存仓库
    TYPE_FIX                                = 4,    -- 禁止修理
    TYPE_SELL                               = 5,    -- 禁止出售
    TYPE_DIE_NOT_DROP                       = 6,    -- 禁止爆出
    TYPE_DROP_HIDE                          = 7,    -- 丢弃消失
    TYPE_DIE_DROP                           = 8,    -- 死亡必爆
    TYPE_TRADE_AUCTION                      = 9,    -- 禁止拍卖  摆摊和上架拍卖行 上架交易行也走这个
    TYPE_DROP_TITLE                         = 10,   -- 禁止掉落提示
    TYPE_DIE_DROP_HIDE                      = 11,   -- 死亡爆出消失
    TYPE_ONLINE_HIDE                        = 12,   -- 上线消失
    TYPE_HERO_USE                           = 13,   -- 禁止英雄使用
    TYPE_TAKE_ARMRINGL                      = 14,   -- 禁止左手镯位置穿戴
    TYPE_PICK                               = 15,   -- 禁止捡取
    TYPE_OFFLINE_DROP                       = 16,   -- 下线必掉
    TYPE_TAKE_OFF                           = 17,   -- 禁止脱下
    TYPE_PLAYER_USE                         = 18,   -- 禁止人物使用
}
GUIDefine.ItemArticleType = itemArticleType

----------------------------------------------操作类型-----------------------------------------------------
GUIDefine.OperateType = {
    INIT                = 0,                -- 初始
    ADD                 = 1,                -- 增加
    DEL                 = 2,                -- 删除
    CHANGE              = 3,                -- 改变
}
-----------------------------------------------------------------------------------------------------------

----------------------------------------------数据类型------------------------------------------------------
GUIDefine.EquipDataType = {
    EQUIP               = 1,
    HEROEQUIP           = 2,
    OTHER_EQUIP         = 3,
    OTHER_HEROEQUIP     = 4,
    TRADE_EQUIP         = 5,
    TRADE_HEROEQUIP     = 6
}

GUIDefine.BagType = {
    BAG = 1,
    HEROBAG = 2
}

GUIDefine.TitleType = {
    PLAYER              = 1,
    HERO                = 2
}

GUIDefine.RoleUIType = {
    PLAYER              = 1,
    HERO                = 2,
    PLAYER_OTHER        = 3,
    HERO_OTHER          = 4,
    TRADE_PLAYER        = 5,
    TRADE_HERO          = 6,
}
-----------------------------------------------------------------------------------------------------------

----------------------------------------------UI层级-------------------------------------------------------
GUIDefine.UIZ = 
{
    BOTTOM              = -3,               -- 战争迷雾最底层
    RTOUCH              = -2,               -- 按键触摸层
    MAIN                = -1,               -- 主界面
    NORMAL              = 1,                -- 正常界面(全屏)
    FUNC                = 2,                -- 功能按钮
    LOADING             = 3,                -- loading层
    TOBOX               = 4,                -- 弹出框
    LOADINGBAR          = 5,                -- 菊花转
    NOTICE              = 6,                -- 滚动层提示
    MOUSE               = 7,                -- 鼠标操作层
    MASK                = 8,                -- 遮盖一切
}
----------------------------------------------------------------------------------------------------------

----------------------------------------------组件事件-----------------------------------------------------
-- 输入框事件类型
GUIDefine.TextInputEventType =
{
    BEGAN               = 0,                -- 开始
    ENDED               = 1,                -- 取消
    CHANGE              = 2,                -- 改变
    RETURN              = 3,                -- 回车键
    SEND                = 4                 -- 发送
}

-- 触摸事件类型
GUIDefine.TouchEventType =
{
    BEGAN               = 0,
    MOVED               = 1,
    ENDED               = 2,
    CANCALED            = 3,
}

-- 滚动事件类型
GUIDefine.ScrollEventType = {
    SCROLL_TO_TOP       = 0,
    SCROLL_TO_BOTTOM    = 1,
    SCROLL_TO_LEFT      = 2,
    SCROLL_TO_RIGHT     = 3,
    SCROLLING           = 4,
    BOUNCE_TOP          = 5,
    BOUNCE_BOTTOM       = 6,
    BOUNCE_LEFT         = 7,
    BOUNCE_RIGHT        = 8,
    CONTAINER_MOVED     = 9,
    AUTOSCROLL_ENDED    = 10
}
----------------------------------------------------------------------------------------------------------

----------------------------------------------角色动作-----------------------------------------------------
GUIDefine.Action = {
    -- 角色动作
	INVALID             = 0xFF,
	IDLE                = 0,
	WALK                = 1,
	ATTACK              = 2,       
	SKILL               = 3,    
	DIE                 = 4,    
	STUCK               = 5,
	RUN                 = 6,
	BORN                = 7,
	READY               = 8,
	MINING              = 9,
	SITDOWN             = 10,
	DEATH               = 11,
	CHANGESHAPE         = 14,               -- 变身
	TURN                = 15,               -- 转身
	CAVE                = 16,               -- 钻回洞穴
	RIDE_RUN            = 17,
	UNKNOWN1            = 18,               -- 服务器触发怪物动作1
	UNKNOWN2            = 19,               -- 服务器触发怪物动作2
	UNKNOWN3            = 20,               -- 服务器触发怪物动作3
	DASH                = 21,               -- 野蛮冲撞
	ONPUSH              = 22,               -- 被野蛮
	DASH_WAITING        = 23,               -- 野蛮等待
	TELEPORT            = 24,               -- 瞬移
	IDLE_LOCK           = 25,               -- 站着等待
	YTPD                = 26,               -- 倚天辟地
	ZXC                 = 27,               -- 追心刺
	SJS                 = 28,               -- 三绝杀
	DYZ                 = 29,               -- 断岳斩
	HSQJ                = 30,               -- 横扫千军
	FWJ                 = 31,               -- 凤舞祭
	JLB                 = 32,               -- 惊雷爆
	BTXD                = 33,               -- 冰天雪地
	SLP                 = 34,               -- 双龙破
	HXJ                 = 35,               -- 虎啸诀
	BGZ                 = 36,               -- 八卦掌
	SYZ                 = 37,               -- 三焰咒
	WJGZ                = 38,               -- 万剑归宗
	DASH_FAIL 		    = 39,               -- 野蛮失败的撞墙动作
	SBYS                = 40,               -- 十步一杀

    ASSASSIN_RUN        = 41,               -- 刺客跑步
	ASSASSIN_SNEAK      = 42,               -- 刺客潜行
	ASSASSIN_SMITE      = 43,               -- 刺客重击
	ASSASSIN_SKILL      = 44,               -- 刺客施法
	ASSASSIN_SY         = 45,               -- 刺客霜月
	ASSASSIN_UNKNOWN    = 46,               -- 刺客未知动作 
	ASSASSIN_XFT        = 47,               -- 旋风腿
	JY                  = 48,               -- 箭雨1
	JY2                 = 49,               -- 箭雨2
	TSZ                 = 50,               -- 推山掌
	XLFH                = 51,               -- 降龙伏虎
}
----------------------------------------------------------------------------------------------------------

---------------------------------------------- 聊天 -------------------------------------------------------
-- 聊天类型
GUIDefine.ChatChannel = {
    COMMON              = 0,                -- 综合
    PRIVATE             = 1,                -- 私聊
    NEAR                = 2,                -- 附近
    SHOUT               = 3,                -- 喊话
    TEAM                = 4,                -- 组队
    GUILD               = 5,                -- 行会
    UNION               = 6,                -- 联盟
    WORLD               = 7,                -- 世界传音
    NATION              = 8,                -- 国家
    SYSTEM              = 9,                -- 系统
    CROSS               = 10,               -- 跨服
    GUILDTIPS           = 40,               -- 行会通知
    DROP                = 100,              -- 掉落
}

-- 聊天配置
GUIDefine.ChatConfig = {
    LIMIT_COUNT          = 50,              -- 聊天限制条数
    LIMIT_COUNT_PC       = 200,             -- 聊天限制条数 PC
    LIMIT_COUNT_MAIN     = 10,              -- 聊天限制条数 手机主界面聊天框
    INPUT_LENTH          = 20,              -- 输入限制长度
    INPUT_CACHE_COUNT    = 10,              -- 输入历史保存条数
    PRIVATE_COUNT        = 10,              -- 私聊列表
    LIMIT_COUNT_EX       = 3,               -- 置顶聊天限制条数
    MSG_LIMIT_COUNT      = 5000,            -- 聊天信息长度限制
}

-- 聊天频道对应前缀
GUIDefine.ChatChannelPrefix = {
    {channel = GUIDefine.ChatChannel.GUILD,     prefix   = "!~"},
    {channel = GUIDefine.ChatChannel.TEAM,      prefix   = "!!"},
    {channel = GUIDefine.ChatChannel.NATION,    prefix   = "!#"},
    {channel = GUIDefine.ChatChannel.CROSS,     prefix   = "!$"},
    {channel = GUIDefine.ChatChannel.SHOUT,     prefix   = "!"},
    {channel = GUIDefine.ChatChannel.PRIVATE,   prefix   = "/.+ ", pattern = "^/(.+) (.+)"},
    {channel = GUIDefine.ChatChannel.WORLD,     prefix   = "@传 "},
}

-- 聊天信息文本类型
GUIDefine.ChatTextType = {
    NORMAL              = 1,                -- 普通消息
    SYSTEMTIPS          = 2,                -- 系统通知消息，需使用特定的富文本解析
    FCTEXT              = 3,                -- 系统通知消息，需使用FColor富文本解析
    SRTEXT              = 4,                -- 系统通知消息，需使用SRText富文本解析
}

-- 聊天数据类型
GUIDefine.ChatMsgType = {
    POSITION            = 1,                -- 坐标
    EQUIP               = 2,                -- 装备
}

----------------------------------------------------------------------------------------------------------

GUIDefine.InputMoveType = {
    AUTOMOVE            = 1,
	JOYSTICK            = 2,
	GRID                = 3,
	LAUNCH              = 4,
	FINDITEM            = 5,
	OTHER               = 6,
}

-- 人物攻击模式
GUIDefine.PKModeType = {
    HAM_ALL             = 0,                -- 全体
	HAM_PEACE           = 1,                -- 和平
	HAM_GROUP           = 4,                -- 组队
	HAM_GUILD           = 5,                -- 公会
	HAM_SHANE           = 6,                -- 善恶
	HAM_NATION          = 7,                -- 国家
	HAM_CAMP            = 8,                -- 阵营
	HAM_SERVER          = 9                 -- 区服
}

-- 宝宝攻击状态
GUIDefine.PetPkType = {
    FOLLOW              = 1,                -- 跟随
    ATTACK              = 2,                -- 攻击
    LOCK_ATTACK         = 3,                -- 锁定攻击
    REST                = 4,                -- 休息
}

-- 玩家关系
GUIDefine.ActorRelationType = {
    RS_ENEMY            = 1,                -- 敌人
	RS_NO               = 2,                -- 非敌人,没有关系
	RS_GROUP            = 3,                -- 同队伍
	RS_GUILD            = 4,                -- 同行会
	RS_CAMP             = 5,                -- 同阵营
	RS_ALLIANCE         = 6,                -- 同盟
	RS_NATION           = 7,                -- 国家
	RS_SERVER           = 8,                -- 区服
	RS_DEAR             = 9, 			    -- 夫妻
	RS_MASTER           = 10, 			    -- 师徒
}

-- 气泡类型
GUIDefine.BubbleType = {
    MAIL                = 2,                -- 邮件
    TEAM_APPLY          = 3,                -- 组队申请
    TEAM_INVITE         = 4,                -- 组队邀请
    FRIEND_APPLY        = 5,                -- 好友申请
    GUILD_APPLY         = 10,               -- 行会申请
    GUILD_INVITE        = 11,               -- 行会邀请
    GUILD_ALLY_APPLY    = 13,               -- 行会结盟申请
    PRIVATE_CHAT        = 14,               -- 私聊
    HORSE_INVITE        = 15,               -- 上马邀请
    TRADE               = 16                -- 面对面交易
}

----------------------------------------------------------------------------------------------------------
-- 职业
GUIDefine.Job = {
    FIGHTER             = 0,                -- 战士
    WIZZARD             = 1,                -- 法师
    TAOIST              = 2                 -- 道士
}

-- 性别
GUIDefine.Sex = {
    MALE                = 0,                -- 男
    FEMALE              = 1                 -- 女
}

-- 默认性别
GUIDefine.DEFAULT_SEX    = GUIDefine.Sex.MALE

-- BGM类型
GUIDefine.BGMType = {
    LOGIN                = 101,             -- BGM 登陆界面
	SELECT               = 102,             -- BGM 选角界面
	DIE                  = 103,             -- BGM 死亡
	MAP                  = 104              -- BGM 地图
}

-- Actor 类型
GUIDefine.ActorType = 
{
    NONE            = -1,
    PLAYER          = 0,
    MONSTER         = 50,
    NPC             = 100,
    DROPITEM        = 150,
    SEFFECT         = 200,
    COLLECTION      = 250,
    HERO            = 400
}

----------------------------------------------------------------------------------------------------------
-- NPC打开出售修理
GUIDefine.NpcEventType = {
    SELL                = 1,                -- 出售
    REPAIRE             = 2,                -- 修理
    DOSOMETHING         = 3,                -- 自定义放入框 类似出售修理
    NEWTYPE             = 4                 -- 自定义放入框
}

-- NPC出售步骤
GUIDefine.NpcSellStep = {
    WAITING             = 1,
    ADD_ITEM            = 2,
    GET_PRICE           = 3,
    HAD_PRICE           = 4,
    SELLING             = 5,
    SELLED              = 6
}

-- NPC修理步骤
GUIDefine.NpcRepaireStep = {
    WAITING             = 1,
    ADD_ITEM            = 2,
    GET_PRICE           = 3,
    HAD_PRICE           = 4,
    REPAIRING           = 5,
    REPAIRED            = 6
}

-- NPC自定义步骤
GUIDefine.NpcDosomethingStep = {
    WAITING             = 1,
    ADD_ITEM            = 2,
    DO_THINGS           = 3,
    DONE                = 4
}

-- NPC新类型步骤
GUIDefine.NpcNewTypeStep = {
    WAITING             = 1,
    ADD_ITEM            = 2,
    DO_THINGS           = 3,
    DONE                = 4
}
----------------------------------------------------------------------------------------------------------
-- 新手引导
local GuideType = {
    NPC                 = 0,
    BAG                 = 1,
    EQUIP               = 2,
    HEROBAG             = 3,
    BAG_COMPONENT       = 7,
    STORE               = 9
}
GUIDefine.GuideType = GuideType

--引导 事件
GUIDefine.GuideEvent = {
    [GuideType.NPC]           = {start = "GUIDE_NPC_TALK_LOAD_SUCCESS",     close = "GUIDE_END_NPC_TALK_LAYER_CLOSED"},
    [GuideType.BAG]           = {start = "GUIDE_BAG_ITEM_LOAD_SUCCESS",     close = "GUIDE_BAG_LAYER_CLOSED"},
    [GuideType.HEROBAG]       = {start = "GUIDE_HEROBAG_ITEM_LOAD_SUCCESS", close = "GUIDE_HEROBAG_LAYER_CLOSED"},
    [GuideType.EQUIP]         = {start = "GUIDE_PLAYER_EQUIP_LOAD_SUCCESS"},
    [GuideType.BAG_COMPONENT] = {start = "GUIDE_BAG_COMPONENT_LOAD_SUCCESS"},
    [GuideType.STORE]         = {start = "GUIDE_STORE_ITEM_LOAD_SUCCESS"} 
}

--------------------------------------------
-- 关系通知类型
GUIDefine.RelationNoticeType = {
    KICKED      = 1,    -- 自己被踢出
    DISSOLVE    = 2,    -- 解散
    EXIT        = 3,    -- 他人退出
    JOIN        = 4,    -- 他人加入
}

----------------------------------------------------------------------------------------------------------
-- 释放优先级
GUIDefine.LaunchPriority = {
    SYSTEM      = 1,            -- system input
	ROBOT       = 2,            -- robot input
	USER        = 3,            -- user input
}

-- 释放类型
GUIDefine.LaunchType = {
	USER            = 1,            -- 主动释放
	AUTO            = 2,            -- 挂机释放
	LOCK            = 3,            -- 锁定目标释放
	ATTACK          = 4,            -- 强攻释放
}

----------------------------------------------------------------------------------------------------------
-- 黑夜状态
GUIDefine.DarkState = {
    DAYTIME     = 0,        -- 白天
    NIGHT       = 1,        -- 晚上
    SUNRISE     = 2,        -- 日出  
    EVENING     = 3         -- 傍晚
}

----------------------------------------------------------------------------------------------------------