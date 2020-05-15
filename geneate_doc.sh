#!/bin/sh

mkdir -p docs

dub build --build=docs

# Generating index.md from README
echo "---" > docs/index.md
echo "layout: default" >> docs/index.md
echo "title: About" >> docs/index.md
echo "---" >> docs/index.md
cat README.md >> docs/index.md

# Generating changelog.md from CHANGELOG
echo "---" > docs/changelog.md
echo "layout: default" >> docs/changelog.md
echo "title: Changelog" >> docs/changelog.md
echo "---" >> docs/changelog.md
cat CHANGELOG.md >> docs/changelog.md

cp LICENSE docs/

