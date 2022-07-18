#!/bin/bash

PROJECT=${1:-app}

set -euxo pipefail

#
# Node.js project
#

npm init -y > /dev/null
jq --arg project "$PROJECT" \
    '.main = "dist/index.js" | .type = "module" | .name = $project' \
    package.json | tee package.json.new
mv package.json.new package.json
npm install --save-dev \
    typescript \
    eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin eslint-plugin-jest \
    jest @types/jest ts-jest
mkdir -p src
touch src/index.ts
npx tsc --init --module es2022 --target es2022 --rootDir src --outDir dist

cat << EOF > .eslintrc.cjs
module.exports = {
  root: true,
  parser: '@typescript-eslint/parser',
  plugins: [
    '@typescript-eslint',
    'jest'
  ],
  extends: [
    'eslint:recommended',
    'plugin:@typescript-eslint/recommended',
    'plugin:jest/recommended'
  ],
};
EOF

cat << EOF > .eslintignore
dist/
EOF

cat << EOF > jest.config.cjs
/** @type {import('ts-jest/dist/types').InitialOptionsTsJest} */
module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'node',
};
EOF

npm install --save-dev \
    @types/node \
    nodemon \
    ts-node
npm pkg set scripts.build="tsc"
npm pkg set scripts.start="node dist/index.js"
npm pkg set scripts.dev="nodemon --watch 'src/**/*.ts' --exec 'ts-node' src/index.ts"
npm pkg set scripts.lint="eslint ."
npm pkg set scripts.test="jest"

#
# Git repo
#

cat << EOF > .gitignore
node_modules/
EOF

git init --initial-branch=main

