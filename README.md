# Custom Fedora bootc Image

Personal Fedora bootc image based on your NixOS config: custom ratpoison 1.4.10-beta, keyd remapping, X11 + ratpoison session, ALSA, etc.

## Setup

1. Create a new GitHub repository (public or private).
2. Clone it locally.
3. Copy the files from this directory into the repo root:
   - `Containerfile`
   - `.github/workflows/build.yml`
   - `configs/keyd-default.conf`
4. Commit and push to `main`.
5. Go to the repo **Settings → Actions → General** and enable Actions if needed.
6. The workflow will build and push to `ghcr.io/<your-username>/<repo-name>:latest`.

## Using the image

Once built:

```bash
# On a machine with podman and bootc (or after installing from ISO)
sudo bootc switch ghcr.io/<your-username>/<repo-name>:latest
sudo systemctl reboot
```

Or generate an ISO/qcow2 with `bootc-image-builder` / `image-builder`.

## Notes

- Base: `quay.io/fedora/fedora-bootc:45`
- Custom ratpoison built from the exact git rev in your Nix overlay.
- keyd compiled from source and enabled with your control/meta mapping.
- Add more packages to the `dnf install` line in the Containerfile as needed (emacs, games, browsers, etc.).
- For more packages or desktop, consider starting from a Silverblue/Kinoite bootc image instead of the minimal fedora-bootc.
