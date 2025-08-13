### QuPath 0.6.0 GUI container

This image packages QuPath 0.6.0 with a lightweight GUI (via `jlesage/baseimage-gui`). It is designed to auto-open a single image passed into the container and can also be used interactively via the built-in web VNC.

### What the image contains
- **Base**: `jlesage/baseimage-gui:ubuntu-24.04-v4`
- **Packages**: `libgl1`, `xz-utils`, `openjfx`, `nano`, `qt5dxcb-plugin`
- **QuPath**: Downloads and extracts `QuPath-v0.6.0-Linux.tar.xz` to `/opt/qupath/QuPath`
- **Startup script**: Copies `startapp.sh` to `/startapp.sh` and makes it executable
- **Environment**: sets `APP_NAME=QuPath`, `KEEP_APP_RUNNING=0`, `TAKE_CONFIG_OWNERSHIP=1`, and uses `/config` as the working directory

### How startup works (`startapp.sh`)
On container start, the base image runs `/startapp.sh`, which:
- Sets `HOME=/tmp` and Java options for JavaFX cache under `/tmp`.
- Launches QuPath with:
  - `--image /opt/qupath/infile.tiff`
  - `--quiet`

If a file exists at `/opt/qupath/infile.tiff`, QuPath opens it automatically. If not, QuPath starts normally and you can open files from the GUI.

### Run: open a single image automatically
Map a local image to the expected path and expose the web UI on port 8080:

```bash
docker run -it --rm \
  -v /absolute/path/to/infile.tiff:/opt/qupath/infile.tiff \
  -p 8080:5800 \
  quay.io/mark_viascientific/qupath:0.6.0
```

Then browse to `http://localhost:8080` to access QuPath’s GUI (noVNC). Optionally map `-p 5900:5900` to use a native VNC client.

### Run: interactive GUI and open files manually
Mount a directory of images and open them from QuPath’s File menu:

```bash
docker run -it --rm \
  -v /absolute/path/to/infile.tiff:/opt/qupath/infile.tiff \
  -p 8080:5800 \
  quay.io/mark_viascientific/qupath:0.6.0
```

### Persist configuration (optional)
To keep QuPath settings across sessions, mount a host directory to `/config`:

```bash
docker run -it --rm \
  -v /absolute/path/to/your_image.tiff:/opt/qupath/infile.tiff \
  -v /absolute/path/to/qupath-config:/config \
  -p 8080:5800 \
  quay.io/mark_viascientific/qupath:0.6.0
```

### Notes
- The special path `/opt/qupath/infile.tiff` is used so external systems can inject the user-selected image for auto-loading.
- The image uses the base image’s default entry point, so you don’t need to pass `/init` or `/start` explicitly.