#!/usr/bin/env node
// Pre-commit hook for ABAP syntax checking with abaplint
// Install: ln -s ../../tools/pre-commit.js .git/hooks/pre-commit

const { execSync } = require('child_process');
const { existsSync } = require('fs');

// Check if abaplint is installed
try {
  execSync('npx abaplint --version', { stdio: 'ignore' });
} catch (e) {
  console.error('abaplint not found. Install with: npm install -g @abaplint/cli');
  process.exit(1);
}

// Get list of staged ABAP files
let stagedFiles;
try {
  stagedFiles = execSync('git diff --cached --name-only --diff-filter=ACM', { encoding: 'utf-8' })
    .trim()
    .split('\n')
    .filter(f => f.match(/\.(abap|clas|prog|fugr|intf)$/));
} catch (e) {
  console.error('Failed to get staged files:', e.message);
  process.exit(1);
}

if (stagedFiles.length === 0 || stagedFiles[0] === '') {
  // No ABAP files staged
  process.exit(0);
}

console.log(`Checking ${stagedFiles.length} ABAP file(s) with abaplint...`);

// Run abaplint on staged files
try {
  execSync('npx abaplint', { stdio: 'inherit' });
  console.log('✓ abaplint checks passed');
  process.exit(0);
} catch (e) {
  console.error('✗ abaplint found issues. Fix them or use --no-verify to skip.');
  process.exit(1);
}
