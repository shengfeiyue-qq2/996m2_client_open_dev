GUIShare = {}

-- 双击时间
GUIShare.CLICK_DOUBLE_TIME                 = 0.3

------------------------------------------------------------------------------------------------------------------------------------
-- 事件枚举
GUIShare.TouchEventType =
{
    began = 0,
    moved = 1,
    ended = 2,
    canceled = 3,
}
------------------------------------------------------------------------------------------------------------------------------------

-- 通用界面的信息
GUIShare.WinView = {
    LayWidth                            = 790,      -- 通用界面的 宽
    LayHeight                           = 536,      -- 通用界面的 高
    Width                               = 732,      -- 挂接区域的 宽
    Height                              = 445,      -- 挂接区域的 高
    HookX                               = 30,       -- 挂接区域的 x
    HookY                               = 40,       -- 挂接区域的 y
}

-- 界面切换页签样式(对应 cfg_colour_style 表的 id)
GUIShare.PageStyle = {
    Bag_Press_ColorID                   = 1003,
    Bag_Normal_ColorID                  = 1002,

    NpcStorage_Press_ColorID            = 1003,
    NpcStorage_Normal_ColorID           = 1002,

    Guild_Press_ColorID                 = 1003,
    Guild_Normal_ColorID                = 1002,

    Setting_Press_ColorID               = 1003,
    Setting_Normal_ColorID              = 1002,

    Player_Press_ColorID                = 1003,
    Player_Normal_ColorID               = 1002,

    Auction_Press_ColorID               = 1025,
    Auction_Normal_ColorID              = 1026,

    Store_Press_ColorID                 = 1025,
    Store_Normal_ColorID                = 1026,

    TradeBank_Press_ColorID             = 1003,
    TradeBank_Normal_ColorID            = 1002,

    MergeBag_Press_ColorID              = 1003,
    MergeBag_Normal_ColorID             = 1002,

    MergePlayer_Press_ColorID           = 1003,
    MergePlayer_Normal_ColorID          = 1002,

    MultiFuncFrame_Press_ColorID        = 1003,
    MultiFuncFrame_Normal_ColorID       = 1002,
}

-- 特效
GUIShare.SfxAnimates = {
    SkillSetClick                       = 4004,         -- 技能设置界面点击技能特效

    BoxNormalID                         = 4530,         -- 宝箱道具
    BoxAnimOpenID                       = 4511,
    OpenAnimID                          = 4512,

    GetTreasureBoxAnims = function (Shape)              -- 根据道具的 Shape 获取宝箱界面的特效
        -- [1] = 宝箱正常情况下的特效
        -- [2] = 宝箱打开时的特效
        -- [3] = 开宝箱的动画
        local anims = {
            [-1] = {            
                [1] = 4530,         
                [2] = 4511,         
                [3] = 4512          
            },          
        }           
        return anims[Shape] or anims[-1]            
    end,

    GoldBoxAnims = {                                    -- 摇一摇时宝箱每个格子的动画
        [1] = 4521, 
        [2] = 4522, 
        [3] = 4523, 
        [4] = 4524, 
        [5] = 4525, 
        [6] = 4526, 
        [7] = 4527, 
        [8] = 4528, 
        [9] = 4529
    }
}

---------------------------------------------------------------------------------------------------------------------------------
---------------------- 功能开关 ----------------------
-- 额外属性显示方式(true: 加在基础属性值后面，false: 并列显示在下面) (ItemTips)
GUIShare.IsAddToBaseAtt = true

-- 套装属性显示方式(true: 合并到属性一起, false: 独立显示) (ItemTips)
GUIShare.IsShowSuitCombine = true

-- 是否显示聊天喊话提示框
GUIShare.IsShowShutDialog = true
---------------------------------------------------------------------------------------------------------------------------------

-- 基础属性（1 ~ 60 对应 cfg_att_score 对应） ---------------------------------------
local BaseAttTypeTable = 
{
    HP                      = 1,        -- 生    命
    BHP                     = 2,        -- 生    命
    MP                      = 3,        -- 魔    法
    BMP                     = 4,        -- 魔    法
    MIN_ATK                 = 5,        -- 攻击下限
    MAX_ATK                 = 6,        -- 攻击上限
    BMIN_ATK                = 7,        -- 攻击下限
    BMAX_ATK                = 8,        -- 攻击上限
    MIN_MAG                 = 9,        -- 魔法下限
    MAX_MAG                 = 10,       -- 魔法上限
    BMIN_MAG                = 11,       -- 魔法下限
    BMAX_MAG                = 12,       -- 魔法上限
    MIN_DAO                 = 13,       -- 道术下限
    MAX_DAO                 = 14,       -- 道术上限
    BMIN_DAO                = 15,       -- 道术下限
    BMAX_DAO                = 16,       -- 道术上限
    MIN_DEF                 = 17,       -- 防御下限
    MAX_DEF                 = 18,       -- 防御上限
    BMIN_DEF                = 19,       -- 防御下限
    BMAX_DEF                = 20,       -- 防御上限
    MIN_MDF                 = 21,       -- 魔防下限
    MAX_MDF                 = 22,       -- 魔防上限
    BMIN_MDF                = 23,       -- 魔防下限
    BMAX_MDF                = 24,       -- 魔防上限
    HIT                     = 25,       -- 命    中
    MISS                    = 26,       -- 闪    避
    A_SPEED                 = 27,       -- 攻击速度
    M_SPEED                 = 28,       -- 移动速度
    BURST                   = 29,       -- 暴击几率
    BURST_DAM               = 30,       -- 暴击伤害
    IMM_ATT                 = 31,       -- 物伤减免
    BIMM_ATT                = 32,       -- 物伤减免
    PIMM_ATT                = 33,       -- 物免几率
    IMM_MAG                 = 34,       -- 魔伤减免
    BIMM_MAG                = 35,       -- 魔伤减免
    PIMM_MAG                = 36,       -- 魔免几率
    REF_ATT                 = 37,       -- 物伤反弹
    BREF_ATT                = 38,       -- 物伤反弹
    PREF_ATT                = 39,       -- 物反几率
    REF_MAG                 = 40,       -- 魔伤反弹
    BREF_MAG                = 41,       -- 魔伤反弹
    PREF_MAG                = 42,       -- 魔反几率
    IGN_DEF                 = 43,       -- 物理穿透
    BIGN_DEF                = 44,       -- 物理穿透
    PIGN_DEF                = 45,       -- 物穿几率
    IGN_MDF                 = 46,       -- 魔法穿透
    BIGN_MDF                = 47,       -- 魔法穿透
    PIGN_MDF                = 48,       -- 魔穿几率
    SUCK_HP                 = 49,       -- 吸    血
    BSUCK_HP                = 50,       -- 吸    血
    PSUCK_HP                = 51,       -- 吸血几率
    SUCK_MP                 = 52,       -- 吸    魔
    BSUCK_MP                = 53,       -- 吸    魔
    PSUCK_MP                = 54,       -- 吸魔几率
    LUCK                    = 55,       -- 幸    运
    DCR                     = 56,       -- 倍    攻
    BEXE                    = 57,       -- 经验倍率
    DROP                    = 58,       -- 怪物爆率
    PK_DROP                 = 59,       -- PK 爆率
    DEL_DROP                = 60,       -- 死亡掉装
    F_SPEED                 = 61,       -- 施法速度

    Weight                  = 94,       -- 当前重量
    Max_Weight              = 95,       -- 玩家最大负重
    Wear_Weight             = 96,       -- 穿戴负重
    Max_Wear_Weight         = 97,       -- 最大穿戴负重
    Hand_Weight             = 98,       -- 腕力
    Max_Hand_Weight         = 99,       -- 当前最大可穿戴腕力
}
GUIShare.BaseAttTypeTable = BaseAttTypeTable

