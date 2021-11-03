{{/*
This template serves as the blueprint for the Deployment objects that are created
within the common library.
*/}}
{{- define "common.deploymentConfig" }}
---
{{- if .Values.deploymentConfig }}
---
apiVersion: apps.openshift.io/v1
kind: DeploymentConfig
metadata:
  name: {{ include "app.fullname" . }}
  labels:
    {{- include "app.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.replicas.min }}
  revisionHistoryLimit: 10
  selector:
    {{- include "app.selectorLabels" . | nindent 4 }}
  strategy:
    activeDeadlineSeconds: 21600
    resources: {}
    rollingParams:
      intervalSeconds: 1
      maxSurge: 25%
      maxUnavailable: 25%
      timeoutSeconds: 600
      updatePeriodSeconds: 1
    type: Rolling
  template:
    metadata:
      annotations:
        prometheus.io/scrape: 'true'
        prometheus.io/path: '/metrics'
        prometheus.io/port: '8080'
        rollme: {{ randAlphaNum 5 | quote }}
      creationTimestamp: null
      labels:
        {{- include "app.selectorLabels" . | nindent 8 }}
    spec:
      containers:
        - env:
            {{- include "app.env" . | nindent 10 }}
          image: {{ .Values.image_name | quote }}
          imagePullPolicy: Always
          name: {{ include "app.name" . }}
          livenessProbe:
            httpGet:
              path: /health
              port: 8080
              scheme: HTTP
            timeoutSeconds: 1
            periodSeconds: 10
            successThreshold: 1
            failureThreshold: 3
          ports:
            - containerPort: 8080
              protocol: TCP
            - containerPort: 8443
              protocol: TCP
          resources:
            limits:
              cpu: '600m'
              memory: 500Mi
            requests:
              cpu: '100m'
              memory: 50Mi
          readinessProbe:
            httpGet:
              path: /health
              port: 8080
              scheme: HTTP
            timeoutSeconds: 1
            periodSeconds: 10
            successThreshold: 1
            failureThreshold: 3
          terminationMessagePath: /dev/termination-log
          terminationMessagePolicy: File
      dnsPolicy: ClusterFirst
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext: {}
      terminationGracePeriodSeconds: 30
  test: false
  triggers:
    - type: ConfigChange
    - imageChangeParams:
        automatic: true
        containerNames:
          - {{ include "app.name" . }}
        from:
          kind: ImageStreamTag
          name: {{ include "app.fullname" . }}:{{ .Values.image_version }}
        lastTriggeredImage: ""
      type: ImageChange
{{- end }}
{{- end }}