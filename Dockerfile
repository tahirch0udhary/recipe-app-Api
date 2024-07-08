# Use an official Python runtime as a parent image
FROM python:3.9-alpine3.13

# Set maintainer label
LABEL maintainer="tahir choudhary"

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PATH="/scripts:/py/bin:$PATH"

# Copy requirements files to the Docker image
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./scripts /scripts
COPY ./app /app
COPY ./entrypoint.sh /entrypoint.sh

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
    mkdir -p /vol/web/media/uploads/recipe && \
    chown -R django-user:django-user /vol && \
    chmod -R 755 /vol && \
    chmod +x /entrypoint.sh

# Switch to the django-user
USER django-user

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Default command
CMD ["run.sh"]