function PShowAttType()
    return BaseAttTypeTable
end

---------------------------------------------------------------------------------------------------------------------------------
-- 需要 Min - Max 合成的属性值列表
local _mergeAttrConfig = {
    {name = "物攻", strFrm = "%d-%d", minID = BaseAttTypeTable.MIN_ATK, maxID = BaseAttTypeTable.MAX_ATK},
    {name = "魔攻", strFrm = "%d-%d", minID = BaseAttTypeTable.MIN_MAG, maxID = BaseAttTypeTable.MAX_MAG},
    {name = "道术", strFrm = "%d-%d", minID = BaseAttTypeTable.MIN_DAO, maxID = BaseAttTypeTable.MAX_DAO},
    {name = "物防", strFrm = "%d-%d", minID = BaseAttTypeTable.MIN_DEF, maxID = BaseAttTypeTable.MAX_DEF},
    {name = "魔防", strFrm = "%d-%d", minID = BaseAttTypeTable.MIN_MDF, maxID = BaseAttTypeTable.MAX_MDF},
    {name = "负重", strFrm = "%s/%s", minID = BaseAttTypeTable.Weight, maxID = BaseAttTypeTable.Max_Weight},
    {name = "穿戴", strFrm = "%s/%s", minID = BaseAttTypeTable.Wear_Weight, maxID = BaseAttTypeTable.Max_Wear_Weight},
    {name = "腕力", strFrm = "%s/%s", minID = BaseAttTypeTable.Hand_Weight, maxID = BaseAttTypeTable.Max_Hand_Weight}
}

-- 将值转化对应的百分比并返回(param: 1整数; 2万分比)
local GetAttPer = function(param, value)
    value = value or 0

    if value == 0 then
        return 0
    end

    if param == 2 then
        value = string.format("%s%%", string.format("%.2f", value/100) * 100 / 100)
    end

    return value
end
GUIShare.GetAttPer = GetAttPer

local function GetNewName(name)
    local lens = string.len(name)
    if lens == 6 then
        local addStr = "　　"
        local str1 = string.sub(name, 1, 3)
        local str2 = string.sub(name, 4, 6)
        local newStr = str1..addStr..str2
        name = newStr
    elseif lens == 9 then
        local addStr = "  "
        local addStr2 = "  "
        local str1 = string.sub(name, 1, 3)
        local str2 = string.sub(name, 4, 6)
        local str3 = string.sub(name, 7, 9)
        local newStr = str1..addStr..str2..addStr2..str3
        name = newStr
    end

    return name.."："
end

GUIShare.ParseBaseAtt = function (att)
    local attList = {}
    att = att or ""
    if string.len( att ) <= 1 then
        return attList
    end

    local attArray = SL:Split(att, "|")
    local myJob    = SL:GetRoleData().job

    for k,v in pairs(attArray) do
        local attData = SL:Split(v, "#")
        local needJob = tonumber(attData[1])     -- 职业需求 0-战; 1-法; 2-道; 3-全职
        local attID   = tonumber(attData[2])     -- 属性 ID
        local attVal  = tonumber(attData[3])     -- 属性 Value
        if (myJob == 3 or needJob == 3 or needJob == myJob) then
            if attList[attID] then
                attList[attID] = attList[attID] + attVal
            else
                attList[attID] = attVal
            end
        end
    end

    return attList
end

-- 自定义属性类型列表
GUIShare._CusTomAttType = {
    ADD = 0,             -- 极品加成属性
}

-- 获取自定义属性(type: 自定义类型)
GUIShare.GetCustomAttByType = function (itemData, type)
    if itemData and itemData.ExtAbil_Ex then
        return SL:CopyData(itemData.ExtAbil_Ex[type])
    end
    return nil
end

