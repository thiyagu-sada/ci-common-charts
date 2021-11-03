{{- define "common.servicemonitor" }}
---
{{- if eq .Values.servicemonitor true }}
---
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: {{ include "app.fullname" . }}
  labels:
    {{- include "app.labels" . | nindent 4 }}
spec:
  endpoints:
    - interval: 30s
      port: tcp-8080
      scheme: http
  selector:
    matchLabels:
    {{- include "app.labels" . | nindent 6 }}
{{ end }}
{{ end }}