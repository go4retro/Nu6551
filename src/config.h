/*
    Nu6551 - Atmela AVR MOS 6551 ACIA emulator
    Copyright Jim Brain and RETRO Innovations, 2021

    These files are free designs; you can redistribute them and/or modify
    them under the terms of the Creative Commons Attribution-ShareAlike 
    4.0 International License.

    You should have received a copy of the license along with this
    work. If not, see <http://creativecommons.org/licenses/by-sa/4.0/>.

    These files are distributed in the hope that they will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    license for more details.

    config.h: User-configurable options to simplify hardware changes and/or
              reduce the code/ram requirements of the code.
*/

#ifndef CONFIG_H
#define CONFIG_H

#include "version.h"

#define STRINGIFY(x) #x
#define TOSTRING(x) STRINGIFY(x)

#ifdef VER_PATCH
#ifdef VER_FIX
  #define VER_TEXT           TOSTRING(VER_MAJOR) "." TOSTRING(VER_MINOR) "." TOSTRING(VER_PATCH) "." TOSTRING(VER_FIX)
#else
  #define VER_TEXT           TOSTRING(VER_MAJOR) "." TOSTRING(VER_MINOR) "." TOSTRING(VER_PATCH)
#endif
#else
  #define VER_TEXT           TOSTRING(VER_MAJOR) "." TOSTRING(VER_MINOR)
#endif
#ifdef VER_PRERELEASE
  #define VERSION "" VER_TEXT TOSTRING(VER_PRERELEASE) ""
#else
  #define VERSION "" VER_TEXT ""
#endif

#include <avr/io.h>

#ifndef TRUE
  #define TRUE (1==1)
  #define FALSE (!TRUE)
#endif

#if defined ARDUINO_AVR_UNO || defined ARDUINO_AVR_PRO || defined ARDUINO_AVR_NANO
 #define CONFIG_HARDWARE_VARIANT   3 // Hardware variant 3 is Arduino, with BAV on D2 for wakeup from standby mode.
 // Variant 3 has been tested on Pro Mini, Uno, and Nano as functional.  Select target platform in the IDE.
#endif

#ifndef ARDUINO
 #include "autoconf.h"
#else

// Debug to serial
//#define CONFIG_UART_DEBUG
//#define CONFIG_UART_DEBUG_SW
#define CONFIG_UART_DEBUG_RATE    115200
#define CONFIG_UART_DEBUG_FLUSH
#define CONFIG_UART_BUF_SHIFT     8

#endif

/* ----- Common definitions for all AVR hardware variants ------ */

#define MAX_OPEN_FILES    8
#define BUFSIZE           255
#define UART_DOUBLE_SPEED

#if CONFIG_HARDWARE_VARIANT == 1
/* ---------- Hardware configuration: HEXTIr v1 ---------- */

#else
#  error "CONFIG_HARDWARE_VARIANT is unset or set to an unknown value."
#endif


/* ---------------- End of user-configurable options ---------------- */

#endif /*CONFIG_H*/
