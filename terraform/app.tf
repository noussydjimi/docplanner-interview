# https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release
resource "helm_release" "doc_planner_app" {
    name       = var.docplanner_release_name
    chart      = "../k8s/docplanner"
    version    = var.docplanner_helmchart_version
}
