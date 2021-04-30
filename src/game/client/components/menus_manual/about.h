#ifndef GAME_CLIENT_COMPONENTS_MENUS_MANUAL_ABOUT_H
#define GAME_CLIENT_COMPONENTS_MENUS_MANUAL_ABOUT_H
#undef GAME_CLIENT_COMPONENTS_MENUS_MANUAL_ABOUT_H // this file will be included multiple times

#ifndef PUTLINE
#define PUTLINE(LINE) ;
#endif

#ifndef NEWLINE
#define NEWLINE() ;
#endif

PUTLINE("|Sash - Version " ATH_VERSION "|")
PUTLINE("Exact Build Date: " BUILD_DATE)
PUTLINE("Teeworlds client modification by Sash")
PUTLINE("Official Website: https://Sash.MyBin.IR")
NEWLINE()
PUTLINE("Use F9 for more information!")


#endif
