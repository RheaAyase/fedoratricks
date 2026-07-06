# vim: syntax=spec

%global srcname fedoratricks
%global debug_package %{nil}

Name:       fedoratricks
Version:    0.2
Release:    1%{?dist}
Summary:    A is a collection of scripts to make the life of a beginner Fedora Linux user a little bit easier. We aspire to not spoon-feed the solution, but to also teach what these tools do for you.
License:    MIT
URL:        https://github.com/RheaAyase/fedoratricks
Source:     https://github.com/RheaAyase/fedoratricks/releases/latest/download/fedoratricks-%{version}.tar.gz

BuildArch:  noarch
BuildRequires: shellcheck
BuildRequires: scdoc
Provides:   fedoratricks

Requires:   bash
Requires:   curl
Requires:   inxi

%description
A is a collection of scripts to make the life of a beginner Fedora Linux user a little bit easier. We aspire to not spoon-feed the solution, but to also teach what these tools do for you.

%prep
%setup -C
shellcheck %{name}.sh commands/*

%build
scdoc < docs/%{name}.1.scd > docs/%{name}.1

%install
install -D -m 0644 commands/* -t "%{buildroot}%{_datarootdir}/%{name}/"
install -D -m 0755 %{name}.sh "%{buildroot}%{_bindir}/%{name}"
install -D -m 0644 docs/%{name}.1 "%{buildroot}%{_mandir}/man1/%{name}.1"

%files
%{_bindir}/%{name}
%{_datarootdir}/%{name}/*
%{_mandir}/man1/%{name}.1*

%changelog
* Sat Jun 6 2026 Rhea Gustavsson <contact@rhea.dev> 0.2-1
- imshubhamsocial: modularize test harness; add multimedia, nvidia and secureboot; refactor logs
* Sat Jun 6 2026 Rhea Gustavsson <contact@rhea.dev> 0.1-1
- init - basic framework that does nothing

