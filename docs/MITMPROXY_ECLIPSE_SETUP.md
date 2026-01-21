# Настройка mitmproxy для перехвата HTTPS-трафика Eclipse ADT

## Цель

Перехватить и увидеть реальные ADT API запросы, которые Eclipse делает к SAP системе.

## Предварительные требования

- Windows с установленным Eclipse ADT
- Python 3.x для установки mitmproxy
- Права администратора для импорта сертификата

## Шаг 1: Установка mitmproxy (Windows)

### Вариант 1: Через pip (рекомендуется)

```powershell
pip install mitmproxy
```

### Вариант 2: Через winget

```powershell
winget install mitmproxy.mitmproxy
```

### Вариант 3: Скачать бинарник

https://mitmproxy.org/downloads/ → скачать Windows binary

## Шаг 2: Первый запуск mitmproxy (генерация сертификата)

Запустите mitmproxy один раз для генерации CA сертификата:

```powershell
mitmproxy
```

Нажмите `q` для выхода.

Сертификат будет создан в:

```
%USERPROFILE%\.mitmproxy\mitmproxy-ca-cert.pem
```

Обычно это:

```
C:\Users\<USERNAME>\.mitmproxy\mitmproxy-ca-cert.pem
```

### Проверка сертификата

```powershell
dir %USERPROFILE%\.mitmproxy\
```

Должны увидеть файлы:
- `mitmproxy-ca-cert.pem`
- `mitmproxy-ca-cert.cer` (для Windows)
- `mitmproxy-ca.pem`
- и другие

## Шаг 3: Найти Java используемую Eclipse

### 3.1 Через Eclipse UI

В Eclipse:
1. `Help` → `About Eclipse`
2. `Installation Details`
3. Вкладка `Configuration`
4. Найдите строку:
   ```
   java.home=C:\path\to\jre
   ```
   или
   ```
   -vm
   C:\path\to\javaw.exe
   ```

### 3.2 Проверить существующие Java

```powershell
# Посмотреть все Java в системе
dir "C:\Program Files\Java"
dir "C:\Program Files\Eclipse"
dir "C:\Program Files\AdoptOpenJDK"
```

### 3.3 Узнать java.home через Eclipse CLI

```powershell
# Если Eclipse в PATH
eclipse -vm "C:\path\to\java\bin\javaw.exe" -vmargs -Djava.home
```

## Шаг 4: Импорт сертификата в Java cacerts

### 4.1 Найти keytool

keytool находится в:

```
<JAVA_HOME>\bin\keytool.exe
```

Например:
```
C:\Program Files\Java\jdk-11.0.12\bin\keytool.exe
C:\Program Files\Eclipse\jre\bin\keytool.exe
```

### 4.2 Импорт сертификата (PowerShell с правами администратора)

```powershell
# Пример 1: Явные пути
cd %USERPROFILE%\.mitmproxy
"C:\Program Files\Java\jdk-11\bin\keytool.exe" -importcert -trustcacerts -noprompt `
  -alias mitmproxy `
  -file mitmproxy-ca-cert.pem `
  -keystore "C:\Program Files\Java\jdk-11\lib\security\cacerts" `
  -storepass changeit

# Пример 2: Если JAVA_HOME установлен
cd %USERPROFILE%\.mitmproxy
"%JAVA_HOME%\bin\keytool.exe" -importcert -trustcacerts -noprompt `
  -alias mitmproxy `
  -file mitmproxy-ca-cert.pem `
  -keystore "%JAVA_HOME%\lib\security\cacerts" `
  -storepass changeit
```

**Важно:**
- Стандартный пароль cacerts: `changeit`
- Нужны права администратора для изменения cacerts
- Если Java несколько - импортируйте в ту, которую использует Eclipse

### 4.3 Проверить импорт

```powershell
"%JAVA_HOME%\bin\keytool.exe" -list -keystore "%JAVA_HOME%\lib\security\cacerts" -storepass changeit | findstr mitmproxy
```

Должна быть строка с alias `mitmproxy`.

## Шаг 5: Перезапуск Eclipse

**Обязательно полностью перезапустите Eclipse!**

Не просто закрыть окно, а:
1. File → Exit (или закрыть все окна Eclipse)
2. Убедитесь в Task Manager что процесс `eclipse.exe` завершен
3. Запустите Eclipse заново

## Шаг 6: Запуск mitmproxy

### Вариант 1: mitmdump (логирование в консоль)

```powershell
mitmdump --listen-host 127.0.0.1 --listen-port 8080
```

### Вариант 2: mitmproxy (интерактивный TUI)

```powershell
mitmproxy --listen-host 127.0.0.1 --listen-port 8080
```

