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

subroutine rc32fact(ze200, nb, lieu, ns, fuseism, futot, lefat, futotenv)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jemarq.h"
#include "asterfort/jedema.h"
#include "asterfort/jeveuo.h"
#include "asterfort/wkvect.h"
#include "asterfort/jedetr.h"
#include "asterc/r8vide.h"
#include "asterfort/utmess.h"
#include "asterfort/rc32s0.h"
#include "asterfort/rcZ2s0.h"
#include "asterfort/rc32env.h"
#include "asterfort/rc32sa.h"
    character(len=4) :: lieu
    integer :: nb, ns
    real(kind=8) :: fuseism, futot, futotenv
    aster_logical :: ze200, lefat
!
!     OPERATEUR POST_RCCM, TRAITEMENT DE FATIGUE ZE200 et B3200
!     CALCUL DU FACTEUR D'USAGE TOTAL
!
!     ------------------------------------------------------------------
! IN  : NB     : nombre de situations
! IN  : LIEU   : ='ORIG' : ORIGINE DU SEGMENT, ='EXTR' : EXTREMITE
! IN  : NS     : =0 : PAS DE SEISME, =1 : SEISME
! OUT : FUTOT
!
    integer :: jresu, jresucomb, jresus, jresucombs, ndim, jfu, jocc
    integer :: iocc1, iocc2, num1, num2, jinfo, noccpris, jfact, i, k
    integer :: jfus, jinfos, noccs, nbsscyc, jcombi, jpassage, jpartage
    integer :: numpass, noccpass, num, iocc3
    real(kind=8) :: fumax, fumaxs, m0(12), pres0, st0(6), sns
    real(kind=8) :: sps(2), rbid, fus(2), sbid(2), fumaxpass, fucible
    real(kind=8) :: futotss
!
! DEB ------------------------------------------------------------------
    call jemarq()
!
    futot = 0.d0
    futotss = 0.d0
    fuseism = 0.d0

