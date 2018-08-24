qcli generate 600
solar deploy mainController.sol --force
solar deploy --force User.sol '["hejmeddig", "0x1234", "bob", "0x1111"]'
qcli generate 1000
while true; do
	sleep 1
	qcli generate 1
done
