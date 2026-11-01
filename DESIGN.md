# Birtunner design

Bit runs through **Nimbus**, an original desktop. Folders are worlds. Files inside a folder are levels. The desktop is where a run starts. Clearing a file returns Bit to that folder's window.

## Core loop

Run along the dock and into a folder. The folder opens as a window. Choose a file to enter its level, jump through it, and avoid whatever lives there. Clearing the file closes the level and shows the folder again.

## Worlds and levels

- **Letters** (open) — a folder world.
  - NOTE.LET — level 1. ILOVEYOU walks the floor and copies itself.
  - DRAFT.LET — locked placeholder.
  - CARD.LET — locked placeholder.
- **Pictures** — a second folder, shown on the dock and locked.

## Planned viruses

Played as things to avoid. The game does not teach how the real programs spread.

- **ILOVEYOU** — in NOTE.LET. A heart on the floor that copies itself. Done.
- **Melissa** — in a document file. Wakes when Bit passes a line, then drifts toward them.
- **Code Red** — a crawler that owns the floor. Bit has to stay on the platforms.
- **Y2K** — not a creature. A clock file running toward midnight. When the year rolls, the page glitches and Bit has to reach the far side.

## Slice plan

1. **Movement and jump** — done.
2. **Desktop hub** — Nimbus: gradient wallpaper, menu bar, clock, dock, folder icons. Done for this pass.
3. **First file level** — NOTE.LET inside the Letters window. Done.
4. **Viruses** — ILOVEYOU only, so far.
5. **Level-complete** — clearing NOTE.LET returns to the Letters window. A fuller screen can wait.
6. **More levels** — unlock the other letters, then Melissa, Code Red, and the Y2K clock.

## Done

- Run, variable jump, coyote time, jump buffer.
- On-screen Left, Right, and Jump, plus arrow keys and Space. The buttons are smaller and translucent, and the floor sits above them.
- Nimbus desktop. Run into Letters to open its window. Pictures is locked.
- NOTE.LET is playable. DRAFT.LET and CARD.LET are greyed.
- ILOVEYOU chases on the floor and spawns up to two slower copies. Touching it restarts the letter.
- Reaching the seal returns to the Letters window.
- Motion Bay remains in the project as a movement test and is not the opening scene.
- Web export with thread support off.

## Controls

- Left / Right: run.
- Jump: tap for a short hop, hold for a full leap.
- On the dock, stand in a folder and it opens.
- In a folder window, tap an unlocked file. Close returns to the dock.

## Out of scope for now

Saving, audio, Melissa, Code Red, the Y2K level, and unlocking the grey files.
