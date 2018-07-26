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

subroutine hujpel(fami, kpg, ksp, etatd, mod,&
                  crit, imat, nmat, materf, angmas,&
                  deps, sigd, nvi, vind, sigf,&
                  vinf, iret)
! person_in_charge: alexandre.foucault at edf.fr
    implicit none
!       ----------------------------------------------------------------
!       INTEGRATION ELASTIQUE SUR DT
!       IN  ETATD  :  ETAT MATERIAU A T (ELASTIC OU PLASTIC)
!           MOD    :  MODELISATION
!           CRIT   :  CRITERES LOCAUX LIES AU SCHEMA DE NEWTON
!           IMAT   :  NUMERO MATERIAU
!           NMAT   :  DIMENSION TABLEAU DONNEES MATERIAUX
!           MATERF :  COEFFICIENTS MATERIAU A T+DT
!           DEPS   :  INCREMENT DE DEFORMATION
!           SIGD   :  CONTRAINTE  A T
!           NVI    :  DIMENSION VECTEUR VARIABLES INTERNES
!           VIND   :  VARIABLES INTERNES A T
!       OUT SIGF   :  CONTRAINTE A T+DT
!           VINF   :  VARIABLES INTERNES A T+DT
!           IRET   :  CODE RETOUR (O-->OK / 1-->NOOK)
!       ----------------------------------------------------------------
#include "asterf_types.h"
#include "asterc/r8vide.h"
#include "asterfort/hujori.h"
#include "asterfort/hujpre.h"
#include "asterfort/lceqvn.h"
#include "asterfort/utmess.h"
    integer :: nvi, imat, iret, nmat, kpg, ksp
    real(kind=8) :: materf(nmat, 2), sigd(6), sigf(6), angmas(3)
    real(kind=8) :: vind(*), vinf(*), deps(6), crit(*)
    character(len=8) :: mod
    character(len=7) :: etatd
    character(len=*) :: fami
!
    integer :: i
    real(kind=8) :: zero, un, bid66(6, 6), matert(22, 2)
    aster_logical :: reorie
    parameter      (zero = 0.d0)
    parameter      (un   = 1.d0)
!       ----------------------------------------------------------------
    if (mod(1:6) .eq. 'D_PLAN') then
        do i = 5, 6
            deps(i) = zero
            sigd(i) = zero
        enddo
    endif
!
    if (( (vind(24) .eq. zero) .or. (vind(24) .eq. -un .and. vind(28) .eq. zero) ) .and.&
        ( (vind(25) .eq. zero) .or. (vind(25) .eq. -un .and. vind(29) .eq. zero) ) .and.&
        ( (vind(26) .eq. zero) .or. (vind(26) .eq. -un .and. vind(30) .eq. zero) ) .and.&
        ( (vind(27) .eq. zero) .or. (vind(27) .eq. -un .and. vind(31) .eq. zero) )) then
        etatd = 'ELASTIC'
    else
        etatd = 'PLASTIC'
    endif
!
! --- ORIENTATION DES CONTRAINTES SELON ANGMAS VERS REPERE LOCAL
    if (angmas(1) .eq. r8vide()) then
        call utmess('F', 'ALGORITH8_20')
    endif
    reorie =(angmas(1).ne.zero) .or. (angmas(2).ne.zero)&
     &          .or. (angmas(3).ne.zero)
    call hujori('LOCAL', 1, reorie, angmas, sigd,&
                bid66)
    call hujori('LOCAL', 1, reorie, angmas, deps,&
                bid66)
!
    do i = 1, 22
        matert(i,1) = materf(i,1)
        matert(i,2) = materf(i,2)
    enddo
!
    call hujpre(fami, kpg, ksp, etatd, mod,&
                crit, imat, matert, deps, sigd,&
                sigf, vind, iret)
    call lceqvn(nvi, vind, vinf)
!
end subroutine
