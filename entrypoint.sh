#!/bin/bash

set -euxo pipefail

npm init -y > /dev/null
jq '.main = "dist/index.js"' package.json | tee package.json.new
mv package.json.new package.json
npm install --save-dev typescript
mkdir -p src
touch src/index.ts
npx tsc --init --rootDir src --outDir dist
npm install --save-dev \
    @types/node \
    nodemon \
    ts-node
npm set-script build "tsc"
npm set-script start "node dist/index.js"
npm set-script dev "nodemon --watch 'src/**/*.ts' --exec 'ts-node' src/index.ts"

