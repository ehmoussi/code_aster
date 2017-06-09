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

subroutine te0563(option, nomte)
!
    implicit none
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/tecach.h"
!
! aslint: disable=W0104
!
    character(len=16), intent(in) :: option
    character(len=16), intent(in) :: nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Options: NORME_L2
!          NORME_FROB
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ncmp_coor, ncmp_vale, ncmp_coef, npg, iret
    integer :: j_coor_elga, j_vale, j_coef, j_resu, j_calc
    integer :: jtab1(3), jtab2(2)
    integer :: jtab3(2), ipg, icmp
    real(kind=8) :: resu, poids_pg, vale_pg, calc_elem
!
! --------------------------------------------------------------------------------------------------
!
    ASSERT(option.eq.'NORME_L2' .or. option.eq.'NORME_FROB')
!
! - Input fields
!
    call jevech('PCOORPG', 'L', j_coor_elga)
    call jevech('PCHAMPG', 'L', j_vale)
    call jevech('PCOEFR', 'L', j_coef)
    call jevech('PCALCI', 'L', j_calc)
!
! - Output fields
!
    call jevech('PNORME', 'E', j_resu)
!
! - Informations of input fields
!
    call tecach('OOO', 'PCHAMPG', 'L', iret, nval=3,&
                itab=jtab1)
    npg=jtab1(3)
    ncmp_vale = jtab1(2)/npg
!
    call tecach('OOO', 'PCOORPG', 'L', iret, nval=2,&
                itab=jtab2)
    ncmp_coor = jtab2(2)/npg
!
    call tecach('OOO', 'PCOEFR', 'L', iret, nval=2,&
                itab=jtab3)
    ncmp_coef = jtab3(2)
!
    ASSERT(ncmp_coef .ge. ncmp_vale)
!
! - Sum on Gauss points of Norm * Norm
!
    resu = 0.d0
    do ipg = 1, npg
        poids_pg = zr(j_coor_elga + ncmp_coor*(ipg-1)+ncmp_coor-1)
        vale_pg = 0.d0
        do icmp = 1, ncmp_vale
            vale_pg = vale_pg + zr(j_coef-1+icmp) * zr(j_vale-1+ncmp_vale*(ipg-1)+icmp) * zr(j_va&
                      &le-1+ncmp_vale*(ipg-1)+icmp)
        enddo
        resu = resu + vale_pg * poids_pg
    enddo
!
    calc_elem = zi(j_calc)
!
    if (calc_elem .lt. 0) then
        zr(j_resu) = resu
    else
        zr(j_resu) = sqrt(resu)
    endif
!
end subroutine
