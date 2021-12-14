
- [Установка prometheus как службы](#установка-prometheus-как-службы)
- [grafana установка](#grafana-установка)
- [Подключение Prometeus к Grafana](#подключение-prometeus-к-grafana)
- [Подключение и настройка windows_exporter](#подключение-и-настройка-windows_exporter)
- [prometheus_1C_exporter](#prometheus_1c_exporter)
  - [Запуск](#запуск)
  - [Отредактировать файл prometheus.yml](#отредактировать-файл-prometheusyml)

## Установка prometheus как службы

 * Скачать [nssm](https://nssm.cc/download)
 * Выполнить в powerShell для установки prometheus как службы windows
  
  ```  .\nssm.exe install prometheus C:\monitoring\prometheus\prometheus.exe```

* Сервис доступен по адресу http://localhost:9090


## grafana установка

* Скачиваем [graphana](https://grafana.com/grafana/download?pg=get&plcmt=selfmanaged-box1-cta1&platform=windows)

* Сервис доступен по адресу http://localhost:3000/login 
* Данные авторизации admin/admin

## Подключение Prometeus к Grafana

- Data Source: Prometheus
- URL: [http://localhost:9090](http://localhost:9090)

## Подключение и настройка windows_exporter

* [https://github.com/prometheus-community/windows_exporter](https://github.com/prometheus-community/windows_exporter/releases/tag/v0.16.0)
* * Сервис доступен по адресу http://localhost:9182


## prometheus_1C_exporter 

- [prometheus_1C_exporter](https://github.com/LazarenkoA/prometheus_1C_exporter) - github репозиторий:
- - метрики:
- - Используемые клиентские лицензии
- - Количество соединений
- - Количество сеансов
- - Общая загрузка ЦПУ (получается из ОС)
- - Проверка галки "блокировка регламентных заданий"
- - Время вызова СУБД

### Запуск 

``` ./1C_exporter -port=9095 --settings=/usr/local/bin/settings.yaml ```

``` yaml
  - job_name: '1С_Metrics'
    metrics_path: '/1С_Metrics' 
    static_configs:
    - targets: ['host1:9091', 'host2:9091', 'host3:9091', 'host4:9091']
```

### Отредактировать файл prometheus.yml
* Добавить секцию job_name


``` yml 
  - job_name: "windows"
    scrape_interval: 18s
    scrape_timeout: 15s
    - targets: ["localhost:9182"]
```
Перезапустить службу prometheus для перечитывания нового конфигурационного файла