-- 相同属性相加
GUIShare.CombineToBaseAtt = function (attList1, attList2)
    attList1 = attList1 or {}
    attList2 = attList2 or {}

    local function valueAdd(value1, value2)
        local char
        if string.find(value1, "%/") then
            char = "/"
        elseif string.find(value1, "%-") then
            char = "-"
        end
        if not char then
            return tonumber(value1) + tonumber(value2)
        end

        local v1 = char == "/" and SL:Split(value1, "/") or SL:Split(value1, "-")
        local v2 = char == "/" and SL:Split(value2, "/") or SL:Split(value2, "-")
        local v1_val1 = tonumber(v1[1]) or 0
        local v1_val2 = tonumber(v1[2]) or 0

        local v2_val1 = tonumber(v2[1]) or 0
        local v2_val2 = tonumber(v2[2]) or 0
        
        return (v1_val1 + v2_val1) .. char .. (v1_val2 + v2_val2)
    end

    local function merge(d)
        for i,v in ipairs(attList1) do
            if v and v.attID == d.attID then
                attList1[i].value = valueAdd(attList1[i].value, d.value)
                return
            end
        end
        table.insert(attList1, d)
    end

    local newList = SL:CopyData(attList1)
    for k,v in ipairs(attList2) do
        if v and v.attID then
            merge(v)
        end
    end

    return attList1
end

-- 属性排序
GUIShare.AttSort = function (attArr)
    -- 按配置表 sort 字段排序
    table.sort(attArr, function (a, b)
        if a and b and a.sort and b.sort then
            return a.sort < b.sort
        else
            return false
        end
    end)
end

-- att = {key = value}
GUIShare.ParseAttList = function (attList)
    if not (attList and next(attList)) then
        return {}
    end
    
    local attArr = {}

    -- 获取组合属性值
    for _,v in ipairs(_mergeAttrConfig) do
        if v then
            if attList[v.minID] or attList[v.maxID] then
                local minVal = attList[v.minID] or 0
                local maxVal = attList[v.maxID] or 0
                -- 取完值之后删除该项属性
                attList[v.minID] = nil
                attList[v.maxID] = nil
                local cfgAtt = SL:GetAttConfigByAttId(v.maxID)
                if cfgAtt then
                    local value = string.format(v.strFrm, minVal, maxVal)
                    -- 插入到新表
                    table.insert(attArr, {
                        attID = v.maxID, name = GetNewName(v.name), value = value, color = cfgAtt.color, sort = v.maxID
                    })
                end
            end
        end
    end
    
    -- 获取其他属性值
    for attID,value in pairs(attList or {}) do
        if attID then
            local cfgAtt = SL:GetAttConfigByAttId(attID)
            if cfgAtt then
                value = GetAttPer(cfgAtt.type, value)
                local name  = cfgAtt.name
                if attID == BaseAttTypeTable.Strength then
                    name = "强度"
                end
                table.insert(attArr, {
                    attID = attID, name = GetNewName(name), value = value, color = cfgAtt.color, sort = attID
                })
            end
        end
    end

    return attArr
end

-- 不合并属性
GUIShare.ParseAttList2 = function (attList)
    if not (attList and next(attList)) then
        return {}
    end
    
    local attArr = {}
    -- 获取其他属性值
    for attID,value in pairs(attList or {}) do
        if attID then
            local cfgAtt = SL:GetAttConfigByAttId(attID)
            if cfgAtt then
                value = GetAttPer(cfgAtt.type, value)
                local name  = cfgAtt.name
                if attID == BaseAttTypeTable.Strength then
                    name = "强度"
                end
                table.insert(attArr, {
                    attID = attID, name = GetNewName(name), value = value, color = cfgAtt.color, sort = attID
                })
            end
        end
    end

    return attArr
end

-- isMerge 是否合并属性
GUIShare.GetAttrData = function (itemData, cusTomAttType, isMerge)
    if isMerge then
        return GUIShare.ParseAttList(GUIShare.GetCustomAttByType(itemData, cusTomAttType), isMerge)
    else
        return GUIShare.ParseAttList2(GUIShare.GetCustomAttByType(itemData, cusTomAttType), isMerge)
    end
end

---------------------------------------------------------------------------------------------------------------------------------


-------------------------------游戏设置相关配置------------------------------------------------------------------------------------
-- 设置--基础配置
local SetBaseCfg = {
    [1] = {
        -- 1.唯一ID        2.显示内容          3.默认勾选（1: 勾选； 0： 不勾选）   4.platform(1: windows模式)
        { id = 1,  content = "人名显示", default = 1 },
        { id = 2,  content = "数字显血", default = 1 },
        { id = 3,  content = "数字飘血", default = 1 },
        { id = 4,  content = "显示血条", default = 1 },
        { id = 5,  content = "怪物显名", default = 1 },
        { id = 6,  content = "单双摇杆", default = 1 },
        { id = 28, content = "残血提示", default = 1 },
        { id = 32, content = "平滑模式", default = 0, platform = 1 },
        { id = 33, content = "只显人名", default = 1 },
        { id = 34, content = "职业等级", default = 1 },
        { id = 35, content = "经验过滤", default = 0, default1 = 100, place = 2},   -- 默认经验过滤的值
        { id = 36, content = "装备比较", default = 1 },
        { id = 50, content = "持久提示", default = 1 },
        { id = 51, content = "自动修理", default = 1 },
        { id = 57, content = "人物简装", default = 0 },
        { id = 58, content = "怪物简装", default = 0 },
        { id = 62, content = "自动穿装备", default = 1 },
        { id = 65, content = "血量单位简写", default = 1 },
        { id = 67, content = "隐藏翅膀", default = 0 }

    },
    [2] = {
        { id = 29, content = "地图缩放", default1 = 1.25 }
    },
    [3] = {
        { id = 27, content = "背景音乐", default1 = 100 }
    },
    [4] = {
        { id = 52, content = "游戏音乐", default1 = 100 }
    }
}

