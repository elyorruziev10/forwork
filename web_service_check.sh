#!/bin/bash 

tg="/root/ravenclaw/telegram.sh"
nginxstatus=$(systemctl status nginx | grep -Eo "running|dead|failed")
  if [[ $nginxstatus = 'running' ]]
   then
    $tg  " WEB server is working" # > /dev/null
         else 
           $tg "Nginx is not working"  #> /dev/null
        systemctl restart nginx
        sleep 1
       $tg "Status after restart - $(systemctl status nginx | grep -Eo "running|dead|failed")" # >  /dev/null
        curl -I 192.168.1.9  | grep  OK        
fi

# Получаем статус php через systemd  записываем его в переменную.
phpfpmstatus=`systemctl status php7.4-fpm | grep -Eo "running|dead|failed"`
 
            if [[ $phpfpmstatus = 'running' ]]
                then
                    $tg  " php7.4-fpm is working " #> /dev/null
                else 
                    $tg " php7.4-fpm status  $phpfpmstatus. Restarting." #> /dev/null
                    systemctl restart php7.4-fpm # Перезапуск php7.2-fpm
                    sleep 1 #  Ожидаем 1 секунду, чтобы php7.2-fpm точно запустился. 
                    
                    $tg " Status  php7.4-fpm after restarting  -  $(systemctl status php7.4-fpm | grep -Eo "running|dead|failed")" #> /dev/null
            fi 
