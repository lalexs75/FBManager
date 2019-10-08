rm FBManager.tar.gz
git clone https://github.com/lalexs75/FBManager.git FBManager-0.10
cd FBManager-0.10
rm .git -r -f
cd ..
tar -czf FBManager.tar.gz FBManager-0.10
rm FBManager-0.10 -r -f
