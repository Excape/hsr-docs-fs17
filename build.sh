#!/bin/bash
set -e # exit with nonzero exit code if anything fails

#Build with mkdocs into ./site
mkdocs build --clean

# Checkout gh-pages
git clone --branch gh-pages git@github.com:Excape/hsr-docs-fs17.git gh-pages

#sync site
rsync -av site/ gh-pages/

#commit
cd gh-pages
git config user.name "Travis CI"
git config user.email "r1suter@hsr.ch"
git add .
git commit -m "Deploy from Travis CI"
git push
