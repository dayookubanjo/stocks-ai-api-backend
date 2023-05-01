# FROM python:3.9-alpine3.13
FROM ubuntu:16.04
FROM python:3.8


# FROM python:3.8
LABEL maintainer="dayookubanjo@yahoo.com"

ENV PYTHONUNBUFFERED 1


COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false

RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    #apt-get install  postgresql-client build-base postgresql-dev musl-dev jpeg-dev gfortran lapack lapack-dev libstdc++ && \
   # apt-get install   --virtual .tmp-build-deps \
     #   build-base postgresql-dev musl-dev zlib zlib-dev && \
    /py/bin/pip install -r /tmp/requirements.txt && \ 
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    #apt-get del .tmp-build-deps && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user && \
    mkdir -p /vol/web/media && \
    mkdir -p /vol/web/static && \
    chown -R django-user:django-user /vol && \
    chmod -R 755 /vol

    # 755 is a super user permission that allows django-user make any changes 

ENV PATH="/py/bin:$PATH"
# ENV JAVA_HOME = "/usr/lib/jvm/java-11-openjdk-amd64"

USER django-user
