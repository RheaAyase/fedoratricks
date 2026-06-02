# vim: syntax=spec

%global srcname fedoratricks
%global debug_package %{nil}

Name:       fedoratricks
Version:    0.1
Release:    1%{?dist}
Summary:    A is a collection of scripts to make the life of a beginner Fedora Linux user a little bit easier. We aspire to not spoon-feed the solution, but to also teach what these tools do for you.
License:    MIT
URL:        https://github.com/RheaAyase/fedoratricks
Source:     https://github.com/RheaAyase/fedoratricks/releases/latest/download/fedoratricks-%{version}.tar.gz

BuildArch:  noarch
Provides:   fedoratricks

Requires:   bash
Requires:   curl

%description
A is a collection of scripts to make the life of a beginner Fedora Linux user a little bit easier. We aspire to not spoon-feed the solution, but to also teach what these tools do for you.

%prep
%setup -C

%install
install -m 0755 %{name}.sh "%{buildroot}%{_bindir}/%{_bindir}/%{name}"

%files
%{_bindir}/%{name}

%changelog
* Sat Jun 6 2026 Rhea Gustavsson <contact@rhea.dev> 0.1-1
- init - basic framework that does nothing

