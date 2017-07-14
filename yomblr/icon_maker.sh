#!/bin/sh
src=$1

sips -Z 120 $src --out Assets.xcassets/AppIcon.appiconset/icon-60@2x.png
sips -Z 180 $src --out Assets.xcassets/AppIcon.appiconset/icon-60@3x.png
sips -Z  76 $src --out Assets.xcassets/AppIcon.appiconset/icon-76.png
sips -Z 152 $src --out Assets.xcassets/AppIcon.appiconset/icon-76@2x.png
sips -Z 167 $src --out Assets.xcassets/AppIcon.appiconset/icon-83.5@2x.png
sips -Z  29 $src --out Assets.xcassets/AppIcon.appiconset/icon-29.png
sips -Z  58 $src --out Assets.xcassets/AppIcon.appiconset/icon-29@2x.png
sips -Z  87 $src --out Assets.xcassets/AppIcon.appiconset/icon-29@3x.png
sips -Z  40 $src --out Assets.xcassets/AppIcon.appiconset/icon-40.png
sips -Z  80 $src --out Assets.xcassets/AppIcon.appiconset/icon-40@2x.png
sips -Z 120 $src --out Assets.xcassets/AppIcon.appiconset/icon-40@3x.png
sips -Z  20 $src --out Assets.xcassets/AppIcon.appiconset/icon-20.png
sips -Z  40 $src --out Assets.xcassets/AppIcon.appiconset/icon-20@2x.png
sips -Z  60 $src --out Assets.xcassets/AppIcon.appiconset/icon-20@3x.png

cat << EOF > Assets.xcassets/AppIcon.appiconset/Contents.json
{
  "images" : [
    {
      "idiom" : "iphone",
      "size" : "20x20",
      "filename" : "icon-20@2x.png",
      "scale" : "2x"
    },
    {
      "idiom" : "iphone",
      "size" : "20x20",
      "filename" : "icon-20@3x.png",
      "scale" : "3x"
    },
    {
      "idiom" : "iphone",
      "size" : "29x29",
      "filename" : "icon-29@2x.png",
      "scale" : "2x"
    },
    {
      "idiom" : "iphone",
      "size" : "29x29",
      "filename" : "icon-29@3x.png",
      "scale" : "3x"
    },
    {
      "idiom" : "iphone",
      "size" : "40x40",
      "filename" : "icon-40@2x.png",
      "scale" : "2x"
    },
    {
      "idiom" : "iphone",
      "size" : "40x40",
      "filename" : "icon-40@3x.png",
      "scale" : "3x"
    },
    {
      "idiom" : "iphone",
      "size" : "60x60",
      "filename" : "icon-60@2x.png",
      "scale" : "2x"
    },
    {
      "idiom" : "iphone",
      "size" : "60x60",
      "filename" : "icon-60@3x.png",
      "scale" : "3x"
    },
    {
      "idiom" : "ipad",
      "size" : "20x20",
      "filename" : "icon-20.png",
      "scale" : "1x"
    },
    {
      "idiom" : "ipad",
      "size" : "20x20",
      "filename" : "icon-20@2x.png",
      "scale" : "2x"
    },
    {
      "idiom" : "ipad",
      "size" : "29x29",
      "filename" : "icon-29.png",
      "scale" : "1x"
    },
    {
      "idiom" : "ipad",
      "size" : "29x29",
      "filename" : "icon-29@2x.png",
      "scale" : "2x"
    },
    {
      "idiom" : "ipad",
      "size" : "40x40",
      "filename" : "icon-40.png",
      "scale" : "1x"
    },
    {
      "idiom" : "ipad",
      "size" : "40x40",
      "filename" : "icon-40@2x.png",
      "scale" : "2x"
    },
    {
      "idiom" : "ipad",
      "size" : "76x76",
      "filename" : "icon-76.png",
      "scale" : "1x"
    },
    {
      "idiom" : "ipad",
      "size" : "76x76",
      "filename" : "icon-76@2x.png",
      "scale" : "2x"
    },
    {
      "idiom" : "ipad",
      "size" : "83.5x83.5",
      "filename" : "icon-83.5@2x.png",
      "scale" : "2x"
    }
  ],
  "info" : {
    "version" : 1,
    "author" : "xcode"
  }
}
EOF