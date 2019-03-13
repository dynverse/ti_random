FROM dynverse/dynwrapr:v0.1.0

COPY definition.yml run.R example.R /code/

ENTRYPOINT ["/code/run.R"]
