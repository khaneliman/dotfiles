function running_services --wraps='systemctl list-units  --type=service  --state=running' --description 'alias running_services=systemctl list-units  --type=service  --state=running'
  systemctl list-units  --type=service  --state=running $argv; 
end