! - CREATION D'UNE MATRICE DES FACTEURS D'USAGE ELEMENTAIRES
    call jeveuo('&&RC3200.SITU_RESU.'//lieu, 'L', jresu) 
    call jeveuo('&&RC3200.COMB_RESU.'//lieu, 'L', jresucomb)
    call jeveuo('&&RC3200.COMBI', 'L', jcombi)
    call jeveuo('&&RC3200.PARTAGE', 'L', jpartage)
    ndim = nb*nb
    call wkvect('RC3200.FU', 'V V R', ndim, jfu) 
    do 10 iocc1 = 1, ndim
        zr(jfu+iocc1-1) = r8vide()
10 continue
    do 20 iocc1 = 1, nb
        do 30 iocc2 = 1, nb
! --------- on y rentre les facteurs d'usage pour les combinaisons de situations 
! --------- si la combinaison n'est pas possible zr(jresucomb) vaut r8vide et la 
! --------- matrice qui est symétrique n'est remplie que au dessus de la diagonale
            zr(jfu+nb*(iocc1-1)+iocc2-1) = zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+17)
30      continue
! ----- on y rentre les facteurs d'usage pour les situations seules
        zr(jfu+(nb+1)*(iocc1-1))= zr(jresu+121*(iocc1-1)+15)
20  continue
!
! - CREATION D'UN VECTEUR AVEC LES NOMBRES D'OCCURENCES
    call wkvect('RC3200.NBOCC', 'V V I', nb, jocc) 
    call jeveuo('&&RC3200.SITU_INFOI', 'L', jinfo)
    do 40 iocc1 = 1, nb
        zi(jocc+iocc1-1) = zi(jinfo+27*(iocc1-1)+21)
40 continue
!
! - CREATION D'UN VECTEUR AVEC LES COMBINAISONS (OU SITUATIONS)
! - QUI INTERVIENNENT DANS FU_TOTAL (LIGNE FACT DU .RESU)
! - NUM1, NUM2, NOCC PRIS
    ndim = 6*200
    call wkvect('&&RC3200.FACT.'//lieu, 'V V I', ndim, jfact) 
    do 50 i = 1, ndim
        zi(jfact+i-1) = 0
50 continue
!---------------------------------------------------
! - CALCUL DU FACTEUR D'USAGE SI SEISME
!---------------------------------------------------
    k = 0
!
    if(ns .eq. 0) goto 888
!
    call jeveuo('&&RC3200.SITUS_RESU.'//lieu, 'L', jresus) 
    call jeveuo('&&RC3200.COMBS_RESU.'//lieu, 'L', jresucombs)
    call jeveuo('&&RC3200.SEIS_INFOI', 'L', jinfos)
    noccs = int(zi(jinfos+2)/2) 
    nbsscyc = 2*zi(jinfos+1)-1
!
    ndim = nb*nb
    call wkvect('RC3200.FUS', 'V V R', ndim, jfus) 
    do 60 iocc1 = 1, ndim
        zr(jfus+iocc1-1) = r8vide()
60  continue
!
!---- CALCUL DU FU(S)
    sns = 0.d0
    sps(1) = 0.d0
    sps(2) = 0.d0
    if(ze200) then
        do 62 i = 1, 12
            m0(i) =0.d0
62      continue
        pres0 = 0.d0
        call rcZ2s0('SN', m0, m0, pres0, pres0, 1, sns) 
        call rcZ2s0('SP', m0, m0, pres0, pres0, 1, sps(1))
    else
        do 65 i = 1, 6
            st0(i) =0.d0
65      continue
        call rc32s0('SNSN', st0, lieu, sns)
        call rc32s0('SPSP', st0, lieu, sps(1))
    endif
    call rc32sa('SITU', sns, sps, sps, rbid, rbid, sbid, fus)
    fuseism = fus(1)*nbsscyc
!
    do 70 iocc1 = 1, nb
        do 80 iocc2 = 1, nb
! --------- on y rentre les facteurs d'usage pour les combinaisons de situations 
! --------- en prenant en compte le séisme
! --------- si la combinaison n'est pas possible zr(jresucomb) vaut r8vide et la 
! --------- matrice qui est symétrique n'est remplie que au dessus de la diagonale
            zr(jfus+nb*(iocc1-1)+iocc2-1) = zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+17)&
                                            +fuseism
80      continue
! ------- on y rentre les facteurs d'usage pour les situations seules avec le séisme
        zr(jfus+(nb+1)*(iocc1-1))= zr(jresus+121*(iocc1-1)+15)+fuseism
70  continue
!     
! -- on cherche le fumaxs avec séisme
!
777 continue
!
    fumaxs = -1.d0
    do 90 iocc1 = 1, nb
        do 100 iocc2 = 1, nb
            if(zr(jfus+nb*(iocc1-1)+iocc2-1) .ne. r8vide()) then
              if(zr(jfus+nb*(iocc1-1)+iocc2-1) .gt. fumaxs) then
                  fumaxs = zr(jfus+nb*(iocc1-1)+iocc2-1)
                  num1 = iocc1
                  num2 = iocc2
              endif
            endif 
100     continue
90  continue
!
    if (fumaxs .lt. 0) goto 888
!
!-- si il n'y a pas de situation de passage
!--------------------------------------------------------------------------------
    if(zi(jcombi+nb*(num1-1)+num2-1) .ne. 2) then
      noccpris = min(zi(jocc+num1-1), zi(jocc+num2-1), noccs)
      if(noccpris .gt. 0) then
        futot=futot+fumaxs*noccpris
        if(num1 .eq. num2) then
            futotss = futotss+noccpris*zr(jresus+121*(num1-1)+120)
        else
            futotss = futotss+noccpris*zr(jresucombs+20*nb*(num1-1)+20*(num2-1)-1+20)
        endif
        zi(jfact+6*k) = num1
        zi(jfact+6*k+1) = num2
        zi(jfact+6*k+2) = zi(jocc+num1-1)
        zi(jfact+6*k+3) = zi(jocc+num2-1)
        zi(jfact+6*k+4) = noccpris
        zi(jfact+6*k+5) = 2
!
        zi(jocc+num1-1) = zi(jocc+num1-1)-noccpris
        if (num1 .ne. num2) zi(jocc+num2-1) = zi(jocc+num2-1)-noccpris
        noccs = noccs - noccpris
!-- on vérifie si les deux situations ne font pas partie d'un groupe de partage
        if(zi(jpartage-1+num1) .ne. 0) then
            do 101 iocc3 = 1,nb
                if(zi(jpartage-1+num1) .eq. zi(jpartage-1+iocc3)) then
                    if(num1 .ne. iocc3) zi(jocc+iocc3-1) = zi(jocc+iocc3-1)-noccpris
                endif
101         continue
        endif
!
        if(num1 .ne. num2 .and. zi(jpartage-1+num2) .ne. 0) then
            do 102 iocc3 = 1,nb
                if(zi(jpartage-1+num2) .eq. zi(jpartage-1+iocc3)) then
                    if(num2 .ne. iocc3) zi(jocc+iocc3-1) = zi(jocc+iocc3-1)-noccpris
                endif
102         continue
        endif
!
        k = k+1
        if(k .eq. 200) call utmess('F', 'POSTRCCM_52')
        if (noccs .le. 0) goto 888 
      endif
!
      zr(jfus+nb*(num1-1)+num2-1) = r8vide()
      goto 777
!
!-- si les situations sont reliées par une de situation de passage
!--------------------------------------------------------------------------------
    else
!
!---- on cherche la situation de passage
!---- (si plusieurs, on prend celle qui donne le fumin par ailleurs)
      fucible = 1000000.d0
      noccpass = 0
      ndim = nb*nb*nb
      call jeveuo('&&RC3200.PASSAGE', 'L', jpassage)
      do 103 i = 1,ndim
!
        fumaxpass = -1.d0
        if(zi(jpassage+3*(i-1)) .eq. 0) goto 555 
        if(zi(jpassage+3*(i-1)+1) .eq. num1 .and. zi(jpassage+3*(i-1)+2) .eq. num2) then
!
            num = zi(jpassage+3*(i-1))
            if(zi(jocc+num-1) .gt. 0) then
              do 104 iocc1 = 1, nb
                if(zr(jfus+nb*(iocc1-1)+num-1) .ne. r8vide()) then
                  fumaxpass = max(fumaxpass,zr(jfus+nb*(iocc1-1)+num-1))
                endif 
104           continue
              do 105 iocc1 = 1, nb
                if(zr(jfus+nb*(num-1)+iocc1-1) .ne. r8vide()) then
                  fumaxpass = max(fumaxpass,zr(jfus+nb*(num-1)+iocc1-1))
                endif 
105           continue
!
              if(fumaxpass .lt. fucible) then
                fucible = fumaxpass
                noccpass = zi(jocc+num-1)
                numpass = zi(jpassage+3*(i-1))
              endif
            endif
!
        endif
        if(zi(jpassage+3*(i-1)+1) .eq. num2 .and. zi(jpassage+3*(i-1)+2) .eq. num1) then
!
            num = zi(jpassage+3*(i-1))
            if(zi(jocc+num-1) .gt. 0) then
              do 106 iocc1 = 1, nb
                if(zr(jfus+nb*(iocc1-1)+num-1) .ne. r8vide()) then
                  fumaxpass = max(fumaxpass,zr(jfus+nb*(iocc1-1)+num-1))
                endif 
106           continue
              do 107 iocc1 = 1, nb
                if(zr(jfus+nb*(num-1)+iocc1-1) .ne. r8vide()) then
                  fumaxpass = max(fumaxpass,zr(jfus+nb*(num-1)+iocc1-1))
                endif 
107           continue
!
              if(fumaxpass .lt. fucible) then
                fucible = fumaxpass
                noccpass = zi(jocc+num-1)
                numpass = zi(jpassage+3*(i-1))
              endif
            endif
!
        endif
103   continue
555 continue
!
      noccpris =  min(noccpass, zi(jocc+num1-1), zi(jocc+num2-1), noccs) 
      if(noccpris .gt. 0) then
        futot=futot+fumaxs*noccpris
        if(num1 .eq. num2) then
            futotss = futotss+noccpris*zr(jresus+121*(num1-1)+120)
        else
            futotss = futotss+noccpris*zr(jresucombs+20*nb*(num1-1)+20*(num2-1)-1+20)
        endif
        zi(jfact+6*k) = num1
        zi(jfact+6*k+1) = num2
        zi(jfact+6*k+2) = zi(jocc+num1-1)
        zi(jfact+6*k+3) = zi(jocc+num2-1)
        zi(jfact+6*k+4) = noccpris
        zi(jfact+6*k+5) = 2
!
        zi(jocc+num1-1) = zi(jocc+num1-1)-noccpris
        zi(jocc+num2-1) = zi(jocc+num2-1)-noccpris
        zi(jocc+numpass-1) = zi(jocc+numpass-1)-noccpris
        noccs = noccs -noccpris
!
!-- on vérifie si les deux situations ne font pas partie d'un groupe de partage
        if(zi(jpartage-1+num1) .ne. 0) then
            do 108 iocc3 = 1,nb
                if(zi(jpartage-1+num1) .eq. zi(jpartage-1+iocc3)) then
                    if(num1 .ne. iocc3) zi(jocc+iocc3-1) = zi(jocc+iocc3-1)-noccpris
                endif
108         continue
        endif
!
        if(num1 .ne. num2 .and. zi(jpartage-1+num2) .ne. 0) then
            do 109 iocc3 = 1,nb
                if(zi(jpartage-1+num2) .eq. zi(jpartage-1+iocc3)) then
                    if(num2 .ne. iocc3) zi(jocc+iocc3-1) = zi(jocc+iocc3-1)-noccpris
                endif
109         continue
        endif
!
        k = k+1
        if(k .eq. 200) call utmess('F', 'POSTRCCM_52')
        if (noccs .le. 0) goto 888 
        goto 777
      endif
!
      zr(jfus+nb*(num1-1)+num2-1) = r8vide()
      goto 777
!
    endif
!
!---------------------------------------------------
! - CALCUL DU FACTEUR D'USAGE SI PAS DE SEISME
!---------------------------------------------------
!
888 continue
!
    fumax = -1.d0
    do 110 iocc1 = 1, nb
        do 120 iocc2 = 1, nb
            if(zr(jfu+nb*(iocc1-1)+iocc2-1) .ne. r8vide()) then
                if(zr(jfu+nb*(iocc1-1)+iocc2-1) .gt. fumax) then
                  fumax = zr(jfu+nb*(iocc1-1)+iocc2-1)
                  num1 = iocc1
                  num2 = iocc2
                endif
            endif 
120     continue
110 continue
!
    if (fumax .lt. 0) goto 999
!
!-- si il n'y a pas de situation de passage
!--------------------------------------------------------------------------------
    if(zi(jcombi+nb*(num1-1)+num2-1) .ne. 2) then
      noccpris = min(zi(jocc+num1-1), zi(jocc+num2-1))
      if(noccpris .gt. 0) then
        futot=futot+fumax*noccpris
        if(num1 .eq. num2) then
            futotss = futotss+noccpris*zr(jresu+121*(num1-1)+120)
        else
            futotss = futotss+noccpris*zr(jresucomb+20*nb*(num1-1)+20*(num2-1)-1+20)
        endif
        zi(jfact+6*k) = num1
        zi(jfact+6*k+1) = num2
        zi(jfact+6*k+2) = zi(jocc+num1-1)
        zi(jfact+6*k+3) = zi(jocc+num2-1)
        zi(jfact+6*k+4) = noccpris
        zi(jfact+6*k+5) = 1
!
        zi(jocc+num1-1) = zi(jocc+num1-1)-noccpris
        if (num1 .ne. num2) zi(jocc+num2-1) = zi(jocc+num2-1)-noccpris
!
!-- on vérifie si les deux situations ne font pas partie d'un groupe de partage
        if(zi(jpartage-1+num1) .ne. 0) then
            do 121 iocc3 = 1,nb
                if(zi(jpartage-1+num1) .eq. zi(jpartage-1+iocc3)) then
                    if(num1 .ne. iocc3) zi(jocc+iocc3-1) = zi(jocc+iocc3-1)-noccpris
                endif
121         continue
        endif
!
        if(num1 .ne. num2 .and. zi(jpartage-1+num2) .ne. 0) then
            do 122 iocc3 = 1,nb
                if(zi(jpartage-1+num2) .eq. zi(jpartage-1+iocc3)) then
                    if(num2 .ne. iocc3) zi(jocc+iocc3-1) = zi(jocc+iocc3-1)-noccpris
                endif
122         continue
        endif
!
        k = k+1
        if(k .eq. 200) call utmess('F', 'POSTRCCM_52')
      endif
      zr(jfu+nb*(num1-1)+num2-1) = r8vide()
      goto 888
!
!-- si les situations sont reliées par une de situation de passage
!--------------------------------------------------------------------------------
    else
!
!---- on cherche la situation de passage
!---- (si plusieurs, on prend celle qui donne le fumin par ailleurs)
      fucible = 1000000.d0
      noccpass = 0
      ndim = nb*nb*nb
      call jeveuo('&&RC3200.PASSAGE', 'L', jpassage)
      do 130 i = 1,ndim
!
        fumaxpass = -1.d0
        if(zi(jpassage+3*(i-1)) .eq. 0) goto 666 
        if(zi(jpassage+3*(i-1)+1) .eq. num1 .and. zi(jpassage+3*(i-1)+2) .eq. num2) then
!
            num = zi(jpassage+3*(i-1))
            if(zi(jocc+num-1) .gt. 0) then
              do 131 iocc1 = 1, nb
                if(zr(jfu+nb*(iocc1-1)+num-1) .ne. r8vide()) then
                  fumaxpass = max(fumaxpass,zr(jfu+nb*(iocc1-1)+num-1))
                endif 
131           continue
              do 132 iocc1 = 1, nb
                if(zr(jfu+nb*(num-1)+iocc1-1) .ne. r8vide()) then
                  fumaxpass = max(fumaxpass,zr(jfu+nb*(num-1)+iocc1-1))
                endif 
132           continue
!
              if(fumaxpass .lt. fucible) then
                fucible = fumaxpass
                noccpass = zi(jocc+num-1)
                numpass = zi(jpassage+3*(i-1))
              endif
            endif
!
        endif
        if(zi(jpassage+3*(i-1)+1) .eq. num2 .and. zi(jpassage+3*(i-1)+2) .eq. num1) then
!
            num = zi(jpassage+3*(i-1))
            if(zi(jocc+num-1) .gt. 0) then
              do 133 iocc1 = 1, nb
                if(zr(jfu+nb*(iocc1-1)+num-1) .ne. r8vide()) then
                  fumaxpass = max(fumaxpass,zr(jfu+nb*(iocc1-1)+num-1))
                endif 
133           continue
              do 134 iocc1 = 1, nb
                if(zr(jfu+nb*(num-1)+iocc1-1) .ne. r8vide()) then
                  fumaxpass = max(fumaxpass,zr(jfu+nb*(num-1)+iocc1-1))
                endif 
134           continue
!
              if(fumaxpass .lt. fucible) then
                fucible = fumaxpass
                noccpass = zi(jocc+num-1)
                numpass = zi(jpassage+3*(i-1))
              endif
            endif
!
        endif
130   continue
666 continue
!
      noccpris =  min(noccpass, zi(jocc+num1-1), zi(jocc+num2-1)) 
      if(noccpris .gt. 0) then
        futot=futot+fumax*noccpris
        if(num1 .eq. num2) then
            futotss = futotss+noccpris*zr(jresu+121*(num1-1)+120)
        else
            futotss = futotss+noccpris*zr(jresucomb+20*nb*(num1-1)+20*(num2-1)-1+20)
        endif
        zi(jfact+6*k) = num1
        zi(jfact+6*k+1) = num2
        zi(jfact+6*k+2) = zi(jocc+num1-1)
        zi(jfact+6*k+3) = zi(jocc+num2-1)
        zi(jfact+6*k+4) = noccpris
        zi(jfact+6*k+5) = 1
!
        zi(jocc+num1-1) = zi(jocc+num1-1)-noccpris
        zi(jocc+num2-1) = zi(jocc+num2-1)-noccpris
        zi(jocc+numpass-1) = zi(jocc+numpass-1)-noccpris
!
!-- on vérifie si les deux situations ne font pas partie d'un groupe de partage
        if(zi(jpartage-1+num1) .ne. 0) then
            do 140 iocc3 = 1,nb
                if(zi(jpartage-1+num1) .eq. zi(jpartage-1+iocc3)) then
                    if(num1 .ne. iocc3) zi(jocc+iocc3-1) = zi(jocc+iocc3-1)-noccpris
                endif
140         continue
        endif
!
        if(num1 .ne. num2 .and. zi(jpartage-1+num2) .ne. 0) then
            do 150 iocc3 = 1,nb
                if(zi(jpartage-1+num2) .eq. zi(jpartage-1+iocc3)) then
                    if(num2 .ne. iocc3) zi(jocc+iocc3-1) = zi(jocc+iocc3-1)-noccpris
                endif
150         continue
        endif
!
        k = k+1
        if(k .eq. 200) call utmess('F', 'POSTRCCM_52')
        goto 888
      endif
!
      zr(jfu+nb*(num1-1)+num2-1) = r8vide()
      goto 888
!
    endif
!
999 continue
!  
! - DESTRUCTION DE LA MATRICE DES FACTEURS D'USAGE ET DU VECTEUR
! - DES NOMBRES D'OCCURENCES
    call jedetr('RC3200.FU')
    call jedetr('RC3200.NBOCC')
    if(ns .ne. 0) call jedetr ('RC3200.FUS')
!
!--- ECRITURE DANS LE .MESS
    if (lieu .eq. 'ORIG') then
        write(*,*)'---------------------------------------------------------------------'
        write(*,*)'FU TOTAL (ORIGINE)   =',futot
        write(*,*)'   DONT FU_SOUS_CYCLE  =',futotss
        if(ns .ne. 0) write(*,*)'   DONT FU_SOUS_CYCLE_SISMIQUE  =', int(zi(jinfos+2)/2)*fuseism 
        write(*,*)'---------------------------------------------------------------------'
    endif
!
    if (lieu .eq. 'EXTR') then
        write(*,*)'FU TOTAL (EXTREMITE) =',futot
        write(*,*)'   DONT FU_SOUS_CYCLE  =',futotss
        if(ns .ne. 0) write(*,*)'   DONT FU_SOUS_CYCLE_SISMIQUE  =', int(zi(jinfos+2)/2)*fuseism
        write(*,*)'---------------------------------------------------------------------'
    endif
!
!---------------------------------------------------------
! - CALCUL DU FACTEUR D'USAGE SI FATIGUE ENVIRONNEMENTALE
!---------------------------------------------------------
!   
    futotenv = r8vide()
    if(lefat) call rc32env(lieu, futotenv)
!
    call jedema()
!
end subroutine
