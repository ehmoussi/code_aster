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

subroutine relax_cable(ppr, ppi, ppc, yy0, dy0, dyy, decoup)
!
    implicit none
!
#include "asterf_types.h"
#include "asterfort/rcvala.h"
!
    real(kind=8)     :: ppr(*)
    integer          :: ppi(*)
    character(len=*) :: ppc(*)
    real(kind=8)     :: yy0(*)
    real(kind=8)     :: dy0(*)
    real(kind=8)     :: dyy(*)
    aster_logical    :: decoup
!
! person_in_charge: jean-luc.flejou at edf.fr
! ----------------------------------------------------------------------
!
!        MODÈLE DE D'AMORTISSEUR DE ZENER GÉNÉRALISÉ
!
!  IN
!     ppr      : paramètres réels
!     ppi      : paramètres entiers
!     ppc      : paramètres caractère
!     nbeq     : nombre d'équations
!     yy0      : valeurs initiales
!     dy0      : dérivées initiales
!     pf       : adresse des fonctions
!
!  OUT
!     dyy      : dérivées calculées
!     decoup   : pour forcer l'adaptation du pas de temps
!
! ----------------------------------------------------------------------
!
!   Système d'équations
    integer :: isig,  iepsi,  iepvis,  itemper
    parameter (isig=1,iepsi=2,iepvis=3,itemper=4)
!
    integer, parameter :: nbcar=6
    character(len=16)  :: nomcar(nbcar)
    real(kind=8)       :: valcar(nbcar)
    integer            :: codcar(nbcar)
    data nomcar /'ECOU_K','ECOU_N','ECRO_N','ECRO_B','ECRO_C','F_PRG'/
!
    real(kind=8) :: young, kecoul, necoul, necrou, becrou, cecrou, fprg
!
    real(kind=8):: repsi, Epsiv, seuil
! --------------------------------------------------------------------------------------------------
!
!   Variables de pilotage
    dyy(iepsi)   = dy0(iepsi)
    dyy(itemper) = dy0(itemper)
!
!   Module d'Young à la température actuelle
    call rcvala(ppi(1),ppc(1),'ELAS', &
                1, 'TEMP', [yy0(itemper)], 1, 'E', valcar , codcar, 0)
    young = abs(valcar(1))
!
!   Caractéristiques matériaux à la température actuelle
    call rcvala(ppi(1),ppc(1),'RELAX_ACIER', &
                1, 'TEMP', [yy0(itemper)], nbcar, nomcar, valcar , codcar, 0)
    kecoul  = abs(valcar(1))
    necoul  = abs(valcar(2))
    necrou  = abs(valcar(3))
    becrou  = abs(valcar(4))
    cecrou  = abs(valcar(5))
!   Si on trouve F_PRG on prend sa valeur sinon on prend celle qui vient en paramètre
    if ( codcar(6).eq.0 ) then
        fprg = abs(valcar(6))
    else
        fprg = ppr(1)
    endif
!
    decoup = .false.
    Epsiv  = abs(yy0(iepvis))
    if ( becrou*Epsiv .gt. 1.0E-06 ) then
        repsi  = (cecrou*Epsiv)/pow(1.0+pow(becrou*Epsiv,necrou,decoup),1.0/necrou,decoup)
        if ( decoup ) goto 999
    else
        repsi = cecrou*Epsiv
    endif
    seuil = (yy0(isig)/fprg - repsi)/kecoul
    if ( seuil .gt. 0.0 ) then
        dyy(iepvis) = pow(seuil,necoul,decoup)
        if ( decoup ) goto 999
    else
        dyy(iepvis) = 0.0
    endif
    dyy(isig) = young*(dyy(iepsi) - dyy(iepvis))
!
999 continue
! ==================================================================================================
contains
!
function pow(xx,puiss,decoup)
    implicit none
#include "asterf_types.h"
    real(kind=8) :: pow
    real(kind=8),intent(in)     :: xx, puiss
    aster_logical,intent(inout) :: decoup
!
    if (log10(xx)*puiss .gt. 200.0) then
        decoup = .true.
        pow = 1.0
    else
        pow = xx**puiss
    endif
end function pow
!
end subroutine relax_cable
