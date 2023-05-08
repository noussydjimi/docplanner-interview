#### Resources: https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release
resource "helm_release" "doc_planner_app" {
    name       = var.docplanner_release_name
    chart      = "../k8s/docplanner"
    version    = var.docplanner_helmchart_version

    set {
    name  = "app.registry"
    value = "noussydjimi/docplanner"
  }

    set {
    name  = "app.front.tag"
    value = "front"
  }

    set {
    name  = "app.back.tag"
    value = "back"
  }

    set {
    name  = "app.domain"
    value = ""
  }
}
