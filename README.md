# GravityPipeline
Dockerfile to build the VLTI/Gravity pipeline with the python tool

## Running pipeline
```
docker run -it --rm  -v $FOLDER:/work/data ferreol/gravity-pipeline
 ```
  where:
  - `$FOLDER` is the folder were all the raw files are (`$PWD` for the current directory).

