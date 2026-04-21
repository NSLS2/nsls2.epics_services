#!/bin/bash

export PORT=3000

npm install
npm run build
serve -s build
