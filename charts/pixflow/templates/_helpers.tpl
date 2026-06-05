{{/*
Expand the name of the chart.
*/}}
{{- define "pixflow.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully-qualified app name, truncated at 63 chars (DNS limit).
If the release name already contains the chart name it is used as-is to avoid
duplication (e.g. "pixflow-pixflow" → "pixflow").
*/}}
{{- define "pixflow.fullname" -}}
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
Chart label: name-version, used in the helm.sh/chart annotation.
*/}}
{{- define "pixflow.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels applied to every resource.
*/}}
{{- define "pixflow.labels" -}}
helm.sh/chart: {{ include "pixflow.chart" . }}
{{ include "pixflow.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels — used in Deployment.spec.selector.matchLabels and
Service.spec.selector. These must remain stable across chart upgrades;
changing them forces a delete+recreate of the Deployment.
*/}}
{{- define "pixflow.selectorLabels" -}}
app.kubernetes.io/name: {{ include "pixflow.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Name of the ServiceAccount to use.
*/}}
{{- define "pixflow.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "pixflow.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Name of the Secret that holds signing credentials.
Uses existingSecret when provided; otherwise falls back to the chart-managed Secret.
*/}}
{{- define "pixflow.secretName" -}}
{{- if .Values.existingSecret }}
{{- .Values.existingSecret }}
{{- else }}
{{- include "pixflow.fullname" . }}
{{- end }}
{{- end }}
