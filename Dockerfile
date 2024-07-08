# Dockerfile

# Use an official Python runtime as a parent image
FROM python:3.9-alpine3.13

# Set maintainer label
LABEL maintainer="tahir choudhary"

# Set environment variables
ENV PYTHONUNBUFFERED 1

# Copy requirements files to the Docker image
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./scripts /scripts
COPY ./app /app

# Set working directory
WORKDIR /app

# Expose port 8000 (if your app needs to listen on a specific port)
EXPOSE 8000

# Argument to determine if development requirements should be installed
ARG DEV=false

# Install Python dependencies
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client jpeg-dev && \
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev zlib zlib-dev linux-headers && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; then /py/bin/pip install -r /tmp/requirements.dev.txt; fi && \
    rm -rf /tmp && \
    apk del .tmp-build-deps && \
    adduser --disabled-password --no-create-home django-user && \
    mkdir -p /vol/web/media && \
    mkdir -p /vol/web/static && \
    chown -R django-user:django-user /vol && \
    chmod -R 755 /vol && \
    chmod -R +x /scripts

# Set PATH environment variable to use binaries from the virtual environment
ENV PATH="/py/bin:$PATH"

# Switch to the django-user
USER django-user

CMD ["run.sh"]