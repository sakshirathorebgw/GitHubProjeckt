#!/bin/bash
sed -i 's/secretName: ""/secretName: "Harbor"/g' values.yaml

AA=$( cat <<\EOF | sed -z -e 's#\([][^$*\.#]\)#\\\1#g' -e 's#\n#\\n#g'
hosts:
      core: core.harbor.domain
      notary: notary.harbor.domain
EOF
)

BB=$( cat <<\EOF | sed -z -e 's#\([&\#]\)#\\\1#g' -e 's#\n#\\n#g'
hosts:
      core: mgmt-registry1.tank.local
      notary: mgmt-registry1.tank.local
EOF
)

sed -z -i 's#'"${AA}"'#'"${BB}"'#g' *.yaml