### Вариант 3: mitmweb (web UI)

```powershell
mitmweb --listen-host 127.0.0.1 --listen-port 8080
```

Откройте http://127.0.0.1:8081 в браузере.

## Шаг 7: Настройка Eclipse для использования прокси

### Вариант A: Через Eclipse Preferences

1. `Window` → `Preferences`
2. `General` → `Network Connections`
3. Active Provider: `Manual`
4. Proxy entries:
   - **HTTP**: Host: `127.0.0.1`, Port: `8080`
   - **HTTPS**: Host: `127.0.0.1`, Port: `8080`
5. OK

### Вариант B: Через eclipse.ini

Добавьте в `eclipse.ini` (перед `-vmargs`):

```ini
-Dhttp.proxyHost=127.0.0.1
-Dhttp.proxyPort=8080
-Dhttps.proxyHost=127.0.0.1
-Dhttps.proxyPort=8080
```

### Вариант C: Через переменные окружения

```powershell
$env:HTTP_PROXY="http://127.0.0.1:8080"
$env:HTTPS_PROXY="http://127.0.0.1:8080"
```

Затем запустите Eclipse из этого же PowerShell окна.

## Шаг 8: Проверка перехвата

1. Запустите mitmproxy
2. Откройте Eclipse ADT
3. Выполните любую операцию в ABAP (например, открыть класс)
4. В mitmproxy должны появиться запросы к `https://ldai1emo.wdf.sap.corp:44300/sap/bc/adt/...`

### Что вы должны увидеть

**Если сертификат НЕ установлен:**
```
CONNECT ldai1emo.wdf.sap.corp:44300
```

**Если сертификат установлен (правильно):**
```
GET https://ldai1emo.wdf.sap.corp:44300/sap/bc/adt/repository/informationsystem/search?...
```

## Troubleshooting

### Проблема: Видны только CONNECT, не видно URL

**Причина:** Сертификат не установлен или установлен не в ту Java.

**Решение:**
1. Проверьте что импортировали в правильный cacerts (того Java который использует Eclipse)
2. Полностью перезапустите Eclipse
3. Проверьте что keytool вернул "Certificate was added to keystore"

### Проблема: Eclipse не подключается к SAP

**Причина:** mitmproxy не запущен или прокси настроен неверно.

**Решение:**
1. Убедитесь что mitmproxy запущен на 127.0.0.1:8080
2. Проверьте настройки прокси в Eclipse
3. Временно отключите прокси чтобы убедиться что это причина

### Проблема: "keytool error: java.io.FileNotFoundException: ... (Access is denied)"

**Причина:** Недостаточно прав для записи в cacerts.

**Решение:**
1. Запустите PowerShell **от имени администратора**
2. Или скопируйте cacerts в другое место, отредактируйте, скопируйте обратно

### Проблема: Несколько Java установлено

**Решение:**
1. Импортируйте сертификат во **ВСЕ** найденные Java
2. Или точно определите какую использует Eclipse через java.home в Configuration

## Полезные команды mitmproxy

### Фильтрация по домену

```powershell
mitmdump --listen-port 8080 "~d ldai1emo.wdf.sap.corp"
```

### Сохранение в файл

```powershell
mitmdump --listen-port 8080 -w traffic.mitm
```

### Воспроизведение из файла

```powershell
mitmdump -r traffic.mitm
```

### Экспорт в HAR (для анализа)

```powershell
mitmdump -r traffic.mitm --set hardump=traffic.har
```

## Интерактивные команды mitmproxy TUI

- `q` - выход
- `?` - помощь
- `f` - установить фильтр
- `enter` - детали запроса
- `tab` - переключение между request/response
- `m` - изменить запрос/ответ (replay)

## Альтернатива: Использовать SOAPUI или Burp Suite

Если mitmproxy не работает, можно использовать:

1. **SOAPUI** (бесплатный)
2. **Burp Suite Community** (бесплатный)
3. **Fiddler** (Windows, бесплатный)

Все они работают по тому же принципу (MITM proxy с импортом CA сертификата).

## Цель исследования

После настройки вы сможете увидеть:
- Точные ADT endpoints используемые Eclipse
- Формат запросов/ответов
- HTTP заголовки
- XML/JSON payload

Это поможет понять какие реальные ADT API существуют для операций типа:
- Syntax check
- Code completion
- Where-used list
- Refactoring
- и т.д.

## См. также

- [ABAP ADT URL Patterns](ABAP_ADT_URL_PATTERNS.md)
- [MCP Setup](MCP_SETUP.md)
- [Syntax Check Reality](SYNTAX_CHECK_REALITY.md)