-- 设置--保护配置
local SetProtectCfg = {
    -- default1: 默认低于多少的时候使用
    -- default2: 在 FindEatCDByIndex 中，在此处根据 id 设置 CD 信息
    { id = 7, content  = "生命值低于<font color='#ff0000'>%s%%</font> 自动使用回城卷", default = 1, default1 = 80 },
    { id = 8, content  = "生命值低于<font color='#ff0000'>%s%%</font> 自动使用随机卷", default = 1, default1 = 90 },
    { id = 9, content  = "生命值低于<font color='#ff0000'>%s%%</font> 自动使用红药HP", default = 1, default1 = 70 },
    { id = 10, content = "生命值低于<font color='#ff0000'>%s%%</font> 自动使用瞬回药", default = 1, default1 = 60 },
    { id = 11, content = "魔法值低于<font color='#ff0000'>%s%%</font> 自动使用蓝药MP", default = 1, default1 = 40 },
    { id = 12, content = "魔法值低于<font color='#ff0000'>%s%%</font> 自动使用瞬回药", default = 1, default1 = 20 },
    { id = 77, content = "魔法值低于<font color='#ff0000'>%s%%</font> 自动使用回城卷", default = 1, default1 = 10 },
    { id = 88, content = "魔法值低于<font color='#ff0000'>%s%%</font> 自动使用随机卷", default = 1, default1 = 20 }
}

-- 设置--战斗配置
GUIShare.SetBattleTitleCfg = {
    [1] = "综 合", [2] = "战 士", [3] = "法 师", [4] = "道士"
}

local SetBattleCfg = {
    [1] = {
        { id = 13,   content="自动走位",     default = 0 },
        { id = 14,   content="持续攻击",     default = 1 },
        { id = 30,   content="技能接平砍",   default = 1 },
        { id = 31,   content="免shift",     default = 0, platform = 1 },
        { id = 37,   content="魔法锁定",     default = 1 },
        { id = 38,   content="自动练功",     default = 0, default1 = nil, default2 = 5, place = 2 }, -- default1 : 自动练功的技能ID, default2: 自动练功 CD
        { id = 39,   content="清理尸体",     default = 1 },
        { id = 60,   content="取消摇杆攻击", default = 1 },
        { id = 61,   content="隐藏称号",     default = 0 },
        { id = 1002, content="高帧率模式",   default = 1 },
        { id = 2001, content="屏蔽召唤物",   default = 0 },
        { id = 2002, content="屏蔽特效",     default = 0 },
        { id = 2003, content="屏蔽已方玩家", default = 0 },
        { id = 2004, content="屏蔽玩家",     default = 0 },
        { id = 2005, content="屏蔽怪物",     default = 0 },
        { id = 3017, content="屏蔽技能特效",  default = 0 },
        { id = 41,   content="宝宝跟随攻击",  default = 0 }
    }, 
    -- 战
    [2] = {
        { id = 15, content = "刀刀刺杀",     default = 1 },
        { id = 56, content = "移动隔位刺杀", default = 0 },
        { id = 18, content = "智能半月",     default = 1 },
        { id = 53, content = "自动开天斩",   default = 1 },
        { id = 16, content = "自动烈火剑法", default = 1 },
        { id = 54, content = "自动逐日剑法", default = 1 }
    },
    -- 法
    [3] = {
        { id = 19, content = "自动魔法盾",  default = 1 },
        { id = 20, content = "自动火墙",    default = 1 },
        { id = 21, content = "群怪技能",    default = 0, place = 2 },
        { id = 47, content = "单体技能",    default = 0, place = 2 },
    },
    -- 道
    [4] = {
        { id = 22, content = "自动施毒",        default = 0 },
        { id = 23, content = "自动幽灵盾",      default = 0 },
        { id = 24, content = "自动神圣战甲术",   default = 0 },
        { id = 25, content = "生命值低于<font color='#ff0000'>%s%%</font> 时使用", default = 0, default1 = nil, default2 = 20, place = 2 }, -- default1 : 技能ID, default2: 默认值
        { id = 26, content = "自动召唤",        default = 0, place = 2 },
        { id = 40, content = "毒符互换",        default = 1 },
        { id = 55, content = "自动隐身",        default = 0 },
        { id = 59, content = "自动无极真气",    default = 0 }
    }
}

-- 设置--英雄配置
local SetHeroCfg = {
    -- 保护设置
    [1] = {
        { id = 3000, content = "生命值低于<font color='#ff0000'>%s%%</font> 自动使用回城卷", default = 1, default1 = 80 },
        { id = 3001, content = "生命值低于<font color='#ff0000'>%s%%</font> 自动使用随机卷", default = 1, default1 = 50 },
        { id = 3002, content = "魔法值低于<font color='#ff0000'>%s%%</font> 自动使用回城卷", default = 1, default1 = 50 },
        { id = 3003, content = "魔法值低于<font color='#ff0000'>%s%%</font> 自动使用随机卷", default = 1, default1 = 50 },
        { id = 3004, content = "生命值低于<font color='#ff0000'>%s%%</font> 自动使用红药HP", default = 1, default1 = 50 },
        { id = 3005, content = "生命值低于<font color='#ff0000'>%s%%</font> 自动使用瞬回药", default = 1, default1 = 50 },
        { id = 3006, content = "魔法值低于<font color='#ff0000'>%s%%</font> 自动使用蓝药MP", default = 1, default1 = 50 },
        { id = 3007, content = "魔法值低于<font color='#ff0000'>%s%%</font> 自动使用瞬回药", default = 1, default1 = 50 },
        { id = 3014, content = "英雄生命低于<font color='#ff0000'>%s%%</font> 时自动收回",   default = 0, default1 = 50 }
    },
    -- 英雄设置
    [2] = {
        { id = 3008, content = "屏蔽英雄",       default = 0 },
        { id = 3009, content = "合击震屏",       default = 1 },
        { id = 3010, content = "自动合击",       default = 0 },
        { id = 3011, content = "跟随主角攻击",   default  = 1 },
        { id = 3012, content = "英雄打怪物躲避", default  = 1 },
        { id = 3013, content = "自动召唤英雄",   default  = 0 }
    }
}

-- 其他设置
local SetOtherCfg = {
    {
        -- 组队界面
        { id = 4001, content = "允许组队", default = 0 }, 
        { id = 4002, content = "自动同意", default = 0 },
        { id = 4003, content = "允许添加", default = 0 },
        { id = 4004, content = "允许交易", default = 0 },
        { id = 4005, content = "允许挑战", default = 0 },
        { id = 4006, content = "允许显示", default = 0 },

        -- 装备界面
        { id = 4101, content = "时装外显示", default = 0 },  -- 玩家
        { id = 4102, content = "时装外显示", default = 0 },  -- 英雄

        { id = 66, content = "人物自动拾取", default = 1 }
    }
}

