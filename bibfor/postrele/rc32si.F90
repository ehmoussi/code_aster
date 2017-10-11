! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------

subroutine rc32si()
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterfort/wkvect.h"
#include "asterfort/getvis.h"
#include "asterfort/getvid.h"
#include "asterfort/utmess.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/jemarq.h"
#include "asterfort/jedema.h"

!     OPERATEUR POST_RCCM, TRAITEMENT DE FATIGUE B3200 et ZE200
!     RECUPERATION DES DONNEES DU MOT CLE "SITUATION"
!
!     ------------------------------------------------------------------
    integer :: nb, ndim, jinfo, iocc, nume, n1, i, numgr(20), nbocc, ibid
    integer :: jnom, jinfor, chara, charb, ns, jinfos, jnoms, jcombi, k
    integer :: numgr1(20), iocc1, numgr2(20), iocc2, nbgrpass, grpass(20)
    integer :: nbgr, i1, i2, numgr1p, numgr2p, i3, i4, jpassage, compteur
    integer :: jpartage, k1, k2, n2, nbocc1, nbocc2
    real(kind=8) :: presa, presb, tempa, tempb
    character(len=8) :: ouinon
    character(len=16) :: nom, cbid
    aster_logical :: passok, partageok, dejapass
!
! DEB ------------------------------------------------------------------
!
    call jemarq()
!
!----------------------------------------------------------------------
!-----------------------TRAITEMENT DU MOT CLE SITUATION----------------
!----------------------------------------------------------------------

    call getfac('SITUATION', nb)
!
! CREATION D'UN TABLEAU QUI CONTIENT LES INFOS TYPE ENTIER DE CHAQUE
! SITUATION (NUMERO, NUMEROS DE GROUPE(MAX 20), NBOCCUR, FORMAT PRESSION,
!       FORMAT MECA, CHAR_ETAT_A, CHAR_ETAT_B, FORMAT THERMIQUE)
!
    ndim = 27*nb
    call wkvect('&&RC3200.SITU_INFOI', 'V V I', ndim, jinfo) 
!
    do 10 iocc = 1, nb , 1
!
!------ on récupère le numéro de situation
        call getvis('SITUATION', 'NUME_SITU', iocc=iocc, scal=nume, nbret=n1)
        zi(jinfo+27*(iocc-1)) = nume
!
!------ verif : deux situations ne peuvent avoir le même numéro
        do 20 i = 1, iocc-1
            if (nume .eq. zi(jinfo+27*(i-1))) call utmess('F', 'POSTRCCM_48')
20      continue
!
!------ on récupère le ou les groupes de la situation
        do 25 i = 1, 20
            zi(jinfo+27*(iocc-1)+i)= 0
25      continue
        call getvis('SITUATION', 'NUME_GROUPE', iocc = iocc, nbval=0, nbret=n1)
        nbgr = -n1
        call getvis('SITUATION', 'NUME_GROUPE', iocc = iocc, nbval=nbgr, vect=numgr, nbret=n1)
        do 26 i = 1, nbgr
            zi(jinfo+27*(iocc-1)+i)= numgr(i)
            if(numgr(i) .le. 0) call utmess('F', 'POSTRCCM_12')
26      continue
!
!------ on récupère le nombre d'occurences de la situation
        call getvis('SITUATION', 'NB_OCCUR', iocc=iocc, scal=nbocc, nbret=n1)
        zi(jinfo+27*(iocc-1)+21) = nbocc
!
!------ on regarde si la pression est sous forme unitaire ou transitoire
        zi(jinfo+27*(iocc-1)+22) = 0
        call getvr8('SITUATION', 'PRES_A', iocc=iocc, scal=presa, nbret=n1)
        if (n1 .ne. 0) zi(jinfo+27*(iocc-1)+22) = 1
        call getvis('SITUATION', 'NUME_RESU_PRES', iocc=iocc, scal=ibid, nbret=n1)
        if (n1 .ne. 0) zi(jinfo+27*(iocc-1)+22) = 2
