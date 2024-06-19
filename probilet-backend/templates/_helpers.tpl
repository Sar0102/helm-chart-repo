{{/*
Expand the name of the chart.
*/}}
{{- define "probilet-backend.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "probilet-backend.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "probilet-backend.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "probilet-backend.labels" -}}
helm.sh/chart: {{ include "probilet-backend.chart" . }}
{{ include "probilet-backend.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "probilet-backend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "probilet-backend.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "probilet-backend.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "probilet-backend.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{- define "probilet-backend.db.env" -}}
- name: SQL_HOST
  value: probilet-backend-postgresql
- name: SQL_PORT
  value: "5432"
- name: SQL_DB
  value: "{{ .Values.postgresqlDatabase }}"
- name: SQL_USER
  value: "postgres"
- name: SQL_PASSWORD
  valueFrom:
    secretKeyRef:
        name: probilet-backend-postgresql
        key: postgres-password
{{- end }}
