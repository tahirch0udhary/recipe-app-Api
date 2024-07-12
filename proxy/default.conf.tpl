server {
    listen ${LISTEN_PORT};
    server_name ec2-16-171-14-96.eu-north-1.compute.amazonaws.com;

    location /static {
        alias /vol/static;
    }

    location /media {
        alias /vol/web/media;
    }

    location / {
        uwsgi_pass              ${APP_HOST}:${APP_PORT};
        include                 /etc/nginx/uwsgi_params;
        client_max_body_size    10M;
    }
}