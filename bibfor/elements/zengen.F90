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

subroutine zengen(ppr, ppi, yy0, dy0, dyy, decoup)
    implicit none
#include "asterf_types.h"
    real(kind=8) :: ppr(*)
    integer      :: ppi(*)
    real(kind=8) :: yy0(*)
    real(kind=8) :: dy0(*)
    real(kind=8) :: dyy(*)
    aster_logical :: decoup
!
! person_in_charge: jean-luc.flejou at edf.fr
! ----------------------------------------------------------------------
!
!        MODÈLE DE D'AMORTISSEUR DE ZENER GÉNÉRALISÉ
!
!  IN
!     ppr      : paramètres réels
!     ppi      : paramètres entiers
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
    real(kind=8) :: seuil, xx
    parameter (seuil=1.0e+10)
!
!   système d'équations : contrainte, epsivisq, epsi , dissipation
    integer :: isig, iepvis, iepsi, idissi
    parameter (isig=1,iepvis=2,iepsi=3,idissi=4)
!   paramètres du modèle : s1, e2, s3, nu3, alpha3
    integer :: is1, ie2, is3, inu3, ialp3
    parameter (is1=1,ie2=2,is3=3,inu3=4,ialp3=5)
!
    dyy(iepsi) = dy0(iepsi)
    xx = (yy0(isig)*(1.0d0+ppr(ie2)*ppr(is1)) -ppr(ie2)*yy0(iepsi))/ppr(inu3)
    if (abs(xx) .gt. seuil) then
        if (log10(abs(xx)) .gt. 200.0d0 * ppr(ialp3)) then
            decoup=.true.
            goto 999
        endif
    endif
    if (xx .ge. 0.0d0) then
        dyy(iepvis) = ( abs(xx) )**(1.0d0/ppr(ialp3))
    else
        dyy(iepvis) = -( abs(xx) )**(1.0d0/ppr(ialp3))
    endif
    dyy(idissi) = ppr(inu3)*abs(xx*dyy(iepvis))
!
    dyy(isig) = (dyy(iepsi)*(1.0d0+ppr(ie2)*ppr(is3)) - dyy(iepvis))
    dyy(isig) = dyy(isig)/(ppr(is1)+ppr(is3)+ppr(ie2)*ppr(is1)*ppr(is3))
!
999 continue
end subroutine