!
!------ on regarde si la méca est sous forme unitaire ou transitoire 
!------ ou moments interpolés sur la température
        zi(jinfo+27*(iocc-1)+23) = 0
        zi(jinfo+27*(iocc-1)+24) = 0
        zi(jinfo+27*(iocc-1)+25) = 0
        call getvis('SITUATION', 'CHAR_ETAT_A', iocc=iocc, scal=chara, nbret=n1)
        if (n1 .ne. 0) then 
            zi(jinfo+27*(iocc-1)+23) = 1
            zi(jinfo+27*(iocc-1)+24) = chara
            call getvis('SITUATION', 'CHAR_ETAT_B', iocc=iocc, scal=charb, nbret=n1)
            zi(jinfo+27*(iocc-1)+25) = charb
        endif
        call getvis('SITUATION', 'NUME_RESU_MECA', iocc=iocc, scal=ibid, nbret=n1)
        if (n1 .ne. 0) zi(jinfo+27*(iocc-1)+23) = 2
        call getvr8('SITUATION', 'TEMP_A', iocc=iocc, scal=tempa, nbret=n1)
        if (n1 .ne. 0) zi(jinfo+27*(iocc-1)+23) = 3
!
!------ on regarde si la thermique est sous forme transitoire
        zi(jinfo+27*(iocc-1)+26) = 0
        call getvis('SITUATION', 'NUME_RESU_THER', iocc=iocc, scal=ibid, nbret=n1)
        if (n1 .ne. 0) zi(jinfo+27*(iocc-1)+26) = 1
!
10  continue
!
! CREATION D'UN TABLEAU QUI CONTIENT LES INFOS TYPE CARACTERE DE CHAQUE
!                             SITUATION (NOM)
!
    ndim = nb
    call wkvect('&&RC3200.SITU_NOM', 'V V K16', ndim, jnom) 
!
    do 30 iocc = 1, nb , 1
!
!------ on récupère le nom de situation
        call getvtx('SITUATION', 'NOM_SITU', iocc=iocc, scal=nom, nbret=n1)
        if (n1 .ne. 0) then      
            zk16(jnom+iocc-1) = nom
        else
            zk16(jnom+iocc-1) = 'PAS DE NOM'
        endif         
!
30  continue
!
! CREATION D'UN TABLEAU QUI CONTIENT LES INFOS TYPE REELS DE CHAQUE
!            SITUATION (PRES_A, PRES_B, TEMP_A, TEMP_B)
!
    ndim = nb*4
    call wkvect('&&RC3200.SITU_INFOR', 'V V R', ndim, jinfor) 
!
    do 40 iocc = 1, nb , 1
!
!------ on récupère pres_a et pres_b
        zr(jinfor+4*(iocc-1)) = 0.d0
        zr(jinfor+4*(iocc-1)+1) = 0.d0
        call getvr8('SITUATION', 'PRES_A', iocc=iocc, scal=presa, nbret=n1)
        if (n1 .ne. 0) zr(jinfor+4*(iocc-1)) = presa         
        call getvr8('SITUATION', 'PRES_B', iocc=iocc, scal=presb, nbret=n1)
        if (n1 .ne. 0) zr(jinfor+4*(iocc-1)+1) = presb  
        zr(jinfor+4*(iocc-1)+2) = 0.d0
        zr(jinfor+4*(iocc-1)+3) = 0.d0
        call getvr8('SITUATION', 'TEMP_A', iocc=iocc, scal=tempa, nbret=n1)
        if (n1 .ne. 0) zr(jinfor+4*(iocc-1)+2) = tempa         
        call getvr8('SITUATION', 'TEMP_B', iocc=iocc, scal=tempb, nbret=n2)
        if (n2 .ne. 0) zr(jinfor+4*(iocc-1)+3) = tempb
        if(n1 .ne. 0 .and. n2 .ne. 0) then
         if (abs(tempa-tempb) .lt. 1.0d-08) call utmess('F', 'POSTRCCM_47')
        endif         
!
40  continue
!----------------------------------------------------------------------
!---------------------------TRAITEMENT DU MOT CLE SEISME---------------
!----------------------------------------------------------------------
    call getfac('SEISME', ns)
    if (ns .eq. 0) goto 999
!
! CREATION D'UN TABLEAU QUI CONTIENT LES INFOS TYPE ENTIER DU SEISME
!          (NUMERO, NBCYCL, NBOCCUR, FORMAT MECA, CHAR_ETAT)
!
    ndim = 5
    call wkvect('&&RC3200.SEIS_INFOI', 'V V I', ndim, jinfos) 
!
!-- on récupère le numéro de situation du séisme
    call getvis('SEISME', 'NUME_SITU', iocc=1, scal=nume, nbret=n1)
    zi(jinfos) = nume
!
!-- verif : le séisme ne peut avoir le même numéro qu'une autre situation
    do 41 i = 1, nb
        if (nume .eq. zi(jinfo+27*(i-1))) call utmess('F', 'POSTRCCM_48')
