{{- define "common.service" }}
---
{{- if eq .Values.service true }}
---
apiVersion: v1
kind: Service
metadata:
  name: {{ include "app.fullname" . }}
  labels:
    {{- include "app.labels" . | nindent 4 }}
spec:
  ports:
    - port: 8080
      protocol: TCP
      targetPort: 8080
      name: tcp-8080
    - port: 8443
      protocol: TCP
      targetPort: 8443
      name: tcp-8443
  selector:
    {{- include "app.selectorLabels" . | nindent 4 }}
  sessionAffinity: None
  type: ClusterIP
status:
  loadBalancer: {}
{{ end }}
{{ end }}