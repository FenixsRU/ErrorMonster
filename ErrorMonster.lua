--
-- ErrorMonster
-- by Rabbit
-- originally RogueSpam by Allara
--

ErrorMonster = AceLibrary("AceAddon-2.0"):new("AceHook-2.0", "AceConsole-2.0", "AceDB-2.0", "AceEvent-2.0")

local L = AceLibrary("AceLocale-2.0"):new("ErrorMonster")
ErrorMonster.L = L

function ErrorMonster:OnInitialize()
	ErrorMonster:RegisterDB("ErrorMonsterDB", "ErrorMonsterDBChar")

    ErrorMonster:RegisterDefaults('char', {
    	errorList = {
ERR_ABILITY_COOLDOWN, 					-- Ability is not ready yet.
ERR_OUT_OF_ENERGY,							-- Not enough energy
ERR_NO_ATTACK_TARGET,						-- There is nothing to attack.
SPELL_FAILED_NO_COMBO_POINTS,		-- That ability requires combo points
SPELL_FAILED_TARGETS_DEAD,			-- Your target is dead
SPELL_FAILED_SPELL_IN_PROGRESS,	-- Another action is in progress
					 },
	})

	local args = {
		type = "group",
		args = {		
			list = {
				name = "list", type = "execute",
				desc = L"Shows the current filters and their ID number.",
                func = function() ErrorMonster.ListFilters() end,
            },
			add = {
				name  = "add", type = "text",
				desc  = L"Adds [message] to the filter list.",
				usage = L"<filter>",
				set   = function(text) self:AddFilter(text) end,
				get   = false,
			},
			remove = {
			     name = "remove", type = "text",
			     desc = L"Removes the message [id] from the filter list.",
			     usage = L"<filter>",
			     set = function(text) self:RemoveFilter(text) end,
			     get = false,
			},
		},				
	}
	
	self:RegisterChatCommand({"/errormonster", "/em"}, args)
end

function ErrorMonster:OnEnable()
	self:Hook("UIErrorsFrame_OnEvent", "ErrorFrameOnEvent")
	--  CHAT_MSG_SPELL_FAILED_LOCALPLAYER
end

function ErrorMonster:ErrorFrameOnEvent(event, message, arg1, arg2, arg3, arg4)
	for key, text in self.db.char.errorList do
		if (text and message) then if (message == text) then return; end end
   	end
   	
   	self.hooks["UIErrorsFrame_OnEvent"].orig(event, message, arg1, arg2, arg3, arg4)
end

function ErrorMonster:AddFilter(filter)
	table.insert(self.db.char.errorList, filter)
end

function ErrorMonster:RemoveFilter(filter)
	for key, text in self.db.char.errorList do
		if (key == tonumber(filter)) then
			table.remove(self.db.char.errorList, key)
			return
		end
	end
end

function ErrorMonster:ListFilters()
	self:Print("Active filters:")
	for key, text in self.db.char.errorList do
		self:Print("  - "..text)
	end
end




