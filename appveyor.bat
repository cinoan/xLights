rem I need to rework this so it works for mingw builds as well

echo on

dir "\program files (x86)\windows kits\10\bin\"

set "xlightsdir=%cd%"

git clone -q --branch=master https://github.com/wxWidgets/wxWidgets.git \projects\wxWidgets
if %ERRORLEVEL% NEQ 0 exit 1

sed -i 's/bool IsKindOf(const wxClassInfo *info) const/bool __attribute__((optimize("O0"))) IsKindOf(const wxClassInfo *info) const/g' \projects\wxWidgets\include\wx\rtti.h
if %ERRORLEVEL% NEQ 0 exit 1

is.exe /LOG=inno.log /SUPPRESSMSGBOXES /SP- /NORESTART /NOCLOSEAPPLICATIONS /DIR=\projects\inno /NOICONS /SILENT
if %ERRORLEVEL% NEQ 0 exit 1

type inno.log

dir \projects\inno

if [%BUILDTYPE%] EQU [X64DEBUGVS] goto x64DebugVS 
if [%BUILDTYPE%] EQU [X64RELEASEGCC] goto x64ReleaseGCC 
if [%BUILDTYPE%] EQU [X86RELEASEGCC] goto x86ReleaseGCC 

echo "Unknown build type " %BUILDTYPE%

exit 1

rem =========================================== 64 BIT MSVC ===========================================
:x64DebugVS

rem prepare the header files for wxWidgets
cd ..\wxWidgets\build\msw
msbuild /m wx_custom_build.vcxproj /p:PlatformToolset=v%PLATFORMTOOLSET% /p:Configuration="Release"
if %ERRORLEVEL% NEQ 0 exit 1

sed -i 's/#   define wxUSE_GRAPHICS_CONTEXT 0/#   define wxUSE_GRAPHICS_CONTEXT 1/g' \projects\wxWidgets\include\wx\msw\setup.h
if %ERRORLEVEL% NEQ 0 exit 1

msbuild /m wx_custom_build.vcxproj /p:PlatformToolset=v%PLATFORMTOOLSET% /p:Configuration="Release"
if %ERRORLEVEL% NEQ 0 exit 1

rem Build wxWidgets
msbuild /m wx_vc14.sln /p:PlatformToolset=v%PLATFORMTOOLSET%
if %ERRORLEVEL% NEQ 0 exit 1

cd %xlightsdir%

cd xLights

sed -i "s/10.0.15063.0/10.0.14393.0/g" Xlights.vcxproj

msbuild /m xLights.sln /p:PlatformToolset=v%PLATFORMTOOLSET%
if %ERRORLEVEL% NEQ 0 exit 1

cd ..

cd xSchedule

sed -i "s/10.0.15063.0/10.0.14393.0/g" xSchedule.vcxproj

msbuild /m xSchedule.sln /p:PlatformToolset=v%PLATFORMTOOLSET%
if %ERRORLEVEL% NEQ 0 exit 1

exit 0

rem =========================================== 32 BIT GCC ===========================================
:x86ReleaseGCC

set MINGWPATH=C:\mingw-w64\i686-6.3.0-posix-dwarf-rt_v5-rev1\mingw32\bin
set PATH=%PATH%;%MINGWPATH%

cd ..\wxWidgets\build\msw

copy ..\..\include\wx\msw\setup0.h ..\..\include\wx\msw\setup.h

sed -i 's/#   define wxUSE_GRAPHICS_CONTEXT 0/#   define wxUSE_GRAPHICS_CONTEXT 1/g' \projects\wxWidgets\include\wx\msw\setup.h
if %ERRORLEVEL% NEQ 0 exit 1

mkdir ..\..\lib\gcc_dll
mkdir ..\..\lib\gcc_dll\mswu
mkdir ..\..\lib\gcc_dll\mswu\wx
copy ..\..\include\wx\msw\setup.h ..\..\lib\gcc_dll\mswu\wx

rem build wxWidgets
mingw32-make -f makefile.gcc --debug MONOLITHIC=1 SHARED=1 UNICODE=1 CXXFLAGS="-std=gnu++14" BUILD=release -j 10

cd %xlightsdir%

7z e cbp2make-stl-rev147-all.tar.7z -o. cbp2make-stl-rev147-all\bin\Release\cbp2make.exe
if %ERRORLEVEL% NEQ 0 exit 1

