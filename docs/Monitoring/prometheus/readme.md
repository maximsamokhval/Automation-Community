
- [Установка prometheus как службы](#установка-prometheus-как-службы)
- [graphana установка](#graphana-установка)
- [Подключение Prometeus к Grafana](#подключение-prometeus-к-grafana)
- [Подключение и настройка windows_exporter](#подключение-и-настройка-windows_exporter)
  - [Отредактировать файл prometheus.yml](#отредактировать-файл-prometheusyml)

## Установка prometheus как службы

 * Скачать [nssm](https://nssm.cc/download)
 * Выполнить в powerShell для установки prometheus как службы windows
  
  ```  .\nssm.exe install prometheus C:\monitoring\prometheus\prometheus.exe```

* Сервис доступен по адресу http://localhost:9090


## graphana установка

* Скачиваем [graphana](https://grafana.com/grafana/download?pg=get&plcmt=selfmanaged-box1-cta1&platform=windows)

* Сервис доступен по адресу http://localhost:3000/login 
* Данные авторизации admin/admin

## Подключение Prometeus к Grafana

- Data Source: Prometheus
- URL: [http://localhost:9090](http://localhost:9090)

## Подключение и настройка windows_exporter

* [https://github.com/prometheus-community/windows_exporter](https://github.com/prometheus-community/windows_exporter/releases/tag/v0.16.0)
* * Сервис доступен по адресу http://localhost:9182

### Отредактировать файл prometheus.yml
* Добавить секцию job_name 
``` yml 
  - job_name: "windows"
    scrape_interval: 18s
    scrape_timeout: 15s
    - targets: ["localhost:9182"]
```
Перезапустить службу prometheus для перечитывания нового конфигурационного файла

