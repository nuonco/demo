---
apiVersion: v1
kind: Namespace
metadata:
  name: api
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "common.labels" . | nindent 4 }}
