unit CorbaUtils;

interface

uses CORBA, Dialogs;

  procedure HandleCorbaException(E: SystemException);

implementation

procedure HandleCorbaException(E: SystemException);
begin
  if E is UNKNOWN then MessageDlg('Неизвестная ошибка!', mtWarning, [mbOK], 0);
  if E is BAD_PARAM then MessageDlg('Неверный параметр!', mtWarning, [mbOK], 0);
  if E is NO_MEMORY then MessageDlg('Нехватка памяти!', mtWarning, [mbOK], 0);
  if E is IMP_LIMIT then MessageDlg('Внутреннее ограничение!', mtWarning, [mbOK], 0);
  if E is COMM_FAILURE then MessageDlg('Отказ исполнения!', mtWarning, [mbOK], 0);
  if E is INV_OBJREF then MessageDlg('Неверная ссылка!', mtWarning, [mbOK], 0);
  if E is NO_PERMISSION then MessageDlg('Нет прав доступа!', mtWarning, [mbOK], 0);
  if E is INTERNAL then MessageDlg('Внутренняя ошибка!', mtWarning, [mbOK], 0);
  if E is MARSHAL then MessageDlg('Маршал ошибся!', mtWarning, [mbOK], 0);
  if E is INITIALIZE then MessageDlg('Ошибка инициализации!', mtWarning, [mbOK], 0);
  if E is NO_IMPLEMENT then MessageDlg('Реализация отсутствует!', mtWarning, [mbOK], 0);
  if E is BAD_TYPECODE then MessageDlg('Неверный код типа!', mtWarning, [mbOK], 0);
  if E is BAD_OPERATION then MessageDlg('Ошибка исполнения!', mtWarning, [mbOK], 0);
  if E is NO_RESOURCES then MessageDlg('Ресурс отсутствует!', mtWarning, [mbOK], 0);
  if E is NO_RESPONSE then MessageDlg('Сервер не отвечает!', mtWarning, [mbOK], 0);
  if E is PERSIST_STORE then MessageDlg('Персист хранится!', mtWarning, [mbOK], 0);
  if E is BAD_INV_ORDER then MessageDlg('Неизвестная ошибка!', mtWarning, [mbOK], 0);
  if E is TRANSIENT then MessageDlg('Сервер умер!', mtWarning, [mbOK], 0);
  if E is FREE_MEM then MessageDlg('Освободите память!', mtWarning, [mbOK], 0);
  if E is INV_IDENT then MessageDlg('Неверный идентификатор!', mtWarning, [mbOK], 0);
  if E is INV_FLAG then MessageDlg('Неверный флаг!', mtWarning, [mbOK], 0);
  if E is INTF_REPOS then MessageDlg('Отказ репозитория!', mtWarning, [mbOK], 0);
  if E is BAD_CONTEXT then MessageDlg('Неверный контекст!', mtWarning, [mbOK], 0);
  if E is OBJ_ADAPTER then MessageDlg('Ошибка объектного адаптера!', mtWarning, [mbOK], 0);
  if E is DATA_CONVERSION then MessageDlg('Ошибка конвертации данных!', mtWarning, [mbOK], 0);
  if E is OBJECT_NOT_EXIST then MessageDlg('Неизвестный объект!', mtWarning, [mbOK], 0);
end;

end.
