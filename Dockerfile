FROM dynverse/dynwrapr:v0.1.0

COPY definition.yml run.R example.sh /code/

ENTRYPOINT ["/code/run.R"]
