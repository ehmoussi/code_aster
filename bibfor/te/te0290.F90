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

subroutine te0290(option, nomte)
    implicit none
#include "jeveux.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/utmess.h"
!
    character(len=16) :: option, nomte
! ......................................................................
!    - FONCTION REALISEE:  CALCUL DES VECTEURS ELEMENTAIRES
!                          OPTION : 'CALC_NOEU_BORD  '
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
! ......................................................................
!
    real(kind=8) :: coor(8), dx(4), dy(4), nx(9), ny(9), sens
!
!
!-----------------------------------------------------------------------
    integer :: i, idfde, igeom, ipoids, ivectu, ivf, jgano
    integer :: ndim, nno, npg, nsom
!-----------------------------------------------------------------------
!
    call elrefe_info(fami='RIGI',ndim=ndim,nno=nno,nnos=nsom,&
  npg=npg,jpoids=ipoids,jvf=ivf,jdfde=idfde,jgano=jgano)
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PVECTUR', 'E', ivectu)
    do 1 i = 1, nsom
        coor(2*i-1) = zr(igeom+2*(i-1))
        coor(2*i) = zr(igeom+2*i-1)
 1  end do
    do 2 i = 1, nsom-1
        dx(i) = coor(2*i+1)-coor(2*i-1)
        dy(i) = coor(2*i+2)-coor(2*i)
 2  end do
    dx(nsom) = coor(1)-coor(2*nsom-1)
    dy(nsom) = coor(2)-coor(2*nsom)
!
!   INITIALISATION A 0.
!
    do 3 i = 1, nno
        zr(ivectu+2*i-2) = 0.d0
        zr(ivectu+2*i-1) = 0.d0
        nx(i) = 0.d0
        ny(i) = 0.d0
 3  end do
    nx(1) = (dy(nsom)+dy(1))
    ny(1) = -(dx(nsom)+dx(1))
    do 4 i = 2, nsom
        nx(i) = (dy(i-1)+dy(i))
        ny(i) = -(dx(i-1)+dx(i))
 4  end do
    if (nno .ne. nsom) then
        do 6 i = nsom+1, 2*nsom
            nx(i) = dy(i-nsom)
            ny(i) = -dx(i-nsom)
 6      continue
    endif
!
!   VERIFICATION DU SENS DE L'ELEMENT
!
    sens = dy(1)*dx(nsom)-dx(1)*dy(nsom)
    if (sens .eq. 0.d0) then
        call utmess('F', 'ELEMENTS3_67')
    else if (sens.lt.0.d0) then
        do 7 i = 1, nno
            nx(i) = -nx(i)
            ny(i) = -ny(i)
 7      continue
    endif
!
    do 5 i = 1, nno
        zr(ivectu+2*i-2) = nx(i)
        zr(ivectu+2*i-1) = ny(i)
 5  end do
end subroutine
