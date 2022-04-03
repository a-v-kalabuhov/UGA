{*******************************************************}
{                                                       }
{       "ИС МП УГА"                                     }
{       Константы                                       }
{                                                       }
{       Copyright (c) 2003-2005, МП УГА                 }
{                                                       }
{       Автор: Калабухов А.В., Сирота Е.А.              }
{                                                       }
{*******************************************************}

{ Описание: содержит константы
  Имя модуля: KIS Consts
}

unit uKisConsts;

interface

uses
  Windows, SysUtils;

type
  TNoNameChars = set of Char;

const
  NoNameChars: TNoNameChars = ['!', '~', '"', '@', '#', '$', ';', '%', '^', ':', '&', '?',
    '*', '(', ')', '_', '=', '+', '|', '<', '>'];
  SmallNoNameChars: TNoNameChars = ['!', '~', '@', '#', '$', ';', '%', '^', ':', '?',
    '*', '_', '=', '+', '|', '<', '>'];
  IntegerEditKeys = [VK_LEFT, VK_RIGHT, VK_UP, VK_DOWN, VK_BACK, VK_INSERT,
    VK_DELETE, VK_RETURN, VK_NUMPAD0 .. VK_NUMPAD9];
  DateEditKeys = IntegerEditKeys + [190 {dot}];

  LatinNumberChars = ['I', 'V', 'X', 'M'];

  BAD_LETTER_PARENT = 1;

  // Типы отчетов
  RT_ACCOUNTS = 1; // отчеты для книги заказов
  RT_DECREE_PROJECTS = 10; // для проектов постановлений
  RT_OUTCOMING_LETTERS = 9; // для исходящих

  // Типы контрагентов
  CT_ORG = 1;
  CT_PERSON = 2;
  CT_PRIVATE = 3;

  // Организации
  ID_ORGS_DGA = 1; // Департамент
  ID_ORGS_KGA = 2; // Комитет
  ID_ORGS_UGA = 3; // МП УГА

  // Типы сотрудников
  ID_PEOPLE_TYPE_OTHER = 0;     // Посторонние
  ID_PEOPLE_TYPE_ORG_CHIEF = 1; // Директора
  ID_PEOPLE_TYPE_DIV_CHIEF = 2; // Начальники подразделений
  ID_PEOPLE_TYPE_EXECUTOR = 3;  // Исполнители

  // Типы документов
  ID_LETTER_TYPE_ALL = 0;  // Все
  ID_LETTER_TYPE_INCOMING = 1;  // Входящее
  ID_LETTER_TYPE_COMPLAINT = 2; // Жалоба
  ID_LETTER_TYPE_DEP_ORDER = 3; // Приказ департамента
  ID_LETTER_TYPE_PROTOCOL = 4;

  ID_DEFAULT_STATE = 1; // ID Воронежской области в таблице RUSSIAN_STATES
  ID_DEFAULT_INDEX = 394000;


var
  DocTypeNames: array [0..10] of String = (
      'Все документы',
      'Входящие документы',
      'Жалобы и обращения',
      'Приказы департамента',
      'Протоколы',
      'Исходящие',
      'Ответ на жалобу',
      'Ответ по заявке',
      'Запрос',
      'Уведомление',
      'Служебные записки'
  );

const
  // Отделы
  ID_OFFICE_PDSZ = 1;
  ID_OFFICE_REKLAMA = 2;
  ID_OFFICE_PRIVATE_BUILDING = 4;
  ID_OFFICE_TGP = 5;
  ID_OFFICE_GIS = 9;
  ID_OFFICE_CANCELLARY = 12;
  ID_OFFICE_PPGM = 13;
  ID_OFFICE_PDPZ = 14;
  ID_OFFICE_KGO = 19;
  ID_OFFICE_PDTOGD = 20;
  ID_OFFICE_SRP = 31;
  ID_OFFICE_MP_ADMIN = 32;
  ID_OFFICE_KGA_ADMIN = 33;
  ID_OFFICE_JUSZ = 41;
  ID_OFFICE_RIELTOR = 42;

  // Служебные
  S_REPORTINI = 'Reports.ini';
  S___ = '---';
  S_COORD_FORMAT = '%0.2f';
  S_INT99_FROMAT = '%9.9d';
  S_DATESTR_FORMAT = 'dd.mm.yyyy';
  S_FONT1 = 'Times New Roman';
  S_RET = #13#10;
  S_NULL = 'NULL';
  S_CONNECTION_SECTION = 'Connection';
  S_ADDR_ACT_NUMBER_MASK = '!(4)/адр';

//resourcestring
  // Роли
  S_ROLE_ADMINISTRATOR = 'ADMINISTRATOR';
  S_ROLE_INDZASTR = 'PRIVATE_BUILDING';
  S_ROLE_GIS = 'GIS';
  S_ROLE_PDPZ = 'PPD_PZ';
  S_ROLE_PDSZ = 'PPD';
  S_ROLE_PDT = 'PTOGD';
  S_ROLE_PDT_TOPO = 'PTOGD_TOPO';
  S_ROLE_PPD = 'PPD';
  S_ROLE_TGR = 'TOPOGEO';
  S_ROLE_KGO = 'KGO';
  S_ROLE_BUH_OPERATOR = 'BUH_OPERATOR';
  S_ROLE_GEOSERVICE_CONTR = 'GEOSERVICE_CONTR';
  S_ROLE_GEOSERVICE = 'GEOSERVICE';
  S_ROLE_CHANCELLERY = 'CHANCELLERY';
  S_ROLE_MP_CHANCELLERY = 'MP_CHANCELLERY';
  S_ROLE_EXECUTION_CONTROL = 'EXECUTION_CONTROL';
  S_ROLE_DECREE_CONTROL = 'DECREE_CONTROL';
  // ID ролей. Введены для ускорения проверки даступности действий.
  ID_ROLE_ADMINISTRATOR = 1;
  ID_ROLE_INDZASTR = 2;
  ID_ROLE_GIS = 3;
  ID_ROLE_PDPZ = 4;
  ID_ROLE_PDSZ = 5;
  ID_ROLE_PDT = 6;
  ID_ROLE_PDT_TOPO = 7;
  ID_ROLE_PPD = 8;
  ID_ROLE_TGR = 9;
  ID_ROLE_KGO = 10;
  ID_ROLE_BUH_OPERATOR = 11;
  ID_ROLE_GEOSERVICE_CONTR = 12;
  ID_ROLE_GEOSERVICE = 13;
  ID_ROLE_CHANCELLERY = 14;
  ID_ROLE_MP_CHANCELLERY = 15;
  ID_ROLE_EXECUTION_CONTROL = 16;
  ID_ROLE_DECREE_CONTROL = 17;

  // Пользователи
  S_ADMIN1 = 'SAFONOV';
  S_ADMIN2 = 'KALABUHOV';

  // Таблицы
  ST_ACCOUNTS = 'ACCOUNTS';
  ST_ARCHIVAL_DOCS = 'ARCHIVAL_DOCS';
  ST_ARCHIVAL_DOC_TYPES = 'ARCHIVAL_DOC_TYPES';
  ST_BANKS = 'BANKS';
  ST_CONTRAGENTS_VIEW = 'CONTRAGENTS_VIEW';
  ST_DECREES = 'DECREES';
  ST_DECREE_TYPES = 'DECREE_TYPES';
  ST_DECREE_PROJECTS = 'DECREE_PRJS';
  ST_DECREE_PRJ_ADDRESSES = 'DECREE_PRJ_ADDRESSES';
  ST_DECREE_PRJ_VISAS = 'DECREE_PRJ_VISAS';
  ST_DOC_TYPES = 'DOC_TYPES';
  ST_FIRMS = 'FIRMS';
  ST_GEOPUNKTS = 'GEOPUNKTS';
  ST_GIVEN_MAP_LIST = 'GIVEN_MAP_LIST';
  ST_GPUNKT_TYPE1 = 'GPUNKT_TYPES_1';
  ST_GPUNKT_TYPE2 = 'GPUNKT_TYPES_2';
  ST_KIOSKS = 'KIOSKS';
  ST_LETTERS = 'LETTERS';
  ST_LETTER_ADDRESSES = 'LETTER_ADDRESSES';
  ST_LETTER_OBJECT_TYPES = 'LETTER_OBJECT_TYPES';
  ST_LETTER_PASSINGS = 'LETTER_PASSINGS';
  ST_LETTER_STATUS_NAMES = 'LETTER_STATUS_NAMES';
  ST_LICENSED_ORGS = 'LICENSED_ORGS';
  ST_MAP_500 = 'MAP_500';
  ST_MAP_500_VIEW = 'MAP_500_VIEW';
  ST_MAP_SCANS = 'MAP_SCANS';
  ST_MAP_SCANS_GIVEOUTS = 'MAP_SCANS_GIVEOUTS';
  ST_MAP_SCAN_VIEW_GIVEOUTS = 'MAP_SCAN_VIEW_GIVEOUTS';
  ST_MAP_TRACINGS = 'MAP_TRACINGS';
  ST_OFFICE_DOC_EXECUTORS = 'OFFICE_DOC_EXECUTORS';
  ST_OFFICE_DOC_TYPES = 'OFFICE_DOC_TYPES';
  ST_OFFICE_DOCS = 'OFFICE_DOCS';
  ST_OFFICES = 'OFFICES';
  ST_ORDERS = 'ORDERS';
  ST_ORGS = 'ORGS';
  ST_PEOPLE = 'PEOPLE';
  ST_SCAN_ORDERS = 'SCAN_ORDERS';
  ST_SCAN_ORDER_MAPS = 'SCAN_ORDER_MAPS';
  ST_SCAN_ORDERS_ALL_VIEW = 'SCAN_ORDERS_ALL_VIEW';
  ST_SCAN_ORDERS_ALL_VIEW_2 = 'SCAN_ORDERS_ALL_VIEW_2';
  ST_STREETS = 'STREETS';
  ST_VILLAGES = 'VILLAGES';
  ST_OUTCOMING_LETTERS = 'OUTCOMING_LETTERS';
  ST_SUBDIV_TYPES = 'ORG_SUBDIV_TYPES';
  ST_PERSON_DOC_TYPES = 'PERSON_DOC_TYPES';
  ST_CHIEF_DOC_TYPES = 'CHIEF_DOC_TYPES';
  ST_CONTRAGENTS = 'CONTRAGENTS';

