{{- define "common.is" }}
---
{{- if eq .Values.is true }}
---
apiVersion: image.openshift.io/v1
kind: ImageStream
metadata:
  name: {{ include "app.fullname" . }}
  labels:
    {{- include "app.labels" . | nindent 4 }}
  creationTimestamp: null
spec:
  lookupPolicy:
    local: false
{{- if (eq .Values.istag.enabled true) }}
  tags:
    - annotations:
        openshift.io/imported-from: {{ .Values.image_repository }}/app
      from:
        kind: DockerImage
        name: {{ .Values.image_repository }}/{{ .Values.image_namespace }}/{{ .Values.image_name }}:{{ .Values.image_version }}
      importPolicy: {}
      name: {{ .Values.image_version }}
{{ end }}
{{ end }}
{{ end }}
