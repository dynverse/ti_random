FROM dynverse/dynwrap:r

LABEL version 0.1.5

ADD . /code

ENTRYPOINT Rscript /code/run.R
