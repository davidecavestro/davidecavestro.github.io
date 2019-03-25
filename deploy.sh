#!/bin/bash

# only proceed script when started not by pull request (PR)
if [ $TRAVIS_PULL_REQUEST == "true" ]; then
  echo "this is PR, exiting"
  exit 0
fi

# enable error reporting to the console
set -e

# build site with jekyll, by default to `_site' folder
jekyll build

# cleanup
rm -rf ../davidecavestro.github.io.master

#clone `master' branch of the repository using encrypted GH_TOKEN for authentification
git clone https://${GITHUB_TOKEN}@github.com/davidecavestro/davidecavestro.github.io.git ../davidecavestro.github.io.master

# copy generated HTML site to `master' branch
cp -R _site/* ../davidecavestro.github.io.master

# commit and push generated content to `master' branch
# since repository was cloned in write mode with token auth - we can push there
cd ../davidecavestro.github.io.master
git config user.email "davidecavestro@gmail.com"
git config user.name "Davide Cavestro"
git add -A .
git commit -a -m "Travis #$TRAVIS_BUILD_NUMBER"
git push --quiet origin master > /dev/null 2>&1
