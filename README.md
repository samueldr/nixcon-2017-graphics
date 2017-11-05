NixCon 2017 graphics
====================

This is a dump of the graphics, and source files used for NixCon 2017.

Not everything produced was used in the end.

I did not make use of proper source control when making those in a rush, hence
the missing history.

This is released under [CC BY-NC-SA 3.0](https://creativecommons.org/licenses/by-nc-sa/3.0/) for the assets.

The "fancy background" itself, as visually produced is considered an art asset.

The scripts are released under GPLv3.

* * *

## exported

A bunch of PNGs as exported from SVG sources.

Some of the PNGs don't have a source file, they were exported from `workspace.svg`.

## fancy-background

This is an electron app that presents a "fancy" background, with effects.

This is what is used as the background of the title cards in the videos.

## personalized-name-bars

They are the name bars as used in the videos, with the full name (as provided),
an avatar, as provided, and the twitter/github usernames.

There is a template svg file used to create them. They were manually created
and adjusted.

## presentation-cards

They were batch generated using a ruby script.

They are PNG files to be overlaid on top of the background.

## scripts

Two scripts to generate images using the `schedule.json` file from the website.

## sources

Source SVG files. They were authored using inkscape and are probably partly
incompatible with other editors.

Fonts used are:

 * Roboto
 * Roboto Condensed