const
  // Поля
  SF_ID = 'ID';
  SF_NAME = 'NAME';
  SF_ACCOMPLISHMENT_AREA = 'ACCOMPLISHMENT_AREA';
  SF_ACCOUNT = 'ACCOUNT';
  SF_ACCOUNTANT = 'ACCOUNTANT';
  SF_ACCOUNTS_ID = 'ACCOUNTS_' + SF_ID;
  SF_ACCOUNT_DATE = SF_ACCOUNT + '_DATE';
  SF_ACCOUNT_TYPE = SF_ACCOUNT + '_TYPE';
  SF_ACCOUNT_TYPE_NAME = 'ACCOUNT_TYPE_NAME';
  SF_ACLASS = 'ACLASS';
  SF_ACT_DATE = 'ACT_DATE';
  SF_ACT_NUMBER = 'ACT_NUMBER';
  SF_ACTUAL = 'ACTUAL';
  SF_ADDRESS = 'ADDRESS';
  SF_ADDRESS1 = 'ADDRESS1';
  SF_ADDRESS_1 = 'ADDRESS_1';
  SF_ADDRESS_1_ID = 'ADDRESS_1_' + SF_ID;
  SF_ADDRESS2 = 'ADDRESS2';
  SF_ADDRESS_2 = 'ADDRESS_2';
  SF_ADDRESS_2_ID = 'ADDRESS_2_' + SF_ID;
  SF_ADM_DATE = 'ADM_DATE';
  SF_ADM_NUMBER = 'ADM_NUMBER';
  SF_ALLOTMENTS_ID = 'ALLOTMENTS_' + SF_ID;
  SF_ANNULLED = 'ANNULLED';
  SF_ANNUL_DATE = 'ANNUL_DATE';
  SF_ANNUL_SOURCE = 'ANNUL_SOURCE';
  SF_ARCH_DOC_TYPE_ID = 'ARCH_DOC_TYPES_' + SF_ID;
  SF_ARCHIVAL_DOC_ID = 'ARCHIVAL_DOC_ID';
  SF_AREA = 'AREA';
  SF_ARCH_NUMBER = 'ARCH_NUMBER';
  SF_ARGUMENT = 'ARGUMENT';
  SF_AYEAR = 'AYEAR';
  SF_BACK_DATE = 'BACK_DATE';
  SF_BANK = 'BANK';
  SF_BANK_ACCOUNT = 'BANK_ACCOUNT';
  SF_BASIS = 'BASIS';
  SF_BASIS_TYPE = 'BASIS_TYPE';
  SF_BANK_GROUP = 'BANK_GROUP';
  SF_BANK_ID = 'BANK_' + SF_ID;
  SF_BANKS_ID = 'BANKS_' + SF_ID;
  SF_BANK_NAME = 'BANK_' + SF_NAME;
  SF_BEGIN_DATE = 'BEGIN_DATE';
  SF_BIK = 'BIK';
  SF_BILL_DATE = 'BILL_DATE';
  SF_BILL_NUMBER = 'BILL_NUMBER';
  SF_BUILDING = 'BUILDING';
  SF_BUILDING_MARK = SF_BUILDING + '_MARK';
  SF_BUILDING_MARKING_NAME = SF_BUILDING + '_MARKING_' + SF_NAME;
  SF_BUILDING_OBJECTS_ID = SF_BUILDING + '_OBJECTS_' + SF_ID;
  SF_BUILDINGS_ID = SF_BUILDING + 'S_' + SF_ID;
  SF_BUILDINGS_NAME = SF_BUILDING + 'S_' + SF_NAME;
  SF_BUSINNES = 'BUSINESS';
  SF_CAN_CREATE_ORDERS = 'CAN_CREATE_ORDERS';
  SF_CAN_SEE_ALL_OFFICES = 'CAN_SEE_ALL_OFFICES';
  SF_CAN_SHEDULE_WORKS = 'CAN_SHEDULE_WORKS';
  SF_CANCELLED = 'CANCELLED';
  SF_CANCELLED_INFO = 'CANCELLED_INFO';
  SF_CATEGORY = 'CATEGORY';
  SF_CERT_DATE = 'CERT_DATE';
  SF_CENTER_TYPE = 'CENTER_TYPE';
  SF_COMMENT = 'COMMENT';
  SF_CHECKED = 'CHECKED';
  SF_CHIEF = 'CHIEF';
  SF_CHIEF_DOC_DATE = 'CHIEF_DOC_DATE';
  SF_CHIEF_DOC_NUMBER = 'CHIEF_DOC_NUMBER';
  SF_CHIEF_DOC_TYPE = 'CHIEF_DOC_TYPE';
  SF_CHIEF_DOCS = 'CHIEF_DOCS';
  SF_CHIEF_POST = 'CHIEF_POST';
  SF_CHILD = 'CHILD';
  SF_CLOSED = 'CLOSED';
  SF_COLOR = 'COLOR';
  SF_COMMENTS = 'COMMENTS';
  SF_CONNECTED_TO = 'CONNECTED_TO';
  SF_CONTACTER = 'CONTACTER';
  SF_CONTACTER_PHONES = 'CONTACTER_PHONES';
  SF_CONTACTER_POST = 'CONTACTER_POST';
  SF_CONTENT = 'CONTENT';
  SF_CONTOURS_ID = 'CONTOURS_' + SF_ID;
  SF_CONTRACT_NUMBER = 'CONTRACT_NUMBER';
  SF_CONTRAGENTS_ID = 'CONTRAGENTS_' + SF_ID;
  SF_CREATOR = 'CREATOR';
  SF_CURRENT_CHANGES_MAPPING = 'CURRENT_CHANGES_MAPPING';
  SF_CUSTOMER_BASE = 'CUSTOMER_BASE';
  SF_CONTROL_DATE = 'CONTROL_DATE';
  SF_CONTROL_DATE_2 = 'CONTROL_DATE_2';
  SF_CORPUS = 'CORPUS';
  SF_COUNTRY_ID = 'COUNTRY_' + SF_ID;
  SF_CREATE_DATE = 'CREATE_DATE';
  SF_CREATE_DOC_ID = 'CREATE_DOC_' + SF_ID;
  SF_CREATE_NUMBER = 'CREATE_NUMBER';
  SF_CREATE_TYPE = 'CREATE_TYPE';
  SF_CURRENT_ORG_ID = 'CURRENT_ORG_' + SF_ID;
  SF_CUSTOMER = 'CUSTOMER';
  SF_CUSTOMER_NAME = 'CUSTOMER_' + SF_NAME;
  SF_DATE_REG = 'DATE_REG';
  SF_DATE_OF_ACCEPT = 'DATE_OF_ACCEPT';
  SF_DATE_OF_BACK = 'DATE_OF_BACK';
  SF_DATE_OF_GIVE = 'DATE_OF_GIVE';
  SF_DATE_OF_SCAN = 'DATE_OF_SCAN';
  SF_DATE_OF_WORKS = 'DATE_OF_WORKS';
  SF_DECREE_PREPARED = 'DECREE_PREPARED';
  SF_DECREES_ID = 'DECREES_' + SF_ID;
  SF_DECREE_PRJS_ID = 'DECREE_PRJS_ID';
  SF_DECREE_TYPES_ID = 'DECREE_TYPES_' + SF_ID;
  SF_DECREE_TYPES_NAME = 'DECREE_TYPES_' + SF_NAME;
  SF_DEFINITION_NUMBER = 'DEFINITION_NUMBER';
  SF_DELIVERED = 'DELIVERED';
  SF_DELIVERED_DATE = 'DELIVERED_DATE';
  SF_DESCRIPTION ='DESCRIPTION';
  SF_DIRECTOR = 'DIRECTOR';
  SF_DIRECTOR_L = 'DIRECTOR_L';
  SF_DO_NEED_CHECK = 'DO_NEED_CHECK';
  SF_DOC_DATE = 'DOC_DATE';
  SF_DOC_KIND = 'DOC_KIND';
  SF_DOC_NUMBER = 'DOC_NUMBER';
  SF_DOC_ORDER = 'DOC_ORDER';
  SF_DOC_PRODUCER_NAME = 'DOC_PRODUCER_NAME';
  SF_DOC_TYPE = 'DOC_TYPE';
  SF_DOC_TYPES_ID = 'DOC_TYPES_' + SF_ID;
  SF_DOC_TYPES_NAME = 'DOC_TYPES_' + SF_NAME;
