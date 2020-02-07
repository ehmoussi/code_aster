! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

subroutine ldc_dis_contact_frot(ppr, ppi, ppc, yy0, dy0, dyy, decoup)
!
! --------------------------------------------------------------------------------------------------
! person_in_charge: jean-luc.flejou at edf.fr
!
!        LOI DE COMPORTEMENT : DISCRET DE CHOC AVEC FROTTEMENT DE COULOMB
!
!  IN
!     ppr       : paramètres réels
!     ppi       : paramètres entiers
!     ppc       : paramètres caractères
!     yy0       : valeurs initiales
!     dy0       : dérivées initiales
!
!  OUT
!     dyy       : dérivées calculées
!     decoup    : pour forcer l'adaptation du pas de temps
!
! --------------------------------------------------------------------------------------------------
!
    implicit none
#include "asterf_types.h"
    real(kind=8)        :: ppr(*)
    integer             :: ppi(*)
    character(len=*)    :: ppc(*)
    real(kind=8)        :: yy0(*)
    real(kind=8)        :: dy0(*)
    real(kind=8)        :: dyy(*)
    aster_logical       :: decoup
!
! --------------------------------------------------------------------------------------------------
!
#include "asterc/r8prem.h"
#include "asterfort/assert.h"
!
    real(kind=8) :: seuil, ft, dlam, dffx, dffy, dffz, ctamor, cnamor, xjeu
!
!   système d'équations
    integer, parameter :: iux=1, iuy=2, iuz=3, ifx=4, ify=5, ifz=6
    integer, parameter :: ivx=7, ivy=8, ivz=9, iuyan=10, iuzan=11, ifcy=12, ifcz=13, ije=14
!   paramètres du modèle :
    integer,parameter  :: ikn=1, ikt=2, imu=3, icn=4, ict=5, ijeu=6, iky=7, ikz=8
!
    decoup = ASTER_FALSE
    dyy(iux) = dy0(iux)
    dyy(iuy) = dy0(iuy)
    dyy(iuz) = dy0(iuz)
    dyy(ivx) = dy0(ivx)
    dyy(ivy) = dy0(ivy)
    dyy(ivz) = dy0(ivz)
    dyy(ije) = dy0(ije)
!
!   Soit on intègre le jeu soit on prend sa valeur
!       ppi(2) = 1 : intégration du jeu
!       ppi(2) = 0 : valeur finale
    xjeu = yy0(ije)*ppi(2) + ppr(ijeu)*(1.0 - ppi(2))
!
!   ppi(1) = 1 : seulement du contact, pas de frottement, pas de seuil
!   ppi(1) = 2 : La loi complète
!   ppi(1) = 3 : contact direction normale
!
    if ( yy0(iux) + xjeu > 0.0 ) then
        dyy(iuyan) = 0.0
        dyy(iuzan) = 0.0
        dyy(ifcy)  = 0.0
        dyy(ifcz)  = 0.0
        dyy(ifx)   = 0.0
        dyy(ify)   = ppr(iky)*dyy(iuy)
        dyy(ifz)   = ppr(ikz)*dyy(iuz)
        goto 999
    endif
!
    if ( ppi(1) == 1 ) then
        dyy(iuyan) = 0.0
        dyy(iuzan) = 0.0
        dyy(ifcy)  = 0.0
        dyy(ifcz)  = 0.0
        ! Si on s'enfonce
        if ( dyy(ivx) < 0.0 )  then
            dyy(ifx) = ppr(ikn)*dyy(iux) + ppr(icn)*dyy(ivx)
        else
            if ( yy0(ifx) < 0.0 ) then
                dyy(ifx) = ppr(ikn)*dyy(iux) + ppr(icn)*dyy(ivx)
            else
                dyy(ifx) = 0.0
            endif
        endif
        dyy(ify)   = ppr(iky)*dyy(iuy)
        dyy(ifz)   = ppr(ikz)*dyy(iuz)
!
    else if ( ppi(1) == 3 ) then
        ASSERT( ppi(2) == 1 )
        dyy(iuyan) = dyy(iuy)
        dyy(iuzan) = dyy(iuz)
        dyy(ifcy)  = 0.0
        dyy(ifcz)  = 0.0
        !
        dyy(ifx) = ppr(ikn)*(dyy(iux) + dyy(ije))
        dyy(ify) = ppr(iky)*dyy(iuy)
        dyy(ifz) = ppr(ikz)*dyy(iuz)
!
    else if ( ppi(1) == 2) then
        ft     = (yy0(ifcy)**2 + yy0(ifcz)**2)**0.5
        seuil  = ft - ppr(imu)*abs(yy0(ifx))
        ctamor = 0.0; cnamor = ppr(icn)
        if ( seuil < 0.0 ) then
            dyy(iuyan) = 0.0
            dyy(iuzan) = 0.0
            ctamor = 0.0
        else
            if ( ft > r8prem() ) then
                dffy = yy0(ifcy)/ft
                dffz = yy0(ifcz)/ft
            else
                dffy = 0.0
                dffz = 0.0
            endif
            if ( yy0(ifx) > 0.0 )then
                dffx = -ppr(imu)
            else
                dffx =  ppr(imu)
            endif
            dlam = dffy*dyy(iuy) + dffz*dyy(iuz) + ppr(ikn)*dffx*dyy(iux)/ppr(ikt)
            if ( dlam < 0.0 ) then
                dyy(iuyan) = 0.0
                dyy(iuzan) = 0.0
                ctamor = 0.0
            else
                dyy(iuyan) = dlam*dffy
                dyy(iuzan) = dlam*dffz
                ctamor = ppr(ict)
            endif
        endif
        dyy(ifcy) = ppr(ikt)*(dyy(iuy)-dyy(iuyan)) + ctamor*dyy(ivy)
        dyy(ifcz) = ppr(ikt)*(dyy(iuz)-dyy(iuzan)) + ctamor*dyy(ivz)
        dyy(ifx)  = ppr(ikn)*dyy(iux) + cnamor*dyy(ivx)
        dyy(ify)  = ppr(iky)*dyy(iuy) + dyy(ifcy)
        dyy(ifz)  = ppr(ikz)*dyy(iuz) + dyy(ifcz)
    else
        ASSERT( .false. )
    endif
!
999 continue
end subroutine
