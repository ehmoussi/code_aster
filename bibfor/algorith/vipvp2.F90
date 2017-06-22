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

subroutine vipvp2(nbvari, vintm, vintp, advico, vicpvp,&
                  pvp0, pvp1, p2, dp2, t,&
                  dt, kh, mamolv, r, rho11m,&
                  yate, pvp, pvpm, retcom)
    implicit      none
#include "jeveux.h"
!
#include "asterc/r8prem.h"
#include "asterfort/iunifi.h"
#include "asterfort/tecael.h"
    integer :: nbvari, advico, vicpvp, yate, retcom
    real(kind=8) :: vintm(nbvari), vintp(nbvari), pvp0, pvp1, p2, dp2, t, dt
    real(kind=8) :: mamolv, r, rho11m, pvp, pvpm, kh
! --- CALCUL ET STOCKAGE DE LA PRESSION DE VAPEUR DANS LE CAS ----------
! --- AVEC AIR DISSOUS -------------------------------------------------
! ======================================================================
    integer :: iadzi, iazk24, umess
    real(kind=8) :: varbio
    character(len=8) :: nomail
! ======================================================================
! ======================================================================
    varbio = (rho11m*kh/pvp1)-mamolv*(1+r*log(t/(t-dt)))
! ======================================================================
! --- VERIFICATION DES COHERENCES --------------------------------------
! ======================================================================
    if (abs(varbio) .lt. r8prem()) then
        umess = iunifi('MESSAGE')
        call tecael(iadzi, iazk24)
        nomail = zk24(iazk24-1+3) (1:8)
        write (umess,9001) 'VIPVP2','DIVISION PAR ZERO A LA MAILLE',&
        nomail
        retcom = 1
        goto 30
    endif
    pvpm = vintm(advico+vicpvp) + pvp0
    pvp = (rho11m*kh-mamolv*(pvpm+(p2-dp2)*r*log(t/(t-dt))))/varbio
    if ((p2-pvp) .lt. 0.d0) then
        umess = iunifi('MESSAGE')
        call tecael(iadzi, iazk24)
        nomail = zk24(iazk24-1+3) (1:8)
        write (umess,9001) 'VIPVP2','PGAZ-PVAP <=0 A LA MAILLE: ',&
        nomail
        retcom = 1
        goto 30
    endif
    vintp(advico+vicpvp) = pvp - pvp0
! ======================================================================
30  continue
! =====================================================================
    9001 format (a8,2x,a30,2x,a8)
! ======================================================================
end subroutine
