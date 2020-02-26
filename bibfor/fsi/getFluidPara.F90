! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine getFluidPara(j_mater,&
                        rho_   , cele_r_, pesa_)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/rcvalb.h"
!
integer, intent(in) :: j_mater
real(kind=8), optional, intent(out) :: rho_, cele_r_, pesa_
!
! --------------------------------------------------------------------------------------------------
!
! Utilities for FSI
!
! Get material properties for fluid
!
! --------------------------------------------------------------------------------------------------
!
! In  j_mater          : coded material address
! Out rho              : density of fluid
! Out cele_r           : sound speed in fluid
! Out pesa             : gravity
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: nb_resu = 3
    integer :: icodre(nb_resu)
    character(len=16), parameter :: resu_name(nb_resu) = (/'RHO   ', 'CELE_R', 'PESA_Z'/)
    real(kind=8) :: resu_vale(nb_resu)
    real(kind=8) :: rho, cele_r, pesa
    character(len=16) :: fami
    character(len=1) :: poum
    integer :: ipg, ispg
!
! --------------------------------------------------------------------------------------------------
!
    fami = 'FPG1'
    ipg  = 1
    ispg = 1
    poum = '+'
!
    if (present(pesa_)) then
        call rcvalb(fami, ipg, ispg, poum, j_mater,&
                    ' ' , 'FLUIDE', 0, ' ', [0.d0],&
                    nb_resu, resu_name, resu_vale, icodre, 1)
        rho    = resu_vale(1)
        cele_r = resu_vale(2)
        pesa   = resu_vale(3)
    else
        call rcvalb(fami, ipg, ispg, poum, j_mater,&
                    ' ' , 'FLUIDE', 0, ' ', [0.d0],&
                    2, resu_name, resu_vale, icodre, 1)
        rho    = resu_vale(1)
        cele_r = resu_vale(2)
    endif
!
    if (present(rho_)) then
        rho_ = rho
    endif
    if (present(cele_r_)) then
        cele_r_ = cele_r
    endif
    if (present(pesa_)) then
        pesa_ = pesa
    endif
!
end subroutine
