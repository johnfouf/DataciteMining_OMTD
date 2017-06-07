FROM python:2.7-alpine

RUN mkdir -p /var/lib/madis

RUN apk update && apk add \
	git \
	sqlite \
	g++ \
	bash

#RUN apk add openssl --update-cache
#RUN wget -qO- https://github.com/git-lfs/git-lfs/releases/download/v2.1.1/git-lfs-linux-amd64-2.1.1.tar.gz | tar xz
#RUN mv git-lfs-*/git-lfs /usr/bin/ && rm -rf git-lfs-* && git lfs install && git lfs pull

RUN git clone https://github.com/madgik/madis.git /var/lib/madis

RUN pip install --no-cache-dir apsw

RUN mkdir -p /usr/app/src
VOLUME /usr/app/src/data
WORKDIR /usr/app/src

COPY finddatacite.sql /usr/app/src/finddatacite.sql
COPY datacite.db.gz /usr/app/src/datacite.db.gz
RUN gunzip /usr/app/src/datacite.db.gz

CMD ["/bin/sh", "-c", "for i in /usr/app/src/data/*.xml ;do echo $i && cat $i | python /var/lib/madis/src/mexec.py -f /usr/app/src/finddatacite.sql -d /usr/app/src/datacite.db > $i.json;done"]
