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

subroutine setgfa(dgf, ngf)
    implicit none
    integer :: dgf(*), ngf
!     MET A 1 LE BIT DE PRESENCE DUNE ENTITE DANS LE GROUPE NUMERO NGF
!     DONT LE DESCRIPTEUR-GROUPE EST LE VECTEUR D'ENTIERS DGF
!     DGF    = DESCRIPTEUR-GROUPE DE LA FAMILLE (VECTEUR ENTIERS)
!     NGF    = NUMERO DU GROUPE
!     ------------------------------------------------------------------
    integer :: ior
    integer :: iec, reste, code
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    iec = ( ngf - 1 ) / 30
    reste = ngf - 30 * iec
    code = 2**reste
    iec = iec + 1
    dgf(iec) = ior(dgf(iec),code)
end subroutine
