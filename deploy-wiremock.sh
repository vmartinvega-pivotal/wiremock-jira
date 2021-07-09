set -eu

function Help()
{
   # Display Help
   echo
   echo
   echo "Add description of the script options."
   echo
   echo "Syntax: deploy-wiremock.sh "
   echo "options:"
   echo 
   echo "-t|--token         Token used to authenticate to openshift."
   echo "-p|--endpoint      Openshift endpoint. Default value: https://api.ocp.ccc.srvb.cn2.paas.cloudcenter.corp:8443."
   echo "-n|--namespace     Project name where rabbitmq will be deployed. This parameter is required."
   echo "-a|--appname       App name to be deployed. Default value wiremock-jira."
   echo "-i|--image         Docker image to deploy. Default value registry.global.ccc.srvb.can.paas.cloudcenter.corp/c3alm-sgt/wiremock-jira."
   echo "-h|--help          This message."
   echo
}

token=""
endpoint="https://api.ocp.ccc.srvb.cn2.paas.cloudcenter.corp:8443"
namespace="global-alm-fix-pre"
appname="wiremock-jira"
image="registry.global.ccc.srvb.can.paas.cloudcenter.corp/c3alm-sgt/wiremock-jira"

while [[ $# -gt 0 ]]; do
	case "$1" in
  	-t|--token)
			token="$2"
			shift 2
  		;;
  	-a|--appname)
			appname="$2"
			shift 2
  		;;
		-n|--namespace)
			namespace="$2"
			shift 2
			;;
		-p|--endpoint)
			endpoint="$2"
			shift 2
			;;
		-i|--image)
			image="$2"
			shift 2
			;;
    -h|--help)
			Help
			exit 0
			;;
		-*)
			echo "ERROR: Unknown option '$1'"
      Help
			exit 1
			;;
		*)
			break
			;;
	esac
done

echo ""
if [[ "${namespace:-}" == "" ]]; then
  echo "The project/namespace is required! Existing..."
  exit 1
else
  echo "A new wiremock server will be deployed with the following values"
  echo ""
  echo "Using project (${namespace})"
fi

if [[ "${endpoint:-}" == "" ]]; then
  echo "The endpoint is required! Existing..."
  exit 1
else
  echo "Using endpoint (${endpoint})"
fi

echo "Using wiremock image (${image})"
echo "Using app name (${appname})"
echo

if [[ -n "${token}" ]]; then
  echo "Trying to login ${endpoint} with token..."
  if ! oc login "${endpoint}" --token="${token}" > /dev/null 2>&1; then
    echo "ERROR: Could not login to ${endpoint} with the specified token"
    exit 1
  else 
    echo "Login successful."
  fi
else
  echo "Trying to login ${endpoint} with username and password..."
  echo
  read -r -p "Username: " username
  read -r -s -p "Password: " password
  echo

  if ! oc login "${endpoint}" -u "${username}" --password="${password}" --insecure-skip-tls-verify=true > /dev/null 2>&1; then
    echo "ERROR: Could not login to ${endpoint} with user ${username}"
    exit 1
  else  
    echo "Login successful."
  fi
fi

# Changing namespace
oc project ${namespace}

echo
read -p "Do you want to proceed (y/n)? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Creating wiremock..."
    echo
    oc process \
    -f "wiremock-template.yaml" \
    -o yaml \
    -p APP_NAME="${appname}" \
    -p TAGGED_IMAGE="${image}" \
  | \
  oc create -f -

  echo 
  echo "Run the following commands in order to remove all created objects..."
  echo
  echo "oc delete deploymentconfig ${appname}"
  echo "oc delete service ${appname}"
  echo "oc delete route ${appname}"
fi