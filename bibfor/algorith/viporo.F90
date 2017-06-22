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

subroutine viporo(nbvari, vintm, vintp, advico, vicphi,&
                  phi0, deps, depsv, alphfi, dt,&
                  dp1, dp2, signe, sat, cs,&
                  tbiot, phi, phim, retcom, cbiot,&
                  unsks, alpha0, aniso, phenom)
    implicit      none
    integer :: nbvari, advico, vicphi, retcom, i, aniso
    real(kind=8) :: vintm(nbvari), vintp(nbvari), phi0
    real(kind=8) :: depsv, alphfi, dt, dp1, dp2, signe, sat, cs, tbiot(6)
    real(kind=8) :: phi, phim, rac2, deps(6), cbiot, unsks, alpha0
    character(len=16) :: phenom
! --- CALCUL ET STOCKAGE DE LA VARIABLE INTERNE DE POROSITE ------------
! ======================================================================
    real(kind=8) :: varbio, epxmax
    parameter    (epxmax = 5.d0)
! ======================================================================
! ======================================================================
! --- CALCUL DES ARGUMENTS EN EXPONENTIELS -----------------------------
! --- ET VERIFICATION DE SA COHERENCE ----------------------------------
! ======================================================================
    999 if (aniso.eq.0) then
    varbio = - depsv + 3.d0*alpha0*dt - (dp2-sat*signe*dp1)*unsks
    if (varbio .gt. epxmax) then
        retcom = 2
        goto 30
    endif
    vintp(advico+vicphi) = cbiot - phi0 - (cbiot-vintm(advico+ vicphi)-phi0)*exp(varbio)
!
    phi = vintp(advico+vicphi) + phi0
    phim = vintm(advico+vicphi) + phi0
else if ((aniso.eq.1).or.(aniso.eq.2)) then
    if (phenom .eq. 'ELAS') then
        aniso=0
        goto 999
        else if ((phenom.eq.'ELAS_ISTR').or. (phenom.eq.'ELAS_ORTH'))&
        then
        rac2 = sqrt(2.d0)
        varbio=0
        do 10 i = 1, 3
            varbio = varbio + tbiot(i)*deps(i)
10      continue
        do 20 i = 4, 6
            varbio = varbio + tbiot(i)*deps(i)/rac2
20      continue
        varbio = varbio-(&
                 vintm(advico+vicphi)-phi0)*depsv - 3.d0*alphfi*dt + cs*(dp2-sat*signe*dp1)
        if (varbio .gt. epxmax) then
            retcom = 2
            goto 30
        endif
        vintp(advico+vicphi) = varbio + vintm(advico+vicphi)
        phi = vintp(advico+vicphi) + phi0
        phim = vintm(advico+vicphi) + phi0
    endif
endif
! ======================================================================
30  continue
! =====================================================================
! ======================================================================
end subroutine
