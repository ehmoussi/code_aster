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

subroutine te0079(option, nomte)
! aslint: disable=C1513
    implicit none
#include "jeveux.h"
#include "asterfort/connec.h"
#include "asterfort/dfdm2d.h"
#include "asterfort/elref1.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
#include "asterfort/teattr.h"
!
    character(len=16) :: option, nomte
! ......................................................................
!    - FONCTION REALISEE:  CALCUL DES VECTEURS ELEMENTAIRES
!                          OPTION : 'CHAR_TH_SOURCR  '
!
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
! ......................................................................
!
    character(len=8) :: elrefe, alias8
    real(kind=8) :: poids, r
    real(kind=8) :: coorse(18), vectt(9)
    integer :: ndim, nno, nnos, kp, npg, i, k, ivectt, isour
    integer :: ipoids, ivf, idfde, igeom, jgano
    integer :: nnop2, c(6, 9), ise, nse, ibid
!
!
!-----------------------------------------------------------------------
    integer :: j
!-----------------------------------------------------------------------
    call elref1(elrefe)
!
    if (lteatt('LUMPE','OUI')) then
        call teattr('S', 'ALIAS8', alias8, ibid)
        if (alias8(6:8) .eq. 'QU9') elrefe='QU4'
        if (alias8(6:8) .eq. 'TR6') elrefe='TR3'
    endif
!
    call elrefe_info(elrefe=elrefe,fami='RIGI',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg,jpoids=ipoids,jvf=ivf,jdfde=idfde,jgano=jgano)
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PSOURCR', 'L', isour)
    call jevech('PVECTTR', 'E', ivectt)
!
    call connec(nomte, nse, nnop2, c)
!
    do i = 1, nnop2
        vectt(i)=0.d0
    end do
!
! BOUCLE SUR LES SOUS-ELEMENTS
!
    do ise = 1, nse
!
        do i = 1, nno
            do j = 1, 2
                coorse(2*(i-1)+j) = zr(igeom-1+2*(c(ise,i)-1)+j)
            end do
        end do
!
        do kp = 1, npg
            k=(kp-1)*nno
            call dfdm2d(nno, kp, ipoids, idfde, coorse,&
                        poids)
            if (lteatt('AXIS','OUI')) then
                r = 0.d0
                do i = 1, nno
                    r = r + coorse(2*(i-1)+1)*zr(ivf+k+i-1)
                end do
                poids = poids*r
            endif
!DIR$ IVDEP
!CC      write(6,*)  '--->>> ZR(ISOUR+',KP,'-1) = ', ZR(ISOUR+KP-1)
!
            do i = 1, nno
                k=(kp-1)*nno
                vectt(c(ise,i)) = vectt( c(ise,i)) + poids * zr(ivf+k+ i-1) * zr(isour+kp-1 )
            end do
        end do
    end do
!
    do i = 1, nnop2
        zr(ivectt-1+i)=vectt(i)
    end do
!
end subroutine
