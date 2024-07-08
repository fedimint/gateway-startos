# Stage 1: Build gatewayd
FROM fedimint/gatewayd:v0.3.1 AS gatewayd

# Set environment variables for gatewayd
ENV FM_GATEWAY_DATA_DIR=/gateway_data
ENV FM_GATEWAY_LISTEN_ADDR=0.0.0.0:8175
ENV FM_GATEWAY_API_ADDR=http://127.0.0.1:8175
ENV FM_GATEWAY_PASSWORD=thereisnosecondbest
ENV FM_GATEWAY_FEES=0,10000
ENV FM_LND_RPC_ADDR=https://lnd.embassy:10009
ENV FM_LND_TLS_CERT=/lnd_data/tls.cert
ENV FM_LND_MACAROON=/lnd_data/data/chain/bitcoin/signet/admin.macaroon

ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod +x /usr/local/bin/docker_entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]

# # Set up volumes for gatewayd
# VOLUME ["/gateway_data"]

# # Stage 2: Build gateway-ui
# FROM fedimintui/gateway-ui:0.3.0 as gateway-ui

# # Set environment variables for gateway-ui
# ENV PORT=3001
# ENV REACT_APP_FM_GATEWAY_API=http://127.0.0.1:8175
# ENV REACT_APP_FM_GATEWAY_PASSWORD=thereisnosecondbest

# # Expose ports for gateway-ui
# EXPOSE 3001

# # Final stage: Combine both
# FROM fedimint/gatewayd:v0.3.0

# # Copy gateway-ui files
# COPY --from=gateway-ui /usr/share/nginx/html /usr/share/nginx/html
