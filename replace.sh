#!/bin/bash



AA=$( cat <<\EOF | sed -z -e 's#\([][^$*\.#]\)#\\\1#g' -e 's#\n#\\n#g'
hosts:
      core: ""
      notary: ""

EOF
)

BB=$( cat <<\EOF | sed -z -e 's#\([&\#]\)#\\\1#g' -e 's#\n#\\n#g'
hosts:
      core: mgmt-registry1.tank.local
      notary: mgmt-registry1.tank.local
EOF
)

sed -z -i 's#'"${AA}"'#'"${BB}"'#g' *.txt