cd xlights

..\cbp2make.exe -in xLights.cbp -out xLights.cbp.mak --with-deps --keep-outdir --keep-objdir -windows -targets MinGW_Release
if %ERRORLEVEL% NEQ 0 exit 1

sed -i "s/libwxmsw31u.a/..\\\\lib\\\\windows\\\\libwxmsw31u.a/g" xLights.cbp.mak
if %ERRORLEVEL% NEQ 0 exit 1

sed -i "s/libwxmsw31u_gl.a/..\\\\lib\\\\windows\\\\libwxmsw31u_gl.a/g" xLights.cbp.mak
if %ERRORLEVEL% NEQ 0 exit 1

sed -i "s/-l\.\./../g" xLights.cbp.mak
if %ERRORLEVEL% NEQ 0 exit 1

mingw32-make -f xLights.cbp.mak CXXFLAGS="-std=gnu++14" WX=\projects\wxWidgets INC=-I\projects\wxWidgets\include -j 10 mingw_release
if %ERRORLEVEL% NEQ 0 exit 1

cd ..\xSchedule

..\cbp2make.exe -in xSchedule.cbp -out xSchedule.cbp.mak --with-deps --keep-outdir --keep-objdir -windows -targets MinGW_Release
if %ERRORLEVEL% NEQ 0 exit 1

mingw32-make -f xSchedule.cbp.mak CXXFLAGS="-std=gnu++14" WX=\projects\wxWidgets INC=-I\projects\wxWidgets\include -j 10 mingw_release
if %ERRORLEVEL% NEQ 0 exit 1

exit 0

rem =========================================== 64 BIT GCC ===========================================
:x64ReleaseGCC

set MINGWPATH=C:\mingw-w64\x86_64-6.3.0-posix-seh-rt_v5-rev1\mingw64\bin
set PATH=%PATH%;%MINGWPATH%

cd ..\wxWidgets\build\msw

copy ..\..\include\wx\msw\setup0.h ..\..\include\wx\msw\setup.h

sed -i 's/#   define wxUSE_GRAPHICS_CONTEXT 0/#   define wxUSE_GRAPHICS_CONTEXT 1/g' \projects\wxWidgets\include\wx\msw\setup.h
if %ERRORLEVEL% NEQ 0 exit 1

mkdir ..\..\lib\gcc_dll
mkdir ..\..\lib\gcc_dll\mswu
mkdir ..\..\lib\gcc_dll\mswu\wx
copy ..\..\include\wx\msw\setup.h ..\..\lib\gcc_dll\mswu\wx

rem build wxWidgets
mingw32-make -f makefile.gcc --debug MONOLITHIC=1 SHARED=1 UNICODE=1 CXXFLAGS="-std=gnu++14" BUILD=release -j 10

cd %xlightsdir%

7z e cbp2make-stl-rev147-all.tar.7z -o. cbp2make-stl-rev147-all\bin\Release\cbp2make.exe
if %ERRORLEVEL% NEQ 0 exit 1

cd xlights

sed -i "s/gnu_gcc_64bit_compiler/gcc/g" xLights.cbp

..\cbp2make.exe -in xLights.cbp -out xLights.cbp.mak --with-deps --keep-outdir --keep-objdir -windows -targets "64bit  MinGW_Release"
if %ERRORLEVEL% NEQ 0 exit 1

sed -i "s/-l\.\./../g" xLights.cbp.mak
if %ERRORLEVEL% NEQ 0 exit 1

mingw32-make -f xLights.cbp.mak CXXFLAGS="-std=gnu++14" WX=\projects\wxWidgets INC=-I\projects\wxWidgets\include -j 10 64bit__mingw_release
if %ERRORLEVEL% NEQ 0 exit 1

cd ..\xSchedule

..\cbp2make.exe -in xSchedule.cbp -out xSchedule.cbp.mak --with-deps --keep-outdir --keep-objdir -windows -targets "64bit  MinGW_Release"
if %ERRORLEVEL% NEQ 0 exit 1

mingw32-make -f xSchedule.cbp.mak CXXFLAGS="-std=gnu++14" WX=\projects\wxWidgets INC=-I\projects\wxWidgets\include -j 10 64bit__mingw_release
if %ERRORLEVEL% NEQ 0 exit 1

exit 0
