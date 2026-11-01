# Birtunner design

Bit is a small runner moving through the inside of a computer. The full game starts on an original desktop, then Bit enters files and folders, runs and jumps along side-scrolling corridors, and avoids viruses. Clearing a file sends Bit back toward the desktop.

This repository currently contains only the movement slice: run, jump, and land in one test room.

## Core loop

Move right, jump across gaps and up onto platforms, and keep going. Later slices add a reason to travel (open a file, reach its end) and a reason to be careful (viruses). Slice 1 only checks that running and jumping feel right on a phone screen.

## Slice plan

1. **Movement and jump** — player controller, touch and keyboard, one test room, camera. This slice.
2. **Desktop hub** — an original desktop where a run starts, with a way into the first file. It should feel like a familiar PC desktop and must not copy any existing product's names, logos, icons, wallpaper, or fonts.
3. **First file level** — a real side-scrolling file with a start and an end, using the same run and jump.
4. **Viruses** — simple enemies Bit has to avoid.
5. **Level-complete screen** — shown when a file is cleared, then a path back toward the hub.
6. **More levels** — additional files and folders that reuse the same movement.

## Done in slice 1

- Bit runs, falls under gravity, and jumps.
- Jump height varies with how long jump is held. A tap is a short hop; a hold is a full leap.
- Coyote time: a jump still works for a brief moment after walking off a ledge.
- Jump buffer: pressing jump slightly before landing still jumps on landing.
- On-screen Left, Right, and Jump buttons. Keyboard arrows and Space do the same thing (Up jumps as well).
- One room, Motion Bay: a floor and platforms at different heights, drawn as a simple circuit board.
- The camera follows Bit and stays inside the room.
- Web export with thread support off, so the build does not need SharedArrayBuffer.

## Next

Slice 2 is the desktop hub. Motion Bay stays as the movement test until the first file level exists. No enemies, menus, or level flow until the later slices.

## Controls

- Left / Right: run.
- Jump: tap for a short hop, hold for a full leap.
- Walking off a ledge still allows a jump for about a tenth of a second.
- A jump pressed just before landing is remembered for about a tenth of a second.

## Out of scope for now

Hub, file levels, viruses, menus, saving, audio, and a level-complete flow.
