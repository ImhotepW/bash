#!/bin/bash
### 
### 
### 
source commit.cfg

cd /c/BitBucket/work/Insight/
git pull insight master

cd /c/BitBucket/Git/commit_script
./script.sh
/c/Program\ Files\\QlikView\\Qv.exe "c:\BitBucket\Work\Insight\XMC\40_GLOBAL_QVDG\BSU\BSU_QVDGS.qvw"

cd /c/BitBucket/work/Insight/
git add XMC/40_GLOBAL_QVDG/BSU/
git commit -m 'JIRA 9148, Version 7.4(1.'$vCommitVersion') - changing interface'
git push insight master


((vCommitVersion++))
cd /c/BitBucket/Git/commit_script

sed -i "s/^\(vCommitVersion\s*=\s*\).*$/\1$vCommitVersion/" commit.cfg

