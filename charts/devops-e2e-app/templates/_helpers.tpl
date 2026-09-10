{{- define "devops-e2e-app.name" -}}
{{- .Chart.Name -}}
{{- end -}}

{{- define "devops-e2e-app.fullname" -}}
{{- printf "%s-%s" .Release.Name (include "devops-e2e-app.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "devops-e2e-app.labels" -}}
app.kubernetes.io/name: {{ include "devops-e2e-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version }}
{{- end -}}

{{- define "devops-e2e-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "devops-e2e-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
