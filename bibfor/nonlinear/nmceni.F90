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

subroutine nmceni(numedd, depdel, deppr1, deppr2, rho,&
                  sdpilo, eta, isxfe, f)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=24) :: numedd
    character(len=19) :: sdpilo, depdel, deppr1, deppr2
    real(kind=8) :: eta, rho, f
    aster_logical :: isxfe
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME - PILOTAGE - SELECTION PARAMETRE)
!
! CALCUL DU PARAMETRE DE SELECTION DE TYPE NORM_INCR_DEPL
!
! ----------------------------------------------------------------------
!
!
! IN  NUMEDD : NUME_DDL
! IN  SDPILO : SD PILOTAGE
! IN  DEPDEL : INCREMENT DE DEPLACEMENT DEPUIS DEBUT PAS DE TEMPS
! IN  DEPPR1 : INCREMENT DE DEPLACEMENT K-1.F_DONNE
! IN  DEPPR2 : INCREMENT DE DEPLACEMENT K-1.F_PILO
! IN  RHO    : PARAMETRE DE RECHERCHE LINEAIRE
! IN  ETA    : PARAMETRE DE PILOTAGE
! IN  ISXFE  : INDIQUE S'IL S'AGIT D'UN MODELE XFEM
! OUT F      : VALEUR DU CRITERE
!
!
!
!
    character(len=19) :: profch, chapil, chapic
    integer :: neq, i, j
    real(kind=8) :: dn, dc, dp
    integer, pointer :: deeq(:) => null()
    real(kind=8), pointer :: coee(:) => null()
    real(kind=8), pointer :: coef(:) => null()
    real(kind=8), pointer :: depde(:) => null()
    real(kind=8), pointer :: du0(:) => null()
    real(kind=8), pointer :: du1(:) => null()
!
! ----------------------------------------------------------------------
!
    call jemarq()
    if (isxfe) then
        chapil = sdpilo(1:14)//'.PLCR'
        call jeveuo(chapil(1:19)//'.VALE', 'L', vr=coef)
        chapic = sdpilo(1:14)//'.PLCI'
        call jeveuo(chapic(1:19)//'.VALE', 'L', vr=coee)
    endif
!
! --- INITIALISATIONS
!
    f = 0.d0
!
! --- INFORMATIONS SUR NUMEROTATION
!
    call dismoi('NB_EQUA', numedd, 'NUME_DDL', repi=neq)
    call dismoi('PROF_CHNO', depdel, 'CHAM_NO', repk=profch)
    call jeveuo(profch(1:19)//'.DEEQ', 'L', vi=deeq)
!
! --- ACCES AUX VECTEURS SOLUTIONS
!
    call jeveuo(depdel(1:19)//'.VALE', 'L', vr=depde)
    call jeveuo(deppr1(1:19)//'.VALE', 'L', vr=du0)
    call jeveuo(deppr2(1:19)//'.VALE', 'L', vr=du1)
!
!
! --- CALCUL DE LA NORME
!
    if (isxfe) then
        do i = 1, neq
            if (deeq(2*i ) .gt. 0) then
                if (coee(i) .eq. 0.d0) then
                    f = f + coef(i)**2* (depde(i)+rho*du0(i)+ eta*du1(i))**2
                else
                    dn = 0.d0
                    dc = 0.d0
                    dp = 0.d0
                    do j = i+1, neq
                        if (coee(i) .eq. coee(j)) then
                            dn = dn + coef(i)*depde(i)+ coef(j)*depde(j)
                            dc = dc + coef(i)*du0(i)+ coef(j)*du0(j)
                            dp = dp + coef(i)*du1(i)+ coef(j)*du1(j)
                        endif
                    end do
                    f = f + (dn+rho*dc+eta*dp)**2
                endif
            endif
        end do
    else
        do i = 1, neq
            if (deeq(2*i + 2) .gt. 0) then
                f = f + (depde(1+i)+rho*du0(1+i)+eta*du1(1+i))** 2
            endif
        end do
    endif
    call jedema()
end subroutine
