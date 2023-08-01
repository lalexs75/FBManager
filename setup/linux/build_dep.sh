mkdir -p ./package/DEBIAN
mkdir -p ./package/usr/bin
mkdir -p ./package/usr/share/applications
mkdir -p ./package/usr/share/pixmaps
mkdir -p ./package/usr/share/fbmanager/languages
mkdir -p ./package/usr/share/fbmanager/docs
mkdir -p ./package/usr/share/fbmanager/reports


cd ../../
./make_fbm.sh gtk2
cd setup/linux

cp ../../IBManager ./package/usr/bin
cp ./FBManager.desktop ./package/usr/share/applications
cp ../../Images/icons/MainIcon.png ./package/usr/share/pixmaps/FBManager.png
cp -a ../../languages/* ./package/usr/share/fbmanager/languages
cp -a ../../reports/* ./package/usr/share/fbmanager/reports
cp -a ../../docs/* ./package/usr/share/fbmanager/docs

echo 'Package: fbmanager
Version: 0.1
Section: admin,devel
Priority: optional
Depends: libc6, libpangocairo-1.0-0, libatk1.0-0
Architecture: amd64
Essential: no
Suggests: sqlite3,libpq-dev
Origin: https://github.com/lalexs75/FBManager
Maintainer: Lagunov Aleksey <alexs75@yandex.ru>
Description: FBManager is a universal managment database application. It''s support Postgre SQL, MySQL, FireBird SQL, SQLite3.' >package/DEBIAN/control 

#Installed-Size: 20


echo 'if [ "$1" = "configure" ] && [ -x "`which update-menus 2>/dev/null`" ] ; then
update-menus
fi' > package/DEBIAN/postinst
chmod 0755 package/DEBIAN/postinst
fakeroot dpkg-deb --build ./package
rm -r ./package
mv package.deb fbmanager-0.1.deb