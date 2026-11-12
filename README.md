# Custom minimal Fedora (rawhide) bootc Image. 558 packages.

Image: `X11, ALSA, amd-gpu, realtek-firmware, no Desktop/WM`.

## The initial update after distro installation (You run this once):
```
sudo bootc switch ghcr.io/danrobi11/my-fedora-bootc:latest
```
## After the initial update. To update, use:
```
sudo bootc upgrade
```
## Package list: [here](https://github.com/danrobi11/my-fedora-bootc/blob/main/packages/packages_list)


