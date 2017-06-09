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

interface
    subroutine pil000(typilo, compor, neps, tau, mat,&
                      vim, sigm, epsm, epsp, epsd,&
                      typmod, etamin, etamax, copilo)
        character(len=8),intent(in) :: typmod(*)
        character(len=16),intent(in) :: compor(*), typilo
        integer,intent(in) :: neps, mat
        real(kind=8),intent(in) :: tau, epsm(neps), epsd(neps), epsp(neps), etamin, etamax
        real(kind=8),intent(in) :: vim(*), sigm(neps)
        real(kind=8),intent(out) :: copilo(2, 2)
    end subroutine pil000
end interface
