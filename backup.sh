#!/bin/bash
#Variable
books=/var/www/bookstack
grav=/var/www/grav
logs=/var/log
Name=$(date +%Y%m%d-%H%M%S)

#Backup_bookstack
tar -czvf /srv/backups/$Name.bookstack.tar.gz $books 2> /tmp/errors.txt
R=$?
if [ ${R} -eq 0 ]
then
        BK='Bookstack : Sauvegarde réussie'
else
        BK='Bookstack : Sauvegarde échouée'
fi

#Backup_Grav
tar -czvf /srv/backups/$Name.grav.tar.gz $grav 2> /tmp/errors.txt
R=$?
if [ ${R} -eq 0 ]
then
        GR='Grav : Sauvegarde réussie'
else
        GR='Grav : Sauvegarde échouée'
fi

#Backup_LOG
tar -czvf /srv/backups/$Name.log.tar.gz $logs 2> /tmp/errors.txt
R=$?
if [ ${R} -eq 0 ]
then
        LG='LOG : Sauvegarde réussie'
else
        LG='LOG : Sauvegarde échouée'
fi

#CONDITION RAPPORT ERREUR MAIL
log=/tmp/errors.txt
size=$(ls -l ${log} | cut -d " " -f5)
if [ ${size} -eq 0 ]
then
        false
else
        errors="-A ${log}"
fi

#ENVOIE MAIL
echo "Sauvegarde fini le : $(date +%d%m%Y-%H%M%S). Listes des sauvegardes : ${BK} : ${GR} : ${LG}" | mail -s "Sauvegarde AUTO" ${errors} backup@gmail
rm $log
