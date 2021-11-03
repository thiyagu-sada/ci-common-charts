{{/*
Main entrypoint for the common library chart. It will render all underlying templates based on the provided values.
*/}}
{{- define "common.all" -}}
  {{- /* Merge the local chart values and the common chart defaults */ -}}
  {{- include "common.values.setup" . }}

  {{- if .Values.controller.enabled }}
    {{- if eq .Values.controller.type "deployment" }}
      {{- include "common.deployment" . | nindent 0 }}
    {{ else if eq .Values.controller.type "deploymentConfig" }}
      {{- include "common.deploymentConfig" . | nindent 0 }}
    {{ else if eq .Values.controller.type "daemonset" }}
      {{- include "common.daemonset" . | nindent 0 }}
    {{ else if eq .Values.controller.type "statefulset"  }}
      {{- include "common.statefulset" . | nindent 0 }}
    {{ else }}
      {{- fail (printf "Not a valid controller.type (%s)" .Values.controller.type) }}
    {{- end -}}
  {{- end -}}


  {{ include "common.service" . | nindent 0 }}

  {{ include "common.route" .  | nindent 0 }}

  {{- if .Values.secret -}}
    {{ include "common.secret" .  | nindent 0 }}
  {{- end -}}
  
{{- end -}}