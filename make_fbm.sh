# path to lazbuild
#export lazbuild=$(which lazbuild)
export lazbuild=/usr/local/share/lazarus/lazbuild

make_clean(){
  find . -name \*.o -delete
  find . -name \*.ppu -delete
  find . -name \*.compiled -delete
  rm -R `find . -name \backup`

  if [ -f IBManager ]; then
    rm IBManager
  fi
  
  if [ -f IBManager.exe ]; then
    rm IBManager.exe
  fi
  
  cd lib
  find . -name \*.lfm -delete
  find . -name \*.rst -delete
  find . -name \*.or -delete
  find . -name \*.res -delete  
  cd ..
  
  cd utils/pg/pg_export
  if [ -f pg_export.exe ]; then
    rm pg_export.exe
  fi
  if [ -f pg_export ]; then
    rm pg_export
  fi
  
  cd lib
  find . -name \*.lfm -delete
  find . -name \*.rst -delete
  find . -name \*.or -delete
  find . -name \*.res -delete  
  cd ../../../..
}

show_help(){
  echo "Ussage: make_fb [all|clean|win32|gtk2|qt]"
  echo "params:"
  echo "    all - clean source tree an compile all modes"
  echo "  clean - clean source tree"
  echo "  win32 - compile for winddows"
  echo "   gtk2 - compile for linux, widgetset - GTK2"
  echo "  win32 - compile for linux, widgetset - QT"
}


make_win32(){
  /usr/local/share/lazarus/tools/svn2revisioninc .
#$lazbuild IBManager.lpi --operating-system=win32 --widgetset=win32
#  env WINEPREFIX="/home/alexs/.wine_delphi" wine "C:\\lazarus\\svn2revisioninc" .
  env WINEPREFIX="/home/alexs/.wine_delphi" wine "C:\\lazarus\\lazbuild.exe" "IBManager.lpi"
#  $lazbuild IBManager.lpi --operating-system=win32 --widgetset=win32 --cpu=i386
  strip IBManager.exe
}

make_win64(){
  /usr/local/share/lazarus/tools/svn2revisioninc .
  $lazbuild IBManager.lpi --operating-system=win64 --widgetset=win32 --cpu=x86_64
  strip IBManager.exe
}

make_gtk2(){
  /usr/local/share/lazarus/tools/svn2revisioninc .
  $lazbuild IBManager.lpi
  strip IBManager
}

make_qt(){
  /usr/local/share/lazarus/tools/svn2revisioninc .
  $lazbuild IBManager.lpi --widgetset=qt
  strip IBManager
}

make_all(){
  make_clean;
  make_gtk2;
  make_win32;
}

case $1 in
  clean) make_clean;;
  win32) make_win32;;
  win64) make_win64;;
   gtk2) make_gtk2;;
     qt) make_qt;;
    all) make_all;;
      *) show_help;;
esac