41  continue
!
!-- on récupère le nbcycl du séisme
    call getvis('SEISME', 'NB_CYCL_SEISME', iocc=1, scal=nume, nbret=n1)
    zi(jinfos+1) = nume
!
!-- on récupère le nombre d'occurences du séisme
    call getvis('SEISME', 'NB_OCCUR', iocc=1, scal=nbocc, nbret=n1)
    zi(jinfos+2) = nbocc
!
!-- on regarde si la méca est sous forme unitaire ou 6 tables
    zi(jinfos+3) = 0
    zi(jinfos+4) = 0
    call getvis('SEISME', 'CHAR_ETAT', iocc=1, scal=chara, nbret=n1)
    if (n1 .ne. 0) then 
        zi(jinfos+3) = 1
        zi(jinfos+4) = chara
    endif
    call getvid('SEISME', 'TABL_FX', iocc=1, scal=cbid, nbret=n1)
    if (n1 .ne. 0) zi(jinfos+3) = 2
!
! CREATION D'UN TABLEAU QUI CONTIENT LES INFOS TYPE CARACTERE DU SEISME (NOM)
!
    call wkvect('&&RC3200.SEIS_NOM', 'V V K16', 1, jnoms) 
!
    call getvtx('SEISME', 'NOM_SITU', iocc=1, scal=nom, nbret=n1)
    if (n1 .ne. 0) then      
        zk16(jnoms) = nom
    else
        zk16(jnoms) = 'PAS DE NOM'
    endif         
!
999 continue
!
!----------------------------------------------------------------------
!--------------------SITUATIONS COMBINABLES ENTRE ELLES----------------
!----------------------------------------------------------------------
!
! CREATION D'UN TABLEAU DE DIMENSION NBSITU*NBSITU QUI CONTIENT UN ENTIER 
! CET ENTIER EST NUL SI LES SITUATIONS NE SONT PAS COMBINABLES ENTRE ELLES
! IL VAUT 1 SI LES DEUX SITUATIONS SONT DANS LE MEME GROUPE OU BIEN RELIEES
! PAR UNE SITUATION DE PASSAGE
    ndim = nb*nb
    call wkvect('&&RC3200.COMBI', 'V V I', ndim, jcombi) 
    do 50 k = 1, ndim
        zi(jcombi-1+k) = 0
50  continue
!
! -- deux situations sont combinables si elles sont dans le même groupe
! -- et on ne remplit que au dessus de la diagonale le tableau qui est symétrique
    do 60 iocc1 = 1, nb-1
        do 61 i1 = 1,20
          numgr1(i1) = zi(jinfo+27*(iocc1-1)+i1)
61      continue
        do 70 iocc2 = iocc1+1, nb
            do 71 i2 = 1,20
              numgr2(i2) = zi(jinfo+27*(iocc2-1)+i2)
71          continue
            do 72 i1 = 1, 20
                do 73 i2 = 1,20
                    if(numgr1(i1) .ne. 0 .and. numgr2(i2) .ne. 0) then    
                        if (numgr2(i2) .eq. numgr1(i1)) zi(jcombi+nb*(iocc1-1)+iocc2-1) = 1
                    endif
73              continue
72          continue
70      continue
60  continue
!
! -- on traite les situations de passage
    ndim = 3*nb*nb*nb
    call wkvect('&&RC3200.PASSAGE', 'V V I', ndim, jpassage) 
    do 92 i = 1,ndim
        zi(jpassage-1+i) = 0
92  continue
    do 95 i = 1,20
        grpass(i) = 0
95  continue
    compteur =0
    do 96 iocc = 1, nb
      call getvis('SITUATION', 'NUME_PASSAGE', iocc = iocc, nbval=0, nbret=n1)
      if(n1 .ne. 0) then
!
        nbgrpass = -n1
        call getvis('SITUATION', 'NUME_PASSAGE', iocc = iocc, nbval=nbgrpass,&
                     vect=grpass, nbret=n1)
! -- on vérifie que la situation fait bien partie des groupes qu'elle relie
        do 97 i1 = 1, nbgrpass
          if (grpass(i1) .eq. 0) call utmess('F', 'POSTRCCM_34')
          passok = .false.
          do 98 i2=1,20
            if (zi(jinfo+27*(iocc-1)+i2) .eq. grpass(i1)) passok = .true.
98        continue
          if (.not. passok) call utmess('F', 'POSTRCCM_34')
97      continue
        do 101 i1 = 1, nbgrpass-1
          numgr1p = grpass(i1) 
          do 102 i2 = i1+1, nbgrpass
            numgr2p = grpass(i2)
            if(numgr1p .eq. numgr2p) call utmess('F', 'POSTRCCM_34')
