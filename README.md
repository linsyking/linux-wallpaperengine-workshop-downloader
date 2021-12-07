# Linux Wallpaper Engine Workshop Downloader
A qt application to download wallpapers from [Wallpaper Engine](https://store.steampowered.com/app/431960/Wallpaper_Engine) Workshop.

*This is my first qt application, so there may be a lot of shortcomings.*

---

## Install

You have to install python 3 first, and the version should be at least 3.8.

### Python dependencies

- requests

### Qt dependencies

Testing

## Usage

1. Download the latest release, and unzip it.
2. Run `guitest`.
3. Use the searchbox to search wallpaper
4. Double-click the wallpaper you want to download
5. Go to Downloading page to check the status

If you want to use proxy to connect to steam workshop, you have to (currently) open a terminal in the environment directory, and set your terminal with proxy (`export ...`), then run `./guitest`.

## Goals and Improvements

- Load more pages
- Add filter
- Make the downloading screen better
