# Utilise l'image nginx la plus récente
FROM nginx:latest

# Installer OpenSSH Server et ses dépendances (supprimé ici car pas nécessaire sur Render)
# RUN apt-get update && apt-get install -y openssh-server

# Copier les fichiers de votre site web dans le répertoire HTML de Nginx
COPY ./siteweb /usr/share/nginx/html

# Copier les certificats SSL dans le répertoire Nginx pour HTTPS
COPY ./siteweb/certificates /etc/nginx/certs

# Créer un fichier de configuration Nginx avec support SSL
RUN echo "server { \
    listen 443 ssl; \
    server_name _; \
    ssl_certificate /etc/nginx/certs/Web.crt; \
    ssl_certificate_key /etc/nginx/certs/Web.key; \
    location / { \
        root /usr/share/nginx/html; \
        index index.html index.htm; \
    } \
}" > /etc/nginx/conf.d/default.conf

# Exposer uniquement le port 443 (HTTPS)
EXPOSE 443

# Lancer Nginx en mode premier plan
CMD ["nginx", "-g", "daemon off;"]

