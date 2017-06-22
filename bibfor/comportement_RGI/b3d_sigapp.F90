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

subroutine b3d_sigapp(sigef6, d66, siga6, base_prin)
! person_in_charge: etienne.grimal at edf.fr
!=====================================================================
!      calcul des contraintes apparentes en fonction des contraintes eff
!      variables externes
!=====================================================================
    implicit none
    real(kind=8) :: sigef6(6)
    real(kind=8) :: d66(6, 6)
    real(kind=8) :: siga6(6)
    logical :: base_prin
!      variables locales
    integer :: i, j
    real(kind=8) :: un
    parameter(un=1.d0)
!
!      calcul des contraintes apparentes
    if (base_prin) then
        do i = 1, 6
            siga6(i)=0.d0
            do j = 1, 6
                if (i .eq. j) then
                    siga6(i)=siga6(i)+(un-d66(i,j))*sigef6(j)
                else
                    if ((j.le.3) .and. (i.le.3)) then
                        siga6(i)=siga6(i)-d66(i,j)*sigef6(j)
                    end if
                end if
            end do
        end do
    else
        do i = 1, 6
            siga6(i)=0.d0
            do j = 1, 6
                if (i .eq. j) then
                    siga6(i)=siga6(i)+(un-d66(i,j))*sigef6(j)
                else
                    siga6(i)=siga6(i)-d66(i,j)*sigef6(j)
                end if
            end do
        end do
    end if
end subroutine
