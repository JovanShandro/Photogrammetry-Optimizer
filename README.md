# Photogrammetry on Dissimilar Images

## How to run

### Install dependencies
To install the dependencies run 
```
make install
```

### Conan setup
After downloading conan make sure to uncomment the following line in ~/.conan/conan.conf

```
sysrequires_mode = enabled          # environment CONAN_SYSREQUIRES_MODE (allowed modes enabled/verify/disabled)
```

and then run the following bash command:

```
conan profile update settings.compiler.libcxx=libstdc++11 default
```

### Extract images

To run the app, the images have to be in a folder named *files*. If you want to extract the images from a video run:

```
./scripts/extract_images_from_video.sh video_name 
```

The above script will extract one frame per second of the video. If more are needed just add the desired number as a second argument.

The video of the bunker Valentin used for testing can be found [here](http://robotics.jacobs-university.de/TMP/BScTheses/data/UAV-Valentin3D/)

### Running image comparison

To build the c++ code into an executable run: 
```bash
make build

```
Then to run the image comparison step: 
```bash
make run

```

The above command will run the code with a coefficient of 0.6 (from 0.1 to 0.9, the greater the value the harder it will be for 2 images to be labeled as similar).
To use another value (e.g 0.3) run:
```bash
make run COEFF=0.3
```

### Perform reconstruction

The code will create the images that will be used for generating the model.
To start reconstruction run
```bash
make reconstruct
```
To than open the resulting model run:
```bash
make preview
```

## Run the complete pipeline in one command
To perform the build run and reconstruct steps in one command run:
```bash
make start COEFF=0.3
```

In case the above script fails to open the generated mesh, most probably the mesh couldn't be generated because there were not enough images.
