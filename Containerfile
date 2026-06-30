FROM fedora:latest AS builder

RUN dnf install -y \
    rpkg \
    rpm-build \
    rpmdevtools \
    git \
    curl  \
    && rpmdev-setuptree

WORKDIR /src
COPY . .
COPY .git .git

RUN dnf builddep -y *.spec \
    && name=$(grep "^Name:" *.spec | awk '{print $2}') \
    && version=$(grep "^Version:" *.spec | awk '{print $2}') \
    && git archive --prefix="${name}-${version}/" HEAD | gzip > ~/rpmbuild/SOURCES/${name}-${version}.tar.gz \
    && rpmbuild -ba fedoratricks.spec \
    && mkdir /rpms \
    && find ~/rpmbuild/RPMS -name "*.rpm" -exec cp {} /rpms/ \;

FROM scratch

COPY --from=builder /rpms /rpms
