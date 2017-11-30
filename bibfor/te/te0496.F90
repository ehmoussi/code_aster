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

subroutine te0496(option, nomte)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jevech.h"
#include "asterfort/tecach.h"
    character(len=16) :: option, nomte
!
!
!     POUR TOUS LES TYPE_ELEM CALCUL DU NOMBRE :
!        DE VARIABLES INTERNES
!        DE SOUS-POINTS
!
! ----------------------------------------------------------------------
!
    integer :: nbcou, npgh, nbsect, nbfibr, nbvari, jcompo, jdcel, jnbsp
    integer :: itab(2), iret
!
! ----------------------------------------------------------------------
!
    call jevech('PDCEL_I', 'E', jdcel)
!
!     PCOMPOR CONTIENT 1 SEULE CMP : NBVARI
!     LES AUTRES INFO VIENNENT DE PNBSP_I
!     SI PCOMPOR N'EST PAS FOURNI : NCMP_DYN = 0
!     ------------------------------------------------
    call tecach('ONO', 'PCOMPOR', 'L', iret, nval=2,&
                itab=itab)
    if (itab(1) .ne. 0) then
        ASSERT(itab(2).eq.1)
        jcompo=itab(1)
        read (zk16(jcompo-1+1),'(I16)') nbvari
    else
        nbvari=0
    endif
!
! --- PAR DEFAUT POUR TOUS LES ELEMENTS
    zi(jdcel-1+1) = 1
    zi(jdcel-1+2) = nbvari
!
!     PNBSP_I : INFOS NECESSSAIRES AU CALCUL DU NOMBRE DE SOUS-POINTS.
!     SI LE CHAMP N'EST PAS DONNE ==> VALEUR PAR DEFAUT
    call tecach('NNO', 'PNBSP_I', 'L', iret, iad=jnbsp)
    if (jnbsp .eq. 0) goto 9999
!
! --- CAS DES ELEMENTS "COQUE EPAISSE" (MULTI-COUCHE) :
    if ((nomte.eq.'MEC3QU9H') .or. (nomte.eq.'MEC3TR7H').or. (nomte.eq.'MECXSE3')) then
        nbcou = zi(jnbsp-1+1)
        npgh = 3
        zi(jdcel-1+1) = npgh*nbcou
!
! --- CAS DES ELEMENTS "DKT"
        else if ( (nomte.eq.'MEDKQU4') .or. (nomte.eq.'MEDKTR3') .or.&
    (nomte.eq.'MEDSQU4') .or. (nomte.eq.'MEDSTR3') .or. (&
    nomte.eq.'MEQ4QU4') .or. (nomte.eq.'MET3TR3')) then
        nbcou = zi(jnbsp-1+1)
        npgh = 3
        zi(jdcel-1+1) = npgh*nbcou
!
! --- CAS DES ELEMENTS  "TUYAU" :
        else if ((nomte.eq.'MET3SEG3') .or. (nomte.eq.'MET6SEG3') .or.&
    (nomte.eq.'MET3SEG4')) then
        nbcou = zi(jnbsp-1+1)
        nbsect = zi(jnbsp-1+2)
        zi(jdcel-1+1) = (2*nbsect+1)* (2*nbcou+1)
!
! --- CAS DES ELEMENTS DE POUTRE "MULTIFIBRES" :
    else if (nomte.eq.'MECA_POU_D_EM') then
        nbfibr = zi(jnbsp-1+1)
        zi(jdcel-1+1) = nbfibr
!
    else if (nomte.eq.'MECA_POU_D_TGM') then
        nbfibr = zi(jnbsp-1+1)
        zi(jdcel-1+1) = nbfibr
!
    else if (nomte.eq.'MECA_POU_D_SQUE') then
        nbfibr = zi(jnbsp-1+1)
        zi(jdcel-1+1) = nbfibr

    endif
!
9999  continue
end subroutine
