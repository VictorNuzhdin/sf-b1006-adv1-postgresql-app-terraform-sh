server {
    listen 80 default_server;

    root /var/www/vm1.dotspace.ru/html;
    index index.html;

    # server_name vm1.dotspace.ru www.vm1.dotspace.ru;
    server_name vm1.dotspace.ru;

    location / {
        try_files $uri $uri/ =404;
    }

}
