unit uCORBAUtils;

interface

uses
  CORBA;

  procedure HandleCorbaException(E: SystemException);

implementation

uses
  Windows;

const
  S_ERROR = 'Ошибка!';

procedure HandleCorbaException(E: SystemException);
var
  S: String;
begin
  S := '';
  if E is UNKNOWN then
    S := 'Неизвестная ошибка!'
  else
  if E is BAD_PARAM then
    S := 'Неверный параметр!'
  else
  if E is NO_MEMORY then
    S := 'Нехватка памяти!'
  else
  if E is IMP_LIMIT then
    S := 'Внутреннее ограничение!'
  else
  if E is COMM_FAILURE then
    S := 'Отказ исполнения!'
  else
  if E is INV_OBJREF then
    S := 'Неверная ссылка!'
  else
  if E is NO_PERMISSION then
    S := 'Нет прав доступа!'
  else
  if E is INTERNAL then
    S := 'Внутренняя ошибка!'
  else
  if E is MARSHAL then
    S := 'Маршал ошибся!'
  else
  if E is INITIALIZE then
    S := 'Ошибка инициализации!'
  else
  if E is NO_IMPLEMENT then
    S := 'Реализация отсутствует!'
  else
  if E is BAD_TYPECODE then
    S := 'Неверный код типа!'
  else
  if E is BAD_OPERATION then
    S := 'Ошибка исполнения!'
  else
  if E is NO_RESOURCES then
    S := 'Ресурс отсутствует!'
  else
  if E is NO_RESPONSE then
    S := 'Сервер не отвечает!'
  else
  if E is PERSIST_STORE then
    S := 'Персист хранится!'
  else
  if E is BAD_INV_ORDER then
    S := 'Неизвестная ошибка!'
  else
  if E is TRANSIENT then
    S := 'Сервер умер!'
  else
  if E is FREE_MEM then
    S := 'Освободите память!'
  else
  if E is INV_IDENT then
    S := 'Неверный идентификатор!'
  else
  if E is INV_FLAG then
    S := 'Неверный флаг!'
  else
  if E is INTF_REPOS then
    S := 'Отказ репозитория!'
  else
  if E is BAD_CONTEXT then
    S := 'Неверный контекст!'
  else
  if E is OBJ_ADAPTER then
    S := 'Ошибка объектного адаптера!'
  else
  if E is DATA_CONVERSION then
    S := 'Ошибка конвертации данных!'
  else
  if E is OBJECT_NOT_EXIST then
    S := 'Неизвестный объект!';
  if S <> '' then
    MessageBox(0, PChar(S), PChar(S_ERROR), MB_OK + MB_ICONWARNING);
end;

end.
