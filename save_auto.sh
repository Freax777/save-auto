#!/bin/bash

#Variables
site1='/var/www/sites1'
home='/home'
CRON='/tmp/config/cron.bak'
AP='/etc/apache2'
site2='/var/www/sites2'
SSH='/etc/ssh/sshd_config'
SSMTP='/etc/ssmtp/ssmtp.conf'
SRV='/media/sauvegarde/'
#FIN

#CONFIG CRON
mkdir /tmp/config/
crontab -l > /tmp/config/cron.bak
rsync -a ${CRON} ${SRV}/config/ 2> /var/log/errors.txt
R=$?
if [ ${R} -eq 0 ]
then
        CR="Cron : Sauvegarde réussie"
else
        CR="Cron : Sauvegarde échouée"
fi
rm -r /tmp/config

#SAVE HOME
rsync -a ${home} ${SRV}/home 2> /var/log/errors.txt
R=$?
if [ ${R} -eq 0 ]
then
        HM='HOME : Sauvegarde réussie'
else
        HM='HOME : Sauvegarde échouée'
fi
#SAVE CONFIG APACHE
rsync -a ${AP} ${SRV}/apache/ 2> /var/log/errors.txt
R=$?
if [ ${R} -eq 0 ]
then
        AP2='Apache : Sauvegarde réussie'
else
        AP2='Apache : Sauvegarde échouée'
fi
#SSH CONFIG
rsync -a ${SSH} ${SRV}/ssh/ 2> /var/log/errors.txt
R=$?
if [ ${R} -eq 0 ]
then
        ssh='SSH : Sauvegarde réussie'
else
        ssh='SSH : Sauvegarde échouée'
fi
#SSMTP CONFIG
rsync -a ${SSMTP} ${SRV}/ssmtp/ 2> /var/log/errors.txt
R=$?
if [ ${R} -eq 0 ]
then
        ssmtp='SSMTP : Sauvegarde réussie'
else
        ssmtp='SSMTP : Sauvegarde échouée'
fi
#SITE 2
rsync -az ${site1} ${SRV}/site1 2> /var/log/errors.txt
R=$?
if [ ${R} -eq 0 ]
then
        SITE2='SITE 1 : Sauvegarde réussie'
else
        SITE2='SITE 1 : Sauvegarde échouée'
fi
#SITE 1
rsync -az ${site2} ${SRV}/site2/ 2> /var/log/errors.txt
R=$?
if [ ${R} -eq 0 ]
then
        SITE2='SITE 2 : Sauvegarde réussie'
else
        SITE2='SITE 2 : Sauvegarde échouée'
fi
#CONDITION RAPPORT ERREUR MAIL
log=/var/log/errors.txt
size=$(ls -l ${log} | cut -d " " -f5)
if [ ${size} -eq 0 ]
then
        false
else
        errors="-A ${log}"
fi
#ENVOIE MAIL
echo "Sauvegarde fini le : $(date +%d%m%Y-%H%M%S). Listes des sauvegardes : ${CR} : ${HM} : ${AP2} : ${ssh} : ${ssmtp} : ${SITE2} : ${SITE1}" | mail -s "Sauvegarde AUTO" ${errors} mail@gmail.com
rm /var/log/errors.txt
