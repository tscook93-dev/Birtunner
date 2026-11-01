# Birtunner design

Bit is a small runner moving through the inside of a computer. A run starts on an original desktop. Bit enters a file, runs and jumps along a side-scrolling page, and avoids the thing living in that file. Clearing a file sends Bit back to the desktop.

## Core loop

From the desk, run into the letter. Inside it, stay off the floor: ILOVEYOU walks there and makes copies of itself. Jump along the lines of the page and reach the seal at the end. Getting touched sends Bit back to the start of the letter. Reaching the seal returns Bit to the desk.

## Slice plan

1. **Movement and jump** — player controller, touch and keyboard, one test room, camera. Done.
2. **Desktop hub** — an original desk where a run starts, with a way into the first file. Done.
3. **First file level** — the letter NOTE.LET, with a start and a seal at the end. Done.
4. **Viruses** — ILOVEYOU, a floor walker that copies itself. Done for this one file.
5. **Level-complete screen** — a full screen is still ahead. Clearing the letter currently shows one line and returns to the desk.
6. **More levels** — a calendar file about surviving the year-2000 rollover, then other files. Each one can carry a different real outbreak, played as something to avoid, not as a lesson in how it spread.

## Done

- Bit runs, falls under gravity, and jumps. Jump height varies with how long jump is held.
- Coyote time and a short jump buffer.
- On-screen Left, Right, and Jump. Arrow keys and Space do the same (Up jumps as well).
- The game opens on the desk. Running into the letter enters it. Reaching the seal comes back.
- Inside the letter, ILOVEYOU chases along the floor and spawns up to two slower copies.
- Touching it restarts Bit at the beginning of the letter.
- Motion Bay is still in the project as the movement test room. The game does not open there.
- Web export with thread support off, so the build does not need SharedArrayBuffer.

## Next

A proper "file survived" moment, then the year-2000 file: a clock runs toward midnight and the page glitches when the year rolls. Other outbreaks can wait until that file exists.

## Controls

- Left / Right: run.
- Jump: tap for a short hop, hold for a full leap.
- Walking off a ledge still allows a jump for about a tenth of a second.
- A jump pressed just before landing is remembered for about a tenth of a second.
- On the desk, stand inside the letter and it opens.

## Out of scope for now

Menus, saving, audio, more than one enterable file, and the year-2000 level.