!
            do 103 iocc1 = 1, nb-1
              do 104 i3 = 1,20
                numgr1(i3) = zi(jinfo+27*(iocc1-1)+i3)
104           continue
              do 105 iocc2 = iocc1+1, nb
                dejapass = .false.
                do 106 i4 = 1,20
                  numgr2(i4) = zi(jinfo+27*(iocc2-1)+i4)
106             continue
                do 107 i3 = 1, 20
                  do 108 i4 = 1,20                   
                    if(numgr1(i3) .ne. 0 .and. numgr2(i4) .ne. 0) then    
                      if (numgr1(i3) .eq. numgr1p .and. numgr2(i4) .eq. numgr2p &
                        .and. zi(jcombi+nb*(iocc1-1)+iocc2-1) .ne. 1 .and. .not. dejapass) then
                        dejapass = .true.
                        zi(jcombi+nb*(iocc1-1)+iocc2-1) = 2
                        zi(jpassage+3*compteur)=iocc
                        zi(jpassage+3*compteur+1)=iocc1
                        zi(jpassage+3*compteur+2)=iocc2
                        compteur = compteur +1
!
                        if (compteur .ge. nb*nb*nb) call utmess('F', 'POSTRCCM_34')
                      endif
                      if (numgr1(i3) .eq. numgr2p .and. numgr2(i4) .eq. numgr1p &
                        .and. zi(jcombi+nb*(iocc1-1)+iocc2-1) .ne. 1 .and. .not. dejapass) then
                        dejapass = .true.
                        zi(jcombi+nb*(iocc1-1)+iocc2-1) = 2
                        zi(jpassage+3*compteur)=iocc
                        zi(jpassage+3*compteur+1)=iocc1
                        zi(jpassage+3*compteur+2)=iocc2
                        compteur = compteur +1
                        if (compteur .ge. nb*nb*nb) call utmess('F', 'POSTRCCM_34')
                      endif
                    endif
108               continue
107             continue
105           continue
103         continue
102       continue
101     continue
!
      endif
96  continue
!
! -- on traite les situations combinables avec elle même seulement
    do 80 iocc1 = 1, nb
        call getvtx('SITUATION', 'COMBINABLE', iocc=iocc1, scal=ouinon, nbret=n1)
        if (n1 .ne. 0 .and. ouinon .eq. 'NON') then
          do 90 iocc2 = 1, nb
            if(iocc2 .ne. iocc1) then
              zi(jcombi+nb*(iocc1-1)+iocc2-1) = 0
              zi(jcombi+nb*(iocc2-1)+iocc1-1) = 0
            endif
90        continue
        endif
80  continue
!
!----------------------------------------------------------------------
!-------------------- GROUPES DE PARTAGE ------------------------------
!----------------------------------------------------------------------
!
    ndim = 1*nb
    call wkvect('&&RC3200.PARTAGE', 'V V I', ndim, jpartage) 
    do 110 k = 1, ndim
        zi(jpartage-1+k) = 0
110  continue
!
    do 120 iocc = 1, nb , 1
!
!------ on récupère le numéro du groupe de partage
        call getvis('SITUATION', 'NUME_PARTAGE', iocc=iocc, scal=nume, nbret=n1)
        if(n1 .ne. 0) then
            if (nume .le. 0) call utmess('F', 'POSTRCCM_53')
            zi(jpartage-1+iocc) = nume
            nbocc1 = zi(jinfo+27*(iocc-1)+21)
!
!------ verif : deux situations du même groupe de partage doivent appartenir au 
!------ même groupe de fonctionnement et avoir le même nombre d'occurence initial
            do 130 i = 1, iocc-1
                if (nume .eq. zi(jpartage-1+i)) then
                    nbocc2 = zi(jinfo+27*(i-1)+21)
                    if(nbocc1 .ne. nbocc2) call utmess('A', 'POSTRCCM_53')
                    partageok = .false.
                    do 136 k1 = 1, 20
                        numgr1(k1)= zi(jinfo+27*(iocc-1)+k1)
                        do 137 k2 = 1,20
                            numgr2(k2)= zi(jinfo+27*(i-1)+k2)
                            if (numgr1(k1) .eq. numgr2(k2) .and. numgr1(k1) .ne. 0) then
                                partageok =.true.
                            endif
137                     continue
136                 continue
                    if(.not. partageok) call utmess('A', 'POSTRCCM_53')
                endif
130          continue

        endif
120 continue
!
    call jedema()
!
end subroutine
