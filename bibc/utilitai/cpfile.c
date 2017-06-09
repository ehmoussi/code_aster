/* -------------------------------------------------------------------- */
/* Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org             */
/* This file is part of code_aster.                                     */
/*                                                                      */
/* code_aster is free software: you can redistribute it and/or modify   */
/* it under the terms of the GNU General Public License as published by */
/* the Free Software Foundation, either version 3 of the License, or    */
/* (at your option) any later version.                                  */
/*                                                                      */
/* code_aster is distributed in the hope that it will be useful,        */
/* but WITHOUT ANY WARRANTY; without even the implied warranty of       */
/* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        */
/* GNU General Public License for more details.                         */
/*                                                                      */
/* You should have received a copy of the GNU General Public License    */
/* along with code_aster.  If not, see <http://www.gnu.org/licenses/>.  */
/* -------------------------------------------------------------------- */

/* appel de la commande systeme de copie de fichier */
/* cp ou copy suivant les plates-formes             */

#include "aster.h"

void DEFSSS(CPFILE, cpfile, char *action, STRING_SIZE la,
            char *nom1, STRING_SIZE lnom1, char *nom2, STRING_SIZE lnom2)
{
   char nomcmd[165];char *ncmd;
   long i,l,ldeb,num;
   int ier;
#ifdef _WINDOWS
   num = _flushall();
   ldeb = 5;
   if ( *action == 'C' ) {ncmd = "copy ";}
   else if ( *action == 'M' ) {ncmd = "move ";}
   else {ncmd = " ? ";ldeb = 3;}
#else
   num = fflush(stderr);
   num = fflush(stdout);
   ldeb = 3;
   if ( *action == 'C' ) {ncmd = "cp ";}
   else if ( *action == 'M' ) {ncmd = "mv ";}
   else {ncmd = " ? ";ldeb = 3;}
#endif
   if (lnom1 > 80) { lnom1 = 80; }
   if (lnom2 > 80) { lnom2 = 80; }
   for (i=0;i<ldeb;i++) {nomcmd[i]=ncmd[i];}
   l    = (long) lnom1;
   ncmd = nom1;
   if (l != 0) {
     for (i=0;i<l;i++) {nomcmd[i+ldeb]=ncmd[i];}
     i=l-1;
     while (ncmd[i] == ' ') {i--;}
     nomcmd[i+ldeb+1] =' ';
     ldeb = ldeb+i+1;
   } else {
     i=0;
     while (ncmd[i] != ' ') { nomcmd[i+ldeb] = ncmd[i];i++;}
     nomcmd[i+ldeb] =' ';
     ldeb = ldeb+i-1;
   }
   nomcmd[ldeb+1]= ' ';
   ldeb = ldeb+1;
   l    = (long) lnom2;
   ncmd = nom2;
   if (l != 0) {
     for (i=0;i<l;i++) {nomcmd[i+ldeb]=ncmd[i];}
     i=l-1;
     while (ncmd[i] == ' ') {i--;}
     nomcmd[i+ldeb+1] ='\0';
   } else {
     i=0;
     while (ncmd[i] != ' ') { nomcmd[i+ldeb] = ncmd[i];i++;}
     nomcmd[i+ldeb] ='\0';
   }

   fprintf(stdout,"\n\nLancement de la commande ->%s<-\n\n",nomcmd);
   ier=system(nomcmd);
   if ( ier == -1 ) {
        perror("\n<cpfile> code retour system");
   } 
#ifdef _WINDOWS
   num = _flushall();
#else
   num = fflush(stderr);
   num = fflush(stdout);
#endif

}
