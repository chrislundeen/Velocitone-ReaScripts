# Velocitone ReaScripts

A collection of ReaScripts for [REAPER](https://www.reaper.fm/) that provide track tagging, tag-based filtering, color management, toolbar syncing, and hardware controller integration.

## Installation

### Prerequisites

- [REAPER](https://www.reaper.fm/) (v6+)
- [ReaPack](https://reapack.com/) — REAPER's package manager
- [SWS Extension](https://www.sws-extension.org/) — recommended (required for startup action and some script features)
- [js_ReaScriptAPI](https://forum.cockos.com/showthread.php?t=212174) — required for Track Manager filtering scripts

### Install via ReaPack

1. In REAPER, go to **Extensions > ReaPack > Import repositories...**
2. Paste this URL:
   ```
   https://github.com/chrislundeen/Velocitone-ReaScripts/raw/main/index.xml
   ```
3. Go to **Extensions > ReaPack > Browse packages**
4. Search for "Velocitone" and install the scripts you want
5. Restart REAPER

### Set Up the Startup Script

The startup script keeps the toolbar tag sync running in the background. To enable it:

**Option A — SWS Startup Action (recommended):**

1. Go to **Actions > Show action list**
2. Search for `Velocitone: Startup ReaScript`
3. Right-click the action → **Copy selected action command ID**
4. Go to **Extensions > Startup actions > Set global startup action**
5. Paste the command ID and confirm

**Option B — Built-in `__startup.lua`:**

Create a file called `__startup.lua` in your REAPER `Scripts/` folder with this one line:

```lua
dofile(reaper.GetResourcePath() .. '/Scripts/Velocitone-ReaScripts/Velocitone - startup.lua')
```

REAPER automatically runs any `__startup.lua` on launch.

---

## Scripts

### Track Tag Manager

A system for organizing tracks by tagging their names with labels like `[audio]`, `[buss]`, `[midi]`, `[fx]`, etc.

**Tag Track Name** scripts toggle a tag at the end of the selected track's name. Run the action once to add the tag, run it again to remove it.

Available tags: `[audio]`, `[buss]`, `[channelstrip]`, `[custom]`, `[folder]`, `[fx]`, `[gfx]` (guitar FX), `[midi]`, `[output]`, `[section]`, `[stem]`, `[tape]`, `[vsti]`

Example: A track named `Drums` becomes `Drums [audio]`

### Tag-Based Track Filtering

**Tag Filter** scripts control track visibility based on tags. Activate a filter to show only tracks with that tag — useful for managing large sessions.

- Each Tag Filter action acts as a toggle (on/off) and reports its state to REAPER's toolbar button system
- **Reset Tag Filter** clears all active filters, making all tracks visible again
- Filters work through REAPER's Track Manager window (requires js_ReaScriptAPI)

### Track Color Tools

- **Color Gradient for Child Tracks** — Applies a smooth color gradient across a parent track's children, interpolating brightness and saturation based on nesting depth
- **Color Media Items Variation of Parent Track Color** — Colors selected media items with randomized shade variations of their top-level parent track's color

### Track Name Tools

- **Track Name Character Replacement** — Prompts for a search string and replacement, then performs find-and-replace on all selected track names

### MCP Track Selection

Navigate the Mixer Control Panel (MCP) with dedicated actions:

- **Select Visible MCP Track - Next** — Selects the next visible track in the mixer
- **Select Visible MCP Track - Previous** — Selects the previous visible track in the mixer
- **Select Visible MCP Track - Controller** — Reads encoder direction from hardware input (-1 = previous, +1 = next) for use with MIDI controllers

### Toolbar Sync

The startup script runs a background loop that keeps REAPER toolbar buttons in sync with the current tag filter and track tag states. This means toolbar buttons reflect whether a tag filter is active or which tags are applied — providing visual feedback through button states (off/hover/on).

### Hardware Control — MIDIFighter Twister

Four scripts for switching banks on the [DJ TechTools MIDIFighter Twister](https://www.midifighter.com/) controller:

- **Select Bank 1–4** — Switches the Twister to the specified bank

---

## Library Files

Scripts under `_library/` are internal modules loaded by the user-facing scripts above. They do **not** appear in REAPER's Actions list and are not meant to be run directly.

---

<!-- TODO: Toolbar Icons section -->
## Toolbar Icons

These scripts are designed to work with the [Velocitone REAPER Toolbar Icons](https://github.com/chrislundeen/velocitone-reaper-toolbar-Icons) repository, which provides matching multi-state toolbar icons and track icons.

The icon repo generates icons that correspond to the tag system (audio, buss, midi, fx, guitar, etc.) with three visual states — off, hover, and on — that align with the toolbar sync behavior of these scripts.

Icons are installed to:
- `REAPER/Data/toolbar_icons/` — toolbar button icons (with 150% and 200% HiDPI variants)
- `REAPER/Data/track_icons/Custom/` — track icons for REAPER's track icon feature

See the toolbar icons repository for setup instructions.

---