GUIShare.SetCfg = {
    SetBaseCfg = SetBaseCfg, SetProtectCfg = SetProtectCfg, SetBattleCfg = SetBattleCfg, SetHeroCfg = SetHeroCfg, SetOtherCfg = SetOtherCfg
}
---------------------------------------------------------------

-- 恢复类CD配置(获取人物道具恢复的 CD , index 是设置配置中的 id)
-- 默认使用的是 CD：当前默认值, minCD:可设置的最少值； maxCD：可设置的最大值
GUIShare.FindEatCDByIndex = function (index)
    local CDs = {
        [-1] = {CD = 1000, minCD = 1000, maxCD = 9999},    -- 默认值
        [7]  = {CD = 1000, minCD = 1000, maxCD = 9999},    -- 毫秒
        [8]  = {CD = 1000, minCD = 1000, maxCD = 9999},
        [9]  = {CD = 1000, minCD = 1000, maxCD = 9999},
        [10] = {CD = 1000, minCD = 1000, maxCD = 9999},
        [11] = {CD = 1000, minCD = 1000, maxCD = 9999},
        [12] = {CD = 1000, minCD = 1000, maxCD = 9999},
        [77] = {CD = 1000, minCD = 1000, maxCD = 9999},
        [88] = {CD = 1000, minCD = 1000, maxCD = 9999},
    }        
    return CDs[index] or CDs[-1]
end

-- 恢复类CD配置(英雄类，使用同上)
GUIShare.FindEatCDByIndex_Hero = function (index)
    local CDs = {
        [-1]   = {CD = 1000, minCD = 1000, maxCD = 9999},    -- 默认值
        [3000] = {CD = 1000, minCD = 1000, maxCD = 9999},    -- 毫秒
        [3001] = {CD = 1000, minCD = 1000, maxCD = 9999},
        [3002] = {CD = 1000, minCD = 1000, maxCD = 9999},
        [3003] = {CD = 1000, minCD = 1000, maxCD = 9999},
        [3004] = {CD = 1000, minCD = 1000, maxCD = 9999},
        [3005] = {CD = 1000, minCD = 1000, maxCD = 9999},
        [3006] = {CD = 1000, minCD = 1000, maxCD = 9999},
        [3007] = {CD = 1000, minCD = 1000, maxCD = 9999},
    }        
    return CDs[index] or CDs[-1]
end

-- 恢复类消耗道具组  { 设置ID = 道具组 }
GUIShare.ProtectItemsCfg = {
    [7]  = {20001},
    [8]  = {20002}, 
    [9]  = {20003},
    [10] = {20004},
    [11] = {20006},
    [12] = {20007},
    [77] = {20015},
    [88] = {20014},

    [3000]  = {20001},
    [3001]  = {20002},
    [3002]  = {20003},
    [3003]  = {20004},
    [3004]  = {20006},
    [3005]  = {20007},
    [3006]  = {20015},
    [3007]  = {20014},
}

GUIShare.FindItemsByIndex = function (index)
    return GUIShare.ProtectItemsCfg[index] or { }
end

-----------------------------------------------------------------------------------------------------------------------------------

----------------服务器定义的开关等字段-----------------------------------------------------------------------------------------------
GUIShare.ServerOption = {
    SHOW_ALL_FIGHTPAGES = "SHOW_ALL_FIGHTPAGES",            -- 服务器开关 设置显示所有战斗页
    OPTION_TRADE_DEAL = "Deal",                             -- 服务器开关 面对面交易 true/需要面对面
    SERVER_OPTION_SNDAITEMBOX = "ShowSndaItemBox",          -- 是否显示首饰盒
    EQUIP_EXTRA_POS = "EquipPanelType",                     -- 是否有额外的装备位置  1= 开启 0 = 关闭
    SERVER_OPTION_OPEN_F_EQUIP = "OpenFEquip",              -- 服务器开关 时装是否开启首饰
}

