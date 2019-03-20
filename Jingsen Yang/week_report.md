#Week Report 

## 3.20

### 1. Help algorithm team to compile opencv, openh264 , libharu

#### 1.1 Opencv_x86

​	1. Use cmake to compile the opencv source

![](https://img-blog.csdn.net/20171219141958294?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2h1X3pz/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

![](https://img-blog.csdn.net/20171219143117497?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2h1X3pz/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

![](https://img-blog.csdn.net/20171219143644296?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2h1X3pz/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

![](https://img-blog.csdn.net/20171219144030026?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2h1X3pz/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

​	2. Use visual studio to compile the output of cmake.

![](https://img-blog.csdn.net/20171219150139799?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2h1X3pz/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

![](https://img-blog.csdn.net/20171219151312435?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2h1X3pz/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)



#### 1.2 Openh264_x86

1. Install MinGW, nasm, windows sdk7

2. Set the environment variable

3. Download the openh264 sources

4. Compile openh264

   ​	run C:\MinGW\msys\1.0\msys.bat

   ```bash
   cd /d/openh264
   make ARCH=i386 OS=msvc
   ```



#### 1.3 Libharu

1. Download zlib, libpng, libharu sources

2. Compile zlib

   ​	a. open **C:\libhpdf\zlib-1.2.8\zlib-1.2.8\contrib\vstudio\vc10\zlibvc.sln**

   ​	b. set **MFC Shared DLL**，**Unicode**，**MDD,DLL**

   ​	c. building zlibvc

3. Compile libpng

   ​	a. open **C:\libhpdf\lpng1624\lpng1624\projects\vstudio\vstudio.sln**

   ​	b. add zlib's **include_dir**

   ​	c. link **zlibwapid.lib**

   ​	d. add the pre-compile setting

   ```
   _CRT_NONSTDC_NO_DEPRECATE
   _CRT_SECURE_NO_DEPRECATE
   _CRT_NONSTDC_NO_WARNINGS
   ZLIB_WINAPI
   ASMV
   ASMINF
   ```

   ​	e. building

4. Compile libharu

   ​	a. create a new project in VS

   ​	b. add the **include_dir**  of zlib, libpng, libharu

   ​	c. add the source code od linharu

   ​	d. link libpng16.lib & zlibwapi.lib

   ​	e. add the pre-compile setting

   ```
   _CRT_NONSTDC_NO_DEPRECATE
   _CRT_SECURE_NO_DEPRECATE
   _CRT_NONSTDC_NO_WARNINGS
   ZLIB_WINAPI
   ASMV
   ASMINF
   ```

   ​	f. building





###2. Write the graduation project

