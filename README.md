### Merging tiles together
montage -background transparent -geometry 210x244+0+0  -tile 16x17 *.png  atlas.png

### Merging animation sprites
montage -background transparent -tile 8x1 *.png  atlas.png

### Splitting texture atlas tiles
convert pickups_copy.png -crop 3x2-0-0@ +repage +adjoin tile-%d.png

### Resize image
`convert heart.png -resize 20% heart_small.png`


`convert heart.png -resize 64x64 heart_small.png`
The image is not stretched anyway and is resized to the minimum edge specified. In case of a 256x256 image, `-resize 64x128` will result in a 64x64 image
