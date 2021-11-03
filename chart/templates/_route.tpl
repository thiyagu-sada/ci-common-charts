{{- define "common.route" }}
---
{{- if eq .Values.route true }}
---
apiVersion: route.openshift.io/v1
kind: Route
metadata:
  name: {{ include "app.fullname" . }}
  labels:
    {{- include "app.labels" . | nindent 4 }}
spec:
  port:
    targetPort: tcp-8080
  to:
    kind: Service
    name: {{ include "app.fullname" . }}
    weight: 100
  tls:
    insecureEdgeTerminationPolicy: Redirect
    termination: edge
  wildcardPolicy: None
{{ end }}
{{ end }}
