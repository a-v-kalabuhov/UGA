{$WARN UNSAFE_CODE OFF}

// Авторизация при входе в систему
// Если опция включена, то при старте программы показывается окно авторизации
// Иначе пользователь захардкоден
{$DEFINE USER}

{$IFNDEF USER}
  // Опция определяет расположение базы данных
  // Если она включена, то база данных лежит в папке data\ в каталоге программы.
  // Иначе разположение определяется файлом Kis
  {$DEFINE LOCALDATA}
{$ENDIF}

{$IFDEF LOCALDATA}
  {.$E local.exe}
{$ENDIF}

{$DEFINE ENTPARAMS}

// Использование отчетов из локальной папки
// Если использована эта опция, то отчёты берутся из захардкоденой папки
// иначе раположение отчётов читается из Kis_main.ini
{.$DEFINE LOCALREPORTS}

{$DEFINE COMMON_DEBUG}

// Letters
{.$DEFINE LETTERS_DEBUG}
{.$DEFINE CHECK_CONTROL_DATE}
{$DEFINE LETTER_MNGR}

// Accounts
{$DEFINE USE_VIEW}

// Reports
{.$DEFINE REPORT_MNGR}

// Firms
{$DEFINE FIRM_MNGR}

// В адресных справках можно использовать FirmMngr а можно ContragentMngr
{.$DEFINE USE_FIRMS_IN_ADDRESSES}

// Тонкая настройка 
{$DEFINE STANDARD_FEATURES}

{$IFDEF STANDARD_FEATURES}
  {$DEFINE INCOMING_LETTERS}
  {$DEFINE OUTCOMING_LETTERS}
  {$DEFINE OFFICE_DOCS}
  {$DEFINE GUIDE}
  {$DEFINE ORDERS}
  {$DEFINE DECREES}
  {$DEFINE ARCHIVE}
  {$DEFINE SOGLAS}
  {.$DEFINE GIS}
  {$DEFINE MAP_500}
  {$DEFINE MAP_TRACINGS}
  {$DEFINE SCAN_ORDERS}
  {$DEFINE SCANS}
  {$DEFINE SCANS_VIEW}
  {.$DEFINE KIOSKS}
  {.$DEFINE LOAD_KIOSKS}
  {$DEFINE LOAD_1C}
  {$DEFINE GEODESY}
{$ELSE}
  {.$DEFINE INCOMING_LETTERS}
  {.$DEFINE OUTCOMING_LETTERS}
  {.$DEFINE OFFICE_DOCS}
  {$DEFINE ORDERS}
  {.$DEFINE DECREES}
  {.$DEFINE ARCHIVE}
  {.$DEFINE SOGLAS}
  {.$DEFINE GIS}
  {.$DEFINE MAP_500}
  {.$DEFINE MAP_TRACINGS}
  {.$DEFINE SCAN_ORDERS}
  {.$DEFINE SCANS}
  {.$DEFINE SCANS_VIEW}
  {.$DEFINE KIOSKS}
  {.$DEFINE LOAD_KIOSKS}
  {.$DEFINE LOAD_1C}
  {.$DEFINE GUIDE}
  {$DEFINE GEODESY}
{$ENDIF}

// Если эта опция используется, то заказ не будет привязан к письму
{$DEFINE ORDER_WITHOUT_LETTER}

{.$ASSERTIONS ON}
