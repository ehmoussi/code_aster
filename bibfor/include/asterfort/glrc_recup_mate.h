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
            subroutine glrc_recup_mate(imate, compor, lrgm, ep, lambda, deuxmu, lamf, deumuf, &
                                       gt, gc, gf, seuil, alpha, alfmc)
              integer, intent(in) :: imate
              character(len=16), intent(in) :: compor
              real(kind=8), optional, intent(out) :: lambda
              real(kind=8), optional, intent(out) :: deuxmu
              real(kind=8), optional, intent(out) :: lamf
              real(kind=8), optional, intent(out) :: deumuf
              real(kind=8), optional, intent(out) :: gt
              real(kind=8), optional, intent(out) :: gc
              real(kind=8), optional, intent(out) :: gf
              real(kind=8), optional, intent(out) :: seuil
              real(kind=8), optional, intent(out) :: alpha
              real(kind=8), optional, intent(out) :: alfmc
              real(kind=8), intent(in) :: ep
              aster_logical, intent(in) :: lrgm
            end subroutine glrc_recup_mate
          end interface
