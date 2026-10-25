# Custom Fedora bootc Image

Personal Fedora bootc image: custom ratpoison 1.4.10-beta, keyd remapping, X11 + ratpoison session, ALSA, etc.

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




