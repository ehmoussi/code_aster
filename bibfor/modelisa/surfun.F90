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

subroutine surfun(char, noma)
!
!
    implicit    none
#include "jeveux.h"
!
#include "asterfort/cudisi.h"
#include "asterfort/infniv.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
    character(len=8) :: char
    character(len=8) :: noma
!
! ----------------------------------------------------------------------
!
! ROUTINE LIAISON_UNILATERALE (AFFICHAGE DONNEES)
!
! AFFICHAGE DES RESULTATS DE LA LECTURE DU MOT-CLE LIAISON_UNILATERALE
!
! ----------------------------------------------------------------------
!
!
! IN  CHAR   : NOM UTILISATEUR DU CONCEPT DE CHARGE
! IN  NOMA   : NOM DU MAILLAGE
!
!
!
!
    integer :: ifm, niv
    character(len=24) :: cmpgcu, coegcu, coedcu, poincu, noeucu
    integer :: jcmpg, jcoefg, jcoefd, jpoin, jnoeu
    integer :: nnocu, ncmpg
    integer :: numno, nbcmp, jdecal
    character(len=24) :: noeuma, deficu
    integer :: ino, icmp
    integer :: lgbloc
    character(len=8) :: nomno
!
! ----------------------------------------------------------------------
!
    call jemarq()
    call infniv(ifm, niv)
!
! --- INITIALISATIONS
!
    deficu = char(1:8)//'.UNILATE'
    noeuma = noma // '.NOMNOE'
    lgbloc = cudisi(deficu,'NB_RESOL')
    nnocu = cudisi(deficu,'NNOCU')
    ncmpg = cudisi(deficu,'NCMPG')
!
! --- ACCES SD
!
    noeuma = noma // '.NOMNOE'
    noeucu = deficu(1:16)//'.LISNOE'
    poincu = deficu(1:16)//'.POINOE'
    cmpgcu = deficu(1:16)//'.CMPGCU'
    coegcu = deficu(1:16)//'.COEFG'
    coedcu = deficu(1:16)//'.COEFD'
    call jeveuo(noeucu, 'L', jnoeu)
    call jeveuo(poincu, 'L', jpoin)
    call jeveuo(cmpgcu, 'L', jcmpg)
    call jeveuo(coegcu, 'L', jcoefg)
    call jeveuo(coedcu, 'L', jcoefd)
!
! ======================================================================
!                    IMPRESSIONS POUR L'UTILISATEUR
! ======================================================================
!
    if (niv .ge. 2) then
!
!
! --- IMPRESSIONS POUR L'UTILISATEUR
!
        write (ifm,*)
        write (ifm,*) '<LIA_UNIL> INFOS GENERALES'
        write (ifm,*)
!
        write (ifm,1070) 'NB_RESOL        ',lgbloc
!
! --- INFOS GENERALES
!
        write (ifm,*)
        write (ifm,1070) 'NNOCU           ',nnocu
        write (ifm,1070) 'NCMPG           ',ncmpg
        write (ifm,*)
!
!
        do 10 ino = 1, nnocu
!
            numno = zi(jnoeu+ino-1)
            call jenuno(jexnum(noeuma, numno), nomno)
!
!
            write (ifm,1030) nomno
            write (ifm,1031) ' --> INEGALITE ai.Ai<C : '
!
            nbcmp = zi(jpoin+ino) - zi(jpoin+ino-1)
            jdecal = zi(jpoin+ino-1)
!
            write (ifm,1040) '     (ai,Ai)'
!
            do 20 icmp = jdecal, jdecal+nbcmp-1
                write (ifm,1042) '     ( ',zk8(jcoefg-1+icmp),' , ',&
     &                         zk8(jcmpg-1+icmp),' )'
20          continue
            write (ifm,1060) '     (C)'
            write (ifm,1062) '     ( ',zk8(jcoefd-1+ino),' )'
10      continue
!
    endif
!
    1070 format (' <LIA_UNIL> ...... PARAM. : ',a16,' - VAL. : ',i5)
!
!
    1031 format ('<LIA_UNIL> ',a25)
    1030 format ('<LIA_UNIL> NOEUD: ',a18,a8)
    1040 format ('<LIA_UNIL>',a12)
    1042 format ('<LIA_UNIL>',a7,a8,a3,a8,a2)
    1060 format ('<LIA_UNIL>',a8)
    1062 format ('<LIA_UNIL>',a7,a8,a2)
!
    call jedetr('&&SURFUN.TRAV')
! ======================================================================
    call jedema()
!
end subroutine
