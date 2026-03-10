local _, ns = ...
ns.L = {}
local L = ns.L

L.none = "- None -"
L.optionsTitle = "Encounter Music"
L.optionsHeading = "Choose a track to play automatically when a boss engages."
L.optionsDisclaimer = "This module is not affiliated with the BigWigs team. Please do not contact them for support regarding this module."
L.track = "Encounter track"
L.stopOnEnd = "Stop the music when the fight ends"
L.preview = "Preview track"
L.stop = "Stop track"
L.noAudioApi = "EncounterMusic: unable to start track, no compatible audio API found."

local locale = GetLocale()
if locale == "frFR" then
	L.none = "- Aucune -"
	L.optionsTitle = "Encounter Music"
	L.optionsHeading = "Choisis une piste à lancer automatiquement à l'engage d'un boss."
	L.optionsDisclaimer = "Ce module n'est pas affilié à l'équipe BigWigs. Merci de ne pas les contacter pour le support concernant ce module."
	L.track = "Piste d'encounter"
	L.stopOnEnd = "Arrêter la musique à la fin du combat"
	L.preview = "Écouter la piste"
	L.stop = "Arrêter la piste"
	L.noAudioApi = "EncounterMusic: impossible de lancer la piste, aucune API audio compatible n'a été trouvée."
end
