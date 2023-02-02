FROM alpine

EXPOSE 8118

HEALTHCHECK --interval=30s --timeout=3s CMD nc -z localhost 8118

RUN apk --no-cache --update add privoxy ca-certificates bash && \
    mv /etc/privoxy/config.new /etc/privoxy/config && \
    mv /etc/privoxy/default.action.new /etc/privoxy/default.action && \
    mv /etc/privoxy/default.filter.new /etc/privoxy/default.filter && \
    mv /etc/privoxy/match-all.action.new /etc/privoxy/match-all.action && \
    mv /etc/privoxy/user.action.new /etc/privoxy/user.action && \
    mv /etc/privoxy/user.filter.new /etc/privoxy/user.filter && \
    mv /etc/privoxy/trust.new /etc/privoxy/trust && \
    mv /etc/privoxy/regression-tests.action.new /etc/privoxy/regression-tests.action && \
    sed -i'' 's/127\.0\.0\.1:8118/0\.0\.0\.0:8118/' /etc/privoxy/config && \
    sed -i'' 's/enable-edit-actions\ 0/enable-edit-actions\ 1/' /etc/privoxy/config && \
    sed -i'' 's/#max-client-connections/max-client-connections/' /etc/privoxy/config && \
    sed -i'' 's/accept-intercepted-requests\ 0/accept-intercepted-requests\ 1/' /etc/privoxy/config

RUN chown privoxy.privoxy /etc/privoxy/*

ENTRYPOINT ["privoxy"]

CMD ["--no-daemon","--user","privoxy","/etc/privoxy/config"]
