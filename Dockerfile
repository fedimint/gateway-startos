# Stage 1: Build yq binary
FROM debian:buster AS builder

ARG PLATFORM
ARG ARCH

RUN apt update && apt install -y ca-certificates
RUN sed -i "s|http://|https://|g" /etc/apt/sources.list
RUN apt-get update && apt-get -y upgrade && apt-get install -y -qq --no-install-recommends wget bash iproute2 gawk
RUN wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_${PLATFORM} -O /usr/bin/yq && chmod +x /usr/bin/yq


# Stage 2: Build gatewayd
FROM fedimint/gatewayd:v0.3.1 AS gatewayd

# Copy yq binary from the builder stage
COPY --from=builder /usr/bin/yq /bin/yq

# Set environment variables for gatewayd
ENV FM_GATEWAY_DATA_DIR=/gateway_data
ENV FM_GATEWAY_LISTEN_ADDR=0.0.0.0:8175
ENV FM_GATEWAY_API_ADDR=http://127.0.0.1:8175
ENV FM_GATEWAY_PASSWORD=thereisnosecondbest
ENV FM_GATEWAY_FEES=0,10000
ENV FM_LND_RPC_ADDR=https://lnd.embassy:10009
ENV FM_LND_TLS_CERT=/lnd_data/tls.cert
ENV FM_LND_MACAROON=/lnd_data/data/chain/bitcoin/mainnet/admin.macaroon

ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod +x /usr/local/bin/docker_entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]
