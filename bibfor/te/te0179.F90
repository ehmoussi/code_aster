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

subroutine te0179(option, nomte)
! ......................................................................
!    - FONCTION REALISEE:  CALCUL DES VECTEURS ELEMENTAIRES
    implicit none
!                          EN ACOUSTIQUE CORRESPONDANT AUX VITESSES
!                          NORMALES IMPOSEES SUR DES ARETES D'ELEMENTS
!                          ISOPARAMETRIQUES 2D
!                          OPTION : 'CHAR_ACOU_VNOR_C'
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
! ......................................................................
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
#include "asterfort/rcvalb.h"
#include "asterfort/vff2dn.h"
!
    character(len=8) :: fami, poum
    character(len=16) :: option, nomte
    integer :: icodre(1), kpg, spt
    real(kind=8) :: poids, r, nx, ny, rho(1)
    integer :: nno, kp, npg, ipoids, ivf, idfde, igeom
    integer :: i, l, li
    integer :: imate, ivitn
    aster_logical :: laxi
!
!
!-----------------------------------------------------------------------
    integer :: ivectt, jgano, mater, ndim, nnos
!-----------------------------------------------------------------------
    call elrefe_info(fami='RIGI', ndim=ndim, nno=nno, nnos=nnos, npg=npg,&
                     jpoids=ipoids, jvf=ivf, jdfde=idfde, jgano=jgano)
!
    fami='FPG1'
    kpg=1
    spt=1
    poum='+'
    laxi = .false.
    if (lteatt('AXIS','OUI')) laxi = .true.
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PVITENC', 'L', ivitn)
    call jevech('PMATERC', 'L', imate)
    call jevech('PVECTTC', 'E', ivectt)
!
    mater = zi(imate)
    call rcvalb(fami, kpg, spt, poum, mater,&
                ' ', 'FLUIDE', 0, ' ', [0.d0],&
                1, 'RHO', rho, icodre, 1)
!
    do 30 kp = 1, npg
        call vff2dn(ndim, nno, kp, ipoids, idfde,&
                    zr(igeom), nx, ny, poids)
        if (laxi) then
            r = 0.d0
            do 10 i = 1, nno
                l = (kp-1)*nno + i
                r = r + zr(igeom+2*i-2)*zr(ivf+l-1)
 10         continue
            poids = poids*r
        endif
!
        do 20 i = 1, nno
            li = ivf + (kp-1)*nno + i - 1
            zc(ivectt+i-1) = zc(ivectt+i-1) + poids*zr(li)*zc(ivitn+ kp-1)*rho(1)
 20     continue
 30 end do
end subroutine
