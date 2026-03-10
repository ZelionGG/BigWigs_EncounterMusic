local _, ns = ...
local L = ns.L

local api = rawget(_G, "BigWigsEncounterMusicAPI")
if type(api) ~= "table" then
	api = {}
	_G.BigWigsEncounterMusicAPI = api
end

local tracks = api.tracks or {}
local order = api.order or {}

api.tracks = tracks
api.order = order

local function sortTracks()
	table.sort(order, function(a, b)
		if a == "none" then
			return true
		end
		if b == "none" then
			return false
		end

		local left = tracks[a] and tracks[a].name or a
		local right = tracks[b] and tracks[b].name or b
		return left < right
	end)
end

if not tracks.none then
	tracks.none = {
		id = "none",
		name = L.none,
		source = "core",
	}
	order[#order + 1] = "none"
	sortTracks()
end

function api.RegisterTrack(id, data)
	if type(id) ~= "string" or id == "" or id == "none" then
		return
	end
	if type(data) ~= "table" then
		return
	end
	if type(data.name) ~= "string" or data.name == "" then
		return
	end
	if type(data.path) ~= "string" or data.path == "" then
		return
	end

	local isNew = tracks[id] == nil
	tracks[id] = {
		id = id,
		name = data.name,
		path = data.path,
		source = data.source or "unknown",
		channel = data.channel,
	}

	if isNew then
		order[#order + 1] = id
	end

	sortTracks()

	local onTracksChanged = rawget(api, "OnTracksChanged")
	if type(onTracksChanged) == "function" then
		onTracksChanged(id, tracks[id])
	end

	return true
end

function api.GetTrack(id)
	return tracks[id]
end

function api.GetTrackIds()
	return order
end

function api.GetTrackValues()
	local values = {}
	for i = 1, #order do
		local id = order[i]
		values[id] = tracks[id].name
	end
	return values
end

api.RegisterTrack("encountermusic_paul_yudin_cinematic_trailer", {
	name = "EncounterMusic: Paul Yudin - Cinematic Trailer",
	path = "Interface\\AddOns\\BigWigs_EncounterMusic\\Music\\Paul Yudin - Cinematic Trailer.mp3",
	source = "EncounterMusic",
	channel = "Music",
})
