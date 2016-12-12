from cm_api.api_client import ApiResource
from cm_api.endpoints.cms import ClouderaManager

cm_host = "localhost"

api = ApiResource(cm_host, username="admin", password="admin")

cms = ClouderaManager(api)

cmd = cms.get_service().restart()
cmd = cmd.wait()
print "Cloudera Manager Restart. Active: %s. Success: %s" % (cmd.active, cmd.success)

cluster = api.get_cluster("Spark")
print cluster

restart_cluster = cluster.restart().wait()
print "Cluster %s. Status - restart success: %s." % (cluster.name, restart_cluster.success)

print "Cluster %s. Status - Configuration Stale -- Redeploying configurations"
redeploy_config = cluster.deploy_client_config().wait()
print "New configuration success: %s." % redeploy_config.success