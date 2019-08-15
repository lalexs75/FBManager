rm FBManager.tar.gz
git clone https://github.com/lalexs75/FBManager.git FBManager-0.9
cd FBManager-0.9
rm .git -r -f
cd ..
tar -czf FBManager.tar.gz FBManager-1.0
rm FBManager-0.9 -r -f
#rpmbuild -ba fbmanager.spec