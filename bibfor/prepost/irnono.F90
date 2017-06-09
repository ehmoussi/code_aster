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

subroutine irnono(noma, nbnoe, nbno, nonoe, nbgr,&
                  nogrn, numno, nbnot, indno, noltop)
! person_in_charge: nicolas.sellenet at edf.fr
    implicit none
!
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/utmess.h"
!
    integer :: nbno, nbgr, nbnot, nbnoe, indno(nbnoe)
    character(len=*) :: noma, nonoe(*), nogrn(*), numno, noltop
! ----------------------------------------------------------------------
!     BUT :   TROUVER LES NUMEROS DES NOEUDS TROUVES DANS
!             UNE LISTE DE NOEUDS ET DE GROUP_NO
!     ENTREES:
!        NOMA   : NOM DU MAILLAGE.
!        NBNOE  : NOMBRE DE NOEUDS DU MAILLAGE
!        NBNO   : NOMBRE DE NOEUDS
!        NBGR   : NOMBRE DE GROUPES DE NOEUDS
!        NONOE  : NOM DES  NOEUDS
!        NOGRN  : NOM DES  GROUP_NO
!     SORTIES:
!        NBNOT  : NOMBRE TOTAL DE NOEUDS A IMPRIMER
!        NUMNO  : NOM DE L'OBJET CONTENANT LES NUMEROS
!                 DES NOEUDS TROUVES.
!        INDNO  : TABLEAU DIMENSIONNE AU NOMBRE DE NOEUDS DU MAILLAGE,
!                 NECESSAIRE POUR QUE NUMNO NE CONTIENNE PAS DE DOUBLONS
!                 INDNO(I)==1 : LE NOEUD I FAIT PARTIE DU FILTRE
!                 INDNO(I)==0 : SINON
! ----------------------------------------------------------------------
    character(len=24) :: valk(2)
!     ------------------------------------------------------------------
    character(len=8) :: nomma
    integer :: jtopo, inoe, ino, igr, iret, nbn, iad, in, lnuno, jnuno
!
!
    call jemarq()
    nomma=noma
    nbnot= 0
    call jeveuo(noltop, 'E', jtopo)
    call jeveuo(numno, 'E', jnuno)
    call jelira(numno, 'LONMAX', lnuno)
!
!  --- TRAITEMENT DES LISTES DE NOEUDS ----
    if (nbno .ne. 0) then
!     --- RECUPERATION DU NUMERO DE NOEUD ----
        do 12 inoe = 1, nbno
            call jenonu(jexnom(nomma//'.NOMNOE', nonoe(inoe)), ino)
            if (ino .eq. 0) then
                valk (1) = nonoe(inoe)
                call utmess('A', 'PREPOST5_38', sk=valk(1))
                nonoe(inoe) = ' '
            else
                zi(jtopo-1+2) = zi(jtopo-1+2) + 1
                nbnot = nbnot + 1
                if (nbnot .gt. lnuno) then
                    call utmess('A', 'PREPOST3_4')
                    nbnot=nbnot-1
                    goto 9999
!             LNUNO=2*LNUNO
!             CALL JUVECA(NUMNO,LNUNO)
!             CALL JEVEUO(NUMNO,'E',JNUNO)
                endif
                zi(jnuno-1+nbnot)=ino
                indno(ino)=1
            endif
12      continue
    endif
!  --- TRAITEMENT DES LISTES DE GROUPES DE NOEUDS ---
    if (nbgr .ne. 0) then
!     --- RECUPERATION DU NUMERO DE NOEUD ----
        do 13 igr = 1, nbgr
            call jeexin(jexnom(nomma//'.GROUPENO', nogrn(igr)), iret)
            if (iret .eq. 0) then
                valk (1) = nogrn(igr)
                call utmess('A', 'PREPOST5_31', sk=valk(1))
                nogrn(igr) = ' '
            else
                call jelira(jexnom(nomma//'.GROUPENO', nogrn(igr)), 'LONMAX', nbn)
                if (nbn .eq. 0) then
                    valk (1) = nogrn(igr)
                    valk (2) = ' '
                    call utmess('A', 'PREPOST5_40', nk=2, valk=valk)
                    nogrn(igr) = ' '
                else
                    zi(jtopo-1+4) = zi(jtopo-1+4) + 1
                    call jeveuo(jexnom(nomma//'.GROUPENO', nogrn(igr)), 'L', iad)
                    do 14 in = 1, nbn
                        nbnot=nbnot+1
                        if (nbnot .gt. lnuno) then
                            call utmess('A', 'PREPOST3_4')
                            nbnot=nbnot-1
                            goto 9999
!                 LNUNO=2*LNUNO
!                 CALL JUVECA(NUMNO,LNUNO)
!                 CALL JEVEUO(NUMNO,'E',JNUNO)
                        endif
                        if (indno(zi(iad+in-1)) .eq. 0) then
                            zi(jnuno-1+nbnot)= zi(iad+in-1)
                            indno(zi(iad+in-1))=1
                        else
                            nbnot=nbnot-1
                        endif
14                  continue
                endif
            endif
13      continue
    endif
!
9999  continue
    call jedema()
end subroutine
