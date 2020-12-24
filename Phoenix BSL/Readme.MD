- [ ] Примечания оставлю к каждой строчке конфигурационного файла:
    `{
    "$schema": "https://1c-syntax.github.io/bsl-language-server/configuration/schema.json", // Путь к схеме конфигурационного файла, на проверки не влияет

```
    "language": "ru", // Язык отображения подсказок

"codeLens": {

	"showCognitiveComplexity": true, // Включается отображение значения когнитивной сложности метода над его определением. По умолчанию параметр включен (установлен в true)

	"showCyclomaticComplexity": true //Включает отображение значения цикломатической сложности метода. По умолчанию параметр включен (установлен в true)

},

"diagnostics": {

	"computeTrigger": "onSave", // Настраивается событие для проверки (в данном проекте не имеет значение, т.к. проверка вызывается по горячим клавишам)

	"skipSupport": "never", // Найстрока проверки модулей "на поддержке" (в данном проекте не имеет значение, т.к. проверка вызывается по горячим клавишам)

	"mode": "all", // Настройка включения проверок ("all" - включить все)

	"parameters": {

		"FunctionNameStartsWithGet": true, // Имя функции не должно начинаться с "Получить" (По умолчанию - выключено)

		"FunctionOutParameter": true,  // Исходящий параметр функции (По умолчанию - выключено)

		"TernaryOperatorUsage": true,  // Использование тернарного оператора (По умолчанию - выключено)

		"TooManyReturns": true,  // Метод не должен содержать много возвратов (По умолчанию - выключено)

		"LineLength": {

			"maxLineLength": 150 //Максимальная длина строки. больше которой предлагать разбить на несколько
		},

		"MethodSize": {

			"maxMethodSize": 200  // Максимальное кол-во строк метода, свыше которых, необходимо предложить пересмотр метода

		},

		"Typo": {  // Проверка орфографических ошибок осуществляется с помощью LanguageTool. Проверяемые строки разбиваются по camelCase и проверяются на соответствие во встроенном словаре.

			"minWordLength": 3, //Минимальная длина слова, которое будет проверено на орфографические ошибки

			"userWordsToIgnore": "Увага" // Словарь слов-исключений (разделитель слов ',' (запятая)

		}

	}

},

"documentLink":{  // Настройка ссылок к документации по проверкам (на стадии разработки)

		"useDevSite":true, // При включении настройки формирующиеся ссылки на документацию будут вести на develop-версию сайта. По умолчанию параметр выключен (установлен в false)

		"siteRoot":"https://1c-syntax.github.io/bsl-language-server"  // Путь к корню сайта с документацией. 

	}, 

    "traceLog": null, //путь к каталогу с логами проверок (хранятся 7 дней)

"configurationRoot": "src" // Путь к каталогу с выгруженными модулями (в этом каталоге создается файл с текстом проверяемого модуля) } `
```



- [ ] Полное описание параметров настроек: [https://1c-syntax.github.io/bsl-language-server/features/ConfigurationFile/#_1](https://github.com/maximsamokhval/automation_community/issues/url)
- [ ] Подробное описание диагностик и их параметров: [https://1c-syntax.github.io/bsl-language-server/diagnostics/](https://github.com/maximsamokhval/automation_community/issues/url)
- [ ] Схема конфигурационного файла: [https://1c-syntax.github.io/bsl-language-server/configuration/schema.json](https://github.com/maximsamokhval/automation_community/issues/url)