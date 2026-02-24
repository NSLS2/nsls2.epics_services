#!/bin/bash
# shellcheck source=/dev/null

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PORT=3000

id
echo "${HOME}"

npm -v
npm install
npm run build
npm install -g serve
serve -s build