------------------------------装备配置----------------------------------------------------------------------------------------------
-- 装备 Pos 配置
local EquipPosTypeConfig = {
    --普通装备
    Equip_Type_Dress       = 0,            --// 衣服
    Equip_Type_Weapon      = 1,            --// 武器
    Equip_Type_RightHand   = 2,            --// 勋章
    Equip_Type_Necklace    = 3,            --// 项链
    Equip_Type_Helmet      = 4,            --// 头盔
    Equip_Type_ArmRingL    = 5,            --// 左手镯
    Equip_Type_ArmRingR    = 6,            --// 右手镯      左右以人物内观内的左右为标准
    Equip_Type_RingL       = 7,            --// 左戒指
    Equip_Type_RingR       = 8,            --// 右戒指
    Equip_Type_Bujuk       = 9,            --// 护身符位置 玉佩 宝珠
    Equip_Type_Belt        = 10,           --// 腰带
    Equip_Type_Boots       = 11,           --// 鞋子
    Equip_Type_Charm       = 12,           --// 宝石        
    Equip_Type_Cap         = 13,           --// 斗笠
    Equip_Type_LeftBottom  = 14,           --// 左下 军鼓
    Equip_Type_RightBottom = 15,           --// 右下 马牌
    Equip_Type_Shield      = 16,           --// 盾牌
    
    Equip_Type_Super_Dress = 17,           --// 神装衣服 --冰雪是神魔套装
    Equip_Type_Super_Weapon= 18,           --// 神装武器
    Equip_Type_Super_Cap   = 19,           --// 时装斗笠
    Equip_Type_Super_Necklace = 20,        --// 时装项链
    Equip_Type_Super_Helmet = 21,          --// 时装头盔
    Equip_Type_Super_ArmRingL = 22,        --// 时装左手镯
    Equip_Type_Super_ArmRingR = 23,        --// 时装右手镯
    Equip_Type_Super_RingL = 24,           --// 时装左戒指
    Equip_Type_Super_RingR = 25,           --// 时装右戒指
    Equip_Type_Super_RightHand = 26,       --// 时装勋章
    Equip_Type_Super_Belt = 27,            --// 时装腰带
    Equip_Type_Super_Boots = 28,           --// 时装靴子
    Equip_Type_Super_Charm = 29,           --// 时装宝石
    Equip_Type_Super_RightBottom = 42,     --// 时装马牌
    Equip_Type_Super_Bujuk = 43,           --// 时装符印
    Equip_Type_Super_LeftBottom = 44,      --// 时装军鼓
    Equip_Type_Super_Shield = 45,          --// 时装盾牌
    Equip_Type_Super_Veil = 46,            --// 时装面巾

    Equip_Type_BestRing1   = 30,           --// 生肖1
    Equip_Type_BestRing2   = 31,           --// 生肖2
    Equip_Type_BestRing3   = 32,           --// 生肖3
    Equip_Type_BestRing4   = 33,           --// 生肖4
    Equip_Type_BestRing5   = 34,           --// 生肖5
    Equip_Type_BestRing6   = 35,           --// 生肖6
    Equip_Type_BestRing7   = 36,           --// 生肖7
    Equip_Type_BestRing8   = 37,           --// 生肖8
    Equip_Type_BestRing9   = 38,           --// 生肖9
    Equip_Type_BestRing10  = 39,           --// 生肖10
    Equip_Type_BestRing11  = 40,           --// 生肖11
    Equip_Type_BestRing12  = 41,           --// 生肖12


    Equip_Type_Veil        = 55,           --// 面纱
    Equip_Type_Wing        = 56,           --// 翅膀
    Equip_Type_Super_Wing  = 57,           -- 神装翅膀

    Equip_Type_Max         = 30,

    Equip_Special_RingL    = 47,            -- 特戒左
    Equip_Special_RingR    = 48,            -- 特戒右

    Equip_Fashion_Dress    = 49,            -- 时装衣服
    Equip_Fashion_Weapon   = 50,            -- 时装武器
    
    Equip_Type_Embattle    = 999,           -- 脚底光环
}
GUIShare.EquipPosTypeConfig = EquipPosTypeConfig

-- StdMode 对应装备 Pos 配置
GUIShare.EquipPosByStdMode = {
    [5] = {EquipPosTypeConfig.Equip_Type_Weapon},
    [6] = {EquipPosTypeConfig.Equip_Type_Weapon},
    [7] = {EquipPosTypeConfig.Equip_Type_Charm},
    [10] = {EquipPosTypeConfig.Equip_Type_Dress},
    [11] = {EquipPosTypeConfig.Equip_Type_Dress},
    [14] = {EquipPosTypeConfig.Equip_Type_Veil},
    [15] = {EquipPosTypeConfig.Equip_Type_Helmet},
    [16] = {EquipPosTypeConfig.Equip_Type_Cap}, -- 斗笠 要加位置
    [19] = {EquipPosTypeConfig.Equip_Type_Necklace},
    [20] = {EquipPosTypeConfig.Equip_Type_Necklace},
    [21] = {EquipPosTypeConfig.Equip_Type_Necklace},
    [22] = {EquipPosTypeConfig.Equip_Type_RingL,EquipPosTypeConfig.Equip_Type_RingR},
    [23] = {EquipPosTypeConfig.Equip_Type_RingL,EquipPosTypeConfig.Equip_Type_RingR},
    [24] = {EquipPosTypeConfig.Equip_Type_ArmRingL,EquipPosTypeConfig.Equip_Type_ArmRingR},
    [25] = {EquipPosTypeConfig.Equip_Type_Bujuk},
    [26] = {EquipPosTypeConfig.Equip_Type_ArmRingL,EquipPosTypeConfig.Equip_Type_ArmRingR},
    [28] = {EquipPosTypeConfig.Equip_Type_RightBottom},
    [29] = {EquipPosTypeConfig.Equip_Type_Wing},
    [30] = {EquipPosTypeConfig.Equip_Type_RightHand},
    [48] = {EquipPosTypeConfig.Equip_Type_Shield},  -- 盾牌 加位置
    [51] = {EquipPosTypeConfig.Equip_Type_Bujuk},
    [52] = {EquipPosTypeConfig.Equip_Type_Boots},
    [53] = {EquipPosTypeConfig.Equip_Type_Charm},
    [54] = {EquipPosTypeConfig.Equip_Type_Belt},
    [62] = {EquipPosTypeConfig.Equip_Type_Boots},
    [63] = {EquipPosTypeConfig.Equip_Type_Charm},
    [64] = {EquipPosTypeConfig.Equip_Type_Belt},
    [65] = {EquipPosTypeConfig.Equip_Type_LeftBottom},
    [95] = {EquipPosTypeConfig.Equip_Type_Super_Wing},
    [96] = {EquipPosTypeConfig.Equip_Type_Bujuk},
    [100] = {EquipPosTypeConfig.Equip_Type_BestRing1},
    [101] = {EquipPosTypeConfig.Equip_Type_BestRing2},
    [102] = {EquipPosTypeConfig.Equip_Type_BestRing3},
    [103] = {EquipPosTypeConfig.Equip_Type_BestRing4},
    [104] = {EquipPosTypeConfig.Equip_Type_BestRing5},
    [105] = {EquipPosTypeConfig.Equip_Type_BestRing6},
    [106] = {EquipPosTypeConfig.Equip_Type_BestRing7},
    [107] = {EquipPosTypeConfig.Equip_Type_BestRing8},
    [108] = {EquipPosTypeConfig.Equip_Type_BestRing9},
    [109] = {EquipPosTypeConfig.Equip_Type_BestRing10},
    [110] = {EquipPosTypeConfig.Equip_Type_BestRing11},
    [111] = {EquipPosTypeConfig.Equip_Type_BestRing12},

    [66] = {EquipPosTypeConfig.Equip_Type_Super_Dress},
    [67] = {EquipPosTypeConfig.Equip_Type_Super_Dress},
    [68] = {EquipPosTypeConfig.Equip_Type_Super_Weapon},
    [69] = {EquipPosTypeConfig.Equip_Type_Super_Weapon},
    [75] = {EquipPosTypeConfig.Equip_Type_Super_Necklace},
    [76] = {EquipPosTypeConfig.Equip_Type_Super_Necklace},
    [77] = {EquipPosTypeConfig.Equip_Type_Super_Necklace},
    [78] = {EquipPosTypeConfig.Equip_Type_Super_Helmet},
    [79] = {EquipPosTypeConfig.Equip_Type_Super_ArmRingL,EquipPosTypeConfig.Equip_Type_Super_ArmRingR},
    [80] = {EquipPosTypeConfig.Equip_Type_Super_ArmRingL,EquipPosTypeConfig.Equip_Type_Super_ArmRingR},
    [81] = {EquipPosTypeConfig.Equip_Type_Super_RingL,EquipPosTypeConfig.Equip_Type_Super_RingR},
    [82] = {EquipPosTypeConfig.Equip_Type_Super_RingL,EquipPosTypeConfig.Equip_Type_Super_RingR},
    [83] = {EquipPosTypeConfig.Equip_Type_Super_RightHand},
    [84] = {EquipPosTypeConfig.Equip_Type_Super_Belt},
    [85] = {EquipPosTypeConfig.Equip_Type_Super_Belt},
    [86] = {EquipPosTypeConfig.Equip_Type_Super_Boots},
    [87] = {EquipPosTypeConfig.Equip_Type_Super_Boots},
    [88] = {EquipPosTypeConfig.Equip_Type_Super_Charm},
    [89] = {EquipPosTypeConfig.Equip_Type_Super_Charm},
    [90] = {EquipPosTypeConfig.Equip_Type_Super_RightBottom},
    [91] = {EquipPosTypeConfig.Equip_Type_Super_Bujuk},
    [92] = {EquipPosTypeConfig.Equip_Type_Super_LeftBottom},
    [93] = {EquipPosTypeConfig.Equip_Type_Super_Shield},
    [94] = {EquipPosTypeConfig.Equip_Type_Super_Veil},

    [50] = {EquipPosTypeConfig.Equip_Type_Veil},
    [71] = {EquipPosTypeConfig.Equip_Type_Super_Cap},

    [112] = {EquipPosTypeConfig.Equip_Special_RingL,EquipPosTypeConfig.Equip_Special_RingR},

    [166] = {EquipPosTypeConfig.Equip_Fashion_Dress},
    [167] = {EquipPosTypeConfig.Equip_Fashion_Dress},
    [168] = {EquipPosTypeConfig.Equip_Fashion_Weapon},
    [169] = {EquipPosTypeConfig.Equip_Fashion_Weapon},
}

