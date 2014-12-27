# Qt4 ImageViewer Project

Just an 'example' image viewer using QImage... I think the original source 
was from http://qt-project.org/doc/qt-4.8/widgets-imageviewer.html... with 
a few relatively minor modification, mainly to load an image file from 
the command line...

And as an experiment ported to using CMake to generate the out of source build 
files in the 'build' directory.

The original CMakeLists.txt was generated by a qt2cmake.pl perl script I have,
which reads the 'project'.pro file. That pro file has been left but has not 
been tested or used.

## Prerequisites

Installation of Qt4 runtime and SDK. Here I used the 64-bit windows install into 
C:\Qt\4.8.6, but there is no reason why it would not also build in 32-bits.

Installation of MSVC10, or other versions, or some alternate build tools supported by
CMake. Running cmake -? will list the generators are available on your platform.

## Building

CMake fully supports out-of-source building, which is great for cleaning up all 
the MSVC10 (in my case, but should work for most MSVC versions) built components, 
and for this I use the 'build' folder.

The simple build instructions are -  
cd build  
cmake ..  
cmake --build . --config Release  
and it should be done.

## Runtime

Naturally the full set of Qt runtime DLLS must be available in the PATH environment 
variable.

This can be done with, in my case -  
set PATH=C:\Qt\4.8.6\bin;%PATH%  
Release\imageviewer [image_file]  

The Qt4 documentation suggests support for the following image formats -

* PNG Portable Network Graphics	Read/write
* JPG/JPEG Joint Photographic Experts Group Read/write
* TIFF Tagged Image File Format Read/write  
* BMP Windows Bitmap Read/write
* PPM Portable Pixmap Read/write
* XBM/XPM X11 Bitmap Read/write  
* GIF Graphic Interchange Format Read
* PBM/PGM Portable Bitmap Read

However only the first 3 are shown in the Save As... dialog. And printing has NOT been 
tested, so is presently disabled...

Three example image files are included in the source, and a windows 64-bit runtime,
imageview.exe. No install has been included in a CMakeLists.txt.

For complete building see build-me.bat, and run-iv.bat for running the binary. These 
files may need adjustment to suit your environment.

The BSD license is included as a header in each source file.

Have fun.

Geoff.
20141227

; eof
