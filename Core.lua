local plugin = BigWigs:NewPlugin("EncounterMusic")
if not plugin then return end

local _, ns = ...
local L = ns.L

local api = rawget(_G, "BigWigsEncounterMusicAPI") or {}
local activeTrackId
local activeEncounterId
local activeMethod
local activeSoundHandle

plugin.defaultDB = {
	trackId = "none",
	stopOnEnd = true,
}

local function getTrackValues()
	if type(api.GetTrackValues) == "function" then
		return api.GetTrackValues()
	end
	return { none = L.none }
end

local function getFirstPlayableTrackId()
	if type(api.GetTrackIds) ~= "function" then
		return "none"
	end

	local ids = api.GetTrackIds()
	for i = 1, #ids do
		local id = ids[i]
		if id ~= "none" then
			return id
		end
	end

	return "none"
end

local function updateProfile()
	local db = plugin.db.profile
	for k, v in next, db do
		local defaultType = type(plugin.defaultDB[k])
		if defaultType == "nil" then
			db[k] = nil
		elseif type(v) ~= defaultType then
			db[k] = plugin.defaultDB[k]
		end
	end

	local trackId = db.trackId
	local track = type(api.GetTrack) == "function" and api.GetTrack(trackId) or nil
	if trackId ~= "none" and not track then
		db.trackId = getFirstPlayableTrackId()
	end
end

plugin.pluginOptions = {
	name = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Sounds:20|t " .. L.optionsTitle,
	type = "group",
	childGroups = "tab",
	order = 13,
	get = function(info)
		return plugin.db.profile[info[#info]]
	end,
	set = function(info, value)
		plugin.db.profile[info[#info]] = value
	end,
	args = {
		heading = {
			type = "description",
			name = L.optionsHeading .. "\n\n",
			order = 1,
			width = "full",
			fontSize = "medium",
		},
		trackId = {
			type = "select",
			name = L.track,
			order = 2,
			values = getTrackValues,
			width = "full",
		},
		stopOnEnd = {
			type = "toggle",
			name = L.stopOnEnd,
			order = 3,
			width = "full",
		},
		preview = {
			type = "execute",
			name = L.preview,
			order = 4,
			func = function()
				plugin:PlaySelectedTrack()
			end,
		},
		stop = {
			type = "execute",
			name = L.stop,
			order = 5,
			func = function()
				plugin:StopEncounterMusic()
			end,
		},
	},
}

local function stopActiveTrack()
	if activeMethod == "music" and type(StopMusic) == "function" then
		StopMusic()
	elseif activeMethod == "sound" and activeSoundHandle and type(StopSound) == "function" then
		StopSound(activeSoundHandle)
	end

	activeTrackId = nil
	activeEncounterId = nil
	activeMethod = nil
	activeSoundHandle = nil
end

local function getConfiguredTrack(encounterId)
	local trackId = plugin.db and plugin.db.profile and plugin.db.profile.trackId or "none"
	if trackId == "none" then
		return nil, encounterId, "none"
	end

	local track = type(api.GetTrack) == "function" and api.GetTrack(trackId) or nil
	if not track then
		return nil, encounterId, trackId
	end

	return track, encounterId, trackId
end

local function playTrack(track, encounterId, trackId)
	if type(track) ~= "table" or type(track.path) ~= "string" or track.path == "" then
		return
	end

	if activeTrackId == trackId and activeEncounterId == encounterId then
		return
	end

	stopActiveTrack()

	if (track.channel == "Music" or not track.channel) and type(PlayMusic) == "function" then
		PlayMusic(track.path)
		activeMethod = "music"
		activeTrackId = trackId
		activeEncounterId = encounterId
		return
	end

	if plugin.PlaySoundFile then
		local _, handle = plugin:PlaySoundFile(track.path, track.channel or "Master")
		activeMethod = "sound"
		activeTrackId = trackId
		activeEncounterId = encounterId
		activeSoundHandle = handle
		return
	end

	BigWigs:Print(L.noAudioApi)
end

function plugin:PlaySelectedTrack()
	local track, encounterId, trackId = getConfiguredTrack(false)
	if not track then
		return
	end

	playTrack(track, encounterId, trackId)
end

function plugin:OnPluginEnable()
	updateProfile()

	self:RegisterMessage("BigWigs_OnBossEngage")
	self:RegisterMessage("BigWigs_OnBossWin", "StopEncounterMusic")
	self:RegisterMessage("BigWigs_OnBossWipe", "StopEncounterMusic")
	self:RegisterMessage("BigWigs_OnBossDisable", "StopEncounterMusic")
	self:RegisterMessage("BigWigs_EncounterEnd", "HandleEncounterEnd")
	self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)

	api.OnTracksChanged = function()
		updateProfile()
		self:UpdateGUI()
	end
end

function plugin:OnPluginDisable()
	stopActiveTrack()
end

function plugin:BigWigs_OnBossEngage(_, module)
	if not module then
		return
	end

	local encounterId = module.GetEncounterID and module:GetEncounterID()
	local track, _, trackId = getConfiguredTrack(encounterId)
	if not track then
		return
	end

	playTrack(track, encounterId, trackId)
end

function plugin:HandleEncounterEnd()
	if plugin.db.profile.stopOnEnd then
		stopActiveTrack()
	end
end

function plugin:StopEncounterMusic()
	stopActiveTrack()
end
