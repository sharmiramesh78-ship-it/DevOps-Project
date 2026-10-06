FROM nginx:alpine

RUN printf '<!DOCTYPE html><html><body><h1>DevOps Project</h1><p>Frontend is running successfully.</p></body></html>' > /usr/share/nginx/html/index.html

EXPOSE 80