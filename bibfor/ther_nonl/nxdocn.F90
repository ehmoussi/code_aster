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

subroutine nxdocn(parcri, parcrr)
    implicit none
#include "asterc/getfac.h"
#include "asterfort/getvis.h"
#include "asterfort/getvr8.h"
    integer :: parcri(3)
    real(kind=8) :: parcrr(2)
! ----------------------------------------------------------------------
!     SAISIE DES CRITERES DE CONVERGENCE
!
! OUT PARCRI  : PARAMETRES ENTIERS DU CRITERE
!               PARCRI(1) = 1 TEST EN ABSOLU  SUR LE RESIDU
!               PARCRI(2) = 1 TEST EN RELATIF SUR LE RESIDU
!               PARCRI(3) = NB MAXIMUM D'ITERATION
! OUT PARCRR  : PARAMETRES REELS DU CRITERE
!
! ----------------------------------------------------------------------
    character(len=16) :: nomcvg
    integer :: n1, iocc
! ----------------------------------------------------------------------
! --- RECUPERATION DES CRITERES DE CONVERGENCE
!
    nomcvg = 'CONVERGENCE'
    call getfac(nomcvg, iocc)
    if (iocc .eq. 1) then
        call getvr8(nomcvg, 'RESI_GLOB_MAXI', iocc=1, scal=parcrr(1), nbret=parcri(1))
        call getvr8(nomcvg, 'RESI_GLOB_RELA', iocc=1, scal=parcrr(2), nbret=parcri(2))
        if (parcri(1)+parcri(2) .eq. 0) then
            parcri(2) = 1
            parcrr(2) = 1.d-6
        endif
!
        call getvis(nomcvg, 'ITER_GLOB_MAXI', iocc=1, scal=parcri(3), nbret=n1)
    endif
! FIN ------------------------------------------------------------------
end subroutine
