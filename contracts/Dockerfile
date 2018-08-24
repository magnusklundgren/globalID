FROM hayeah/qtumportal
RUN ["sed", "-i", "s/-printtoconsole/-printtoconsole -blockmaxweight=100000000 -staker-soft-block-gas-limit=1000000000 -staker-max-tx-gas-limit=10000000000000 -blockmintxfee=0.04 -maxtxfee=1000 -fallbackfee=0.04 -minrelaytxfee=0.04/g", "/usr/local/bin/qtumd-launch"]
