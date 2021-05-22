# SAM Coupé Leisure Suit Larry in the Land of the Lounge Lizards

An attempt at a SAM Coupé Z80 implemenation of AGI ([Adventure Game Interpreter](https://wiki.scummvm.org/index.php?title=AGI)) as used by Sierra in their early adventure games.

The data files used are from the original PC version, downloaded from [myabandonware.com](http://www.myabandonware.com/game/leisure-suit-larry-in-the-land-of-the-lounge-lizards-bl).

## Structure

- boot.s: loads the rest and provides load routines for logic
- main.s: main code including logic execution
- pic.s: draws pictures
- snd.s: plays sound
- view.s: handles views (sprites)

## WIP

- 2021-05-22 Executing more logic, three channel sound, getting to second intro screen.

[![](https://img.youtube.com/vi/uuMEnUA0ZJ8/0.jpg)](https://www.youtube.com/watch?v=uuMEnUA0ZJ8)

- 2021-05-18 Executing logic, one channel sound.

[![](https://img.youtube.com/vi/llnwEy08kf0/0.jpg)](https://www.youtube.com/watch?v=llnwEy08kf0)

- 2016 Drawing all screens, no logic yet.

[![](https://img.youtube.com/vi/gwnQOlHn7mE/0.jpg)](https://www.youtube.com/watch?v=gwnQOlHn7mE)
