{{/*
This template serves as the blueprint for the Deployment objects that are created
within the common library.
*/}}
{{- define "common.deployment" }}
---
{{- if (ne .Values.deploymentConfig true) }}
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "app.fullname" . }}
  annotations:
    image.openshift.io/triggers: '[{"from":{"kind":"ImageStreamTag","name":"{{ include "app.fullname" . }}:{{ .Values.image_version }}"},"fieldPath":"spec.template.spec.containers[?(@.name==\"app\")].image"}]'
  labels:
    {{- include "app.labels" . | nindent 4 }}
spec:
  progressDeadlineSeconds: 600
  replicas: {{ .Values.replicas.min }}
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      {{- include "app.selectorLabels" . | nindent 6 }}
  strategy:
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
    type: RollingUpdate
  template:
    metadata:
      annotations:
        prometheus.io/scrape: 'true'
        prometheus.io/path: '/metrics'
        prometheus.io/port: '8080'
        rollme: {{ randAlphaNum 5 | quote }}
      labels:
        {{- include "app.selectorLabels" . | nindent 8 }}
    spec:
      volumes:
        - name: config-volume
          secret:
             secretName: {{ .Values.config_secret_name | quote }}
             defaultMode: 420
      containers:
        - env:
            - name: QUARKUS_PROFILE
              value: prod
            - name: QUARKUS_LOG_LEVEL
              value: INFO
            - name: QUARKUS_LOG_LEVEL
              value: INFO       
          image: {{ .Values.image_name | quote }}
          imagePullPolicy: Always
          name: {{ include "app.name" . }}
       #Quarkus reads the runtime config from $PWD/config/application.properties
          volumeMounts: 
            - name: config-volume
              mountPath: /deployments/config
              readOnly: true
          livenessProbe:
            httpGet:
              path: /health/live
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
          readinessProbe:
            httpGet:
              path: /health/ready
              port: 8080
              scheme: HTTP
            timeoutSeconds: 1
            periodSeconds: 10
            successThreshold: 1
            failureThreshold: 3
          resources:
            limits:
              cpu: '1.5'
              memory: 900Mi
            requests:
              cpu: '800m'
              memory: 500Mi
          terminationMessagePath: /dev/termination-log
          terminationMessagePolicy: File
      dnsPolicy: ClusterFirst
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext: {}
      terminationGracePeriodSeconds: 30
{{- end }}
{{- end }}