echo "Generating Network Config for Caliper . . . ."

CURRENT_DIR=$PWD

cp networks/network_config_template.json networks/network_config.json

function one_line_pem() {
    echo "$(awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1)"
}

INDEX=0

for ORG in citizen police forensics court identityprovider; do
    # SET PRIVATE KEYS
    KEY_PATH="../network-config/crypto-config/peerOrganizations/${ORG}.example.com/users/Admin@${ORG}.example.com/msp/keystore/"
    echo $OPATH
    echo $INDEX
    cd $OPATH
    PRIV_KEY=$(ls *_sk)
    cd $CURRENT_DIR
    sed -i "s/C${INDEX}_PRIVATE_KEY/${PRIV_KEY}/g" networks/network_config.json

    # SET PEERPEM
    PEERPEM="../network-config/crypto-config/peerOrganizations/${ORG}.example.com/tlsca/tlsca.${ORG}.example.com-cert.pem"
    local PP=$(one_line_pem $PEERPEM)
    sed -e "s#PEERPEM${INDEX}#$PP#" networks/network_config.json

    # SET CAPEM
    CAPEM="../network-config/crypto-config/peerOrganizations/${ORG}.example.com/ca/ca.${ORG}.example.com-cert.pem"
    local PP=$(one_line_pem $CAPEM)
    sed -e "s#CAPEM${INDEX}#$PP#" networks/network_config.json

    # ITERATE INDEX
    $INDEX=$(($INDEX + 1))
done
