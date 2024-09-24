############################################################################
# Copyright 2024 Ramon Fischer                                             #
#                                                                          #
# Licensed under the Apache License, Version 2.0 (the "License");          #
# you may not use this file except in compliance with the License.         #
# You may obtain a copy of the License at                                  #
#                                                                          #
#     http://www.apache.org/licenses/LICENSE-2.0                           #
#                                                                          #
# Unless required by applicable law or agreed to in writing, software      #
# distributed under the License is distributed on an "AS IS" BASIS,        #
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. #
# See the License for the specific language governing permissions and      #
# limitations under the License.                                           #
############################################################################

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
