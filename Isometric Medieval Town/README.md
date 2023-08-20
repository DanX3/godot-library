Command to merge all PNGs to a single atlas using imagemagick. 

`montage -background transparent -geometry tile_widthxtile_height+0+0 -tile atlas_tiles_widthxatlas_tiles_height <all_tiles**.png> outfile.png`

The following command will merge tiles of size 210x244 into an atlas with 16x17 tiles, merging all PNGs in the current directory into a file named atlas.png
`montage -background transparent -geometry 210x244+0+0  -tile 16x17 *.png  atlas.png`

