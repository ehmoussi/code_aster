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

subroutine vipvpt(nbvari, vintm, vintp, advico, vicpvp,&
                  dimcon, p2, congem, adcp11, adcp12,&
                  ndim, pvp0, dp1, dp2, t,&
                  dt, mamolv, r, rho11, kh,&
                  signe, cp11, cp12, yate, pvp,&
                  pvpm, retcom)
! aslint: disable=W1504
    implicit      none
#include "jeveux.h"
#include "asterc/r8prem.h"
#include "asterfort/iunifi.h"
#include "asterfort/tecael.h"
    integer :: nbvari, advico, vicpvp, adcp11, adcp12, ndim, dimcon
    integer :: yate, retcom
    real(kind=8) :: vintm(nbvari), vintp(nbvari), congem(dimcon), pvp0, dp1
    real(kind=8) :: dp2, t, dt, mamolv, r, rho11, cp11, cp12, pvp, pvpm, p2
    real(kind=8) :: signe
    real(kind=8) :: kh
! --- BUT : CALCUL ET STOCKAGE DES PRESSIONS DE VAPEUR INTER PTILDE-----
! -------   DANS LES CAS AVEC AIR DISSOUS ------------------------------
! ======================================================================
    integer :: iadzi, iazk24, umess
    real(kind=8) :: varpv, epxmax
    parameter    (epxmax = 5.d0)
    character(len=8) :: nomail
! ======================================================================
! ======================================================================
! --- CALCUL DES ARGUMENTS EN EXPONENTIELS -----------------------------
! --- ET VERIFICATION DES COHERENCES -----------------------------------
! ======================================================================
!      VARPV = MAMOLV*(1/R/T-1/KH)* DP2/RHO11-MAMOLV/R/T*DP1/RHO11
    varpv = mamolv/r/t*(dp2-signe*dp1)/rho11-mamolv/rho11/kh*dp2
    if (yate .eq. 1) then
        varpv = varpv+(congem(adcp12+ndim+1)-congem(adcp11+ndim+1))* (1.0d0/(t-dt)-1.0d0/t&
                )*mamolv/r
        varpv = varpv+(cp12-cp11)*(log(t/(t-dt))-(dt/t))*mamolv/r
    endif
    if (varpv .gt. epxmax) then
        umess = iunifi('MESSAGE')
        call tecael(iadzi, iazk24)
        nomail = zk24(iazk24-1+3) (1:8)
        write (umess,9001) 'VIPVPT','VARPV > EXPMAX A LA MAILLE: ',&
        nomail
        retcom = 1
        goto 30
    endif
    vintp(advico+vicpvp) = - pvp0 + (vintm(advico+vicpvp)+pvp0)*exp(varpv)
    pvp = vintp(advico+vicpvp) + pvp0
    pvpm = vintm(advico+vicpvp) + pvp0
    if ((p2-pvp) .lt. 0.0d0) then
        umess = iunifi('MESSAGE')
        call tecael(iadzi, iazk24)
        nomail = zk24(iazk24-1+3) (1:8)
        write (umess,9001) 'VIPVPT','PGAZ-PVAP <=0 A LA MAILLE: ',&
        nomail
        retcom = 1
        goto 30
    endif
    if ((pvp) .lt. r8prem()) then
        umess = iunifi('MESSAGE')
        call tecael(iadzi, iazk24)
        nomail = zk24(iazk24-1+3) (1:8)
        write (umess,9001) 'VIPVPT','PVAP =0 A LA MAILLE: ',nomail
        retcom = 1
        goto 30
    endif
! ======================================================================
30  continue
! ======================================================================
    9001 format (a8,2x,a30,2x,a8)
! ======================================================================
end subroutine
