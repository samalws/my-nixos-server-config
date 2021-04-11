''
user root;
events {}
http {
  server {
    server_name samuwe.com www.samuwe.com samalws.com www.samalws.com;

    listen 443 http2 ssl;
    listen [::]:443 http2 ssl;

    ssl_certificate /etc/letsencrypt/live/samuwe.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/samuwe.com/privkey.pem;

    root /home/uwe/purgatory/emptyDir;

    location /zehnerRaus/ {
      proxy_set_header        Host $host;
      proxy_set_header        X-Real-IP $remote_addr;
      proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header        X-Forwarded-Proto $scheme;

      rewrite /zehnerRaus/(.*) /$1  break;

      proxy_pass          http://localhost:444;
      proxy_read_timeout  444;

      # WebSocket support
      proxy_http_version 1.1;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection "upgrade";
    }

    location / {
      proxy_set_header        Host $host;
      proxy_set_header        X-Real-IP $remote_addr;
      proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header        X-Forwarded-Proto $scheme;

      proxy_pass          http://localhost:445;
      proxy_read_timeout  445;
    }
  }
}
''
