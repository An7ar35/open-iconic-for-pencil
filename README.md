# Open-Iconic stencil packager for Pencil

# Installing the stencil package

1. Download the latest release package,
2. In Pencil: go to Tools > Install new collection and select the zip file package.
3. Done!

# Packaging

1. Clone this repository with the `--recursive` flag to include the open-iconic submodule
2. Execute the `generate-stencil.sh` shell script in the repository's root.
3. Done. The stencil package is generated in the root of the repository.

Note: The shell script uses the following command line tools: `identify`, librsvg (`rsvg-convert`), `zip`.

# Final words

If you find this useful or even adapt the script for another icon collection you can show some love by starring this repo.