//  SF_DOC_YEAR = 'DOC_YEAR';
  SF_DOCUMENTS = 'DOCUMENTS';
  SF_DRAFT_WORKS_EXECUTOR = 'DRAFT_WORKS_EXECUTOR';
  SF_ENABLED = 'ENABLED';
  SF_END_DATE = 'END_DATE';
  SF_ENGIN_NET_MAPPING = 'ENGIN_NET_MAPPING';
  SF_ERROR_COORD = 'ERROR_COORD';
  SF_EXECUTED = 'EXECUTED';
  SF_EXECUTED_2 = 'EXECUTED_2';
  SF_EXECUTE_INFO = 'EXECUTE_INFO';
  SF_EXECUTOR = 'EXECUTOR';
  SF_EXPIRED = 'EXPIRED';
  SF_EXECUTOR_DATE = 'EXECUTOR_DATE';
  SF_EXECUTOR_ID = 'EXECUTOR_ID';
  SF_EXTENT_BOTTOM = 'EXTENT_BOTTOM';
  SF_EXTENT_LEFT = 'EXTENT_LEFT';
  SF_EXTENT_RIGHT = 'EXTENT_RIGHT';
  SF_EXTENT_TOP = 'EXTENT_TOP';
  SF_FIELD_DESCRIPTION = 'FIELD_DESCRIPTION';
  SF_FIELD_NAME = 'FIELD_' + SF_NAME;
  SF_FIELD_TYPE = 'FIELD_TYPE';
  SF_FIGURE_COLOR = 'FIGURE_COLOR';
  SF_FIGURE_ID = 'FIGURE_ID';
