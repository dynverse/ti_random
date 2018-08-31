FROM dynverse/dynwrap:r

LABEL version 0.1.1

ADD . /code

ENTRYPOINT Rscript /code/run.R
