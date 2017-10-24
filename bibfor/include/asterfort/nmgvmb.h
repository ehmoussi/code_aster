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

!
!
#include "asterf_types.h"
!
interface
    subroutine nmgvmb(ndim, nno1, nno2, npg, axi, grand, &
                  geoi, vff1, vff2, idfde1, idfde2, &
                  iw, nddl, neps, b, w, ni2ldc, ddlm)
        aster_logical,intent(in) :: axi,grand
        integer,intent(in) :: ndim, nno1, nno2, npg, idfde1, idfde2, iw
        real(kind=8),intent(in) :: geoi(ndim,nno1)
        real(kind=8),intent(in) :: vff1(nno1,npg), vff2(nno2,npg)
        integer,intent(out) :: nddl,neps
        real(kind=8),intent(out),allocatable :: b(:,:,:)
        real(kind=8),intent(out),allocatable :: w(:,:),ni2ldc(:,:)
        real(kind=8),intent(in),optional :: ddlm(nno1*ndim + nno2*2)
    end subroutine nmgvmb
end interface
