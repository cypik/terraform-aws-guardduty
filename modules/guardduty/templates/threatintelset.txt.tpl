# Custom ThreatIntelSet list
%{ for ip in threatintelset_iplist ~}
${ip}
%{ endfor ~}
