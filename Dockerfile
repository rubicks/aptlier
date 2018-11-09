# aptlier/Dockerfile

FROM debian
ARG BUILD_DATE
ARG VCS_REF
ARG VCS_URL
LABEL \
  org.label-schema.schema-version="1.0" \
  org.label-schema.build-date="${BUILD_DATE}" \
  org.label-schema.vcs-ref="${VCS_REF}" \
  org.label-schema.vcs-url="${VCS_URL}"
ARG BUILD_CODE="UNDEFINED_BUILD_CODE"
WORKDIR /tmp/${BUILD_CODE}
ENV APTLY_GPG_KEY="ED75B5A4483DA07C"
RUN set -euvx \
    && apt-get -y update \
    && apt-get -y --no-install-recommends install dirmngr gnupg2 \
    && ( false \
    || apt-key adv --recv-keys --keyserver keys.gnupg.net "${APTLY_GPG_KEY}" \
    || apt-key adv --recv-keys --keyserver pgp.mit.edu "${APTLY_GPG_KEY}" \
    || apt-key adv --recv-keys --keyserver pool.sks-keyservers.net "${APTLY_GPG_KEY}" \
    ) \
    && echo "deb http://repo.aptly.info/ squeeze main" >>/etc/apt/sources.list.d/aptly.list \
    && apt-get -y update \
    && apt-get -y --no-install-recommends install aptly \
    && apt-get -y autoremove \
    && apt-get -y autoclean \
    && true
