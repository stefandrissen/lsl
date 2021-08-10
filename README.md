# SAM Coupé Leisure Suit Larry in the Land of the Lounge Lizards

An attempt at a SAM Coupé Z80 implementation of AGI ([Adventure Game Interpreter](https://wiki.scummvm.org/index.php?title=AGI)) as used by Sierra in their early adventure games.

The data files used are from the original PC version, downloaded from [myabandonware.com](http://www.myabandonware.com/game/leisure-suit-larry-in-the-land-of-the-lounge-lizards-bl).

## Structure

- boot.s: loads the rest and provides load routines for logic
- main.s: main code including logic execution
- pic.s: draws pictures
- snd.s: plays sound
- view.s: handles views (sprites)

## Ant targets

- lllll
- lllll-silent

## WIP

- 2021-08-10 objects (sprites) are now mirrored when necessary, no more moonwalking for Larry

[![](https://img.youtube.com/vi/2jFQ09XHzOA/0.jpg)](https://youtu.be/2jFQ09XHzOA)

- 2021-08-06 sound playback at 60Hz, buffering screens, (re)storing object (sprite) backgrounds

[![](https://img.youtube.com/vi/wklwWEloDvw/0.jpg)](https://youtu.be/wklwWEloDvw)

- 2021-05-22 Executing more logic, three channel sound, getting to second intro screen.

[![](https://img.youtube.com/vi/uuMEnUA0ZJ8/0.jpg)](https://youtu.be/uuMEnUA0ZJ8)

- 2021-05-18 Executing logic, one channel sound.

[![](https://img.youtube.com/vi/llnwEy08kf0/0.jpg)](https://youtu.be/llnwEy08kf0)

- 2019-01-09 Drawing all screens, no logic yet.

[![](https://img.youtube.com/vi/F9AWT6OgUL4/0.jpg)](https://youtu.be/F9AWT6OgUL4)

- 2016-10-30 Drawing screens incorrectly.

[![](https://img.youtube.com/vi/gwnQOlHn7mE/0.jpg)](https://youtu.be/gwnQOlHn7mE)
