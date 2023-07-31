mkdir -p ./package/DEBIAN
mkdir -p ./package/usr/bin
mkdir -p ./package/usr/share/applications

cp /home/alexs/1/IBManager ./package/usr/bin
cp ./FBManager.desktop ./package/usr/share/applications
echo 'Package: fbmanager
Version: 0.1
Section: admin,devel
Priority: optional
Depends: libc6, libpangocairo-1
Architecture: amd64
Essential: no
Maintainer: Lagunov Aleksey <alexs75@yandex.ru>
Description: FBManager is a universal managment database application. It''s support Postgre SQL, MySQL, FireBird SQL, SQLite3.' >package/DEBIAN/control 

#Installed-Size: 20

dpkg-deb --build ./package
rm -r ./package