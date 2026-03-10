local _, ns = ...
ns.L = {}
local L = ns.L

L.none = "None"
L.optionsTitle = "Encounter Music"
L.optionsHeading = "Choose a track to play automatically when a boss engages."
L.track = "Encounter track"
L.stopOnEnd = "Stop the music when the fight ends"
L.preview = "Preview track"
L.stop = "Stop track"
L.noAudioApi = "EncounterMusic: unable to start track, no compatible audio API found."

local locale = GetLocale()
if locale == "frFR" then
	L.none = "Aucune"
	L.optionsTitle = "Encounter Music"
	L.optionsHeading = "Choisis une piste à lancer automatiquement à l'engage d'un boss."
	L.track = "Piste d'encounter"
	L.stopOnEnd = "Arrêter la musique à la fin du combat"
	L.preview = "Préécouter la piste"
	L.stop = "Stopper la piste"
	L.noAudioApi = "EncounterMusic: impossible de lancer la piste, aucune API audio compatible n'a été trouvée."
end