//  SF_FIGURE_NUMBER = 'FIGURE_NUMBER';
  SF_FIGURE_TYPE = 'FIGURE_TYPE';
  SF_FILE_OPERATION_ID = 'FILE_OPERATION_ID';
  SF_FILEPATH = 'FILEPATH';
  SF_FIRMS_ID = 'FIRMS_' + SF_ID;
  SF_FIRM_NAME = 'FIRM_' + SF_NAME;
  SF_FIRM = 'FIRM';
  SF_FIRST_NAME = 'FIRST_' + SF_NAME;
  SF_FULL_NAME = 'FULL_' + SF_NAME;
  SF_GET_DATE = 'GET_DATE';
  SF_GIVE_DATE = 'GIVE_DATE';
  SF_GIVE_STATUS = 'GIVE_STATUS';
  SF_GIVEDOUT = 'GIVEDOUT';
  SF_GIVEN_OBJECT = 'GIVEN_OBJECT';
  SF_HEADER = 'HEADER';
  SF_HEAD_ID = 'HEAD_ID';
  SF_HEAD_ORG_ID = 'HEAD_ORG_' + SF_ID;
  SF_HEIGHT = 'HEIGHT';
  SF_HIGH_RISE_MAPPING = 'HIGH_RISE_MAPPING';
  SF_HISTORY_ELEMENT_ID = 'HISTORY_ELEMENT_ID';
  SF_HISTORY_FILE = 'HISTORY_FILE';
  SF_HOLDER = 'HOLDER';
  SF_HOLDER_NAME = 'HOLDER_NAME';
  SF_HORIZONTAL_MAPPING = 'HORIZONTAL_MAPPING';
  SF_IMAGE = 'IMAGE';
  SF_IMAGE_KIND = 'IMAGE_KIND';
  SF_INCOMLETTER_ID = 'INCOMLETTER_ID';
  SF_IN_DATE = 'IN_DATE';
  SF_INFORMATION = 'INFORMATION';
  SF_INFO_FLORA = 'INFO_FLORA';
  SF_INFO_LANDSCAPE = 'INFO_LANDSCAPE';
  SF_INFO_MINERALS = 'INFO_MINERALS';
  SF_INFO_MONUMENT = 'INFO_MONUMENT';
  SF_INFO_REALTY = 'INFO_REALTY';
  SF_INITIAL_NAME = 'INITIAL_' + SF_NAME;
  SF_INN = 'INN';
  SF_INSERT_NAME = 'INSERT_' + SF_NAME;
  SF_INT_DATE = 'INT_DATE';
  SF_INT_NOMENCLATURE = 'INT_NOMENCLATURE';
  SF_INT_NUMBER = 'INT_NUMBER';
  SF_IS_DEFAULT = 'IS_DEFAULT';
  SF_IS_OLD = 'IS_OLD';
  SF_IS_OVERDUE = 'IS_OVERDUE';
  SF_IS_SECRET = 'IS_SECRET';
  SF_K_ACCOUNT = 'K_ACCOUNT';
  SF_KILL_DATE = 'KILL_DATE';
  SF_KILL_DOC_ID = 'KILL_DOC_' + SF_ID;
  SF_KILL_NUMBER = 'KILL_NUMBER';
  SF_KILL_TYPE = 'KILL_TYPE';
  SF_KIND = 'KIND';
  SF_KIOSKS_ID = 'KIOSKS_ID';
  SF_KPP = 'KPP';
  SF_LAST_NAME = 'LAST_' + SF_NAME;
  SF_LAST_VISA_ID = 'LAST_VISA_ID';
  SF_LAYER_POSITION = 'LAYER_POSITION';
  SF_LAYER_TYPE = 'LAYER_TYPE';
  SF_LETTERS_ID = 'LETTERS_' + SF_ID;
  SF_LETTER_DATE = 'LETTER_DATE';
  SF_LETTER_CONTROL_DATE = 'LETTER_CONTROL_DATE';
  SF_LETTER_NUMBER = 'LETTER_NUMBER';
  SF_LETTER_STATUS = 'LETTER_STATUS';
  SF_LICENSED_ORG = 'LICENSED_ORG';
  SF_LICENSED_ORG_ID = 'LICENSED_ORG_ID';
  SF_LICENSED_ORGS_ID = 'LICENSED_ORGS_' + SF_ID;
  SF_LIMIT = 'LIMIT';
  SF_MAP_500_ID = 'MAP_500_ID';
  SF_MAP_ORIGIN_ORG = 'MAP_ORIGIN_ORG';
  SF_MAP_SCANS_ID = 'MAP_SCANS_ID';
  SF_MAP_TRACINGS_ID = 'MAP_TRACINGS_ID';
  SF_MAPPER_FIO = 'MAPPER_FIO';
  SF_MARK_EXECUTOR = 'MARK_EXECUTOR';
  SF_MARKING_ID = 'MARKING_' + SF_ID;
  SF_MAX_ID = 'MAX_' + SF_ID;
  SF_MD5_NEW = 'MD5_NEW';
  SF_MD5_OLD = 'MD5_OLD';
  SF_MENS_MAPPING = 'MENS_MAPPING';
  SF_MIDDLE_NAME = 'MIDDLE_' + SF_NAME;
  SF_MP_DATE = 'MP_DATE';
  SF_MP_NUMBER = 'MP_NUMBER';
  SF_MP_YEAR_NUMBER = 'MP_YEAR_NUMBER';
  SF_NAME_SHORT = 'NAME_SHORT';
  SF_NDS = 'NDS';
  SF_NEIGHBOURS = 'NEIGHBOURS';
  SF_CADASTRE = 'CADASTRE';
  SF_NEWLY_BUILDING_MAPPING = 'NEWLY_BUILDING_MAPPING';
  SF_NOMENCLATURA = 'NOMENCLATURA';
  SF_NOMENCLATURE = 'NOMENCLATURE';
  SF_NOTIFICATION = 'NOTIFICATION';
  SF_NSP = 'NSP';
  SF_NUMBER = 'NUMBER';
  SF_SEQ_NUMBER = 'SEQ_NUMBER';
  SF_OBJECT_ADDRESS = 'OBJECT_ADDRESS';
  SF_OBJECT_NAME = 'OBJECT_NAME';
  SF_OBJECT_TYPE = 'OBJECT_TYPE';
  SF_OBJECT_TYPE_ID = 'OBJECT_TYPE_' + SF_ID;
  SF_OBJECTS_AMOUNT = 'OBJECTS_AMOUNT';
  SF_OFFICE_DOC_TYPES_ID = 'OFFICE_DOC_TYPES_' + SF_ID;
  SF_OFFICE_DOCS_ID = 'OFFICE_DOCS_' + SF_ID;
  SF_OFFICE_NAME = 'OFFICE_NAME';
  SF_OFFICES = 'OFFICES';
  SF_OFFICES_ID = 'OFFICES_' + SF_ID;
  SF_OFFICES_NAME = 'OFFICES_' + SF_NAME;
  SF_OKONH = 'OKONH';
  SF_OKPF = 'OKPF';
  SF_OKPO = 'OKPO';
  SF_OLD_ID = 'OLD_' + SF_ID;
  SF_ORDER_ACCOUNT = 'ORDER_ACCOUNT';
  SF_ORDER_DOC_LINK = 'ORDER_GIVEN_DOC_LINK';
  SF_ORDER_DATE = 'ORDER_DATE';
  SF_ORDER_NUMBER = 'ORDER_NUMBER';
  SF_ORDERS_ID = 'ORDERS_' + SF_ID;
  SF_ORG_NUMBER = 'ORG_NUMBER';
  SF_ORG_DATE = 'ORG_DATE';
  SF_ORGS_ID = 'ORGS_' + SF_ID;
  SF_ORG_NAME = 'ORG_' + SF_NAME;
  SF_ORIGIN_YEAR = 'ORIGIN_YEAR';
  SF_OUTCOMING_LETTER_ID = 'OUTCOMING_LETTER_ID';
  SF_OUTCOMLETTER_ID = 'OUTCOMLETTER_ID';
  SF_OUT_DATE = 'OUT_DATE';
  SF_OWNER = 'OWNER';
  SF_OWNER_ADDRESS = SF_OWNER + '_ADDRESS';
  SF_OWNER_FIRM = SF_OWNER + '_FIRM';
  SF_OWNER_INFO = SF_OWNER + '_INFO';
  SF_OWNER_NAME = SF_OWNER + '_NAME';
  SF_OWNER_OFFICE_ID = 'OWNER_OFFICE_' + SF_ID;
  SF_OWNER_ORG_ID = 'OWNER_ORG_' + SF_ID;
  SF_PAID = 'PAID';
  SF_PARENT = 'PARENT';
  SF_PARENT_ID = 'PARENT_' + SF_ID;
  SF_PARENT_OFFICE_ID = 'PARENT_OFFICE_' + SF_ID;
  SF_PART_CHIEF = 'PART_CHIEF';
  SF_PAYER_ID =  'PAYER_' + SF_ID;
  SF_PAY_DATE = 'PAY_DATE';
  SF_PAYER_ACCOUNT = 'PAYER_ACCOUNT';
  SF_PAYER_ACCOUNT_TYPE = 'PAYER_ACCOUNT_TYPE';
  SF_PAYER_BANK_ID = 'PAYER_BANK_ID';
  SF_PAYER_CUSTOMER = 'PAYER_CUSTOMER';
  SF_PEOPLE_BACK_NAME = 'PEOPLE_BACK_' + SF_NAME;
  SF_PEOPLE_BACK_ID = 'PEOPLE_BACK_' + SF_ID;
  SF_PEOPLE_FULL_NAME = 'PEOPLE_FULL_' + SF_NAME;
  SF_PEOPLE_ID = 'PEOPLE_' + SF_ID;
  SF_PEOPLE_NAME = 'PEOPLE_NAME';
  SF_PEOPLE_TYPES_ID = 'PEOPLE_TYPES_' + SF_ID;
  SF_PERCENT = 'PERCENT';
  SF_PERIOD = 'PERIOD';
  SF_PERSON_NAME = 'PERSON_NAME';
  SF_PERSON_WHO_GIVE = 'PERSON_WHO_GIVE';
  SF_PERSON_WHO_GIVE_ID = 'PERSON_WHO_GIVE_ID';
  SF_PERSON_WHO_TAKED_BACK = 'PERSON_WHO_TAKED_BACK';
  SF_PERSON_WHO_TAKED_BACK_ID = 'PERSON_WHO_TAKED_BACK_' + SF_ID;
  SF_PHASE_NAME = 'PHASE_NAME';
  SF_PHONES = 'PHONES';
  SF_PHOTO = 'PHOTO';
  SF_PLACE_INFO = 'PLACE_INFO';
  SF_POINTS_NUMBER = 'POINTS_NUMBER';
  SF_POINT_CORNER = 'POINT_CORNER';
  SF_POINT_LENGTH = 'POINT_LENGTH';
  SF_POSITIVE = 'POSITIVE';
  SF_POST = 'POST';
  SF_POST_INDEX = 'POST_INDEX';
