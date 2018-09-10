! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine disc_isotr(ppr, ppi, ppc, yy0, dy0, dyy, decoup)
    implicit none
#include "asterf_types.h"
    real(kind=8)     :: ppr(*)
    integer          :: ppi(*)
    character(len=*) :: ppc(*)
    real(kind=8)     :: yy0(*)
    real(kind=8)     :: dy0(*)
    real(kind=8)     :: dyy(*)
    aster_logical    :: decoup
!
! person_in_charge: jean-luc.flejou at edf.fr
! --------------------------------------------------------------------------------------------------
!
!        DISCRET AVEC COMPORTEMENT ISOTROPE
!
!  IN
!       ppr     : paramètres réels
!       ppi     : paramètres entiers
!       ppc     : paramètres caractères
!       yy0     : valeurs initiales
!       dy0     : dérivées initiales
!
!  OUT
!       dyy      : dérivées calculées
!       decoup   : pour forcer l'adaptation du pas de temps
!
! --------------------------------------------------------------------------------------------------
!
!     ppi  : informations sur les fonctions (5*nbfct) : (nbvale, jprol, jvale, iloi, tecro)
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: vfct,dfct,seuil,raide,Fequi,dcharg,Fx,Fy,Fz
    integer      :: tecro, iloi
!
!   système d'équations : Force, Up, U , dissipation, P
    integer :: ifx, ify, ifz, iux, iuy, iuz, iw, ip, iupx, iupy, iupz, ixx, ixy, ixz
    parameter (ifx=1,ify=2,ifz=3, iux=4,iuy=5,iuz=6, iw=7, ip=8, iupx=9,iupy=10,iupz=11)
    parameter (ixx=12,ixy=13,ixz=14)
!
    decoup = .false.
    dyy(iux) = dy0(iux)
    dyy(iuy) = dy0(iuy)
    dyy(iuz) = dy0(iuz)
!   Raideur initiale de la fonction
    raide   = ppr(1)/ppr(2)
!   Type de loi et d'écrouissage
    iloi  = ppi(4) ; tecro = ppi(5)
!   La fonction seuil et sa dérivée
    if (  tecro == 2 ) then
        call val_fct_dfct(ppi,0.0d0,vfct,dfct)
        vfct = ppr(1)
    else
        call val_fct_dfct(ppi,yy0(ip),vfct,dfct)
    endif
!   La norme des efforts
    Fx = (yy0(ifx)-yy0(ixx))
    Fy = (yy0(ify)-yy0(ixy))
    Fz = (yy0(ifz)-yy0(ixz))
    Fequi = sqrt(Fx*Fx + Fy*Fy + Fz*Fz)
    seuil = Fequi - vfct
!   Par défaut, on reste sous le seuil
    dyy(ip)   = 0.0
    dyy(iupx) = 0.0 ; dyy(iupy) = 0.0 ; dyy(iupz) = 0.0
    dyy(ixx)  = 0.0 ; dyy(ixy)  = 0.0 ; dyy(ixz)  = 0.0
    if ( seuil .gt. 0.0 ) then
        dcharg = (Fx*dyy(iux) + Fy*dyy(iuy) + Fz*dyy(iuz))
        if ( dcharg .gt. 0.0 ) then
            dyy(ip)   = raide*dcharg/(Fequi*(raide+dfct))
            dyy(iupx) = dyy(ip)*Fx/Fequi
            dyy(iupy) = dyy(ip)*Fy/Fequi
            dyy(iupz) = dyy(ip)*Fz/Fequi
            if ( tecro == 2 ) then
                dyy(ixx)  = dfct*dyy(iupx)
                dyy(ixy)  = dfct*dyy(iupy)
                dyy(ixz)  = dfct*dyy(iupz)
            endif
        endif
    endif
    dyy(ifx) = raide*(dyy(iux) - dyy(iupx))
    dyy(ify) = raide*(dyy(iuy) - dyy(iupy))
    dyy(ifz) = raide*(dyy(iuz) - dyy(iupz))
    dyy(iw)  = dyy(ip)*Fequi
!
! ==================================================================================================
contains
!
subroutine val_fct_dfct(info_fct,p,vfct,dfct)
    integer :: info_fct(5)
    real(kind=8) :: p, vfct, dfct
!
#include "jeveux.h"
#include "asterfort/utmess.h"
!
    integer      :: ip, jr, jp, nbvale, i0, i1
    real(kind=8) :: raide, peq, p0, p1, f0, f1
!
    nbvale = info_fct(1)
    jp     = info_fct(3)
    jr     = jp+nbvale
!   Le point 0 c'est (0.0,0.0)
    raide = zr(jr+1)/zr(jp+1)
!
    i0 = 0 ; i1 = 0
    do ip = 2 , nbvale-1
        peq = zr(jp+ip) - zr(jr+ip)/raide
        if ( p .lt. peq ) then
            i0 = ip - 1
            i1 = ip
            goto 20
        endif
    enddo
    call utmess('F', 'DISCRETS_61', sk=zk24(info_fct(2)+5), sr=zr(jp+nbvale-1))
20  continue
    f0 = zr(jr+i0) ; f1 = zr(jr+i1)
    p0 = zr(jp+i0) - f0/raide
    p1 = zr(jp+i1) - f1/raide
    dfct = (f1-f0)/(p1-p0)
    vfct = f0 + dfct*(p-p0)
end subroutine val_fct_dfct
!
end subroutine disc_isotr
