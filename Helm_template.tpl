# helm-charts/ecommerce-app/templates/_helpers.tpl
{{/*
Expand the name of the chart.
*/}}
{{- define "ecommerce-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ecommerce-app.fullname" -}}
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
{{- define "ecommerce-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ecommerce-app.labels" -}}
helm.sh/chart: {{ include "ecommerce-app.chart" . }}
{{ include "ecommerce-app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: {{ include "ecommerce-app.name" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ecommerce-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ecommerce-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "ecommerce-app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "ecommerce-app.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Generate certificates for webhook
*/}}
{{- define "ecommerce-app.gen-certs" -}}
{{- $altNames := list ( printf "%s.%s" (include "ecommerce-app.name" .) .Release.Namespace ) ( printf "%s.%s.svc" (include "ecommerce-app.name" .) .Release.Namespace ) -}}
{{- $ca := genCA "ecommerce-app-ca" 365 -}}
{{- $cert := genSignedCert ( include "ecommerce-app.name" . ) nil $altNames 365 $ca -}}
tls.crt: {{ $cert.Cert | b64enc }}
tls.key: {{ $cert.Key | b64enc }}
ca.crt: {{ $ca.Cert | b64enc }}
{{- end }}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "ecommerce-app.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.frontend.image .Values.backend.image .Values.paymentService.image) "global" .Values.global) -}}
{{- end }}

{{/*
Create a default fully qualified postgresql name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "ecommerce-app.postgresql.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "postgresql" "chartValues" .Values.postgresql "context" $) -}}
{{- end }}

{{/*
Return the Postgresql Database hostname
*/}}
{{- define "ecommerce-app.databaseHost" -}}
{{- if .Values.postgresql.enabled }}
    {{- if eq .Values.postgresql.architecture "replication" }}
        {{- printf "%s-primary" (include "ecommerce-app.postgresql.fullname" .) -}}
    {{- else -}}
        {{- printf "%s" (include "ecommerce-app.postgresql.fullname" .) -}}
    {{- end -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.host -}}
{{- end -}}
{{- end }}

{{/*
Return the Postgresql port
*/}}
{{- define "ecommerce-app.databasePort" -}}
{{- if .Values.postgresql.enabled }}
    {{- printf "5432" -}}
{{- else -}}
    {{- printf "%d" (.Values.externalDatabase.port | int ) -}}
{{- end -}}
{{- end }}

{{/*
Return the Postgresql database name
*/}}
{{- define "ecommerce-app.databaseName" -}}
{{- if .Values.postgresql.enabled }}
    {{- printf "%s" .Values.postgresql.auth.database -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.database -}}
{{- end -}}
{{- end }}

{{/*
Return the Postgresql username
*/}}
{{- define "ecommerce-app.databaseUsername" -}}
{{- if .Values.postgresql.enabled }}
    {{- printf "%s" .Values.postgresql.auth.username -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.username -}}
{{- end -}}
{{- end }}

{{/*
Return the Postgresql secret name
*/}}
{{- define "ecommerce-app.databaseSecretName" -}}
{{- if .Values.postgresql.enabled }}
    {{- if .Values.postgresql.auth.existingSecret -}}
        {{- printf "%s" .Values.postgresql.auth.existingSecret -}}
    {{- else -}}
        {{- printf "%s" (include "ecommerce-app.postgresql.fullname" .) -}}
    {{- end -}}
{{- else if .Values.externalDatabase.existingSecret -}}
    {{- printf "%s" .Values.externalDatabase.existingSecret -}}
{{- else -}}
    {{- printf "%s-externaldb" (include "ecommerce-app.fullname" .) -}}
{{- end -}}
{{- end }}

{{/*
Add environment variables to configure database values
*/}}
{{- define "ecommerce-app.databaseSecretPasswordKey" -}}
{{- if .Values.postgresql.enabled -}}
    {{- printf "password" -}}
{{- else -}}
    {{- if .Values.externalDatabase.existingSecret -}}
        {{- if .Values.externalDatabase.existingSecretPasswordKey -}}
            {{- printf "%s" .Values.externalDatabase.existingSecretPasswordKey -}}
        {{- else -}}
            {{- printf "password" -}}
        {{- end -}}
    {{- else -}}
        {{- printf "password" -}}
    {{- end -}}
{{- end -}}
{{- end }}

{{/*
Return Redis(TM) host
*/}}
{{- define "ecommerce-app.redisHost" -}}
{{- if .Values.redis.enabled }}
    {{- printf "%s-master" (include "common.names.dependency.fullname" (dict "chartName" "redis" "chartValues" .Values.redis "context" $)) -}}
{{- else -}}
    {{- printf "%s" .Values.externalRedis.host -}}
{{- end -}}
{{- end }}

{{/*
Return Redis(TM) port
*/}}
{{- define "ecommerce-app.redisPort" -}}
{{- if .Values.redis.enabled }}
    {{- printf "6379" -}}
{{- else -}}
    {{- printf "%d" (.Values.externalRedis.port | int ) -}}
{{- end -}}
{{- end }}