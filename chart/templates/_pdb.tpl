{{- define "common.pdb" }}
---
{{- if eq .Values.pdb true }}
---
apiVersion: policy/v1beta1
kind: PodDisruptionBudget
metadata:
  name: {{ include "app.fullname" . }}
  labels:
    {{- include "app.labels" . | nindent 4 }}
spec:
  minAvailable: 1
  selector:
    matchLabels:
      deploymentconfig: {{ include "app.fullname" . }}
{{- end }}
{{- end }}