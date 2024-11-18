# Godot Library

This is a collection of personal utilities facing common issues encountered while developing games. 
All the project files are stored under the `library/` directory, which is meant to be copied into your project to import it. Under this directory, the structure is the following:
* `assets`: minimum assets used to test the different components
* `demo`: small demo scenes used as example on the usage of the different components
* `scenes`: scene files of the components
* `scripts`: script files of the components
* `shaders`: collection of different shaders


## Installation
To import correctly the utilities into your Godot Project, copy and paste the `library/` directory in the root of your project. Is this bad? Yes, but its the cleanest solution to not mess with the existing project files.


## Imagemagick utilities
Some most common image edits can be performed quicker using the imagemagick tool. The following is a list of the most used commands

##### Merging tiles together
`montage -background transparent -geometry 210x244+0+0  -tile 16x17 *.png  atlas.png`

##### Merging animation sprites
`montage -background transparent -tile 8x1 *.png  atlas.png`

##### Splitting texture atlas tiles
`convert pickups_copy.png -crop 3x2-0-0@ +repage +adjoin tile-%d.png`

##### Resize image
`convert heart.png -resize 20% heart_small.png`

`convert heart.png -resize 64x64 heart_small.png`
The image is not stretched anyway and is resized to the minimum edge specified. In case of a 256x256 image, `-resize 64x128` will result in a 64x64 image
