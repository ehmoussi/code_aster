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

subroutine te0169(option, nomte)
! SUPPRESSION D'INSTRUCTIONS INUTILES
    implicit none
#include "jeveux.h"
#include "asterfort/jevech.h"
#include "asterfort/tecach.h"
#include "asterfort/terefe.h"
#include "blas/ddot.h"
!
    character(len=16) :: option, nomte
! ......................................................................
!    - FONCTION REALISEE:  CALCUL DES FORCES NODALES DE MEPOULI
!                          REFE_FORC_NODA
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
! ......................................................................
!
    real(kind=8) :: w(9), l1(3), l2(3), forref
    real(kind=8) :: norml1, norml2, coef1, coef2
    integer :: jefint, lsigma, igeom, idepla, ideplp, ivectu, nno, nc
    integer :: ino, i, kc, iret
! ----------------------------------------------------------------------
!
    if (option .eq. 'REFE_FORC_NODA') then
        nno = 3
        nc = 3
        call terefe('EFFORT_REFE', 'MECA_POULIE', forref)
        call jevech('PVECTUR', 'E', ivectu)
        do 101 ino = 1, nno
            do 102 i = 1, nc
                zr(ivectu+(ino-1)*nc+i-1)=forref
102          continue
101      continue
!
    else if (option.eq.'FORC_NODA') then
!
!        PARAMETRES EN ENTREE
        call jevech('PGEOMER', 'L', igeom)
!
        call jevech('PDEPLMR', 'L', idepla)
        call tecach('ONO', 'PDEPLPR', 'L', iret, iad=ideplp)
        call jevech('PCONTMR', 'L', lsigma)
!        PARAMETRES EN SORTIE
        call jevech('PVECTUR', 'E', jefint)
!
        if (ideplp .eq. 0) then
            do 10 i = 1, 9
                w(i)=zr(idepla-1+i)
10          continue
        else
            do 11 i = 1, 9
                w(i)=zr(idepla-1+i)+zr(ideplp-1+i)
11          continue
        endif
!
        do 21 kc = 1, 3
            l1(kc) = w(kc )+zr(igeom-1+kc)-w(6+kc)-zr(igeom+5+kc)
21      continue
        do 22 kc = 1, 3
            l2(kc) = w(3+kc)+zr(igeom+2+kc)-w(6+kc)-zr(igeom+5+kc)
22      continue
        norml1=ddot(3,l1,1,l1,1)
        norml2=ddot(3,l2,1,l2,1)
        norml1 = sqrt (norml1)
        norml2 = sqrt (norml2)
!
        coef1 = zr(lsigma) / norml1
        coef2 = zr(lsigma) / norml2
!
        do 15 i = 1, 3
            zr(jefint+i-1) = coef1 * l1(i)
            zr(jefint+i+2) = coef2 * l2(i)
            zr(jefint+i+5) = -zr(jefint+i-1) - zr(jefint+i+2)
15      continue
    endif
end subroutine
