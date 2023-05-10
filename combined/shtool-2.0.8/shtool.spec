##
##  shtool.spec -- RPM specification for shtool package
##  Copyright (c) 2000-2008 Ralf S. Engelschall <rse@engelschall.com>
##
##  This file is part of shtool and free software; you can redistribute
##  it and/or modify it under the terms of the GNU General Public
##  License as published by the Free Software Foundation; either version
##  2 of the License, or (at your option) any later version.
##
##  This file is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
##  General Public License for more details.
##
##  You should have received a copy of the GNU General Public License
##  along with this program; if not, write to the Free Software
##  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
##  USA, or contact Ralf S. Engelschall <rse@engelschall.com>.
##

#   This is a specification file for the RedHat Package Manager (RPM).
#   It is part of the shtool source tree and this way directly included
#   in shtool distribution tarballs. This way one can use a simple "rpm
#   -tb shtool-1.X.Y.tar.gz" command to build binary RPM packages from a
#   original shtool distribution tarball.

%ifdef %{_prefix}
%define prefix %{_prefix}
%else
%define prefix /usr/local
%endif

%define ver 2.0.8
%define rel 0

Name:       shtool
Version:    %{ver}
Release:    %{rel}
Group:      Development/Tools
License:    GPL
URL:        http://www.gnu.org/software/shtool/
Summary:    GNU shtool, The GNU Portable Shell Tool

Source:     ftp://ftp.gnu.org/gnu/shtool/shtool-%{ver}.tar.gz
BuildArch:  noarch
BuildRoot:  /tmp/shtool-%{ver}-root

%description
    GNU shtool is a compilation of small but very stable and portable
    shell scripts into a single shell tool. All ingredients were in
    successful use over many years in various free software projects.
    The compiled shtool program is intended to be used inside the
    source tree of other free software packages. There it can overtake
    various (usually non-portable) tasks related to the building and
    installation of such a package. It especially can replace the old
    mkdir.sh, install.sh and related scripts.

%prep
%setup

%build
    ./configure --prefix=%{prefix}
    make
    make test

%install
    rm -rf $RPM_BUILD_ROOT
    make install DESTDIR=$RPM_BUILD_ROOT

%clean
    rm -rf $RPM_BUILD_ROOT

%files
    %defattr(-,root,root)
    %doc AUTHORS COPYING ChangeLog INSTALL README THANKS
    %{prefix}/bin/shtool
    %{prefix}/bin/shtoolize
    %{prefix}/man/man1/shtool.1
    %{prefix}/man/man1/shtoolize.1
    %{prefix}/share/aclocal/shtool.m4
    %{prefix}/share/shtool/

