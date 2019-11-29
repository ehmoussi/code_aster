! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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

subroutine hujcrd(k, mater, sig, vin, seuild, iret)
    implicit none
!    HUJEUX:  SEUIL DU MECANISME DEVIATOIRE K(=1 A 3)
!             FD(K) = QII(K) + M*PK*RK*( 1 - B*LOG(PK/PC) )
!    ---------------------------------------------------------------
!    IN  k      : Plan de projection (k = 1 a 3)
!        sig    : Contrainte
!        vin    : Variables internes = ( q, r, x )
!    OUT seuild : Seuil du mecanisme deviatoire k
!        iret   : =0 si 0, 1 en cas d'erreur.
!    ---------------------------------------------------------------
#include "asterf_types.h"
#include "asterfort/hujprj.h"
    integer, intent(in) :: k
    real(kind=8), intent(in) :: mater(22, 2), sig(6), vin(*)
    real(kind=8), intent(out) :: seuild
    integer, intent(out) :: iret

    integer :: ndt, ndi
    real(kind=8) :: un, r, epsvp, pcr, pa, tole
    real(kind=8) :: degr, beta, b, m, phi, pcref, ptrac
    real(kind=8) :: sigd(3), p, q
    aster_logical :: debug
    parameter    (un = 1.d0)
    parameter    (tole = 1.d-7)
    parameter    (degr = 0.0174532925199d0)
!
!       ------------------------------------------------------------
    common /tdim/   ndt, ndi
    common /meshuj/ debug
!
    iret = 0
!
! ==================================================================
! --- VARIABLES INTERNES -------------------------------------------
! ==================================================================
    epsvp = vin(23)
    r = vin(k)
!
! ==================================================================
! --- CARACTERISTIQUES MATERIAU ------------------------------------
! ==================================================================
    beta = mater(2, 2)
    b = mater(4, 2)
    phi = mater(5, 2)
    pcref = mater(7, 2)
    pa = mater(8, 2)
    if (-beta*epsvp .gt. 700.d0) then
        iret = 1
        goto 999
    endif
    pcr = pcref*exp(-beta*epsvp)
    ptrac = mater(21,2)
    m = sin(degr*phi)
!
! ==================================================================
! --- PROJECTION DANS LE PLAN DEVIATEUR K ------------------------
! ==================================================================
    call hujprj(k, sig, sigd, p, q)
!
    p = p - ptrac
!
    if ((p/pa) .le. tole) then
        if (debug) write (6, '(A)') 'HUJCRD :: LOG(P/PA) NON DEFINI'
        seuild = -1.d0
        goto 999
    endif
!
!        IF(K.EQ.1)THEN
!         WRITE(6,*)'QK =',QK,' --- FR =',RK*(UN-B*LOG(PK/PCR))*M*PK
!        ENDIF
! ==================================================================
! --- CALCUL DU SEUIL DU MECANISME DEVIATOIRE K ------------------
! ==================================================================
    seuild = -q /m/p - r*(un-b*log(p/pcr))
!
999 continue
end subroutine
