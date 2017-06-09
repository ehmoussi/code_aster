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

subroutine te0019(option, nomte)
!
    implicit none
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/fointe.h"
#include "asterfort/jevecd.h"
#include "asterfort/jevech.h"
#include "asterfort/nmpr3d_vect.h"
!
! aslint: disable=W0104
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=16), intent(in) :: option
    character(len=16), intent(in) :: nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: 3D
! Option: CHAR_MECA_PRES_F
!         CHAR_MECA_EFON_F
!
! --------------------------------------------------------------------------------------------------
!
    integer :: mxpara
    parameter     (mxpara=4)
!
    character(len=8) :: nompar(mxpara)
    real(kind=8) :: valpar(mxpara)
    integer :: ier, ndim, nno, npg, nnos, jgano, kpg, kdec, n
    integer :: ipoids, ivf, idf
    integer :: j_geom, j_pres, j_time, j_vect, j_effe
    real(kind=8) :: x, y, z
    real(kind=8) :: pres, pres_point(27), coef_mult
!
! --------------------------------------------------------------------------------------------------
!
    ASSERT(option.eq.'CHAR_MECA_PRES_F'.or.option.eq.'CHAR_MECA_EFON_F')
!
! - Finite element parameters
!
    call elrefe_info(fami='RIGI',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg,jpoids=ipoids,jvf=ivf,jdfde=idf,jgano=jgano)
!
! - IN fields
!
    call jevech('PGEOMER', 'L', j_geom)
    call jevech('PTEMPSR', 'L', j_time)
!
! - OUT fields
!
    call jevech('PVECTUR', 'E', j_vect)
!
! - For pressure, no node affected -> 0
!
    if (option .eq. 'CHAR_MECA_PRES_F') then
        call jevecd('PPRESSF', j_pres, 0.d0)
    else if (option.eq.'CHAR_MECA_EFON_F') then
        call jevecd('PPREFFF', j_pres, 0.d0)
    endif
!
! - Multiplicative ratio for pressure (EFFE_FOND)
!
    coef_mult = 1.d0
    if (option .eq. 'CHAR_MECA_EFON_F') then
        call jevech('PEFOND', 'L', j_effe)
        coef_mult = zr(j_effe-1+1)
    endif
!
! - Parameters of function
!
    valpar(4) = zr(j_time)
    nompar(4) = 'INST'
    nompar(1) = 'X'
    nompar(2) = 'Y'
    nompar(3) = 'Z'
!
! - Evaluation of pressure (function) at Gauss points (from nodes)
!
    do kpg = 0, npg-1
        kdec = kpg*nno
        x = 0.d0
        y = 0.d0
        z = 0.d0
        do n = 0, nno-1
            x = x + zr(j_geom+3*n ) * zr(ivf+kdec+n)
            y = y + zr(j_geom+3*n+1) * zr(ivf+kdec+n)
            z = z + zr(j_geom+3*n+2) * zr(ivf+kdec+n)
        end do
        valpar(1) = x
        valpar(2) = y
        valpar(3) = z
        call fointe('FM', zk8(j_pres), mxpara, nompar, valpar,&
                    pres, ier)
        pres_point(kpg+1) = coef_mult * pres
    end do
!
! - Second member
!
    call nmpr3d_vect(nno, npg, zr(ipoids), zr(ivf), zr(idf),&
                     zr(j_geom), pres_point, zr(j_vect))
!
end subroutine
