

--MangleRank = Rock:NewAddon("MangleRank")
--MangleRank.version = "1.0"

--TODO
--add localization to strings
--allow for a  disable command
--allow for customization of report string

local L = Rock("LibRockLocale-1.0"):GetTranslationNamespace("MangleRank")
MangleRank = Rock:NewAddon("MangleRank", "LibRockConfig-1.0", "LibRockDB-1.0", "LibRockEvent-1.0")


MangleRank:SetDatabase("MangleRankDB")
MangleRank:SetDatabaseDefaults('profile', {
   enabled=true
})

function MangleRank:OnInitialize()
	local optionsTable = {
      name = "MangleRank",
      enabled = 1,
      last_notification = 0
   }

   self.lastMangleReport = 0

   self:SetConfigSlashCommand("/manglerank")
end

function MangleRank:OnEnable()
   self:AddEventListener("Blizzard", "COMBAT_LOG_EVENT_UNFILTERED")
end

function MangleRank:OnDisable()
   self:RemoveAllEventListeners()
end


function MangleRank:COMBAT_LOG_EVENT_UNFILTERED(namespace, event, ...)
   local timestamp, event = ...
   if event ~= "SPELL_CAST_SUCCESS" then return end

   local _,event,_,player,_,_,target,rank,spellid,_,_ = ...
   -- 33878 == mangle bear rank 1, 33876 == mangle cat rank 1
   if spellid == 33878 or
      spellid == 33876
      then 
      self:ReportMangleRank(player)
   end
end


function MangleRank:ReportMangleRank(player)
   local now = GetTime()
   if(now - self.lastMangleReport) > 300 then
      self.lastMangleReport = now
      SendChatMessage(player.." is a noob who forgot to train mangle ranks after respec", "SAY")
   end

end