-- 装备部位描述
GUIShare.EquipPosTips = {
    [0]="衣服",
    [1]="武器",
    [2]="勋章",
    [3]="项链",
    [4]="头盔",
    [5]="手镯",
    [6]="手镯",
    [7]="戒指",
    [8]="戒指",
    [9]="佩饰",
    [10]="腰带",
    [11]="鞋子",
    [12]="宝珠",
    [13]="斗笠",
    [14]="佩饰",
    [15]="守护",
    [16]="盾牌",
    [17]="衣服",
    [18]="武器",
    [19]="斗笠",
    [20]="项链",
    [21]="头盔",
    [22]="手镯",
    [23]="手镯",
    [24]="戒指",
    [25]="戒指",
    [26]="勋章",
    [27]="腰带",
    [28]="靴子",
    [29]="宝石",
    [30]="生肖1",
    [31]="生肖2",
    [32]="生肖3",
    [33]="生肖4",
    [34]="生肖5",
    [35]="生肖6",
    [36]="生肖7",
    [37]="生肖8",
    [38]="生肖9",
    [39]="生肖10",
    [40]="生肖11",
    [41]="生肖12"
}

------------------------------------------------------------------------------------------------------------------------------------ 
-- 用于装备界面中一个部位可以实现穿戴多个部位， 纯显示上
local EquipPosMapping = {
    [EquipPosTypeConfig.Equip_Type_Helmet] = {
        EquipPosTypeConfig.Equip_Type_Helmet,
        EquipPosTypeConfig.Equip_Type_Veil,
        EquipPosTypeConfig.Equip_Type_Cap
    },  --斗笠在显示上为在头盔位置
    [EquipPosTypeConfig.Equip_Type_Super_Helmet] = {
        EquipPosTypeConfig.Equip_Type_Super_Helmet,
        EquipPosTypeConfig.Equip_Type_Super_Veil,
        EquipPosTypeConfig.Equip_Type_Super_Cap
    }
}
GUIShare.EquipPosMapping = EquipPosMapping

GUIShare.GetEquipMappingConfig = function (pos)
    return EquipPosMapping[pos]
end

-- 通过装备位置反向取装备显示部位
GUIShare.GetDeEquipMappingConfig = function (pos)
    for belongPos,v in pairs(EquipPosMapping) do
        for _,_pos in pairs(v) do
            if _pos == pos then
                return belongPos
            end
        end
    end
    return false
end

-- 是否展示内观（玩家和英雄目前是通用的）
GUIShare.IsNaikanEquip = function (equipPos)
    local items = {
        [EquipPosTypeConfig.Equip_Type_Dress]           = true, -- 衣服
        [EquipPosTypeConfig.Equip_Type_Weapon]          = true, -- 武器
        [EquipPosTypeConfig.Equip_Type_Helmet]          = true, -- 头盔
        [EquipPosTypeConfig.Equip_Type_Cap]             = true, -- 斗笠
        [EquipPosTypeConfig.Equip_Type_Shield]          = true, -- 盾牌
        [EquipPosTypeConfig.Equip_Type_Veil]            = true, -- 面纱
        [EquipPosTypeConfig.Equip_Type_Wing]            = true, -- 翅膀

        [EquipPosTypeConfig.Equip_Type_Super_Dress]     = true, -- 神装衣服
        [EquipPosTypeConfig.Equip_Type_Super_Weapon]    = true, -- 神装武器
        [EquipPosTypeConfig.Equip_Type_Super_Helmet]    = true, -- 神装头盔
        [EquipPosTypeConfig.Equip_Type_Super_Cap]       = true, -- 神装斗笠
        [EquipPosTypeConfig.Equip_Type_Super_Shield]    = true, -- 神装盾牌
        [EquipPosTypeConfig.Equip_Type_Super_Veil]      = true, -- 神装面巾
        [EquipPosTypeConfig.Equip_Type_Super_Wing]      = true, -- 神装翅膀

        [EquipPosTypeConfig.Equip_Fashion_Dress]        = true, -- 时装衣服
        [EquipPosTypeConfig.Equip_Fashion_Weapon]       = true, -- 时装武器
    }
    return items[equipPos or 0]
