# IPSet custom blocklist
%{ for ip in ipset_iplist ~}
${ip}
%{ endfor ~}
