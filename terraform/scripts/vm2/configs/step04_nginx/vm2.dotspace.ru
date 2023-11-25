server {
    listen 80 default_server;

    root /var/www/vm2.dotspace.ru/html;
    index index.html;

    # server_name vm2.dotspace.ru www.vm2.dotspace.ru;
    server_name vm2.dotspace.ru;

    location / {
        try_files $uri $uri/ =404;
    }

}