//  SF_PPD_DOCS_ID = 'PPD_DOCS_' + SF_ID;
  SF_PREV_ID = 'PREV_ID';
  SF_PRICE = 'PRICE';
  SF_PRINT_WORKS_VALUE = 'PRINT_WORKS_VALUE';
  SF_PRINTED = 'PRINTED';
  SF_PRINTABLE_NAME = 'PRINTABLE_' + SF_NAME;
  SF_PRJ_STATE_ID = 'PRJ_STATE_ID';
  SF_PRJ_STATE = 'PRJ_STATE';
  SF_PROPERTIES = 'PROPERTIES';
  SF_PROP_FORMS_NAME = 'PROP_FORMS_' + SF_NAME;
  SF_PUNKT_DATE = 'PUNKT_DATE';
  SF_PURPOSE = 'PURPOSE';
  SF_PZ = 'PZ';
  SF_QUANTITY = 'QUANTITY';
  SF_R_ACCOUNT = 'R_ACCOUNT';
  SF_RECEIVE_DATE = 'RECEIVE_DATE';
  SF_RECIPIENT = 'RECIPIENT';
  SF_REGION_NAME = 'REGION_' + SF_NAME;
  SF_REGIONS_ID = 'REGIONS_' + SF_ID;
  SF_REGIONS_NAME = 'REGIONS_' + SF_NAME;
  SF_REGIONS_NAME_PREP = 'REGIONS_NAME_PREP';
  SF_RENT_PERIOD = 'RENT_PERIOD';
  SF_REPORT_TYPE = 'REPORT_TYPE';
  SF_RETURNED = 'RETURNED';
  SF_ROLE_NAME = 'ROLE_' + SF_NAME;
  SF_ROOM = 'ROOM';
  SF_SCAN_ORDER_MAPS_ID = 'SCAN_ORDER_MAPS_ID';
  SF_SCAN_ORDERS_ID = 'SCAN_ORDERS_ID';
  SF_SCAN_STATUS = 'SCAN_STATUS';
  SF_SERIES = 'SERIES';
  SF_SERTIFICATE = 'SERTIFICATE';
  SF_SHELVE_DATE = 'SHELVE_DATE';
  SF_SHORT_NAME = 'SHORT_' + SF_NAME;
  SF_SIGNATURE = 'SIGNATURE';
  SF_SQUARES = 'SQUARES';
  SF_START_DATE = 'START_DATE';
  SF_STATE_ID = 'STATE_' + SF_ID;
  SF_STATE_NAME = 'STATE_' + SF_NAME;
  SF_STATUS = 'STATUS';
  SF_STREET_ID = 'STREET_' + SF_ID;
  SF_STREET_NAME = 'STREET_' + SF_NAME;
  SF_STREET_MARK = 'STREET_MARK';
  SF_STREET_MARKING_ID = 'STREET_MARKING_' + SF_ID;
  SF_STREET_MARKING_NAME = 'STREET_MARKING_' + SF_NAME;
  SF_STREETS_ID = 'STREETS_' + SF_ID;
  SF_SUBDIVISION_ID = 'SUBDIVISION_' + SF_ID;
  SF_SUM_ALL = 'SUM_ALL';
  SF_SUM_BASE = 'SUM_BASE';
  SF_SUM_NDS = 'SUM_NDS';
  SF_SUM_PERCENT = 'SUM_PERCENT';
  SF_SUMMA = 'SUMMA';
  SF_SYMBOL_INFO = 'SYMBOL_INFO';
  SF_SYMBOL_INFO2 = 'SYMBOL_INFO_2';
  SF_TABLE_NAME = 'TABLE_' + SF_NAME;
  SF_TACHEOMETRIC_MAPPING = 'TACHEOMETRIC_MAPPING';
  SF_TERM = 'TERM';
  SF_TERM_OF_GIVE = 'TERM_OF_GIVE';
  SF_TEMP_BUILDING_AREA = 'TEMP_BUILDING_AREA';
  SF_TICKET = 'TICKET';
  SF_TOWN = 'TOWN';
  SF_TOWN_KIND = SF_TOWN + '_' + SF_KIND;
  SF_TOWN_NAME = SF_TOWN + '_' + SF_NAME;
  SF_TOTAL_SUM = 'TOTAL_SUM';
  SF_T_SITUATION_ID = 'T_SITUATION_' + SF_ID;
  SF_TYPE_ACCOUNT = 'TYPE_ACCOUNT';
  SF_TYPE_ID = 'TYPE_' + SF_ID;
  SF_TYPE1_ID = 'TYPES_1_ID';
  SF_TYPE2_ID = 'TYPES_2_ID';
  SF_UNIT = 'UNIT';
  SF_USER_NAME = 'USER_' + SF_NAME;
  SF_VAL_PERIOD = 'VAL_PERIOD';
  SF_VILLAGE_ID = 'VILLAGE_' + SF_ID;
  SF_VILLAGE_KIND = 'VILLAGE_' + SF_KIND;
  SF_VILLAGE_NAME = 'VILLAGE_' + SF_NAME;
  SF_VILLAGES_ID = 'VILLAGES_' + SF_ID;
  SF_VILLAGES_MARKING_NAME = 'VILLAGES_MARKING_' + SF_NAME;
  SF_VILLAGES_NAME = 'VILLAGES_' + SF_NAME;
  SF_VISIBLE = 'VISIBLE';
  SF_VISIBLE_NAME = 'VISIBLE_NAME';
  SF_VRS = 'VRS';
  SF_WORK_NAME = 'WORK_' + SF_NAME;
  SF_WORK_TYPE = 'WORK_TYPE';
  SF_WORK_TYPE_CODE = 'WORK_TYPE_CODE';
  SF_WORK_TYPES_ID = 'WORK_TYPES_' + SF_ID;
  SF_WORK_TYPES_NAME = 'WORK_TYPES_' + SF_NAME;
  SF_WORKS_EXECUTOR = 'WORKS_EXECUTOR';
  SF_X = 'X';
  SF_Y = 'Y';
  SF_YEAR_NUMBER = 'YEAR_NUMBER';
{
}
  // Метки полей
  SFL_ADDRESS = 'Адрес';
  SFL_BANK = 'Банк';
  SFL_BIK = 'БИК';
  SFL_CONTENT = 'Содержание';
  SFL_CURRENT_VISA = 'Текущая виза';
  SFL_CUSTOMER = 'Заказчик';
  SFL_DATE = 'Дата';
  SFL_DATE_OF_BACK = 'Дата возврата';
  SFL_DATE_OF_GIVE = 'Дата выдачи';
  SFL_DEFINITION_NUMBER = '№ разрешения';
  SFL_DIRECTOR = 'Руководитель';
  SFL_EXPIRED = 'Просрочен';
  SFL_GIVE_STATUS = 'Выдан или нет';
  SFL_HEADER = 'Заголовок';
  SFL_HOLDER_NAME = 'Где находится';
  SFL_ID = 'Порядок ввода';
  SFL_INN = 'ИНН';
  SFL_INSERT_ORDER = 'Порядок ввода';
  SFL_IS_OVERDUE = SFL_EXPIRED;
  SFL_IS_SECRET = 'Спецчасть';
  SFL_NAME = 'Наименование';
  SFL_NOMENCLATURE = 'Номенклатура';
  SFL_NUMBER = 'Номер';
  SFL_OFFICE = 'Отдел';
  SFL_ORIGIN_YEAR = 'Год заведения';
  SFL_OWNER_FIRM = 'Вышестоящая организация';
  SFL_PERIOD = 'Срок';
  SFL_PERSON_NAME = 'Ф.И.О.';
  SFL_PHONES = 'Телефоны';
  SFL_PROPERTIES = 'Реквизиты';
  SFL_RECIPIENT = 'Где находится';
  SFL_SCAN_DATE = 'Дата начала использования';
  SFL_SCAN_ORDER_DATE = 'Дата заявки';
  SFL_SCAN_ORDER_NUMBER = 'Номер заявки';
  SFL_SCAN_STATUS = 'Отсканировано';
  SFL_SHORTNAME = 'Краткое наименование';
  SFL_YEAR = 'Год';
  SFL_YEAR_NUMBER = 'Год/Номер';

  // Генераторы
  SG_CONTRAGENTS = 'CONTRAGENTS';
  SG_CONTRAGENT_ACCOUNTS = 'CONTRAGENT_ACCOUNTS';

  // Запросы
  SQ_GET_REPORTS_FILES = 'SELECT PATH||FILENAME FROM ALL_REPORTS WHERE REPORT_TYPES_ID=%d';
  SQ_SELECT_REPORT_FILENAME = 'SELECT PATH||FILENAME FROM ALL_REPORTS WHERE ID=%d';

  // Названия сущностей
  SEN_ADDRESS = 'Адрес';
  SEN_ARCHIVAL_DOCS = 'Архивные документы';
  SEN_CONTR_ACCOUNT = 'Банковский счет';
  SEN_CONTR_ORG = 'Контрагент - юридическое лицо';
  SEN_CONTR_PERSON = 'Контрагент - физическое лицо';
  SEN_CONTR_PRIVATE = 'Контрагент - частный предприниматель';
  SEN_DECREE_PROJECTS = 'Проекты постановлений';
  SEN_GEOPUNKTS = 'Геодезические знаки';
  SEN_MAP_500 = 'Планшет';
  SEN_MAP_SCAN = 'Скан планшета';
  SEN_OFFICE = 'Отдел';
  SEN_OFFICE_DOC = 'Заявка отдела';
  SEN_ORDER = 'Заказ';
  SEN_ORG = 'Организация';
  SEN_OUTCOMING_LETTER = 'Исходящее письмо';
  SEN_PASSING = 'Движение';
  SEN_SCAN_ORDER = 'Заявка на сканы планшетов';
  SEN_VISA = 'Виза';
  SEN_WORKER = 'Сотрудник';

  // слои карты
  SL_CITYBORDER = 'CITYBORDER';
  SL_KIOSK = 'KIOSK';
  SL_MAP_IMAGES = 'MAP_IMAGES';
  SL_MAP_SCANS = 'MAP_SCANS';

  // команды на карте
  SF_CMD_KIOSK_COORDS = 'KIOSK_COORDS_';

  // Пользовательские сообщения
  S_CONFIRM = 'Подтвердите';
  S_ERROR = 'Ошибка!';
  S_WARN = 'Внимание!';
  S_MESS = 'Сообщение';
  S_CHECK = 'Проверьте ';
  S_DELETE = 'Удалить ';

  S_TALK_ADMIN =  #13 + 'Сообщите администратору.';

  S_ADDRESS_MISSED = 'Не указан адрес';
  S_BAD_AREA_POINTS = 'Некорректная площадь или нет точек';
  S_BAD_AREA_SUMM = 'Сумма долей владельцев не равна 100%';
  S_BAD_FASTREPORT_FILE = 'Файл должен находиться в папке /Reports и иметь расширение ".frf"';
  S_BAD_INFO_FORMAT = 'Невозможно интерпретировать информацию!';
  S_BANK_NOT_FOUND = 'Банк с таким БИК не найден!' + #13 + 'Проверте правильно ли введен БИК и попробуйте еще раз!';
  S_BUILDING_NOT_FOUND = 'Строение не найдено: ';
  S_CAN_DELETE_LAST_VISA = 'Удалять можно только последнюю визу!';
  S_CANT_CHANGE_FILE = 'Не удается изменить файл "%s"!';
  S_CANT_CREATE_NEW_ENTITY = 'Ошибка создания новой сущности!';
  S_CANT_DELETE_FILE = 'Не удается удалить файл ';
  S_CANT_DELETE_LETTER = 'Не удалось удалить письмо!' + S_TALK_ADMIN;
  S_CANT_OPEN_FILE = 'Не удается открыть файл "%s"!';
  S_CANT_SAVE_ORDER = 'Не удалось сохранить заказ!' + S_TALK_ADMIN;
  S_CANT_SAVE_LETTER = 'Не удалось сохранить письмо!' + S_TALK_ADMIN;
  S_CANT_WRITE_VALUE = 'Невозможно записать значение';
  S_CHANGE_COORDS = 'Изменятся координаты всех точек! Продолжить?';
  S_CONNECTED_FAIL = 'Соединение не установлено';
  S_CONNECTED_OK = 'Соединение установлено';
  S_COPY_ERROR = 'Не удалось скопировать данные!';
  S_DEFAULT_TRANSACTION_MISSED = 'Отсутсвует транзакция по умолчанию! [%s]';
  S_CONFIRM_DELETE_ACCOUNT = S_DELETE + 'счет?';
  S_CONFIRM_DELETE_ACT = 'Удалить нормативный акт ';
  S_CONFIRM_DELETE_ADDRESS = 'Удалить адрес?';
  S_CONFIRM_DELETE_CONTOUR = 'Удалить контур со всеми точками?';
  S_CONFIRM_DELETE_GIVEN_DOC_LIST = 'Удалить данные о выданном документе?';
  S_CONFIRM_DELETE_GIVEN_MAP_LIST = 'Удалить данные о выданном планшете?';
  S_CONFIRM_DELETE_HISTORY_LIST = 'Удалить данные?';
  S_CONFIRM_DELETE_LAST_GIVING = 'Удалить последнюю выдачу?';
  S_CONFIRM_DELETE_OFF_DOC_LETTER = 'Удалить документ из письма?' + #13#10 + '(Документ сохранится и будет достуен через "Документы отделов")';
  S_CONFIRM_DELETE_OWNER = 'Удалить владельца ?';
  S_CONFIRM_DELETE_PASSING = 'Удалить движение?';
  S_CONFIRM_DELETE_POINTS = 'Удалить выделенные точки?';
  S_CONFIRM_DELETE_INCOMLETTER = 'Удалить входящее письмо?';
  S_CONFIRM_DELETE_RECORD = 'Удалить запись?';
  S_CONFIRM_DELETE_REPORT = 'Удалить отчет?';
  S_CONFIRM_DELETE_SCANNING_LIST = 'Удалить данные о сканировании?';
  S_CONFIRM_DELETE_SELECTED_FILES = 'Удалить выделенные файлы?';
  S_CONFIRM_DELETE_SUPPLEMENT = 'Удалить документ-приложение?';
  S_CONFIRM_DELETE_EXECUTOR = 'Удалить исполнителя из списка?';
  S_CONFIRM_DELETE_VISA = 'Удалить визу?';
  S_CONFIRM_SAFE_ORDER_ALL = 'Перед печатью необходимо сохранить изменения в базе данных.'#13#10'Сохранить изменения?';
  S_DO_YOU_SURE = 'Вы уверены?';
  S_DOCS_MISSED = 'Нет ни одного документа';
  S_DONT_START_WORD = 'Не удалось запустить Word!';
  S_DONT_START_VISIO = 'Не удалось запустить Visio!';
  S_ERROR_MODE_ON = 'Не снята метка ошибки';
  S_EXECUTOR_MISSED = 'Не указаны исполнители';
  S_FEILD_NOT_FOUND = 'Поле %s не найдено!';
  S_FILENAME_MISSED = 'Имя файла не указано!';
  S_IMPORT_ACTS = 'Импортировать постановлений: ';
  S_INSERT_POINTS = 'Вставка точек из буфера обмена';
  S_INSERT_CHOICE ='Выбирайте что вставить'#13#10'контур или точку';
  S_ISNT_RANGE = 'Условие не является диапазоном!';
  S_LETTER_NUMBER_ALREADY_FILLED = 'Письму уже присвоен номер %s!'#13#10'Вы действительно хотите изменить номер письма?';
  S_LETTER_NUMBER_EXISTS = 'Письмо с номером %s уже существует!'#13#10'Заполните номер снова!';
  S_LOAD_ENTITY_ERROR = 'Ошибка загрузки объекта!';
  S_NO_DEFAULT_TRANSACTION = 'Нет транзакции по умолчанию!';
  S_NO_SELECTED_CONTOURS = 'Контур не выбран';
  S_NO_SELECTED_POINTS = 'Нет выделенных точек';
  S_NOMENCLATURA_MISSED = 'Номенклатура не указана!';
  S_NOPOINTS_TO_COPY = 'Нет точек для копирования!';
  S_ONLY_TWO_SIGNS = 'Можно указать не более двух знаков после запятой!';
  S_NUMBER_ERROR = 'Такой номер уже есть';
  S_OWNERS_MISSED = 'Нет ни одного владельца';
  S_PARTIAL_BAD_FORMAT = 'Неправильный формат! Часть точек не будет вставлена!';
  S_PLEASE_FILL_FIELD = 'Необходимо заполнить поле';
  S_PLEASE_ENTER_COORD = 'Необходимо ввести координату!';
  S_POINT_IS_EXISTS = 'Точка с именем "%s" уже есть в отводе!';
  S_POINT_NOT_FOUND = 'Точка не найдена';
  S_RECORD_NOT_FOUND = 'Не удалось найти запись';
  S_REGIONS_NAME_MISSED = 'Не указан район!';
  S_REPLACE_POINTS = 'Произвести замену имеющихся точек?';
  S_REPORT_NOT_FOUND = 'Не найден файл отчета!';
  S_RESTORE_TABLE = 'Восстановить исходный вид таблицы ?';
  S_SET_LOT_READONLY = 'Запретить редактирование отвода?';
  S_STREET_NOT_SELECTED = 'Не выбрана улица!';

  S_FILE = 'Файл ';
  S_NOT_FOUND = ' не найден!';
  S_YES = 'Да';
  S_NO = 'Нет';
  S_M2 = ' кв.м.';
  S_LOT = 'Отвод';
  S_HEAD_ORG = 'Головная организация';
  S_CONTRAGENT = 'Контрагент';
  S_CONTRAGENTS = 'Контрагенты';
  S_PERSON = 'Физическое лицо';
  S_ORG = 'Юридическое лицо (организация)';
  S_PERSON_DOC = 'Документ';
  S_CANT_EDIT = ' невозможно редактировать!';

  S_CANT_COPY_ADDRESS = 'Необнаружена адресная справка-источник!#13#10Копирование невозможно.';
  S_CANT_DELETE_PASSING_BY_CHILD = 'Невозможно удалить движение! Письмо передано в %s.';
  S_CANT_EDIT_LETTER = 'Вы не можете изменить это письмо!'; //  + 'Оно списано в %s';
  S_CANT_EDIT_OFFICE_DOC = 'Вы можете радактировать документы только своего отдела!';
  S_CANT_FIND_BY_FIELD = 'Поиск по данному полю невозможен';
  S_CANT_GIVE_BACK = 'Документ нельзя принять, т.к. он не был выдан исполнителю!';
  S_CANT_GIVE_OUT = 'Документ не может быть выдан!' + #13 + 'Он находится у исполнителя';
  S_CANT_GIVE_OUT_MAP = 'Планшет не может быть выдан!' + #13 + 'Он находится у исполнителя.';
  S_CANT_GIVE_OUT_MAP_SCAN = 'Скан планшета не может быть выдан!' + #13 + 'Он находится у исполнителя.';
  S_CANT_PASS_LETTER = 'Нельзя списать письмо, т.к. оно списано на исполнителя!';
  S_CANNOT_COMPARE_ENTITES = 'Невозможно сравнить объекты %s и %s!';
  S_CANNOT_COMPARE_ENTITY_WITH_NIL = 'Невозможно сравнить объект %s и NULL!';
  S_CANNOT_COPY_ENTITY = 'Невозможно скопировать объект %s в объект %s!';
  S_CANNOT_DELETE_ENTITY = 'Невозможно удалить!' + #13 + 'Объект %s используется.';

  S_DELETE_CONTRAGENT = 'Удалить контрагента?';
  S_DELETE_DOC = 'Удалить документ из списка?';

  S_EDITOR_NOT_ASSIGNED = 'Не найден редактор свойств банка!';
  S_EMPTY_SEARCH_DATA = 'Пустая структура данных для подготовки диялога выбора!';

  S_FIELD_NOT_FOUND = 'Поле %s не обнаружено в таблице %s';

  S_GEN_ID_ERROR = 'Ошибка генерации ID в модуле [%s]!';

  S_INCORRECT_IN_DATE = 'Проверьте дату передачи!';
  S_INCORRECT_OUT_DATE = 'Проверьте дату возврата!';
  S_INVALID_BIK = 'Неверное значение БИК!';
  S_INVALID_BANK_KACCOUNT = 'Неверное значение корр/счета!';
  S_INVALID_BANK_NAME = 'Неверное наименование банка!';
  S_LETTER_PASS_AGAIN = 'Письмо %s передано повторно!'#13#10'Занесите все необходимые данные вручную.';
  S_LETTER_INCOM_ADD_AGAIN = 'Письмо с такими реквизитами уже выбрано!';

  S_NO_ACTIVE_TABLE = 'Нет активной таблицы';
  S_NO_WORKS = 'Необходимо ввести работы по заказу!';
  S_NO_WORKS_FOR_PRINTED = 'Нет работ, отмеченных на печать!';

  S_NOTHING_TO_PRINT = 'Нечего печатать!';

  S_OFFICE_DOC_NUMBER_EXISTS = 'Документ отдела с номером %s за %s год уже существует!'#13#13'Введите другой номер.'#13#13'Максимальный свободный номер на текущий момент: %s';

  S_ONLY_OWNED_DOC_CAN_DELETE = 'Можно удалять только документы своего отдела!';
  S_ONLY_OWNED_DOC_CAN_EDIT = 'Можно изменять только документы своего отдела!';
  S_ONLY_OWNER_CAN_DELETE_LOT = S_LOT + ' может быть удален только владельцем';

  S_SAVE_ENTER_KEY = 'Сохранить - ENTER.';
  S_SELECT_CHIEF_DOCTYPE = 'Выберите тип документа!';

  S_TOO_MANY_USERS = 'Система не может обслуживать более одного пользователя!';

  S_UNSUPPORTED_ENTITY_CLASS = 'Менеджер %s не может обслужить объект %s!';
  S_UNSUPPORTED_FIELD_TYPE = 'Неподдерживаемый тип поля!';

  S_WORKTYPE_ALREADY_EXISTS = 'Такой тип работы уже есть в этом счете!';


  S_INVALID_MASK = 'Невозможно разобрать маску номера!';
  S_SELECT_EXECUTOR = 'Выберите исполнителя!';
  S_TOO_LESS_POINTS = 'Слишком мало точек!#13#10Для помешения в архив отвод должен содержать не менн 3-х точек!';
  S_NO_PERMISSION = 'У вас нет прав доступа для этой операции!';

  S_ACTNCAT_DATA = 'Данные';
  S_ACTNCAT_PRINT = 'Печать';

  S_UNDEF = 'неопределен';

  S_MANAGER_NOT_FOUND = 'Запрашиваемый менеждер [%s] не обнаружен!';

  S_CHECK_ACCOUNT = S_CHECK + 'расчетный счет!';
  S_CHECK_ACCOUNT_DATE = S_CHECK + 'дату счета!';
  S_CHECK_ACCOUNT_NUMBER = S_CHECK + 'номер счета!';
  S_CHECK_ACCOUNTANT = S_CHECK + 'Ф.И.О. главного бухгалтера!';
  S_CHECK_ACT_DATE = S_CHECK + 'дату акта!';
  S_CHECK_ADDRESS = S_CHECK + ' адрес!';
  S_CHECK_ADDRESS1 = S_CHECK + 'юридический адрес!';
  S_CHECK_ANNUL_DATE = S_CHECK + 'дату аннулирования!';
  S_CHECK_ARCH_NUMBER = S_CHECK + 'архивный номер!';
  S_CHECK_AREA = S_CHECK + 'площадь!';
  S_CHECK_BANK = 'Необходимо выбрать банк!';
  S_CHECK_BASIS_TYPE = S_CHECK + 'тип подосновы!';
  S_CHECK_BUILDING = S_CHECK + 'дом!';
  S_CHECK_CERTBUSINESS = S_CHECK + 'вид деятельности!';
  S_CHECK_CERTDATE = S_CHECK + 'дату выдачи сертификата!';
  S_CHECK_CERTNUMBER = S_CHECK + 'номер сертификата!';
  S_CHECK_CERTOWNER = S_CHECK + 'органиацию, выдавшую сертификат!';
  S_CHECK_CHIEF = S_CHECK + 'руководителя!';
  S_CHECK_CHIEF_FIO = S_CHECK + 'Ф.И.О. руководителя!';
  S_CHECK_CHIEF_POST = S_CHECK + 'должность руководителя!';
  S_CHECK_CHIEF_DOC_DATE = S_CHECK + 'дату документа!';
  S_CHECK_CHIEF_DOC_TYPE = S_CHECK + 'тип документа!';
  S_CHECK_CHIEF_DOCS = 'Введите документ у руководителя!';
  S_CHECK_CONNECTTED_POSITIONS = 'Все непечатаемые позиции заказа должны суммироваться с печатаемыми!';
  S_CHECK_CONTACTER = S_CHECK + 'Ф.И.О. контактного лица!';
  S_CHECK_CONTACTER_POST = S_CHECK + 'должность контактного лица!';
  S_CHECK_CONTENT = S_CHECK + 'содержание!';
  S_CHECK_CONTRACT_NUMBER = S_CHECK + 'номер договора!';
  S_CHECK_CONTRAGENT = S_CHECK + 'заказчика!';
  S_CHECK_CONTROL_DATE = 'Укажите контрольную дату!';
  S_CHECK_COORDS = S_CHECK + 'координаты !';
  S_CHECK_COUNTRY = 'Выберите страну!';
  S_CHECK_CUSTOMER = 'Проверьте заказчика!';
  S_CHECK_DATE = S_CHECK + 'дату!';
  S_CHECK_DATE_REG = S_CHECK + 'дату регистрации!';
  S_CHECK_DATE_OF_GIVE = S_CHECK + 'дату выдачи документа!';
  S_CHECK_DATE_OF_BACK = S_CHECK + 'дату возврата!';
  S_CHECK_DATE_OF_SCAN = S_CHECK + 'дату сканирования!';
  S_CHECK_DEFAULT_ACCOUNT = 'Необходимо указать банковский счет!';
  S_CHECK_DEFINITION_NUMBER = S_CHECK + 'номер разрешения!';
  S_CHECK_DELIVERED_DATE = S_CHECK + 'дату получения уведомления!';
  S_CHECK_DOC_YEAR = S_CHECK + 'год!';
  S_CHECK_DOCTYPE = S_CHECK + 'тип документа!';
  S_CHECK_DOCNUMBER = S_CHECK + 'номер документа!';
  S_CHECK_DOCSERIE = S_CHECK + 'серию документа!';
  S_CHECK_DOCOWNER = S_CHECK + 'органиацию, выдавшую документ!';
  S_CHECK_DOCDATE = S_CHECK + 'дату выдачи документа!';
  S_CHECK_END_DATE = S_CHECK + 'дату завершения!';
  S_CHECK_EXECUTOR = S_CHECK + 'исполнителя!';
  S_CHECK_EXTERIOR_ORGS = S_CHECK + 'стороннюю организацию!';
  S_CHECK_PHASE_NAME = S_CHECK + 'название этапа!';
  S_CHECK_FIRM = S_CHECK + 'получателя письма!';
  S_CHECK_HEADER = S_CHECK + 'заголовок постановления!';
  S_CHECK_IN_DATE = 'дата передачи проекта должна быть больше даты передачи из предыдущей визы!';
  S_CHECK_IN_DATE_AND_OUT_DATE = 'дата передачи должна быть меньше даты возврата!';
  S_CHECK_INDEX = S_CHECK + 'почтовый индекс!';
  S_CHECK_INN = S_CHECK + 'ИНН!';
  S_CHECK_KPP = S_CHECK + 'КПП!';
  S_CHECK_LAST_DATE = S_CHECK + 'дату передачи исполнителю!';
  S_CHECK_LAST_AND_PRED_DATE = 'Последняя дата должна быть больше предыдущей!';
  S_CHECK_LETTER_ADM_DATE = S_CHECK + 'дату администрации!';
  S_CHECK_LETTER_AUTHOR = S_CHECK + 'заказчика!';
  S_CHECK_LETTER_CONTROL_DATE = S_CHECK + 'контрольную дату!';
  S_CHECK_LETTER_DATE = S_CHECK + 'входящую дату КГА!';
  S_CHECK_LETTER_DATE2 = S_CHECK + 'дату письма!';
  S_CHECK_LETTER_DOC_TYPE = S_CHECK + 'тип входящего документа!';
  S_CHECK_LETTER_NUMBER = S_CHECK + 'входящий номер КГА!';
  S_CHECK_LETTER_OFFICE_NAME = S_CHECK + 'отдел!';
  S_CHECK_LETTER_ORG_DATE = S_CHECK + 'дату документа заказчика!';
  S_CHECK_LETTER_ORG_NUMBER = S_CHECK + 'номер документа заказчика!';
  S_CHECK_LICENSE_END_DATE = S_CHECK + 'дату окончания действия лицензии!';
  S_CHECK_LICENSED_ORG = S_CHECK + 'организацию, выполнявшую работы!';
  S_CHECK_LICENSE_START_DATE = S_CHECK + 'дату начала действия лицензии!';
  S_CHECK_MAP_NUMBER = S_CHECK + 'номер планшета!';
  S_CHECK_MP_LETTER_DATE = S_CHECK + 'входящую дату МП!';
  S_CHECK_MP_LETTER_NUMBER = S_CHECK + 'входящий номер МП!';
  S_CHECK_NAME = S_CHECK + 'наименование!';
  S_CHECK_NOMENCLATURE = S_CHECK + 'номенклатуру!';
  S_CHECK_NOMENCLATURE_IS_UNIQUE = 'Такая номенклатура уже есть в базе данных!';
  S_CHECK_OBJECT_ADDRESS = S_CHECK + 'адрес объекта!';
  S_CHECK_OBJECT_NAME = S_CHECK + 'наименование объекта!';
  S_CHECK_OBJECT_TYPE = S_CHECK + 'тип объекта!';
  S_CHECK_OFFICE = 'Выберите отдел!';
  S_CHECK_OKONH = S_CHECK + 'ОКОНХ!';
  S_CHECK_OKPF = S_CHECK + 'ОКПФ!';
  S_CHECK_OKPO = S_CHECK + 'ОКПО!';
  S_CHECK_ORDER_DATE = S_CHECK + 'дату заказа!';
  S_CHECK_ORDER_DATE2 = S_CHECK + 'дату ордера!';
  S_CHECK_ORDER_NUMBER = S_CHECK + 'номер заказа!';
  S_CHECK_ORDER_NUMBER2 = S_CHECK + 'номер ордера!';
  S_CHECK_ORIGIN_ORG = S_CHECK + 'организацию, заводившую планшет!';
  S_CHECK_ORIGIN_YEAR = S_CHECK + 'год заведения!';
  S_CHECK_OWNER_FIRM_NAME = S_CHECK + 'название вышестоящей организации!';
  S_CHECK_OUT_DATE = 'последняя виза не закрыта!';
  S_CHECK_PAY_DATE = S_CHECK + 'дату оплаты!';
  S_CHECK_PEOPLE_NAME = S_CHECK + 'человека-отправителя!';
  S_CHECK_PERIOD = S_CHECK + 'срок действия!';
  S_CHECK_PERSON_WHO_GIVE = S_CHECK + 'кто выдал!';
  S_CHECK_PERSON_WHO_TAKED_BACK = S_CHECK + 'кто принял!';
  S_CHECK_PRJ_STATE = S_CHECK + 'текущее состояние проекта!';
  S_CHECK_SHELVE_DATE = S_CHECK + 'дату сдачи в архив!';
  S_CHECK_SHORTNAME = S_CHECK + 'краткое наименование!';
  S_CHECK_SIGNATURE = S_CHECK + 'Подпись!';
  S_CHECK_STREET = S_CHECK + 'наименование улицы!';
  S_CHECK_TERM = S_CHECK + 'срок!';
  S_CHECK_TERM_OF_GIVE = S_CHECK + 'срок, на который выдан планшет!';
  S_CHECK_TICKET = S_CHECK + 'платежный документ!';
  S_CHECK_TOWN = S_CHECK + 'населенный пункт!';
  S_CHECK_VAL_PERIOD = S_CHECK + 'срок договора!';
  S_CHECK_WORKER = 'Выберите исполнителя!';
  S_CHECK_WORK_TYPE = S_CHECK + 'тип работы!';
  S_PROJECT_IS_READY = 'Проект постановления подготовлен!';

  S_CANT_CONVERT = 'Нельзя представить данные типа %s как %s!';
  S_BAD_LETTER_EDITOR = 'Недопустимый редактор письма!';

  // Numbers
  N_ZERO = 0;
  N_ONE = 1;
  N_TWO = 2;
  N_THREE = 3;
  N_TEN = 10;

  //Страна, город, выбранные по умолчанию
  S_DEFAULT_COUNTRY = 'Российская Федерация';
  ID_RUSSIA_ID = 1;
  S_DEFAULT_CITY = 'Воронеж';
  S_DEFAULT_STATE = 'Воронежская область';
  S_DEFAULT_VILLAGE = 'нет';

  // Фильтры для вьюшек
  FF_OFFICE_PASSING = 'FF_OFFICE_PASSING';

var
  MIN_DOC_DATE: TDateTime;
  LAST_OLD_LETTER_DATE: TDateTime;
  MIN_CHIEF_DOC_DATE: TDateTime;
  FloatEditKeys: set of Byte;

implementation

initialization
  MIN_DOC_DATE := EncodeDate(1900, N_ONE, N_ONE);
  MIN_CHIEF_DOC_DATE := EncodeDate(2000, N_ONE, N_ONE);
  LAST_OLD_LETTER_DATE := EncodeDate(2005, 6, 28); 
  FloatEditKeys := IntegerEditKeys + [Ord(Char(DecimalSeparator))];

end.
