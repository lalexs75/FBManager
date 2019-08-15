rm FBManager.tar.gz
git clone https://github.com/lalexs75/FBManager.git FBManager-1.0
cd FBManager-1.0
rm .git -r -f
cd ..
tar -czf FBManager.tar.gz FBManager-1.0
rm FBManager-1.0 -r -f
rpmbuild -ba fbmanager.spec