Name: FBManager
Version: 0.9
Release: 1
Summary: Free DataBase Manager
Group: Development/Databases
License: GPL
Source0: FBManager.tar.gz
URL: https://github.com/lalexs75/FBManager
#BuildArch: i386
Requires: sqlite-libs
Requires(post): desktop-file-utils
Requires(postun): desktop-file-utils

%global debug_package %{nil}

%description
FBManager is a universal managment database application.
It's support Postgre SQL, MySQL, FireBird SQL, SQLite3.

%prep
%setup -q -n %{name}-%{version}
       
%build
./make_fbm.sh gtk2

%install
[ %{buildroot} != "/" ] && ( rm -rf %{buildroot} )

FBM_DIR=%{_libdir}/%{name}
#mkdir -p %{buildroot}/usr/{bin,lib,share}
#mkdir -p %{buildroot}/usr/share/FBManager
#mkdir -p %{buildroot}/usr/share/FBManager/languages
#mkdir -p %{buildroot}/usr/share/FBManager/docs
#mkdir -p %{buildroot}/usr/share/FBManager/reports
mkdir -p %{buildroot}$FBM_DIR
mkdir -p %{buildroot}$FBM_DIR/languages/
mkdir -p %{buildroot}$FBM_DIR/docs/
mkdir -p %{buildroot}$FBM_DIR/reports/

mkdir -p %{buildroot}%{_bindir}
mkdir -p %{buildroot}%{_datadir}/pixmaps
mkdir -p %{buildroot}%{_datadir}/applications

install IBManager %{buildroot}$FBM_DIR
cp -a languages/* %{buildroot}$FBM_DIR/languages/
cp -a reports/* %{buildroot}$FBM_DIR/reports/
cp -a docs/* %{buildroot}$FBM_DIR/docs/

ln -sf $FBM_DIR/IBManager %{buildroot}%{_bindir}/IBManager

install -m 644 Images/icons/MainIcon.png %{buildroot}%{_datadir}/pixmaps/FBManager.png
install -m 644 setup/linux/FBManager.desktop %{buildroot}%{_datadir}/applications/FBManager.desktop

%files
%defattr(-,root,root)
%{_libdir}/%{name}
%{_bindir}/*
%{_datadir}/pixmaps/FBManager.png
%{_datadir}/applications/FBManager.desktop

%clean
[ %{buildroot} != "/" ] && ( rm -rf %{buildroot} )

%changelog
* Tue Jul 31 2019 Lagunov Aleksey
 - Initial build
