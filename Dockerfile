FROM debian:12.7-slim AS builder

    ARG DEBIAN_FRONTEND="noninteractive"

    RUN apt-get update && \
        apt-get install --no-install-recommends --assume-yes \
            mkdocs && \
        rm --recursive --force "/var/lib/apt/lists/"

    WORKDIR "/source/website/"

    COPY "./website/" "/source/website/"

    RUN mkdocs build

FROM nginx:alpine AS nginx

    COPY --from="builder" "/source/website/site/" "/usr/share/nginx/html/"

    EXPOSE 80/tcp
