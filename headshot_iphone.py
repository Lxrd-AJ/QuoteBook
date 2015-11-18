from PIL import Image
import sys
import os

dict = {"3.5-Inch Retina":(640,960), "4-Inch Retina":(640,1136), "4.7-inch Retina":(750,1334),"5.5-Inch Retina":(1242,2208)};

def resizeImage( filename, width, height, output_file ):
    #print filename, width, height, output_file
    image_object = Image.open(filename)
    image_object = image_object.resize( (width,height) )
    image_object.save( output_file )

def generateScreenShot( filename,dict ):
    fullFileName = ''.join(filename)
    print "Making Directory for: " + filename[0]
    # Make a directory for each file
    if not os.path.exists(filename[0]):
        os.makedirs(filename[0])

    # Using each entry in the dictinary resize the image to the dict value size
    for key,value in dict.iteritems():
        print "Generating " + key + " image for " + filename[0]
        resizeImage( fullFileName, value[0], value[1], filename[0] + '/' + key + '.jpg')

# Get all files in the current directory
for fn in os.listdir('.'):
    if os.path.isfile(fn):
        filename = os.path.splitext(fn)
        if filename[1] == '.jpg':
            generateScreenShot(filename, dict)
