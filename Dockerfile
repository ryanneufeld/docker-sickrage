FROM ubuntu:14.04.3

MAINTAINER Ryan Neufeld <ryan@neucode.org>

EXPOSE 8081/tcp

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qq update
RUN apt-get -yf install software-properties-common
RUN apt-add-repository multiverse
RUN apt-get -qq update
RUN apt-get -yf install supervisor python python-pip unzip libssl-dev git python-dev unrar

RUN mkdir /sickrage

RUN git clone -b v4.0.63 https://github.com/SiCKRAGETV/SickRage.git /sickrage
RUN pip install -r /sickrage/requirements.txt
RUN mv /sickrage/autoProcessTV/autoProcessTV.cfg.sample /sickrage/autoProcessTV/autoProcessTV.cfg

RUN mkdir -p /sickrage/logs/supervisor/

#ADD conf/sickrage.ini /sickrage/config.ini
ADD conf/supervisord.conf /etc/supervisor/conf.d/sickrage.conf

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/sickrage.conf"]
