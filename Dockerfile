FROM python:3.6-alpine

# Copy data to container
COPY . /app

# Set Workdir
WORKDIR /app

# Install libraries
RUN pip install --upgrade pip
RUN \
 apk add --no-cache bash && \
 apk add --no-cache postgresql-libs && \
 apk add --no-cache --virtual .build-deps gcc musl-dev postgresql-dev libffi-dev

# Install dependencies
RUN pip install -r requirements.txt
EXPOSE 5000

# Run entrypoint.sh
CMD ["/bin/bash", "entrypoint.sh"]