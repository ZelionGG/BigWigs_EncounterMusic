<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a name="readme-top"></a>

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![Discord][discord-shield]][discord-url]
[![License][license-shield]][license-url]

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <kbd><img src="https://raw.githubusercontent.com/ZelionGG/BigWigs_EncounterMusic/refs/heads/main/logo.png" alt="BigWigs Encounter Music Logo" width="130" height="130"></kbd>
  <br />
  <h3 align="center">BigWigs Encounter Music</h3>

  <p align="center">
    `BigWigs_EncounterMusic` is a BigWigs plugin that automatically plays a selected music track when a boss encounter starts.
    <br />
    <br />
    <a href="https://github.com/ZelionGG/BigWigs_EncounterMusic/issues">Report Bug</a>
    ·
    <a href="https://github.com/ZelionGG/BigWigs_EncounterMusic/issues">Request Feature</a>
  </p>
</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li><a href="#about-the-project">About The Project</a></li>
    <li><a href="#features">Features</a></li>
    <li><a href="#requirements">Requirements</a></li>
    <li><a href="#installation">Installation</a></li>
    <li><a href="#how-to-configure">How to configure</a></li>
    <li><a href="#how-it-works">How it works</a></li>
    <li><a href="#architecture">Architecture</a></li>
    <li><a href="#shared-api">Shared API</a></li>
    <li><a href="#creating-a-custom-music-pack">Creating a custom music pack</a></li>
    <li><a href="#current-behavior">Current behavior</a></li>
    <li><a href="#localization">Localization</a></li>
    <li><a href="#notes-for-development">Notes for development</a></li>
    <li><a href="#troubleshooting">Troubleshooting</a></li>
    <li><a href="#project-structure">Project structure</a></li>
  </ol>
</details>

## About The Project

The addon is designed to stay lightweight, configurable, and extensible:

- It integrates into the BigWigs options UI.
- It lets you choose a single global encounter track.
- It can stop the music automatically when the fight ends.
- It exposes a shared track registry so external music pack addons can register additional tracks.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Features

- Automatic music playback on BigWigs boss engage
- Preview and stop buttons in the BigWigs options panel
- Global track selector
- Optional stop-on-encounter-end behavior
- Support for external music packs through `BigWigsEncounterMusicAPI`
- Built-in localization structure via `Locales.lua`

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Requirements

- `BigWigs`

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Installation

Install the addon into your WoW AddOns folder:

```text
World of Warcraft/_retail_/Interface/AddOns/BigWigs_EncounterMusic
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## How to configure

In game:

- Open the BigWigs options
- Go to the `Encounter Music` plugin panel
- Select the track you want to use
- Optionally enable or disable automatic stop at the end of the encounter
- Use `Preview track` to test the selected music
- Use `Stop track` to stop playback manually

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## How it works

When BigWigs fires a boss engage event, the plugin:

- Reads the selected global track from the plugin profile
- Resolves the track from the shared registry
- Starts playback with `PlayMusic()` when possible
- Falls back to `plugin:PlaySoundFile()` when needed

When the encounter ends, the plugin stops the currently active track if `stopOnEnd` is enabled.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Architecture

### Core addon

`BigWigs_EncounterMusic` contains:

- `Core.lua`
  - BigWigs plugin lifecycle
  - option panel definition
  - playback and stop logic
  - encounter event handling
- `Registry.lua`
  - global track registry
  - registration and sorting helpers
  - API exposed through `_G.BigWigsEncounterMusicAPI`
- `Locales.lua`
  - base English strings
  - locale overrides

### External music packs

Additional packs can register tracks without modifying the core addon.

The current example is:

- `BigWigs_EncounterMusic_EpicMusicPack`

This companion addon registers tracks into the shared registry during load.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Shared API

The core addon exposes a global registry object:

```lua
_G.BigWigsEncounterMusicAPI
```

Available functions:

- `RegisterTrack(id, data)`
- `GetTrack(id)`
- `GetTrackIds()`
- `GetTrackValues()`

A registered track looks like this:

```lua
api.RegisterTrack("my_track_id", {
	name = "My Track Name",
	path = "Interface\\AddOns\\MyAddon\\Music\\MyTrack.mp3",
	source = "MyAddon",
	channel = "Music",
})
```

### Track fields

- `id`
  - unique string identifier
- `name`
  - display name shown in the selector
- `path`
  - full in-game file path
- `source`
  - addon or pack name
- `channel`
  - audio channel, usually `Music`

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Creating a custom music pack

To create your own pack:

- Create a new addon folder
- Add a `.toc` file with a dependency on `BigWigs_EncounterMusic`
- Load a Lua file that calls `BigWigsEncounterMusicAPI.RegisterTrack(...)`
- Store your audio files inside your addon folder

Example layout:

```text
BigWigs_EncounterMusic_MyPack/
  BigWigs_EncounterMusic_MyPack.toc
  Tracks.lua
  Music/
    BossTheme.mp3
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Current behavior

- The plugin uses one global selected track for all encounters
- There is no boss-specific music mapping
- If the selected track is missing, the profile is normalized to a valid fallback
- If no track is selected, the plugin does nothing on engage

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Localization

Localization is defined in `Locales.lua` using the same simple pattern used by other BigWigs companion addons:

- English strings are the base
- Other locales override only the strings they need

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Notes for development

- The addon is loaded on demand by BigWigs
- The plugin is created with `BigWigs:NewPlugin("EncounterMusic")`
- Do not manually call `plugin:Initialize()`
- Music packs should register tracks through the shared registry, not by editing the core addon

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Troubleshooting

### The panel does not appear

Check that:

- `BigWigs` is enabled
- the addon folder name is exactly `BigWigs_EncounterMusic`
- the plugin loaded without Lua errors

### No music plays

Check that:

- a track is selected in the options
- the registered file path is correct
- the audio file exists in the expected addon folder
- your in-game audio settings allow music playback

### The music pack tracks do not appear

Check that:

- the music pack addon is enabled
- its file paths point to the correct `Music` folder

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Project structure

```text
BigWigs_EncounterMusic/
  BigWigs_EncounterMusic.toc
  Core.lua
  Registry.lua
  Locales.lua
  README.md
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

[contributors-shield]: https://img.shields.io/github/contributors/ZelionGG/BigWigs_EncounterMusic.svg?style=for-the-badge
[contributors-url]: https://github.com/ZelionGG/BigWigs_EncounterMusic/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/ZelionGG/BigWigs_EncounterMusic.svg?style=for-the-badge
[forks-url]: https://github.com/ZelionGG/BigWigs_EncounterMusic/network/members
[stars-shield]: https://img.shields.io/github/stars/ZelionGG/BigWigs_EncounterMusic.svg?style=for-the-badge
[stars-url]: https://github.com/ZelionGG/BigWigs_EncounterMusic/stargazers
[issues-shield]: https://img.shields.io/github/issues/ZelionGG/BigWigs_EncounterMusic.svg?style=for-the-badge
[issues-url]: https://github.com/ZelionGG/BigWigs_EncounterMusic/issues
[discord-shield]: https://img.shields.io/badge/Discord-7289DA?style=for-the-badge&logo=discord&logoColor=white
[discord-url]: https://discord.gg/g7JZNGSU32
[license-shield]: https://img.shields.io/badge/Licence-GPL3.0-blue.svg?style=for-the-badge
[license-url]: https://github.com/ZelionGG/BigWigs_EncounterMusic/blob/main/LICENSE.txt
[Lua]: https://img.shields.io/badge/lua-000000?style=for-the-badge&logo=lua&logoColor=white
[Lua-url]: https://www.lua.org/