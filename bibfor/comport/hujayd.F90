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

subroutine hujayd(nmat, mater, nvi, vind, vinf,&
                  nr, yd, bnews, mtrac)
! person_in_charge: alexandre.foucault at edf.fr
    implicit none
!     ----------------------------------------------------------------
!     CHOIX DES VALEURS DE VIND A AFFECTER A YD
!     ----------------------------------------------------------------
!     IN   MATER  :  PROPRIETES MATERIAU
!          NMAT   :  DIMENSION TABLEAU DONNEES MATERIAU
!          NVI    :  NOMBRE DE VARIABLES INTERNES
!          VIND   :  VARIABLES INTERNES A T
!          VINF   :  VARIABLES INTERNES A T+DT (BASE SUR PRED_ELAS)
!          NR     :  DIMENSION MAXIMALE DE YD
!     OUT  YD     :  VECTEUR INITIAL
!          VIND   :  IMAGE DE VINF (COHERENCE AVEC ROUTINE HUJMID.F)
!          NR     :  DIMENSION DU SYSTEME NL A RESOUDRE
!     ----------------------------------------------------------------
#include "asterf_types.h"
#include "asterfort/lceqvn.h"
    integer :: nvi, nr, nmat
    real(kind=8) :: vind(nvi), vinf(nvi), yd(nr), mater(nmat, 2)
    aster_logical :: bnews(3), mtrac
!
    integer :: i, ii, nbmeca, ndt
    real(kind=8) :: zero, un
!
    parameter (zero = 0.d0)
    parameter (un   = 1.d0)
    parameter (ndt  = 6)
!     ----------------------------------------------------------------
! ---  DEFINITION DU NOMBRE DE MECANISMES POTENTIELS ACTIFS
    nbmeca = 0
    do i = 1, 8
        if (vinf(23+i) .eq. un) nbmeca = nbmeca + 1
    end do
! ---  DIMENSION DU SYSTEME NL A RESOUDRE FONCTION DE NBMECA
    nr = ndt + 1 + 2*nbmeca
!
! --- AFFECTATION DE VIND A VINF
!    (COHERENCE AVEC SCHEMA D'INTEGRATION SPECIFIQUE)
!
    call lceqvn(nvi, vinf, vind)
!
! ---  YD(NDT+1) = EPS_V^P = VIND(23) A T
    yd(ndt+1) = vind(23)
!
    ii = 1
    do i = 1, 8
        if (vind(23+i) .eq. un) then
!
            if (i .ne. 4) then
                yd(ndt+1+ii) = vind(i)
                yd(ndt+1+nbmeca+ii) = zero
                ii = ii + 1
            else
                yd(ndt+1+nbmeca) = vind(i)
                yd(ndt+1+2*nbmeca) = zero
            endif
!
        endif
    enddo
!
! --- REDIMENSIONNEMENT DE YD ET YF POUR S'ADAPTER A HUJJID
! --- SIGMA/E0, R * PREF/ E0
    do i = 1, 6
        yd(i) = yd(i)/mater(1,1)
    end do
!
    do i = 1, nbmeca
        yd(ndt+1+i) = yd(ndt+1+i)/mater(1,1)*abs(mater(8,2))
    end do
!
! --- VARIABLE DE GESTION DES MECANISMES DE TRACTION
    do i = 1, 3
        bnews(i) = .true.
    end do
    mtrac = .false.
!
! --- MISE A ZERO DU COMPTEUR D'ITERATIONS LOCALES
    vinf(35) = zero
!
!
end subroutine