end

GUIShare.EquipNaikanShow = {
    [EquipPosTypeConfig.Equip_Type_Helmet] = true,  -- 头盔是否展示内观
    [EquipPosTypeConfig.Equip_Type_Cap] = true      -- 斗笠是否内观
}

-- 装备特效和图标都显示且独立
GUIShare.EquipAllShow = {
    [EquipPosTypeConfig.Equip_Type_Wing] = true,
    [EquipPosTypeConfig.Equip_Type_Super_Wing] = true
}

-- 模型是否单个创建
GUIShare.IsCreateSingleModel = false

------------------------------------------------------------------------------------------------------------------------------------
-- 背包格子配置
GUIShare.BagGridSet = {
    ScrollHeight  = 320,       -- 容器滚动区域的高度
    VisibleWidth  = 500,       -- 容器可见区域 宽
    VisibleHeight = 320,       -- 容器可见区域 高
    ItemWidth     = 62.5,      -- item 宽 (ItemWidth   / Col)
    ItemWHeight   = 64,        -- item 高 (ItemWHeight / Row)
    Row           = 5,         -- 行数
    Col           = 8,         -- 列数
    PerPageNum    = 40,        -- 每页的数量（Row * Col）
    MaxPage       = 5          -- 一共 5 页
}

-- 仓库格子配置
GUIShare.NpcStorageGridSet = {
    ScrollHeight  = 384,       -- 容器滚动区域的高度
    VisibleWidth  = 508,       -- 容器可见区域 宽
    VisibleHeight = 384,       -- 容器可见区域 高
    ItemWidth     = 63.5,      -- item 宽 (ItemWidth   / Col)
    ItemWHeight   = 64,        -- item 高 (ItemWHeight / Row)
    Row           = 6,         -- 行数
    Col           = 8,         -- 列数
    PerPageNum    = 48,        -- 每页的数量（Row * Col）
    MaxPage       = 5          -- 一共 5 页
}

------------------------------------------------------------------------------------------------------------------------------------

-- PC 鼠标样式
GUIShare.IsOpenCursorStyle      = false     -- PC 是否开启鼠标多样式（默认关闭）
GUIShare.CURSOR_TYPE_NORMAL     = 0         -- 正常样式
GUIShare.CURSOR_TYPE_PLAYER     = 1         -- 鼠标经过[玩家]样式
GUIShare.CURSOR_TYPE_MONSTER    = 2         -- 鼠标经过[怪物]样式
GUIShare.CURSOR_TYPE_NPC        = 3         -- 鼠标经过[NPC]样式
GUIShare.CURSOR_TYPE_DROPITEM   = 4         -- 鼠标经过[掉落物]样式
GUIShare.GetMouseStylePic = function (type)
    return string.format("res/private/cursor/%s.png", type)
end
------------------------------------------------------------------------------------------------------------------------------------

-- 显示顺序右上到下(下标由小到大)
GUIShare.AliasIndexPre = 1              -- 玩家身上-称谓前缀显示下标
GUIShare.PlayerNameIndex = 2            -- 玩家身上-名字显示下标
GUIShare.AliasIndexSuf = 3              -- 玩家身上-称谓后缀显示下标
GUIShare.GuildeNameIndex = 4            -- 玩家身上-行会名字显示下标

------------------------------------------------------------------------------------------------------------------------------------
-- 操作类型
GUIShare.Operator_Init          = 0      --初始
GUIShare.Operator_Add           = 1      --增加
GUIShare.Operator_Sub           = 2      --删除
GUIShare.Operator_Change        = 3      --改变
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
-- 部分打印屏蔽, 默认打印
-- [GUI LOG] SL:SubmitForm ...
-- [GUI LOG] lib996:showformwithcontent ...
GUIShare.IsForbidLog = false

------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
-- 996 盒子称号界面位置
GUIShare.Box996TitlePos = { x = -30, y = -75 }
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
-- PC 聊天前缀
GUIShare.ChatPrefixOnPC = {
    [4]     = "〖行会〗",
    [5]     = "〖组队〗"
}
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
-- 队伍召集令
GUIShare.CallTeamFunc = function ()
    local memberCount = SL:GetTeamMemberCount()
    if memberCount <= 0 then
        return SL:ShowSystemTips("未组队，无法使用!")
    end
    if memberCount == 1 then
        return SL:ShowSystemTips("缺少成员，无法召集!")
    end

    -- 消耗召集道具
    local itemIndex = 3020001
    local itemName  = SL:GetItemNameByIndex(itemIndex)
    if SL:GetItemNumberByIndex(itemIndex, true) < 1 then
        return SL:ShowSystemTips(string.format("缺少%s!", itemName))
    end

    local callback = function (type)
        if 1 == type then
            SL:UseItemByIndex(itemIndex) 
        end
    end
    SL:OpenCommonTipsPop({
        str = string.format("确认使用%s?", itemName), 
        callback = callback,
        btnType = 2
    })
end
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
-- PC 是否竖屏, 默认横屏
GUIShare.PcIsPortraitScreen = false

------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
-- 关闭内挂自动穿戴状态时, 是否显示装备使用弹窗
GUIShare.IsShowAutoUsePop = true

------------------------------------------------------------------------------------------------------------------------------------