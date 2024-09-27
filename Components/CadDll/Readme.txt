Copy CAD.dll to your demo directory in order to compile
and run demo application. CAD.DLL should be on the
same directory where the exe file is.

For VC++ developers:
The "Include" folder must be specified in include path of the project options.

For BCB developers:
When compiling BCB demo project, it is necessary to comment the following
line in the ..\cadimage.h:
#define CS_STATIC_DLL


If you need developer or server license, please contact us:
     Tel: +1 (800) 469-9789
     World Wide Web: https://www.cadsofttools.com
     E-mail: info@cadsofttools.com