# TauntEm

**Текущая версия**: 1.0

**Лицензия**: GNU GPL 3.0

### **Требования**:
- Team Fortress 2
- SourceMod 1.8+
- [TF2Items](https://forums.alliedmods.net/showthread.php?t=115100)
- _(опционально)_ [VIP Core by R1KO](http://hlmod.ru/resources/245/)

### **Описание**:
Плагин добавляет меню с насмешками TF2. Все насмешки в меню настраиваются в файле **/data/TauntEm.cfg**

Плагин может работать с VIP-ядром R1KO:
- Добавляет функцию **TauntEm_AllTaunts**, дающую доступ ко всем насмешкам
- Добавляет по функции на каждую насмешку, название которой генерируется на основе _EID_ (_Economic ID_). Например, если EID равен "RPS", то плагин добавит функцию _TauntEm_RPS_. Если EID не указан, используется стандартный EID "Generic".

### **Установка**:
- Скачать архив
- Распаковать архив
- Если необходимо, внести правки в **/data/TauntEm.cfg** и **/translations/TauntEm_Taunts.phrases.txt**
- Загрузить все файлы на сервер, в каталог **/addons/sourcemod/**, соблюдая иерархию каталогов.

### **Удаление**:
- Удалить файлы:
  - /addons/sourcemod/data/TauntEm.cfg
  - /addons/sourcemod/plugins/TauntEm.smx
  - /addons/sourcemod/scripting/TauntEm.sp
  - /addons/sourcemod/scripting/TauntEm/VIP.sp
  - /addons/sourcemod/scripting/TauntEm/Cmd.sp
  - /addons/sourcemod/scripting/TauntEm/UTIL.sp
  - /addons/sourcemod/scripting/TauntEm/Menus.sp
  - /addons/sourcemod/scripting/TauntEm/Taunts.sp
  - /addons/sourcemod/scripting/TauntEm/Events.sp
  - /addons/sourcemod/scripting/TauntEm/Config.sp
  - /addons/sourcemod/scripting/TauntEm/Defines.sp
  - /addons/sourcemod/translations/TauntEm_Taunts.phrases.txt
  - /addons/sourcemod/translations/TauntEm_Generic.phrases.txt
- Перезапустить сервер **ИЛИ** сменить карту **ИЛИ** выполнить в консоли сервера команду sm plugins unload TauntEm

### Важно!
При добавлении новых насмешек, выпускаться новая версия плагина **не будет**. Будут обновляться файлы в папках **data** и **translations**. Потому придётся вручную качать весь репозиторий, вытягивая эти папки на свой сервер, либо вручную смотреть, что изменилось, и вносить эти изменения у себя.
