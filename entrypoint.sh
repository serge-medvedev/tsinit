#!/bin/bash

PROJECT=${1:-app}

set -euxo pipefail

npm init -y > /dev/null
jq --arg project "$PROJECT" '.main = "dist/index.js" | .name = $project' package.json | tee package.json.new
mv package.json.new package.json
npm install --save-dev typescript tslint
mkdir -p src
touch src/index.ts
npx tsc --init --rootDir src --outDir dist
npx tslint --init
npm install --save-dev \
    @types/node \
    nodemon \
    ts-node
npm pkg set scripts.build="tsc"
npm pkg set scripts.start="node dist/index.js"
npm pkg set scripts.dev="nodemon --watch 'src/**/*.ts' --exec 'ts-node' src/index.ts"
npm pkg set scripts.lint="tslint -c tslint.json 'src/**/*.ts'"

